From: akpm@linux-foundation.org
Subject: [merged] pagemap-remove-remaining-unneeded-spin_lock.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:39 -0700
Message-ID: <20120403201040.002FCA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35417 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2DCUKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:10:42 -0400
Received: by wgbdt11 with SMTP id dt11so4116wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, levinsasha928@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: remove remaining unneeded spin_lock()
has been removed from the -mm tree.  Its filename was
     pagemap-remove-remaining-unneeded-spin_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch

