From: akpm@linux-foundation.org
Subject: + pagemap-remove-remaining-unneeded-spin_lock.patch added to -mm tree
Date: Thu, 29 Mar 2012 13:57:56 -0700
Message-ID: <20120329205756.9C0B6A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:44226 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab2C2U55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 16:57:57 -0400
Received: by ghbz15 with SMTP id z15so319121ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 13:57:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, levinsasha928@gmail.com


The patch titled
     Subject: pagemap: remove remaining unneeded spin_lock()
has been added to the -mm tree.  Its filename is
     pagemap-remove-remaining-unneeded-spin_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: remove remaining unneeded spin_lock()

commit: 025c5b2451e4 ("thp: optimize away unnecessary page table locking")
moves spin_lock() into pmd_trans_huge_lock() in order to avoid locking
unless pmd is for thp.  So this spin_lock() is a bug.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_mmu.c~pagemap-remove-remaining-unneeded-spin_lock fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-remove-remaining-unneeded-spin_lock
+++ a/fs/proc/task_mmu.c
@@ -783,7 +783,6 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	spin_lock(&walk->mm->page_table_lock);
 	if (pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
_
Subject: Subject: pagemap: remove remaining unneeded spin_lock()

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
pagemap-remove-remaining-unneeded-spin_lock.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch

