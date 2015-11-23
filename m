From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch
 removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:11 -0800
Message-ID: <565373cf.2w0Srpwh/1Dsj9Rt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbbKWUPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlbfs: fix bugs in fallocate hole punch of areas with holes
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlbfs: fix bugs in fallocate hole punch of areas with holes

Hugh Dickins pointed out problems with the new hugetlbfs fallocate hole
punch code.  These problems are in the routine remove_inode_hugepages and
mostly occur in the case where there are holes in the range of pages to be
removed.  These holes could be the result of a previous hole punch or
simply sparse allocation.  The current code could access pages outside the
specified range.

remove_inode_hugepages handles both hole punch and truncate operations. 
Page index handling was fixed/cleaned up so that the loop index always
matches the page being processed.  The code now only makes a single pass
through the range of pages as it was determined page faults could not race
with truncate.  A cond_resched() was added after removing up to
PAGEVEC_SIZE pages.

Some totally unnecessary code in hugetlbfs_fallocate() that remained from
early development was also removed.

Tested with fallocate tests submitted here:
http://librelist.com/browser//libhugetlbfs/2015/6/25/patch-tests-add-tests-for-fallocate-system-call/
And, some ftruncate tests under development

Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>	[4.3]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   65 ++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes
+++ a/fs/hugetlbfs/inode.c
@@ -332,12 +332,17 @@ static void remove_huge_page(struct page
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
- *	maps and global counts.
+ *	maps and global counts.  Page faults can not race with truncation
+ *	in this routine.  hugetlb_no_page() prevents page faults in the
+ *	truncated range.  It checks i_size before allocation, and again after
+ *	with the page table lock for the page held.  The same lock must be
+ *	acquired to unmap a page.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserv map
  *	deleted.  The region/reserv map for ranges without associated
- *	pages are not modified.
+ *	pages are not modified.  Page faults can race with hole punch.
+ *	This is indicated if we find a mapped page.
  * Note: If the passed end of range value is beyond the end of file, but
  * not LLONG_MAX this routine still performs a hole punch operation.
  */
@@ -361,46 +366,37 @@ static void remove_inode_hugepages(struc
 	next = start;
 	while (next < end) {
 		/*
-		 * Make sure to never grab more pages that we
-		 * might possibly need.
+		 * Don't grab more pages than the number left in the range.
 		 */
 		if (end - next < lookup_nr)
 			lookup_nr = end - next;
 
 		/*
-		 * This pagevec_lookup() may return pages past 'end',
-		 * so we must check for page->index > end.
+		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr)) {
-			if (next == start)
-				break;
-			next = start;
-			continue;
-		}
+		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr))
+			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
 			u32 hash;
 
+			/*
+			 * The page (index) could be beyond end.  This is
+			 * only possible in the punch hole case as end is
+			 * max page offset in the truncate case.
+			 */
+			next = page->index;
+			if (next >= end)
+				break;
+
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
 							mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			lock_page(page);
-			if (page->index >= end) {
-				unlock_page(page);
-				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-				next = end;	/* we are done */
-				break;
-			}
-
-			/*
-			 * If page is mapped, it was faulted in after being
-			 * unmapped.  Do nothing in this race case.  In the
-			 * normal case page is not mapped.
-			 */
-			if (!page_mapped(page)) {
+			if (likely(!page_mapped(page))) {
 				bool rsv_on_error = !PagePrivate(page);
 				/*
 				 * We must free the huge page and remove
@@ -421,17 +417,23 @@ static void remove_inode_hugepages(struc
 						hugetlb_fix_reserve_counts(
 							inode, rsv_on_error);
 				}
+			} else {
+				/*
+				 * If page is mapped, it was faulted in after
+				 * being unmapped.  It indicates a race between
+				 * hole punch and page fault.  Do nothing in
+				 * this case.  Getting here in a truncate
+				 * operation is a bug.
+				 */
+				BUG_ON(truncate_op);
 			}
 
-			if (page->index > next)
-				next = page->index;
-
-			++next;
 			unlock_page(page);
