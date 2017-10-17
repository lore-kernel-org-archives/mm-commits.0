From: akpm@linux-foundation.org
Subject: [failures]
 mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor.patch
 removed from -mm tree
Date: Tue, 17 Oct 2017 16:27:40 -0700
Message-ID: <59e691ec.+lfESE1QdTaQJjVQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755780AbdJQX1l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, aarcange@redhat.com, corbet@lwn.net, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename page dtor functions to {compound,huge,transhuge}_page__dtor
has been removed from the -mm tree.  Its filename was
     mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Changbin Du <changbin.du@intel.com>
Subject: mm: rename page dtor functions to {compound,huge,transhuge}_page__dtor

The current name free_{huge,transhuge}_page are paired with
alloc_{huge,transhuge}_page functions, but the actual page free function
is still free_page() which will indirectly call
free_{huge,transhuge}_page.  So this patch removes this confusion by
renaming all the compound page dtors.

Link: http://lkml.kernel.org/r/1508145557-9944-3-git-send-email-changbin.du@intel.com
Signed-off-by: Changbin Du <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbfs_reserv.txt |    4 ++--
 include/linux/huge_mm.h               |    2 +-
 include/linux/hugetlb.h               |    2 +-
 include/linux/mm.h                    |    8 ++++----
 mm/huge_memory.c                      |    4 ++--
 mm/hugetlb.c                          |   14 +++++++-------
 mm/page_alloc.c                       |   10 +++++-----
 mm/swap.c                             |    2 +-
 mm/userfaultfd.c                      |    2 +-
 9 files changed, 24 insertions(+), 24 deletions(-)

diff -puN Documentation/vm/hugetlbfs_reserv.txt~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor Documentation/vm/hugetlbfs_reserv.txt
--- a/Documentation/vm/hugetlbfs_reserv.txt~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/Documentation/vm/hugetlbfs_reserv.txt
@@ -238,7 +238,7 @@ to the global reservation count (resv_hu
 
 Freeing Huge Pages
 ------------------
-Huge page freeing is performed by the routine free_huge_page().  This routine
+Huge page freeing is performed by the routine huge_page_dtor().  This routine
 is the destructor for hugetlbfs compound pages.  As a result, it is only
 passed a pointer to the page struct.  When a huge page is freed, reservation
 accounting may need to be performed.  This would be the case if the page was
@@ -468,7 +468,7 @@ However, there are several instances whe
 page is allocated but before it is instantiated.  In this case, the page
 allocation has consumed the reservation and made the appropriate subpool,
 reservation map and global count adjustments.  If the page is freed at this
-time (before instantiation and clearing of PagePrivate), then free_huge_page
+time (before instantiation and clearing of PagePrivate), then huge_page_dtor
 will increment the global reservation count.  However, the reservation map
 indicates the reservation was consumed.  This resulting inconsistent state
 will cause the 'leak' of a reserved huge page.  The global reserve count will
diff -puN include/linux/huge_mm.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/include/linux/huge_mm.h
@@ -130,7 +130,7 @@ extern unsigned long thp_get_unmapped_ar
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags);
 
-extern void free_transhuge_page(struct page *page);
+extern void transhuge_page_dtor(struct page *page);
 
 struct page *alloc_transhuge_page_vma(gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr);
diff -puN include/linux/hugetlb.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/include/linux/hugetlb.h
@@ -118,7 +118,7 @@ long hugetlb_unreserve_pages(struct inod
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
-void free_huge_page(struct page *page);
+void huge_page_dtor(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
diff -puN include/linux/mm.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/include/linux/mm.h
@@ -625,7 +625,7 @@ void split_page(struct page *page, unsig
  * prototype for that function and accessor functions.
  * These are _only_ valid on the head of a compound page.
  */
-typedef void compound_page_dtor(struct page *);
+typedef void compound_page_dtor_t(struct page *);
 
 /* Keep the enum in sync with compound_page_dtors array in mm/page_alloc.c */
 enum compound_dtor_id {
@@ -639,7 +639,7 @@ enum compound_dtor_id {
 #endif
 	NR_COMPOUND_DTORS,
 };
-extern compound_page_dtor * const compound_page_dtors[];
+extern compound_page_dtor_t * const compound_page_dtors[];
 
 static inline void set_compound_page_dtor(struct page *page,
 		enum compound_dtor_id compound_dtor)
@@ -648,7 +648,7 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
+static inline compound_page_dtor_t *get_compound_page_dtor(struct page *page)
 {
 	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
 	return compound_page_dtors[page[1].compound_dtor];
@@ -666,7 +666,7 @@ static inline void set_compound_order(st
 	page[1].compound_order = order;
 }
 
-void free_compound_page(struct page *page);
+void compound_page_dtor(struct page *page);
 
 #ifdef CONFIG_MMU
 /*
diff -puN mm/huge_memory.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/mm/huge_memory.c
@@ -2731,7 +2731,7 @@ out:
 	return ret;
 }
 
-void free_transhuge_page(struct page *page)
+void transhuge_page_dtor(struct page *page)
 {
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(page));
 	unsigned long flags;
@@ -2742,7 +2742,7 @@ void free_transhuge_page(struct page *pa
 		list_del(page_deferred_list(page));
 	}
 	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
-	free_compound_page(page);
+	compound_page_dtor(page);
 }
 
 void deferred_split_huge_page(struct page *page)
diff -puN mm/hugetlb.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor mm/hugetlb.c
--- a/mm/hugetlb.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/mm/hugetlb.c
@@ -1248,7 +1248,7 @@ static void clear_page_huge_active(struc
 	ClearPagePrivate(&page[1]);
 }
 
-void free_huge_page(struct page *page)
+void huge_page_dtor(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
@@ -1361,7 +1361,7 @@ int PageHeadHuge(struct page *page_head)
 	if (!PageHead(page_head))
 		return 0;
 
-	return get_compound_page_dtor(page_head) == free_huge_page;
+	return get_compound_page_dtor(page_head) == huge_page_dtor;
 }
 
 pgoff_t __basepage_index(struct page *page)
@@ -1930,11 +1930,11 @@ static long vma_add_reservation(struct h
  * specific error paths, a huge page was allocated (via alloc_huge_page)
  * and is about to be freed.  If a reservation for the page existed,
  * alloc_huge_page would have consumed the reservation and set PagePrivate
- * in the newly allocated page.  When the page is freed via free_huge_page,
+ * in the newly allocated page.  When the page is freed via huge_page_dtor,
  * the global reservation count will be incremented if PagePrivate is set.
- * However, free_huge_page can not adjust the reserve map.  Adjust the
+ * However, huge_page_dtor can not adjust the reserve map.  Adjust the
  * reserve map here to be consistent with global reserve count adjustments
- * to be made by free_huge_page.
+ * to be made by huge_page_dtor.
  */
 static void restore_reserve_on_error(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address,
@@ -1948,7 +1948,7 @@ static void restore_reserve_on_error(str
 			 * Rare out of memory condition in reserve map
 			 * manipulation.  Clear PagePrivate so that
 			 * global reserve count will not be incremented
-			 * by free_huge_page.  This will make it appear
+			 * by huge_page_dtor.  This will make it appear
 			 * as though the reservation for this page was
 			 * consumed.  This may prevent the task from
 			 * faulting in the page at a later time.  This
@@ -2302,7 +2302,7 @@ static unsigned long set_max_huge_pages(
 	while (count > persistent_huge_pages(h)) {
 		/*
 		 * If this allocation races such that we no longer need the
-		 * page, free_huge_page will handle it by freeing the page
+		 * page, huge_page_dtor will handle it by freeing the page
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
diff -puN mm/page_alloc.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/mm/page_alloc.c
@@ -249,14 +249,14 @@ char * const migratetype_names[MIGRATE_T
 #endif
 };
 
-compound_page_dtor * const compound_page_dtors[] = {
+compound_page_dtor_t * const compound_page_dtors[] = {
 	NULL,
-	free_compound_page,
+	compound_page_dtor,
 #ifdef CONFIG_HUGETLB_PAGE
-	free_huge_page,
+	huge_page_dtor,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	free_transhuge_page,
+	transhuge_page_dtor,
 #endif
 };
 
@@ -587,7 +587,7 @@ out:
  * This usage means that zero-order pages may not be compound.
  */
 
-void free_compound_page(struct page *page)
+void compound_page_dtor(struct page *page)
 {
 	__free_pages_ok(page, compound_order(page));
 }
diff -puN mm/swap.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor mm/swap.c
--- a/mm/swap.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/mm/swap.c
@@ -81,7 +81,7 @@ static void __put_single_page(struct pag
 
 static void __put_compound_page(struct page *page)
 {
-	compound_page_dtor *dtor;
+	compound_page_dtor_t *dtor;
 
 	/*
 	 * __page_cache_release() is supposed to be called for thp, not for
diff -puN mm/userfaultfd.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor mm/userfaultfd.c
--- a/mm/userfaultfd.c~mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor
+++ a/mm/userfaultfd.c
@@ -323,7 +323,7 @@ out:
 		 * map of a private mapping, the map was modified to indicate
 		 * the reservation was consumed when the page was allocated.
 		 * We clear the PagePrivate flag now so that the global
-		 * reserve count will not be incremented in free_huge_page.
+		 * reserve count will not be incremented in huge_page_dtor.
 		 * The reservation map will still indicate the reservation
 		 * was consumed and possibly prevent later page allocation.
 		 * This is better than leaking a global reservation.  If no
_

Patches currently in -mm which might be from changbin.du@intel.com are

mm-update-comments-for-struct-pagemapping.patch
mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch

