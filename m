From: akpm@linux-foundation.org
Subject: +
 mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
 added to -mm tree
Date: Thu, 07 May 2015 15:09:41 -0700
Message-ID: <554be2a5.1z4X8OCgHxxjMpMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbEGWJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 18:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, nzimmer@sgi.com, scott.norton@hp.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: finish initialisation of struct pages before basic setup
has been added to the -mm tree.  Its filename is
     mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch

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
Subject: mm: meminit: finish initialisation of struct pages before basic setup

Waiman Long reported that 24TB machines hit OOM during basic setup when
struct page initialisation was deferred.  One approach is to initialise
memory on demand but it interferes with page allocator paths.  This patch
creates dedicated threads to initialise memory before basic setup.  It
then blocks on a rw_semaphore until completion as a wait_queue and counter
is overkill.  This may be slower to boot but it's simplier overall and
also gets rid of a section mangling which existed so kswapd could do the
initialisation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Waiman Long <waiman.long@hp.com
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 +++++++
 init/main.c         |    2 +
 mm/internal.h       |   24 ---------------------
 mm/page_alloc.c     |   46 +++++++++++++++++++++++++++++++++---------
 mm/vmscan.c         |    6 +----
 5 files changed, 49 insertions(+), 37 deletions(-)

diff -puN include/linux/gfp.h~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup include/linux/gfp.h
--- a/include/linux/gfp.h~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup
+++ a/include/linux/gfp.h
@@ -379,6 +379,14 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+void page_alloc_init_late(void);
+#else
+static inline void page_alloc_init_late(void)
+{
+}
+#endif
+
 /*
  * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
  * GFP flags are used before interrupts are enabled. Once interrupts are
diff -puN init/main.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup init/main.c
--- a/init/main.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup
+++ a/init/main.c
@@ -998,6 +998,8 @@ static noinline void __init kernel_init_
 	smp_init();
 	sched_init_smp();
 
+	page_alloc_init_late();
+
 	do_basic_setup();
 
 	/* Open the /dev/console on the rootfs, this should never fail */
diff -puN mm/internal.h~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup mm/internal.h
--- a/mm/internal.h~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup
+++ a/mm/internal.h
@@ -379,30 +379,6 @@ static inline void mminit_verify_zonelis
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-/*
- * Deferred struct page initialisation requires init functions that are freed
- * before kswapd is available. Reuse the memory hotplug section annotation
- * to mark the required code.
- *
- * __defermem_init is code that always exists but is annotated __meminit to
- * 	avoid section warnings.
- * __defer_init code gets marked __meminit when deferring struct page
- *	initialistion but is otherwise in the init section.
- */
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-#define __defermem_init __meminit
-#define __defer_init    __meminit
-
-void deferred_init_memmap(int nid);
-#else
-#define __defermem_init
-#define __defer_init __init
-
-static inline void deferred_init_memmap(int nid)
-{
-}
-#endif
-
 /* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
 #if defined(CONFIG_SPARSEMEM)
 extern void mminit_validate_memmodel_limits(unsigned long *start_pfn,
diff -puN mm/page_alloc.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup
+++ a/mm/page_alloc.c
@@ -61,6 +61,7 @@
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 #include <linux/page_owner.h>
+#include <linux/kthread.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -242,7 +243,7 @@ static inline void reset_deferred_memini
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
-static inline bool __defermem_init early_page_uninitialised(unsigned long pfn)
+static inline bool __meminit early_page_uninitialised(unsigned long pfn)
 {
 	int nid = early_pfn_to_nid(pfn);
 
@@ -972,7 +973,7 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-static void __defer_init __free_pages_boot_core(struct page *page,
+static void __init __free_pages_boot_core(struct page *page,
 					unsigned long pfn, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
@@ -1045,7 +1046,7 @@ static inline bool __meminit meminit_pfn
 #endif
 
 
-void __defer_init __free_pages_bootmem(struct page *page, unsigned long pfn,
+void __init __free_pages_bootmem(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
 	if (early_page_uninitialised(pfn))
@@ -1054,7 +1055,7 @@ void __defer_init __free_pages_bootmem(s
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-static void __defermem_init deferred_free_range(struct page *page,
+static void __init deferred_free_range(struct page *page,
 					unsigned long pfn, int nr_pages)
 {
 	int i;
@@ -1074,20 +1075,30 @@ static void __defermem_init deferred_fre
 		__free_pages_boot_core(page, pfn, 0);
 }
 
+static struct rw_semaphore __initdata pgdat_init_rwsem;
+
 /* Initialise remaining memory on a node */
-void __defermem_init deferred_init_memmap(int nid)
+static int __init deferred_init_memmap(void *data)
 {
+	pg_data_t *pgdat = (pg_data_t *)data;
+	int nid = pgdat->node_id;
 	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long start = jiffies;
 	unsigned long nr_pages = 0;
 	unsigned long walk_start, walk_end;
 	int i, zid;
 	struct zone *zone;
-	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long first_init_pfn = pgdat->first_deferred_pfn;
+	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
-	if (first_init_pfn == ULONG_MAX)
-		return;
+	if (first_init_pfn == ULONG_MAX) {
+		up_read(&pgdat_init_rwsem);
+		return 0;
+	}
+
+	/* Bound memory initialisation to a local node if possible */
+	if (!cpumask_empty(cpumask))
+		set_cpus_allowed_ptr(current, cpumask);
 
 	/* Sanity check boundaries */
 	BUG_ON(pgdat->first_deferred_pfn < pgdat->node_start_pfn);
@@ -1179,8 +1190,25 @@ free_range:
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
-	pr_info("kswapd %d initialised %lu pages in %ums\n", nid, nr_pages,
+	pr_info("node %d initialised, %lu pages in %ums\n", nid, nr_pages,
 					jiffies_to_msecs(jiffies - start));
+	up_read(&pgdat_init_rwsem);
+	return 0;
+}
+
+void __init page_alloc_init_late(void)
+{
+	int nid;
+
+	init_rwsem(&pgdat_init_rwsem);
+	for_each_node_state(nid, N_MEMORY) {
+		down_read(&pgdat_init_rwsem);
+		kthread_run(deferred_init_memmap, NODE_DATA(nid), "pgdatinit%d", nid);
+	}
+
+	/* Block until all are initialised */
+	down_write(&pgdat_init_rwsem);
+	up_write(&pgdat_init_rwsem);
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
diff -puN mm/vmscan.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup mm/vmscan.c
--- a/mm/vmscan.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup
+++ a/mm/vmscan.c
@@ -3348,7 +3348,7 @@ static void kswapd_try_to_sleep(pg_data_
  * If there are applications that are active memory-allocators
  * (most normal use), this basically shouldn't matter.
  */
-static int __defermem_init kswapd(void *p)
+static int kswapd(void *p)
 {
 	unsigned long order, new_order;
 	unsigned balanced_order;
@@ -3383,8 +3383,6 @@ static int __defermem_init kswapd(void *
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	deferred_init_memmap(pgdat->node_id);
-
 	order = new_order = 0;
 	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
@@ -3540,7 +3538,7 @@ static int cpu_callback(struct notifier_
  * This kswapd start function will be called by init and node-hot-add.
  * On node-hot-add, kswapd will moved to proper cpus if cpus are hot-added.
  */
-int __defermem_init kswapd_run(int nid)
+int kswapd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	int ret = 0;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
mm-meminit-remove-mminit_verify_page_links.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
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
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

