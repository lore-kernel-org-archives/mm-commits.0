From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch removed from -mm
 tree
Date: Wed, 09 Sep 2015 12:46:17 -0700
Message-ID: <55f08c89.1sowODPBmF0ptNoC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbbIITqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: truncate_hugepages() takes a range of pages
has been removed from the -mm tree.  Its filename was
     hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: truncate_hugepages() takes a range of pages

Modify truncate_hugepages() to take a range of pages (start, end) instead
of simply start.  If an end value of LLONG_MAX is passed, the current
"truncate" functionality is maintained.  Existing callers are modified to
pass LLONG_MAX as end of range.  By keying off end == LLONG_MAX, the
routine behaves differently for truncate and hole punch.  Page removal is
now synchronized with page allocation via faults by using the fault mutex
table.  The hole punch case can experience the rare region_del error and
must handle accordingly.

Add the routine hugetlb_fix_reserve_counts to fix up reserve counts in the
case where region_del returns an error.

Since the routine handles more than just the truncate case, it is renamed
to remove_inode_hugepages().  To be consistent, the routine
truncate_huge_page() is renamed remove_huge_page().

Downstream of remove_inode_hugepages(), the routine
hugetlb_unreserve_pages() is also modified to take a range of pages. 
hugetlb_unreserve_pages is modified to detect an error from region_del and
pass it back to the caller.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   98 ++++++++++++++++++++++++++++++++++----
 include/linux/hugetlb.h |    4 +
 mm/hugetlb.c            |   40 ++++++++++++++-
 3 files changed, 128 insertions(+), 14 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-truncate_hugepages-takes-a-range-of-pages fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-truncate_hugepages-takes-a-range-of-pages
+++ a/fs/hugetlbfs/inode.c
@@ -293,26 +293,61 @@ static int hugetlbfs_write_end(struct fi
 	return -EINVAL;
 }
 
-static void truncate_huge_page(struct page *page)
+static void remove_huge_page(struct page *page)
 {
 	ClearPageDirty(page);
 	ClearPageUptodate(page);
 	delete_from_page_cache(page);
 }
 
-static void truncate_hugepages(struct inode *inode, loff_t lstart)
+
+/*
+ * remove_inode_hugepages handles two distinct cases: truncation and hole
+ * punch.  There are subtle differences in operation for each case.
+
+ * truncation is indicated by end of range being LLONG_MAX
+ *	In this case, we first scan the range and release found pages.
+ *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
+ *	maps and global counts.
+ * hole punch is indicated if end is not LLONG_MAX
+ *	In the hole punch case we scan the range and release found pages.
+ *	Only when releasing a page is the associated region/reserv map
+ *	deleted.  The region/reserv map for ranges without associated
+ *	pages are not modified.
+ * Note: If the passed end of range value is beyond the end of file, but
+ * not LLONG_MAX this routine still performs a hole punch operation.
+ */
+static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
+				   loff_t lend)
 {
 	struct hstate *h = hstate_inode(inode);
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t start = lstart >> huge_page_shift(h);
+	const pgoff_t end = lend >> huge_page_shift(h);
+	struct vm_area_struct pseudo_vma;
 	struct pagevec pvec;
 	pgoff_t next;
 	int i, freed = 0;
+	long lookup_nr = PAGEVEC_SIZE;
+	bool truncate_op = (lend == LLONG_MAX);
 
+	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
+	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
 	pagevec_init(&pvec, 0);
 	next = start;
-	while (1) {
-		if (!pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+	while (next < end) {
+		/*
+		 * Make sure to never grab more pages that we
+		 * might possibly need.
+		 */
+		if (end - next < lookup_nr)
+			lookup_nr = end - next;
+
+		/*
+		 * This pagevec_lookup() may return pages past 'end',
+		 * so we must check for page->index > end.
+		 */
+		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr)) {
 			if (next == start)
 				break;
 			next = start;
@@ -321,26 +356,69 @@ static void truncate_hugepages(struct in
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
+			u32 hash;
+
+			hash = hugetlb_fault_mutex_hash(h, current->mm,
+							&pseudo_vma,
+							mapping, next, 0);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			lock_page(page);
+			if (page->index >= end) {
+				unlock_page(page);
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				next = end;	/* we are done */
+				break;
+			}
+
+			/*
+			 * If page is mapped, it was faulted in after being
+			 * unmapped.  Do nothing in this race case.  In the
+			 * normal case page is not mapped.
+			 */
+			if (!page_mapped(page)) {
+				bool rsv_on_error = !PagePrivate(page);
+				/*
+				 * We must free the huge page and remove
+				 * from page cache (remove_huge_page) BEFORE
+				 * removing the region/reserve map
+				 * (hugetlb_unreserve_pages).  In rare out
+				 * of memory conditions, removal of the
+				 * region/reserve map could fail.  Before
+				 * free'ing the page, note PagePrivate which
+				 * is used in case of error.
+				 */
+				remove_huge_page(page);
+				freed++;
+				if (!truncate_op) {
+					if (unlikely(hugetlb_unreserve_pages(
+							inode, next,
+							next + 1, 1)))
+						hugetlb_fix_reserve_counts(
+							inode, rsv_on_error);
+				}
+			}
+
 			if (page->index > next)
 				next = page->index;
+
 			++next;
-			truncate_huge_page(page);
 			unlock_page(page);
-			freed++;
+
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		huge_pagevec_release(&pvec);
 	}
-	BUG_ON(!lstart && mapping->nrpages);
-	hugetlb_unreserve_pages(inode, start, freed);
+
+	if (truncate_op)
+		(void)hugetlb_unreserve_pages(inode, start, LONG_MAX, freed);
 }
 
 static void hugetlbfs_evict_inode(struct inode *inode)
 {
 	struct resv_map *resv_map;
 
-	truncate_hugepages(inode, 0);
+	remove_inode_hugepages(inode, 0, LLONG_MAX);
 	resv_map = (struct resv_map *)inode->i_mapping->private_data;
 	/* root inode doesn't have the resv_map, so we should check it */
 	if (resv_map)
@@ -397,7 +475,7 @@ static int hugetlb_vmtruncate(struct ino
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
-	truncate_hugepages(inode, offset);
+	remove_inode_hugepages(inode, offset, LLONG_MAX);
 	return 0;
 }
 
diff -puN include/linux/hugetlb.h~hugetlbfs-truncate_hugepages-takes-a-range-of-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-truncate_hugepages-takes-a-range-of-pages
+++ a/include/linux/hugetlb.h
@@ -83,11 +83,13 @@ int hugetlb_fault(struct mm_struct *mm,
 int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						vm_flags_t vm_flags);
-void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
+long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
+						long freed);
 int dequeue_hwpoisoned_huge_page(struct page *page);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 void free_huge_page(struct page *page);
+void hugetlb_fix_reserve_counts(struct inode *inode, bool restore_reserve);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
 				struct vm_area_struct *vma,
diff -puN mm/hugetlb.c~hugetlbfs-truncate_hugepages-takes-a-range-of-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-truncate_hugepages-takes-a-range-of-pages
+++ a/mm/hugetlb.c
@@ -547,6 +547,28 @@ retry:
 }
 
 /*
+ * A rare out of memory error was encountered which prevented removal of
+ * the reserve map region for a page.  The huge page itself was free'ed
+ * and removed from the page cache.  This routine will adjust the subpool
+ * usage count, and the global reserve count if needed.  By incrementing
+ * these counts, the reserve map entry which could not be deleted will
+ * appear as a "reserved" entry instead of simply dangling with incorrect
+ * counts.
+ */
+void hugetlb_fix_reserve_counts(struct inode *inode, bool restore_reserve)
+{
+	struct hugepage_subpool *spool = subpool_inode(inode);
+	long rsv_adjust;
+
+	rsv_adjust = hugepage_subpool_get_pages(spool, 1);
+	if (restore_reserve && rsv_adjust) {
+		struct hstate *h = hstate_inode(inode);
+
+		hugetlb_acct_memory(h, 1);
+	}
+}
+
+/*
  * Count and return the number of huge pages in the reserve map
  * that intersect with the range [f, t).
  */
@@ -3909,7 +3931,8 @@ out_err:
 	return ret;
 }
 
-void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
+long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
+								long freed)
 {
 	struct hstate *h = hstate_inode(inode);
 	struct resv_map *resv_map = inode_resv_map(inode);
@@ -3917,8 +3940,17 @@ void hugetlb_unreserve_pages(struct inod
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long gbl_reserve;
 
-	if (resv_map)
-		chg = region_del(resv_map, offset, LONG_MAX);
+	if (resv_map) {
+		chg = region_del(resv_map, start, end);
+		/*
+		 * region_del() can fail in the rare case where a region
+		 * must be split and another region descriptor can not be
+		 * allocated.  If end == LONG_MAX, it will not fail.
+		 */
+		if (chg < 0)
+			return chg;
+	}
+
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
@@ -3929,6 +3961,8 @@ void hugetlb_unreserve_pages(struct inod
 	 */
 	gbl_reserve = hugepage_subpool_put_pages(spool, (chg - freed));
 	hugetlb_acct_memory(h, -gbl_reserve);
+
+	return 0;
 }
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


