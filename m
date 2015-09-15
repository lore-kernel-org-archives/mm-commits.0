From: akpm@linux-foundation.org
Subject: +
 mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:12:58 -0700
Message-ID: <55f897ea.UQWKaIYFcIzwDE9c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbIOWM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:12:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pack compound_dtor and compound_order into one word in struct page
has been added to the -mm tree.  Its filename is
     mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: pack compound_dtor and compound_order into one word in struct page

The patch halves space occupied by compound_dtor and compound_order in
struct page.

For compound_order, it's trivial long -> short conversion.

For get_compound_page_dtor(), we now use hardcoded table for destructor
lookup and store its index in the struct page instead of direct pointer
to destructor. It shouldn't be a big trouble to maintain the table: we
have only two destructor and NULL currently.

This patch free up one word in tail pages for reuse. This is preparation
for the next patch.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   24 +++++++++++++++++++-----
 include/linux/mm_types.h |    6 ++----
 mm/hugetlb.c             |    8 ++++----
 mm/page_alloc.c          |   11 ++++++++++-
 4 files changed, 35 insertions(+), 14 deletions(-)

diff -puN include/linux/mm.h~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page include/linux/mm.h
--- a/include/linux/mm.h~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page
+++ a/include/linux/mm.h
@@ -568,18 +568,32 @@ int split_free_page(struct page *page);
 /*
  * Compound pages have a destructor function.  Provide a
  * prototype for that function and accessor functions.
- * These are _only_ valid on the head of a PG_compound page.
+ * These are _only_ valid on the head of a compound page.
  */
+typedef void compound_page_dtor(struct page *);
+
+/* Keep the enum in sync with compound_page_dtors array in mm/page_alloc.c */
+enum compound_dtor_id {
+	NULL_COMPOUND_DTOR,
+	COMPOUND_PAGE_DTOR,
+#ifdef CONFIG_HUGETLB_PAGE
+	HUGETLB_PAGE_DTOR,
+#endif
+	NR_COMPOUND_DTORS,
+};
+extern compound_page_dtor * const compound_page_dtors[];
 
 static inline void set_compound_page_dtor(struct page *page,
-						compound_page_dtor *dtor)
+		enum compound_dtor_id compound_dtor)
 {
-	page[1].compound_dtor = dtor;
+	VM_BUG_ON_PAGE(compound_dtor >= NR_COMPOUND_DTORS, page);
+	page[1].compound_dtor = compound_dtor;
 }
 
 static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
 {
-	return page[1].compound_dtor;
+	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
+	return compound_page_dtors[page[1].compound_dtor];
 }
 
 static inline int compound_order(struct page *page)
@@ -589,7 +603,7 @@ static inline int compound_order(struct
 	return page[1].compound_order;
 }
 
-static inline void set_compound_order(struct page *page, unsigned long order)
+static inline void set_compound_order(struct page *page, unsigned int order)
 {
 	page[1].compound_order = order;
 }
diff -puN include/linux/mm_types.h~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page
+++ a/include/linux/mm_types.h
@@ -28,8 +28,6 @@ struct mem_cgroup;
 		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
 
-typedef void compound_page_dtor(struct page *);
-
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -136,8 +134,8 @@ struct page {
 						 */
 		/* First tail page of compound page */
 		struct {
-			compound_page_dtor *compound_dtor;
-			unsigned long compound_order;
+			unsigned short int compound_dtor;
+			unsigned short int compound_order;
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
diff -puN mm/hugetlb.c~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page
+++ a/mm/hugetlb.c
@@ -1146,7 +1146,7 @@ static void update_and_free_page(struct
 				1 << PG_writeback);
 	}
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
-	set_compound_page_dtor(page, NULL);
+	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
 		destroy_compound_gigantic_page(page, huge_page_order(h));
@@ -1242,7 +1242,7 @@ void free_huge_page(struct page *page)
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
 	INIT_LIST_HEAD(&page->lru);
-	set_compound_page_dtor(page, free_huge_page);
+	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
@@ -1294,7 +1294,7 @@ int PageHuge(struct page *page)
 		return 0;
 
 	page = compound_head(page);
-	return get_compound_page_dtor(page) == free_huge_page;
+	return page[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -1491,7 +1491,7 @@ static struct page *alloc_buddy_huge_pag
 	if (page) {
 		INIT_LIST_HEAD(&page->lru);
 		r_nid = page_to_nid(page);
-		set_compound_page_dtor(page, free_huge_page);
+		set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 		set_hugetlb_cgroup(page, NULL);
 		/*
 		 * We incremented the global counters already
diff -puN mm/page_alloc.c~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page
+++ a/mm/page_alloc.c
@@ -229,6 +229,15 @@ static char * const zone_names[MAX_NR_ZO
 #endif
 };
 
+static void free_compound_page(struct page *page);
+compound_page_dtor * const compound_page_dtors[] = {
+	NULL,
+	free_compound_page,
+#ifdef CONFIG_HUGETLB_PAGE
+	free_huge_page,
+#endif
+};
+
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
 
@@ -458,7 +467,7 @@ void prep_compound_page(struct page *pag
 	int i;
 	int nr_pages = 1 << order;
 
-	set_compound_page_dtor(page, free_compound_page);
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
 	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

