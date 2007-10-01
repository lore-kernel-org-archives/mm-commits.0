From: akpm@linux-foundation.org
Subject: - have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch removed from -mm tree
Date: Mon, 01 Oct 2007 14:34:55 -0700
Message-ID: <200710012134.l91LYt8j004209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755901AbXJAVfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 17:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Have kswapd keep a minimum order free other than order-0
has been removed from the -mm tree.  Its filename was
     have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Have kswapd keep a minimum order free other than order-0
From: Mel Gorman <mel@csn.ul.ie>

kswapd normally reclaims at order 0 unless there is a higher-order allocation
currently being serviced.  However, in some cases it is known that there is a
minimum order size that is generally required such as when SLUB is configured
to use higher orders for performance reasons.  This patch allows a minumum
order to be set, such that min_free_kbytes pages are kept at higher orders. 
This depends on lumpy-reclaim to work.

[clameter@sgi.com: Call raise_kswapd_order() on kmem_cache_open()]
[clameter@sgi.com: fix maximum allocation order]
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/slub.c              |    1 +
 mm/vmscan.c            |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~have-kswapd-keep-a-minimum-order-free-other-than-order-0 include/linux/mmzone.h
--- a/include/linux/mmzone.h~have-kswapd-keep-a-minimum-order-free-other-than-order-0
+++ a/include/linux/mmzone.h
@@ -536,6 +536,7 @@ typedef struct pglist_data {
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
@@ -2874,6 +2874,7 @@ struct kmem_cache *kmem_cache_create(con
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
 			up_write(&slub_lock);
+			raise_kswapd_order(s->order);
 			if (sysfs_slab_add(s))
 				goto err;
 			return s;
diff -puN mm/vmscan.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0 mm/vmscan.c
--- a/mm/vmscan.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0
+++ a/mm/vmscan.c
@@ -1483,6 +1483,34 @@ out:
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
@@ -1527,12 +1555,12 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
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
@@ -1544,7 +1572,7 @@ static int kswapd(void *p)
 			if (!freezing(current))
 				schedule();
 
-			order = pgdat->kswapd_max_order;
+			order = kswapd_order(pgdat->kswapd_max_order);
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
