From: akpm@linux-foundation.org
Subject: +
 mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch added to -mm tree
Date: Mon, 27 Apr 2015 15:34:28 -0700
Message-ID: <553eb974.D6e0wpAFxkXIfQPi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965241AbbD0We3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Apr 2015 18:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: initialise a subset of struct pages if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set
has been added to the -mm tree.  Its filename is
     mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: initialise a subset of struct pages if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set

This patch initalises all low memory struct pages and 2G of the highest
zone on each node during memory initialisation if
CONFIG_DEFERRED_STRUCT_PAGE_INIT is set.  That config option cannot be set
but will be available in a later patch.  Parallel initialisation of struct
page depends on some features from memory hotplug and it is necessary to
alter alter section annotations.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   11 ++++-
 include/linux/mmzone.h |    8 ++++
 mm/Kconfig             |   18 +++++++++
 mm/internal.h          |    8 ++++
 mm/page_alloc.c        |   78 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 117 insertions(+), 6 deletions(-)

diff -puN drivers/base/node.c~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set drivers/base/node.c
--- a/drivers/base/node.c~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set
+++ a/drivers/base/node.c
@@ -359,12 +359,16 @@ int unregister_cpu_under_node(unsigned i
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 #define page_initialized(page)  (page->lru.next)
 
-static int get_nid_for_pfn(unsigned long pfn)
+static int get_nid_for_pfn(struct pglist_data *pgdat, unsigned long pfn)
 {
 	struct page *page;
 
 	if (!pfn_valid_within(pfn))
 		return -1;
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+	if (pgdat && pfn >= pgdat->first_deferred_pfn)
+		return early_pfn_to_nid(pfn);
+#endif
 	page = pfn_to_page(pfn);
 	if (!page_initialized(page))
 		return -1;
@@ -376,6 +380,7 @@ int register_mem_sect_under_node(struct
 {
 	int ret;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
+	struct pglist_data *pgdat = NODE_DATA(nid);
 
 	if (!mem_blk)
 		return -EFAULT;
@@ -388,7 +393,7 @@ int register_mem_sect_under_node(struct
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid;
 
-		page_nid = get_nid_for_pfn(pfn);
+		page_nid = get_nid_for_pfn(pgdat, pfn);
 		if (page_nid < 0)
 			continue;
 		if (page_nid != nid)
@@ -427,7 +432,7 @@ int unregister_mem_sect_under_nodes(stru
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid;
 
-		nid = get_nid_for_pfn(pfn);
+		nid = get_nid_for_pfn(NULL, pfn);
 		if (nid < 0)
 			continue;
 		if (!node_online(nid))
diff -puN include/linux/mmzone.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set
+++ a/include/linux/mmzone.h
@@ -762,6 +762,14 @@ typedef struct pglist_data {
 	/* Number of pages migrated during the rate limiting time interval */
 	unsigned long numabalancing_migrate_nr_pages;
 #endif
+
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+	/*
+	 * If memory initialisation on large machines is deferred then this
+	 * is the first PFN that needs to be initialised.
+	 */
+	unsigned long first_deferred_pfn;
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff -puN mm/Kconfig~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set mm/Kconfig
--- a/mm/Kconfig~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set
+++ a/mm/Kconfig
@@ -635,3 +635,21 @@ config MAX_STACK_SIZE_MB
 	  changed to a smaller value in which case that is used.
 
 	  A sane initial value is 80 MB.
+
+# For architectures that support deferred memory initialisation
+config ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
+	bool
+
+config DEFERRED_STRUCT_PAGE_INIT
+	bool "Defer initialisation of struct pages to kswapd"
+	default n
+	depends on ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
+	depends on MEMORY_HOTPLUG
+	help
+	  Ordinarily all struct pages are initialised during early boot in a
+	  single thread. On very large machines this can take a considerable
+	  amount of time. If this option is set, large machines will bring up
+	  a subset of memmap at boot and then initialise the rest in parallel
+	  when kswapd starts. This has a potential performance impact on
+	  processes running early in the lifetime of the systemm until kswapd
+	  finishes the initialisation.
diff -puN mm/internal.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set mm/internal.h
--- a/mm/internal.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set
+++ a/mm/internal.h
@@ -387,6 +387,14 @@ static inline void mminit_verify_zonelis
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+#define __defermem_init __meminit
+#define __defer_init    __meminit
+#else
+#define __defermem_init
+#define __defer_init __init
+#endif
+
 /* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
 #if defined(CONFIG_SPARSEMEM)
 extern void mminit_validate_memmodel_limits(unsigned long *start_pfn,
diff -puN mm/page_alloc.c~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set
+++ a/mm/page_alloc.c
@@ -235,6 +235,64 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static inline void reset_deferred_meminit(pg_data_t *pgdat)
+{
+	pgdat->first_deferred_pfn = ULONG_MAX;
+}
+
+/* Returns true if the struct page for the pfn is uninitialised */
+static inline bool __defermem_init early_page_uninitialised(unsigned long pfn)
+{
+	int nid = early_pfn_to_nid(pfn);
+
+	if (pfn >= NODE_DATA(nid)->first_deferred_pfn)
+		return true;
+
+	return false;
+}
+
+/*
+ * Returns false when the remaining initialisation should be deferred until
+ * later in the boot cycle when it can be parallelised.
+ */
+static inline bool update_defer_init(pg_data_t *pgdat,
+				unsigned long pfn, unsigned long zone_end,
+				unsigned long *nr_initialised)
+{
+	/* Always populate low zones for address-contrained allocations */
+	if (zone_end < pgdat_end_pfn(pgdat))
+		return true;
+
+	/* Initialise at least 2G of the highest zone */
+	(*nr_initialised)++;
+	if (*nr_initialised > (2UL << (30 - PAGE_SHIFT)) &&
+	    (pfn & (PAGES_PER_SECTION - 1)) == 0) {
+		pgdat->first_deferred_pfn = pfn;
+		return false;
+	}
+
+	return true;
+}
+#else
+static inline void reset_deferred_meminit(pg_data_t *pgdat)
+{
+}
+
+static inline bool early_page_uninitialised(unsigned long pfn)
+{
+	return false;
+}
+
+static inline bool update_defer_init(pg_data_t *pgdat,
+				unsigned long pfn, unsigned long zone_end,
+				unsigned long *nr_initialised)
+{
+	return true;
+}
+#endif
+
+
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
 	if (unlikely(page_group_by_mobility_disabled &&
@@ -886,8 +944,8 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-void __init __free_pages_bootmem(struct page *page, unsigned long pfn,
-							unsigned int order)
+static void __defer_init __free_pages_boot_core(struct page *page,
+					unsigned long pfn, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
@@ -945,6 +1003,14 @@ static inline bool __meminit early_pfn_i
 }
 #endif
 
+void __defer_init __free_pages_bootmem(struct page *page, unsigned long pfn,
+							unsigned int order)
+{
+	if (early_page_uninitialised(pfn))
+		return;
+	return __free_pages_boot_core(page, pfn, order);
+}
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
@@ -4260,14 +4326,16 @@ static void setup_zone_migrate_reserve(s
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, enum memmap_context context)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 	struct zone *z;
+	unsigned long nr_initialised = 0;
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
 
-	z = &NODE_DATA(nid)->node_zones[zone];
+	z = &pgdat->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
@@ -4279,6 +4347,9 @@ void __meminit memmap_init_zone(unsigned
 				continue;
 			if (!early_pfn_in_nid(pfn, nid))
 				continue;
+			if (!update_defer_init(pgdat, pfn, end_pfn,
+						&nr_initialised))
+				break;
 		}
 		__init_single_pfn(pfn, zone, nid);
 	}
@@ -5080,6 +5151,7 @@ void __paginginit free_area_init_node(in
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
 
+	reset_deferred_meminit(pgdat);
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
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
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

