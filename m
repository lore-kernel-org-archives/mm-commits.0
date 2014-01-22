From: akpm@linux-foundation.org
Subject: [merged]
 mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:12:25 -0800
Message-ID: <52e02629.jELFxNoonMS9mNxc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: [merged] mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch removed from -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:25 -0800


The patch titled
     Subject: mm: tail page refcounting optimization for slab and hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: tail page refcounting optimization for slab and hugetlbfs

This skips the _mapcount mangling for slab and hugetlbfs pages.

The main trouble in doing this is to guarantee that PageSlab and
PageHeadHuge remains constant for all get_page/put_page run on the
tail of slab or hugetlbfs compound pages. Otherwise if they're set
during get_page but not set during put_page, the _mapcount of the tail
page would underflow.

PageHeadHuge will remain true until the compound page is released and
enters the buddy allocator so it won't risk to change even if the tail
page is the last reference left on the page.

PG_slab instead is cleared before the slab frees the head page with
put_page, so if the tail pin is released after the slab freed the
page, we would have a problem. But in the slab case the tail pin
cannot be the last reference left on the page. This is because the
slab code is free to reuse the compound page after a
kfree/kmem_cache_free without having to check if there's any tail pin
left. In turn all tail pins must be always released while the head is
still pinned by the slab code and so we know PG_slab will be still set
too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ------
 include/linux/mm.h      |   32 +++++++++++++++++++++++++++++++-
 mm/internal.h           |    3 ++-
 mm/swap.c               |   33 +++++++++++++++++++++++++++------
 4 files changed, 60 insertions(+), 14 deletions(-)

diff -puN include/linux/hugetlb.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs
+++ a/include/linux/hugetlb.h
@@ -31,7 +31,6 @@ struct hugepage_subpool *hugepage_new_su
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 int PageHuge(struct page *page);
-int PageHeadHuge(struct page *page_head);
 
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -103,11 +102,6 @@ static inline int PageHuge(struct page *
 {
 	return 0;
 }
-
-static inline int PageHeadHuge(struct page *page_head)
-{
-	return 0;
-}
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
diff -puN include/linux/mm.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs include/linux/mm.h
--- a/include/linux/mm.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs
+++ a/include/linux/mm.h
@@ -414,15 +414,45 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+extern int PageHeadHuge(struct page *page_head);
+#else /* CONFIG_HUGETLB_PAGE */
+static inline int PageHeadHuge(struct page *page_head)
+{
+	return 0;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
+static inline bool __compound_tail_refcounted(struct page *page)
+{
+	return !PageSlab(page) && !PageHeadHuge(page);
+}
+
+/*
+ * This takes a head page as parameter and tells if the
+ * tail page reference counting can be skipped.
+ *
+ * For this to be safe, PageSlab and PageHeadHuge must remain true on
+ * any given page where they return true here, until all tail pins
+ * have been released.
+ */
+static inline bool compound_tail_refcounted(struct page *page)
+{
+	VM_BUG_ON(!PageHead(page));
+	return __compound_tail_refcounted(page);
+}
+
 static inline void get_huge_page_tail(struct page *page)
 {
 	/*
 	 * __split_huge_page_refcount() cannot run
 	 * from under us.
+	 * In turn no need of compound_trans_head here.
 	 */
 	VM_BUG_ON(page_mapcount(page) < 0);
 	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
+	if (compound_tail_refcounted(compound_head(page)))
+		atomic_inc(&page->_mapcount);
 }
 
 extern bool __get_page_tail(struct page *page);
diff -puN mm/internal.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs mm/internal.h
--- a/mm/internal.h~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs
+++ a/mm/internal.h
@@ -51,7 +51,8 @@ static inline void __get_page_tail_foll(
 	VM_BUG_ON(page_mapcount(page) < 0);
 	if (get_page_head)
 		atomic_inc(&page->first_page->_count);
-	atomic_inc(&page->_mapcount);
+	if (compound_tail_refcounted(page->first_page))
+		atomic_inc(&page->_mapcount);
 }
 
 /*
diff -puN mm/swap.c~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs mm/swap.c
--- a/mm/swap.c~mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs
+++ a/mm/swap.c
@@ -88,8 +88,9 @@ static void put_compound_page(struct pag
 
 		/*
 		 * THP can not break up slab pages so avoid taking
-		 * compound_lock(). Slab performs non-atomic bit ops
-		 * on page->flags for better performance. In
+		 * compound_lock() and skip the tail page refcounting
+		 * (in _mapcount) too. Slab performs non-atomic bit
+		 * ops on page->flags for better performance. In
 		 * particular slab_unlock() in slub used to be a hot
 		 * path. It is still hot on arches that do not support
 		 * this_cpu_cmpxchg_double().
@@ -102,7 +103,7 @@ static void put_compound_page(struct pag
 		 * PageTail clear after smp_rmb() and we'll treat it
 		 * as a single page.
 		 */
-		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+		if (!__compound_tail_refcounted(page_head)) {
 			/*
 			 * If "page" is a THP tail, we must read the tail page
 			 * flags after the head page flags. The
@@ -117,10 +118,30 @@ static void put_compound_page(struct pag
 				 * cannot race here.
 				 */
 				VM_BUG_ON(!PageHead(page_head));
-				VM_BUG_ON(page_mapcount(page) <= 0);
-				atomic_dec(&page->_mapcount);
-				if (put_page_testzero(page_head))
+				VM_BUG_ON(page_mapcount(page) != 0);
+				if (put_page_testzero(page_head)) {
+					/*
+					 * If this is the tail of a
+					 * slab compound page, the
+					 * tail pin must not be the
+					 * last reference held on the
+					 * page, because the PG_slab
+					 * cannot be cleared before
+					 * all tail pins (which skips
+					 * the _mapcount tail
+					 * refcounting) have been
+					 * released. For hugetlbfs the
+					 * tail pin may be the last
+					 * reference on the page
+					 * instead, because
+					 * PageHeadHuge will not go
+					 * away until the compound
+					 * page enters the buddy
+					 * allocator.
+					 */
+					VM_BUG_ON(PageSlab(page_head));
 					__put_compound_page(page_head);
+				}
 				return;
 			} else
 				/*
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

