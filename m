From: akpm@linux-foundation.org
Subject: + proc-pagemap-walk-page-tables-under-pte-lock.patch added to -mm tree
Date: Mon, 26 Jan 2015 14:15:45 -0800
Message-ID: <54c6bc91.zrzOxP2w/Pz692zz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 17:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, a.ryabinin@samsung.com, nao.horiguchi@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
has been added to the -mm tree.  Its filename is
     proc-pagemap-walk-page-tables-under-pte-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-pagemap-walk-page-tables-under-pte-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-pagemap-walk-page-tables-under-pte-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: proc/pagemap: walk page tables under pte lock

Lockless access to pte in pagemap_pte_range() might race with page
migration and trigger BUG_ON(!PageLocked()) in migration_entry_to_page():

CPU A (pagemap)                           CPU B (migration)
                                          lock_page()
                                          try_to_unmap(page, TTU_MIGRATION...)
                                               make_migration_entry()
                                               set_pte_at()
<read *pte>
pte_to_pagemap_entry()
                                          remove_migration_ptes()
                                          unlock_page()
    if(is_migration_entry())
        migration_entry_to_page()
            BUG_ON(!PageLocked(page))

Also lockless read might be non-atomic if pte is larger than wordsize.
Other pte walkers (smaps, numa_maps, clear_refs) already lock ptes.

Fixes: 052fb0d635df ("proc: report file/anon bit in /proc/pid/pagemap")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pagemap-walk-page-tables-under-pte-lock fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pagemap-walk-page-tables-under-pte-lock
+++ a/fs/proc/task_mmu.c
@@ -1056,7 +1056,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct vm_area_struct *vma;
 	struct pagemapread *pm = walk->private;
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, *orig_pte;
 	int err = 0;
 
 	/* find the first VMA at or above 'addr' */
@@ -1117,15 +1117,19 @@ static int pagemap_pte_range(pmd_t *pmd,
 		BUG_ON(is_vm_hugetlb_page(vma));
 
 		/* Addresses in the VMA. */
-		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
+		orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+		for (; addr < min(end, vma->vm_end); pte++, addr += PAGE_SIZE) {
 			pagemap_entry_t pme;
-			pte = pte_offset_map(pmd, addr);
+
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			pte_unmap(pte);
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
-				return err;
+				break;
 		}
+		pte_unmap_unlock(orig_pte, ptl);
+
+		if (err)
+			return err;
 
 		if (addr == end)
 			break;
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

page_writeback-put-account_page_redirty-after-set_page_dirty.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch

