From: akpm@linux-foundation.org
Subject: + mm-use-unsigned-int-for-page-order.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:13:03 -0700
Message-ID: <55f897ef.jRLKBWZCqntmfsrv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbIOWNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use 'unsigned int' for page order
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-int-for-page-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-int-for-page-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-int-for-page-order.patch

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
Subject: mm: use 'unsigned int' for page order

Let's try to be consistent about data type of page order.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

 include/linux/mm.h |    5 +++--
 mm/hugetlb.c       |   19 ++++++++++---------
 mm/internal.h      |    4 ++--
 mm/page_alloc.c    |   27 +++++++++++++++------------
 4 files changed, 30 insertions(+), 25 deletions(-)

diff -puN include/linux/mm.h~mm-use-unsigned-int-for-page-order include/linux/mm.h
--- a/include/linux/mm.h~mm-use-unsigned-int-for-page-order
+++ a/include/linux/mm.h
@@ -550,7 +550,7 @@ static inline compound_page_dtor *get_co
 	return compound_page_dtors[page[1].compound_dtor];
 }
 
-static inline int compound_order(struct page *page)
+static inline unsigned int compound_order(struct page *page)
 {
 	if (!PageHead(page))
 		return 0;
@@ -1787,7 +1787,8 @@ extern void si_meminfo(struct sysinfo *
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
 extern __printf(3, 4)
-void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
+void warn_alloc_failed(gfp_t gfp_mask, unsigned int order,
+		const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff -puN mm/hugetlb.c~mm-use-unsigned-int-for-page-order mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-unsigned-int-for-page-order
+++ a/mm/hugetlb.c
@@ -994,7 +994,7 @@ static int hstate_next_node_to_free(stru
 
 #if defined(CONFIG_CMA) && defined(CONFIG_X86_64)
 static void destroy_compound_gigantic_page(struct page *page,
-					unsigned long order)
+					unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1009,7 +1009,7 @@ static void destroy_compound_gigantic_pa
 	__ClearPageHead(page);
 }
 
-static void free_gigantic_page(struct page *page, unsigned order)
+static void free_gigantic_page(struct page *page, unsigned int order)
 {
 	free_contig_range(page_to_pfn(page), 1 << order);
 }
@@ -1053,7 +1053,7 @@ static bool zone_spans_last_pfn(const st
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-static struct page *alloc_gigantic_page(int nid, unsigned order)
+static struct page *alloc_gigantic_page(int nid, unsigned int order)
 {
 	unsigned long nr_pages = 1 << order;
 	unsigned long ret, pfn, flags;
@@ -1089,7 +1089,7 @@ static struct page *alloc_gigantic_page(
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
-static void prep_compound_gigantic_page(struct page *page, unsigned long order);
+static void prep_compound_gigantic_page(struct page *page, unsigned int order);
 
 static struct page *alloc_fresh_gigantic_page_node(struct hstate *h, int nid)
 {
@@ -1122,9 +1122,9 @@ static int alloc_fresh_gigantic_page(str
 static inline bool gigantic_page_supported(void) { return true; }
 #else
 static inline bool gigantic_page_supported(void) { return false; }
-static inline void free_gigantic_page(struct page *page, unsigned order) { }
+static inline void free_gigantic_page(struct page *page, unsigned int order) { }
 static inline void destroy_compound_gigantic_page(struct page *page,
-						unsigned long order) { }
+						unsigned int order) { }
 static inline int alloc_fresh_gigantic_page(struct hstate *h,
 					nodemask_t *nodes_allowed) { return 0; }
 #endif
@@ -1250,7 +1250,7 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+static void prep_compound_gigantic_page(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1868,7 +1868,8 @@ found:
 	return 1;
 }
 
-static void __init prep_compound_huge_page(struct page *page, int order)
+static void __init prep_compound_huge_page(struct page *page,
+		unsigned int order)
 {
 	if (unlikely(order > (MAX_ORDER - 1)))
 		prep_compound_gigantic_page(page, order);
@@ -2579,7 +2580,7 @@ static int __init hugetlb_init(void)
 module_init(hugetlb_init);
 
 /* Should be called on processing a hugepagesz=... option */
-void __init hugetlb_add_hstate(unsigned order)
+void __init hugetlb_add_hstate(unsigned int order)
 {
 	struct hstate *h;
 	unsigned long i;
diff -puN mm/internal.h~mm-use-unsigned-int-for-page-order mm/internal.h
--- a/mm/internal.h~mm-use-unsigned-int-for-page-order
+++ a/mm/internal.h
@@ -161,7 +161,7 @@ __find_buddy_index(unsigned long page_id
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
-extern void prep_compound_page(struct page *page, unsigned long order);
+extern void prep_compound_page(struct page *page, unsigned int order);
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
 #endif
@@ -219,7 +219,7 @@ int find_suitable_fallback(struct free_a
  * page cannot be allocated or merged in parallel. Alternatively, it must
  * handle invalid values gracefully, and use page_order_unsafe() below.
  */
-static inline unsigned long page_order(struct page *page)
+static inline unsigned int page_order(struct page *page)
 {
 	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
diff -puN mm/page_alloc.c~mm-use-unsigned-int-for-page-order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-unsigned-int-for-page-order
+++ a/mm/page_alloc.c
@@ -181,7 +181,7 @@ bool pm_suspended_storage(void)
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
-int pageblock_order __read_mostly;
+unsigned int pageblock_order __read_mostly;
 #endif
 
 static void __free_pages_ok(struct page *page, unsigned int order);
@@ -462,7 +462,7 @@ static void free_compound_page(struct pa
 	__free_pages_ok(page, compound_order(page));
 }
 
-void prep_compound_page(struct page *page, unsigned long order)
+void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -662,7 +662,7 @@ static inline void __free_one_page(struc
 	unsigned long combined_idx;
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
-	int max_order = MAX_ORDER;
+	unsigned int max_order = MAX_ORDER;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
@@ -1471,7 +1471,7 @@ int move_freepages(struct zone *zone,
 			  int migratetype)
 {
 	struct page *page;
-	unsigned long order;
+	unsigned int order;
 	int pages_moved = 0;
 
 #ifndef CONFIG_HOLES_IN_ZONE
@@ -1584,7 +1584,7 @@ static bool can_steal_fallback(unsigned
 static void steal_suitable_fallback(struct zone *zone, struct page *page,
 							  int start_type)
 {
-	int current_order = page_order(page);
+	unsigned int current_order = page_order(page);
 	int pages;
 
 	/* Take ownership for orders >= pageblock_order */
@@ -2690,7 +2690,7 @@ static DEFINE_RATELIMIT_STATE(nopage_rs,
 		DEFAULT_RATELIMIT_INTERVAL,
 		DEFAULT_RATELIMIT_BURST);
 
-void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
+void warn_alloc_failed(gfp_t gfp_mask, unsigned int order, const char *fmt, ...)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
@@ -2724,7 +2724,7 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%d, mode:0x%x\n",
+	pr_warn("%s: page allocation failure: order:%u, mode:0x%x\n",
 		current->comm, order, gfp_mask);
 
 	dump_stack();
@@ -3488,7 +3488,8 @@ void free_kmem_pages(unsigned long addr,
 	}
 }
 
-static void *make_alloc_exact(unsigned long addr, unsigned order, size_t size)
+static void *make_alloc_exact(unsigned long addr, unsigned int order,
+		size_t size)
 {
 	if (addr) {
 		unsigned long alloc_end = addr + (PAGE_SIZE << order);
@@ -3538,7 +3539,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
  */
 void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
 {
-	unsigned order = get_order(size);
+	unsigned int order = get_order(size);
 	struct page *p = alloc_pages_node(nid, gfp_mask, order);
 	if (!p)
 		return NULL;
@@ -3840,7 +3841,8 @@ void show_free_areas(unsigned int filter
 	}
 
 	for_each_populated_zone(zone) {
-		unsigned long nr[MAX_ORDER], flags, order, total = 0;
+		unsigned int order;
+		unsigned long nr[MAX_ORDER], flags, total = 0;
 		unsigned char types[MAX_ORDER];
 
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
@@ -4189,7 +4191,7 @@ static void build_zonelists(pg_data_t *p
 	nodemask_t used_mask;
 	int local_node, prev_node;
 	struct zonelist *zonelist;
-	int order = current_zonelist_order;
+	unsigned int order = current_zonelist_order;
 
 	/* initialize zonelists */
 	for (i = 0; i < MAX_ZONELISTS; i++) {
@@ -6852,7 +6854,8 @@ int alloc_contig_range(unsigned long sta
 		       unsigned migratetype)
 {
 	unsigned long outer_start, outer_end;
-	int ret = 0, order;
+	unsigned int order;
+	int ret = 0;
 
 	struct compact_control cc = {
 		.nr_migratepages = 0,
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

