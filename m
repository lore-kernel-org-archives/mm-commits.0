From: akpm@linux-foundation.org
Subject: +
 mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
 added to -mm tree
Date: Wed, 29 Apr 2015 14:19:40 -0700
Message-ID: <55414aec.H7j6QIX3jDFWPlGx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbD2VTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: initialise remaining struct pages in parallel with kswapd
has been added to the -mm tree.  Its filename is
     mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch

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
Subject: mm: meminit: initialise remaining struct pages in parallel with kswapd

Only a subset of struct pages are initialised at the moment.  When this
patch is applied kswapd initialise the remaining struct pages in parallel.

This should boot faster by spreading the work to multiple CPUs and
initialising data that is local to the CPU.  The user-visible effect on
large machines is that free memory will appear to rapidly increase early
in the lifetime of the system until kswapd reports that all memory is
initialised in the kernel log.  Once initialised there should be no other
user-visibile effects.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    6 ++
 mm/mm_init.c    |    1 
 mm/page_alloc.c |  123 ++++++++++++++++++++++++++++++++++++++++++++--
 mm/vmscan.c     |    6 +-
 4 files changed, 130 insertions(+), 6 deletions(-)

diff -puN mm/internal.h~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd mm/internal.h
--- a/mm/internal.h~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd
+++ a/mm/internal.h
@@ -396,9 +396,15 @@ static inline void mminit_verify_zonelis
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 #define __defermem_init __meminit
 #define __defer_init    __meminit
+
+void deferred_init_memmap(int nid);
 #else
 #define __defermem_init
 #define __defer_init __init
+
+static inline void deferred_init_memmap(int nid)
+{
+}
 #endif
 
 /* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
diff -puN mm/mm_init.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd mm/mm_init.c
--- a/mm/mm_init.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd
+++ a/mm/mm_init.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/memory.h>
 #include <linux/notifier.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
diff -puN mm/page_alloc.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd
+++ a/mm/page_alloc.c
@@ -252,6 +252,14 @@ static inline bool __defermem_init early
 	return false;
 }
 
+static inline bool early_page_nid_uninitialised(unsigned long pfn, int nid)
+{
+	if (pfn >= NODE_DATA(nid)->first_deferred_pfn)
+		return true;
+
+	return false;
+}
+
 /*
  * Returns false when the remaining initialisation should be deferred until
  * later in the boot cycle when it can be parallelised.
@@ -284,6 +292,11 @@ static inline bool early_page_uninitiali
 	return false;
 }
 
+static inline bool early_page_nid_uninitialised(unsigned long pfn, int nid)
+{
+	return false;
+}
+
 static inline bool update_defer_init(pg_data_t *pgdat,
 				unsigned long pfn, unsigned long zone_end,
 				unsigned long *nr_initialised)
@@ -880,20 +893,51 @@ static void __meminit __init_single_pfn(
 	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid);
 }
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static void init_reserved_page(unsigned long pfn)
+{
+	pg_data_t *pgdat;
+	int nid, zid;
+
+	if (!early_page_uninitialised(pfn))
+		return;
+
+	nid = early_pfn_to_nid(pfn);
+	pgdat = NODE_DATA(nid);
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
+			break;
+	}
+	__init_single_pfn(pfn, zid, nid);
+}
+#else
+static inline void init_reserved_page(unsigned long pfn)
+{
+}
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
 /*
  * Initialised pages do not have PageReserved set. This function is
  * called for each range allocated by the bootmem allocator and
  * marks the pages PageReserved. The remaining valid pages are later
  * sent to the buddy page allocator.
  */
-void reserve_bootmem_region(unsigned long start, unsigned long end)
+void __meminit reserve_bootmem_region(unsigned long start, unsigned long end)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long end_pfn = PFN_UP(end);
 
-	for (; start_pfn < end_pfn; start_pfn++)
-		if (pfn_valid(start_pfn))
-			SetPageReserved(pfn_to_page(start_pfn));
+	for (; start_pfn < end_pfn; start_pfn++) {
+		if (pfn_valid(start_pfn)) {
+			struct page *page = pfn_to_page(start_pfn);
+
+			init_reserved_page(start_pfn);
+			SetPageReserved(page);
+		}
+	}
 }
 
 static bool free_pages_prepare(struct page *page, unsigned int order)
@@ -1018,6 +1062,74 @@ void __defer_init __free_pages_bootmem(s
 	return __free_pages_boot_core(page, pfn, order);
 }
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+/* Initialise remaining memory on a node */
+void __defermem_init deferred_init_memmap(int nid)
+{
+	struct mminit_pfnnid_cache nid_init_state = { };
+	unsigned long start = jiffies;
+	unsigned long nr_pages = 0;
+	unsigned long walk_start, walk_end;
+	int i, zid;
+	struct zone *zone;
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long first_init_pfn = pgdat->first_deferred_pfn;
+
+	if (first_init_pfn == ULONG_MAX)
+		return;
+
+	/* Sanity check boundaries */
+	BUG_ON(pgdat->first_deferred_pfn < pgdat->node_start_pfn);
+	BUG_ON(pgdat->first_deferred_pfn > pgdat_end_pfn(pgdat));
+	pgdat->first_deferred_pfn = ULONG_MAX;
+
+	/* Only the highest zone is deferred so find it */
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		zone = pgdat->node_zones + zid;
+		if (first_init_pfn < zone_end_pfn(zone))
+			break;
+	}
+
+	for_each_mem_pfn_range(i, nid, &walk_start, &walk_end, NULL) {
+		unsigned long pfn, end_pfn;
+
+		end_pfn = min(walk_end, zone_end_pfn(zone));
+		pfn = first_init_pfn;
+		if (pfn < walk_start)
+			pfn = walk_start;
+		if (pfn < zone->zone_start_pfn)
+			pfn = zone->zone_start_pfn;
+
+		for (; pfn < end_pfn; pfn++) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state))
+				continue;
+
+			if (page->flags) {
+				VM_BUG_ON(page_zone(page) != zone);
+				continue;
+			}
+
+			__init_single_page(page, pfn, zid, nid);
+			__free_pages_boot_core(page, pfn, 0);
+			nr_pages++;
+			cond_resched();
+		}
+		first_init_pfn = max(end_pfn, first_init_pfn);
+	}
+
+	/* Sanity check that the next zone really is unpopulated */
+	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
+
+	pr_info("kswapd %d initialised %lu pages in %ums\n", nid, nr_pages,
+					jiffies_to_msecs(jiffies - start));
+}
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
@@ -4271,6 +4383,9 @@ static void setup_zone_migrate_reserve(s
 	zone->nr_migrate_reserve_block = reserve;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		if (!early_page_nid_uninitialised(pfn, zone_to_nid(zone)))
+			return;
+
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
diff -puN mm/vmscan.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd
+++ a/mm/vmscan.c
@@ -3348,7 +3348,7 @@ static void kswapd_try_to_sleep(pg_data_
  * If there are applications that are active memory-allocators
  * (most normal use), this basically shouldn't matter.
  */
-static int kswapd(void *p)
+static int __defermem_init kswapd(void *p)
 {
 	unsigned long order, new_order;
 	unsigned balanced_order;
@@ -3383,6 +3383,8 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
+	deferred_init_memmap(pgdat->node_id);
+
 	order = new_order = 0;
 	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
@@ -3538,7 +3540,7 @@ static int cpu_callback(struct notifier_
  * This kswapd start function will be called by init and node-hot-add.
  * On node-hot-add, kswapd will moved to proper cpus if cpus are hot-added.
  */
-int kswapd_run(int nid)
+int __defermem_init kswapd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	int ret = 0;
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
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
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

