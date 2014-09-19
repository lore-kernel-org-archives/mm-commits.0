From: akpm@linux-foundation.org
Subject: + mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch added to -mm tree
Date: Fri, 19 Sep 2014 15:02:42 -0700
Message-ID: <541ca802.kiZ/FTIn0swmjDua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaISWCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2
has been added to the -mm tree.  Its filename is
     mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2

Restructured patch to make logic more clear.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2
+++ a/fs/proc/task_mmu.c
@@ -1067,27 +1067,15 @@ static int pagemap_pte_range(pmd_t *pmd,
 		return 0;
 
 	while (1) {
-		unsigned long vm_start = end;
-		unsigned long vm_end = end;
-		unsigned long vm_flags = 0;
-
-		if (vma) {
-			/*
-			 * We can't possibly be in a hugetlb VMA. In general,
-			 * for a mm_walk with a pmd_entry and a hugetlb_entry,
-			 * the pmd_entry can only be called on addresses in a
-			 * hugetlb if the walk starts in a non-hugetlb VMA and
-			 * spans a hugepage VMA. Since pagemap_read walks are
-			 * PMD-sized and PMD-aligned, this will never be true.
-			 */
-			BUG_ON(is_vm_hugetlb_page(vma));
-			vm_start = vma->vm_start;
-			vm_end = min(end, vma->vm_end);
-			vm_flags = vma->vm_flags;
-		}
+		/* End of address space hole, which we mark as non-present. */
+		unsigned long hole_end;
+
+		if (vma)
+			hole_end = min(end, vma->vm_start);
+		else
+			hole_end = end;
 
-		/* Addresses before the VMA. */
-		for (; addr < vm_start; addr += PAGE_SIZE) {
+		for (; addr < hole_end; addr += PAGE_SIZE) {
 			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 			err = add_to_pagemap(addr, &pme, pm);
@@ -1095,8 +1083,20 @@ static int pagemap_pte_range(pmd_t *pmd,
 				return err;
 		}
 
+		if (!vma)
+			break;
+		/*
+		 * We can't possibly be in a hugetlb VMA. In general,
+		 * for a mm_walk with a pmd_entry and a hugetlb_entry,
+		 * the pmd_entry can only be called on addresses in a
+		 * hugetlb if the walk starts in a non-hugetlb VMA and
+		 * spans a hugepage VMA. Since pagemap_read walks are
+		 * PMD-sized and PMD-aligned, this will never be true.
+		 */
+		BUG_ON(is_vm_hugetlb_page(vma));
+
 		/* Addresses in the VMA. */
-		for (; addr < vm_end; addr += PAGE_SIZE) {
+		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			pagemap_entry_t pme;
 			pte = pte_offset_map(pmd, addr);
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
_

Patches currently in -mm which might be from pfeiner@google.com are

mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch

