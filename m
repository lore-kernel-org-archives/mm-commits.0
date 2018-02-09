From: akpm@linux-foundation.org
Subject: + mm-initialize-pages-on-demand-during-boot.patch added to -mm
 tree
Date: Fri, 09 Feb 2018 12:36:25 -0800
Message-ID: <5a7e0649.WgnItA24TqU8JotA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbeBIUhC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 15:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, baiyaowei@cmss.chinamobile.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, gi-oh.kim@profitbricks.com, hannes@cmpxchg.org, heiko.carstens@de.ibm.com, mgorman@suse.de, mhocko@suse.com, miles.chen@mediatek.com, m.mizuma@jp.fujitsu.com, paul.burton@mips.com, richard.weiyang@gmail.com, steven.sistare@oracle.com, takahiro.akashi@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: initialize pages on demand during boot
has been added to the -mm tree.  Its filename is
     mm-initialize-pages-on-demand-during-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-pages-on-demand-during-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-pages-on-demand-during-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: initialize pages on demand during boot

Deferred page initialization allows the boot cpu to initialize a small
subset of the system's pages early in boot, with other cpus doing the rest
later on.

It is, however, problematic to know how many pages the kernel needs during
boot.  Different modules and kernel parameters may change the requirement,
so the boot cpu either initializes too many pages or runs out of memory.

To fix that, initialize early pages on demand.  This ensures the kernel
does the minimum amount of work to initialize pages during boot and leaves
the rest to be divided in the multithreaded initialization path
(deferred_init_memmap).

The on-demand code is permanently disabled using static branching once
deferred pages are initialized.  After the static branch is changed to
false, the overhead is up-to two branch-always instructions if the zone
watermark check fails or if rmqueue fails.

Link: http://lkml.kernel.org/r/20180209192216.20509-2-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: <m.mizuma@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Miles Chen <miles.chen@mediatek.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   10 --
 mm/memblock.c            |   23 ----
 mm/page_alloc.c          |  175 ++++++++++++++++++++++++++++---------
 3 files changed, 136 insertions(+), 72 deletions(-)

diff -puN include/linux/memblock.h~mm-initialize-pages-on-demand-during-boot include/linux/memblock.h
--- a/include/linux/memblock.h~mm-initialize-pages-on-demand-during-boot
+++ a/include/linux/memblock.h
@@ -417,21 +417,11 @@ static inline void early_memtest(phys_ad
 {
 }
 #endif
-
-extern unsigned long memblock_reserved_memory_within(phys_addr_t start_addr,
-		phys_addr_t end_addr);
 #else
 static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
 	return 0;
 }
-
-static inline unsigned long memblock_reserved_memory_within(phys_addr_t start_addr,
-		phys_addr_t end_addr)
-{
-	return 0;
-}
-
 #endif /* CONFIG_HAVE_MEMBLOCK */
 
 #endif /* __KERNEL__ */
diff -puN mm/memblock.c~mm-initialize-pages-on-demand-during-boot mm/memblock.c
--- a/mm/memblock.c~mm-initialize-pages-on-demand-during-boot
+++ a/mm/memblock.c
@@ -1778,29 +1778,6 @@ static void __init_memblock memblock_dum
 	}
 }
 
-extern unsigned long __init_memblock
-memblock_reserved_memory_within(phys_addr_t start_addr, phys_addr_t end_addr)
-{
-	struct memblock_region *rgn;
-	unsigned long size = 0;
-	int idx;
-
-	for_each_memblock_type(idx, (&memblock.reserved), rgn) {
-		phys_addr_t start, end;
-
-		if (rgn->base + rgn->size < start_addr)
-			continue;
-		if (rgn->base > end_addr)
-			continue;
-
-		start = rgn->base;
-		end = start + rgn->size;
-		size += end - start;
-	}
-
-	return size;
-}
-
 void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
diff -puN mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot
+++ a/mm/page_alloc.c
@@ -291,40 +291,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 int page_group_by_mobility_disabled __read_mostly;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-
-/*
- * Determine how many pages need to be initialized during early boot
- * (non-deferred initialization).
- * The value of first_deferred_pfn will be set later, once non-deferred pages
- * are initialized, but for now set it ULONG_MAX.
- */
-static inline void reset_deferred_meminit(pg_data_t *pgdat)
-{
-	phys_addr_t start_addr, end_addr;
-	unsigned long max_pgcnt;
-	unsigned long reserved;
-
-	/*
-	 * Initialise at least 2G of a node but also take into account that
-	 * two large system hashes that can take up 1GB for 0.25TB/node.
-	 */
-	max_pgcnt = max(2UL << (30 - PAGE_SHIFT),
-			(pgdat->node_spanned_pages >> 8));
-
-	/*
-	 * Compensate the all the memblock reservations (e.g. crash kernel)
-	 * from the initial estimation to make sure we will initialize enough
-	 * memory to boot.
-	 */
-	start_addr = PFN_PHYS(pgdat->node_start_pfn);
-	end_addr = PFN_PHYS(pgdat->node_start_pfn + max_pgcnt);
-	reserved = memblock_reserved_memory_within(start_addr, end_addr);
-	max_pgcnt += PHYS_PFN(reserved);
-
-	pgdat->static_init_pgcnt = min(max_pgcnt, pgdat->node_spanned_pages);
-	pgdat->first_deferred_pfn = ULONG_MAX;
-}
-
 /* Returns true if the struct page for the pfn is uninitialised */
 static inline bool __meminit early_page_uninitialised(unsigned long pfn)
 {
@@ -357,10 +323,6 @@ static inline bool update_defer_init(pg_
 	return true;
 }
 #else
-static inline void reset_deferred_meminit(pg_data_t *pgdat)
-{
-}
-
 static inline bool early_page_uninitialised(unsigned long pfn)
 {
 	return false;
@@ -1604,6 +1566,107 @@ static int __init deferred_init_memmap(v
 	pgdat_init_report_one_done();
 	return 0;
 }
+
+/*
+ * This lock grantees that only one thread at a time is allowed to grow zones
+ * (decrease number of deferred pages).
+ * Protects first_deferred_pfn field in all zones during early boot before
+ * deferred pages are initialized.  Deferred pages are initialized in
+ * page_alloc_init_late() soon after smp_init() is complete.
+ */
+static __initdata DEFINE_SPINLOCK(deferred_zone_grow_lock);
+DEFINE_STATIC_KEY_TRUE(deferred_pages);
+
+/*
+ * If this zone has deferred pages, try to grow it by initializing enough
+ * deferred pages to satisfy the allocation specified by order, rounded up to
+ * the nearest PAGES_PER_SECTION boundary.  So we're adding memory in increments
+ * of SECTION_SIZE bytes by initializing struct pages in increments of
+ * PAGES_PER_SECTION * sizeof(struct page) bytes.
+ *
+ * Return true when zone was grown by at least number of pages specified by
+ * order. Otherwise return false.
+ *
+ * Note: We use noinline because this function is needed only during boot, and
+ * it is called from a __ref function _deferred_grow_zone. This way we are
+ * making sure that it is not inlined into permanent text section.
+ */
+static noinline bool __init
+deferred_grow_zone(struct zone *zone, unsigned int order)
+{
+	int zid = zone_idx(zone);
+	int nid = zone->node;
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
+	unsigned long nr_pages = 0;
+	unsigned long first_init_pfn, first_deferred_pfn, spfn, epfn, t, flags;
+	phys_addr_t spa, epa;
+	u64 i;
+
+	/* Only the last zone may have deferred pages */
+	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
+		return false;
+
+	spin_lock_irqsave(&deferred_zone_grow_lock, flags);
+	/*
+	 * Bail if we raced with another thread that disabled on demand
+	 * initialization.
+	 */
+	if (!static_branch_unlikely(&deferred_pages)) {
+		spin_unlock_irqrestore(&deferred_zone_grow_lock, flags);
+		return false;
+	}
+
+	first_deferred_pfn = pgdat->first_deferred_pfn;
+	first_init_pfn = max(zone->zone_start_pfn, first_deferred_pfn);
+
+	if (first_init_pfn >= pgdat_end_pfn(pgdat)) {
+		spin_unlock_irqrestore(&deferred_zone_grow_lock, flags);
+		return false;
+	}
+
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
+		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
+		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+
+		while (spfn < epfn && nr_pages < nr_pages_needed) {
+			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
+			first_deferred_pfn = min(t, epfn);
+			nr_pages += deferred_init_pages(nid, zid, spfn,
+							first_deferred_pfn);
+			spfn = first_deferred_pfn;
+		}
+
+		if (nr_pages >= nr_pages_needed)
+			break;
+	}
+
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
+		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
+		epfn = min_t(unsigned long, first_deferred_pfn, PFN_DOWN(epa));
+		deferred_free_pages(nid, zid, spfn, epfn);
+
+		if (first_deferred_pfn == epfn)
+			break;
+	}
+	pgdat->first_deferred_pfn = first_deferred_pfn;
+	spin_unlock_irqrestore(&deferred_zone_grow_lock, flags);
+
+	return nr_pages >= nr_pages_needed;
+}
+
+/*
+ * deferred_grow_zone() is __init, but it is called from
+ * get_page_from_freelist() during early boot until deferred_pages permanently
+ * disables this call. This is why we have refdata wrapper to avoid warning,
+ * and to ensure that the function body gets unloaded.
+ */
+static bool __ref
+_deferred_grow_zone(struct zone *zone, unsigned int order)
+{
+	return deferred_grow_zone(zone, order);
+}
+
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 void __init page_alloc_init_late(void)
@@ -1613,6 +1676,14 @@ void __init page_alloc_init_late(void)
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	int nid;
 
+	/*
+	 * We are about to initialize the rest of deferred pages, permanently
+	 * disable on-demand struct page initialization.
+	 */
+	spin_lock(&deferred_zone_grow_lock);
+	static_branch_disable(&deferred_pages);
+	spin_unlock(&deferred_zone_grow_lock);
+
 	/* There will be num_node_state(N_MEMORY) threads */
 	atomic_set(&pgdat_init_n_undone, num_node_state(N_MEMORY));
 	for_each_node_state(nid, N_MEMORY) {
@@ -3199,6 +3270,16 @@ get_page_from_freelist(gfp_t gfp_mask, u
 				       ac_classzone_idx(ac), alloc_flags)) {
 			int ret;
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+			/*
+			 * Watermark failed for this zone, but see if we can
+			 * grow this zone if it contains deferred pages.
+			 */
+			if (static_branch_unlikely(&deferred_pages)) {
+				if (_deferred_grow_zone(zone, order))
+					goto try_this_zone;
+			}
+#endif
 			/* Checked here to keep the fast path fast */
 			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
@@ -3240,6 +3321,14 @@ try_this_zone:
 				reserve_highatomic_pageblock(page, zone, order);
 
 			return page;
+		} else {
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+			/* Try again if zone has deferred pages */
+			if (static_branch_unlikely(&deferred_pages)) {
+				if (_deferred_grow_zone(zone, order))
+					goto try_this_zone;
+			}
+#endif
 		}
 	}
 
@@ -6247,7 +6336,15 @@ void __paginginit free_area_init_node(in
 
 	alloc_node_mem_map(pgdat);
 
-	reset_deferred_meminit(pgdat);
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+	/*
+	 * We start only with one section of pages, more pages are added as
+	 * needed until the rest of deferred pages are initialized.
+	 */
+	pgdat->static_init_pgcnt = min(PAGES_PER_SECTION,
+				       pgdat->node_spanned_pages);
+	pgdat->first_deferred_pfn = ULONG_MAX;
+#endif
 	free_area_init_core(pgdat);
 }
 
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
sparc64-ng4-memset-32-bits-overflow.patch

