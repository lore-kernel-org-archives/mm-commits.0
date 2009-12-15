From: akpm@linux-foundation.org
Subject: [merged] hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:35 -0800
Message-ID: <200912152154.nBFLsZ1F015371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761270AbZLOVzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     hugetlb: acquire the i_mmap_lock before walking the prio_tree to unmap a page
has been removed from the -mm tree.  Its filename was
     hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: acquire the i_mmap_lock before walking the prio_tree to unmap a page
From: Mel Gorman <mel@csn.ul.ie>

When the owner of a mapping fails COW because a child process is holding a
reference, the children VMAs are walked and the page is unmapped.  The
i_mmap_lock is taken for the unmapping of the page but not the walking of
the prio_tree.  In theory, that tree could be changing if the lock is not
held.  This patch takes the i_mmap_lock properly for the duration of the
prio_tree walk.

[hugh.dickins@tiscali.co.uk: Spotted the problem in the first place]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2
+++ a/mm/hugetlb.c
@@ -2237,6 +2237,12 @@ static int unmap_ref_private(struct mm_s
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
 
+	/*
+	 * Take the mapping lock for the duration of the table walk. As
+	 * this mapping should be shared between all the VMAs,
+	 * __unmap_hugepage_range() is called as the lock is already held
+	 */
+	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2250,10 +2256,11 @@ static int unmap_ref_private(struct mm_s
 		 * from the time of fork. This would look like data corruption
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			unmap_hugepage_range(iter_vma,
+			__unmap_hugepage_range(iter_vma,
 				address, address + huge_page_size(h),
 				page);
 	}
+	spin_unlock(&mapping->i_mmap_lock);
 
 	return 1;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

