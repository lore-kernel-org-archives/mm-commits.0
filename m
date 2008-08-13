From: akpm@linux-foundation.org
Subject: - hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:33 -0700
Message-ID: <200808130852.m7D8qXig008219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbYHMJFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, gerald.schaefer@de.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: allocate structures for reservation tracking outside of spinlocks
has been removed from the -mm tree.  Its filename was
     hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: allocate structures for reservation tracking outside of spinlocks
From: Andy Whitcroft <apw@shadowen.org>

In the normal case, hugetlbfs reserves hugepages at map time so that the
pages exist for future faults.  A struct file_region is used to track when
reservations have been consumed and where.  These file_regions are
allocated as necessary with kmalloc() which can sleep with the
mm->page_table_lock held.  This is wrong and triggers may-sleep warning
when PREEMPT is enabled.

Updates to the underlying file_region are done in two phases.  The first
phase prepares the region for the change, allocating any necessary memory,
without actually making the change.  The second phase actually commits the
change.  This patch makes use of this by checking the reservations before
the page_table_lock is taken; triggering any necessary allocations.  This
may then be safely repeated within the locks without any allocations being
required.

Credit to Mel Gorman for diagnosing this failure and initial versions of
the patch.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb.c~hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks
+++ a/mm/hugetlb.c
@@ -1942,6 +1942,15 @@ retry:
 			lock_page(page);
 	}
 
+	/*
+	 * If we are going to COW a private mapping later, we examine the
+	 * pending reservations for this page now. This will ensure that
+	 * any allocations necessary to record that reservation occur outside
+	 * the spinlock.
+	 */
+	if (write_access && !(vma->vm_flags & VM_SHARED))
+		vma_needs_reservation(h, vma, address);
+
 	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
@@ -1978,6 +1987,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	pte_t *ptep;
 	pte_t entry;
 	int ret;
+	struct page *pagecache_page = NULL;
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
@@ -2000,19 +2010,35 @@ int hugetlb_fault(struct mm_struct *mm, 
 
 	ret = 0;
 
+	/*
+	 * If we are going to COW the mapping later, we examine the pending
+	 * reservations for this page now. This will ensure that any
+	 * allocations necessary to record that reservation occur outside the
+	 * spinlock. For private mappings, we also lookup the pagecache
+	 * page now as it is used to determine if a reservation has been
+	 * consumed.
+	 */
+	if (write_access && !pte_write(entry)) {
+		vma_needs_reservation(h, vma, address);
+
+		if (!(vma->vm_flags & VM_SHARED))
+			pagecache_page = hugetlbfs_pagecache_page(h,
+								vma, address);
+	}
+
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
 	if (likely(pte_same(entry, huge_ptep_get(ptep))))
-		if (write_access && !pte_write(entry)) {
-			struct page *page;
-			page = hugetlbfs_pagecache_page(h, vma, address);
-			ret = hugetlb_cow(mm, vma, address, ptep, entry, page);
-			if (page) {
-				unlock_page(page);
-				put_page(page);
-			}
-		}
+		if (write_access && !pte_write(entry))
+			ret = hugetlb_cow(mm, vma, address, ptep, entry,
+							pagecache_page);
 	spin_unlock(&mm->page_table_lock);
+
+	if (pagecache_page) {
+		unlock_page(pagecache_page);
+		put_page(pagecache_page);
+	}
+
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
_

Patches currently in -mm which might be from apw@shadowen.org are

checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
page-owner-tracking-leak-detector.patch

