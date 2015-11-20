From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3.patch
 removed from -mm tree
Date: Fri, 20 Nov 2015 15:50:01 -0800
Message-ID: <564fb1a9.mrJlLdr6aL4swhRv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbbKTXuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 18:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3.patch

This patch was dropped because it was folded into mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3

V3:
  Add more descriptive comments and minor improvements as suggested by
  Naoya Horiguchi
v2:
  Make remove_inode_hugepages simpler after verifying truncate can not
  race with page faults here.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   65 +++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes-v3
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
@@ -361,37 +366,16 @@ static void remove_inode_hugepages(struc
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
-		 * When no more pages are found, take different action for
-		 * hole punch and truncate.
-		 *
-		 * For hole punch, this indicates we have removed each page
-		 * within the range and are done.  Note that pages may have
-		 * been faulted in after being removed in the hole punch case.
-		 * This is OK as long as each page in the range was removed
-		 * once.
-		 *
-		 * For truncate, we need to make sure all pages within the
-		 * range are removed when exiting this routine.  We could
-		 * have raced with a fault that brought in a page after it
-		 * was first removed.  Check the range again until no pages
-		 * are found.
+		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr)) {
-			if (!truncate_op)
-				break;
-
-			if (next == start)
-				break;
-			next = start;
-			continue;
-		}
+		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr))
+			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
@@ -400,13 +384,11 @@ static void remove_inode_hugepages(struc
 			/*
 			 * The page (index) could be beyond end.  This is
 			 * only possible in the punch hole case as end is
-			 * LLONG_MAX for truncate.
+			 * max page offset in the truncate case.
 			 */
-			if (page->index >= end) {
-				next = end;	/* we are done */
-				break;
-			}
 			next = page->index;
+			if (next >= end)
+				break;
 
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
@@ -414,12 +396,7 @@ static void remove_inode_hugepages(struc
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			lock_page(page);
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
@@ -440,13 +417,21 @@ static void remove_inode_hugepages(struc
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
 
-			++next;
 			unlock_page(page);
