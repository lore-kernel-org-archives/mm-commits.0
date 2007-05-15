From: akpm@linux-foundation.org
Subject: + have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch added to -mm tree
Date: Mon, 14 May 2007 20:06:57 -0700
Message-ID: <200705150306.l4F36vfl000324@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbXEODIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 23:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     Have kswapd keep a minimum order free other than order-0
has been added to the -mm tree.  Its filename is
     have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Have kswapd keep a minimum order free other than order-0
From: mel@skynet.ie (Mel Gorman)

kswapd normally reclaims at order 0 unless there is a higher-order allocation
currently being serviced.  However, in some cases it is known that there is a
minimum order size that is generally required such as when SLUB is configured
to use higher orders for performance reasons.  This patch allows a minumum
order to be set, such that min_free_kbytes pages are kept at higher orders. 
This depends on lumpy-reclaim to work.

[clameter@sgi.com: Call raise_kswapd_order() on kmem_cache_open()]
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/slub.c              |    1 +
 mm/vmscan.c            |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~have-kswapd-keep-a-minimum-order-free-other-than-order-0 include/linux/mmzone.h
--- a/include/linux/mmzone.h~have-kswapd-keep-a-minimum-order-free-other-than-order-0
+++ a/include/linux/mmzone.h
@@ -489,6 +489,7 @@ typedef struct pglist_data {
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
 void build_all_zonelists(void);
+void raise_kswapd_order(unsigned int order);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
diff -puN mm/slub.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0 mm/slub.c
--- a/mm/slub.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0
+++ a/mm/slub.c
@@ -1987,6 +1987,7 @@ static int kmem_cache_open(struct kmem_c
 #ifdef CONFIG_NUMA
 	s->defrag_ratio = 100;
 #endif
+	raise_kswapd_order(s->order);
 
 	if (init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		return 1;
diff -puN mm/vmscan.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0 mm/vmscan.c
--- a/mm/vmscan.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0
+++ a/mm/vmscan.c
@@ -1290,6 +1290,34 @@ out:
 	return nr_reclaimed;
 }
 
+static unsigned int kswapd_min_order __read_mostly;
+
+static inline int kswapd_order(unsigned int order)
+{
+	return max(kswapd_min_order, order);
+}
+
+/**
+ * raise_kswapd_order - Raise the minimum order that kswapd reclaims
+ * @order: The minimum order kswapd should reclaim at
+ *
+ * kswapd normally reclaims at order 0 unless there is a higher-order
+ * allocation being serviced. This function is used to set the minimum
+ * order that kswapd reclaims at when it is known there will be regular
+ * high-order allocations at a given order.
+ */
+void raise_kswapd_order(unsigned int order)
+{
+	if (order >= MAX_ORDER)
+		return;
+
+	/* Update order if necessary and inform if changed */
+	if (order > kswapd_min_order) {
+		kswapd_min_order = order;
+		printk(KERN_INFO "kswapd reclaim order set to %d\n", order);
+	}
+}
+
 /*
  * The background pageout daemon, started as a kernel thread
  * from the init process. 
@@ -1333,12 +1361,12 @@ static int kswapd(void *p)
 	 */
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 
-	order = 0;
+	order = kswapd_order(0);
 	for ( ; ; ) {
 		unsigned long new_order;
 
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
-		new_order = pgdat->kswapd_max_order;
+		new_order = kswapd_order(pgdat->kswapd_max_order);
 		pgdat->kswapd_max_order = 0;
 		if (order < new_order) {
 			/*
@@ -1350,7 +1378,7 @@ static int kswapd(void *p)
 			if (!freezing(current))
 				schedule();
 
-			order = pgdat->kswapd_max_order;
+			order = kswapd_order(pgdat->kswapd_max_order);
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
