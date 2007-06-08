From: akpm@linux-foundation.org
Subject: + slub-use-list_for_each_entry-for-loops-over-all-slabs.patch added to -mm tree
Date: Thu, 07 Jun 2007 23:00:17 -0700
Message-ID: <200706080600.l5860HII020648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbXFHGAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: use list_for_each_entry for loops over all slabs
has been added to the -mm tree.  Its filename is
     slub-use-list_for_each_entry-for-loops-over-all-slabs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: use list_for_each_entry for loops over all slabs
From: Christoph Lameter <clameter@sgi.com>

Use list_for_each_entry() instead of list_for_each().

Get rid of for_all_slabs(). It had only one user. So fold it into the
callback. This also gets rid of cpu_slab_flush.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   51 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff -puN mm/slub.c~slub-use-list_for_each_entry-for-loops-over-all-slabs mm/slub.c
--- a/mm/slub.c~slub-use-list_for_each_entry-for-loops-over-all-slabs
+++ a/mm/slub.c
@@ -2582,7 +2582,7 @@ static struct kmem_cache *find_mergeable
 		size_t align, unsigned long flags,
 		void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
-	struct list_head *h;
+	struct kmem_cache *s;
 
 	if (slub_nomerge || (flags & SLUB_NEVER_MERGE))
 		return NULL;
@@ -2594,10 +2594,7 @@ static struct kmem_cache *find_mergeable
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
+	list_for_each_entry(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -2680,33 +2677,6 @@ void *kmem_cache_zalloc(struct kmem_cach
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
 #ifdef CONFIG_SMP
-static void for_all_slabs(void (*func)(struct kmem_cache *, int), int cpu)
-{
-	struct list_head *h;
-
-	down_read(&slub_lock);
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
-		func(s, cpu);
-	}
-	up_read(&slub_lock);
-}
-
-/*
- * Version of __flush_cpu_slab for the case that interrupts
- * are enabled.
- */
-static void cpu_slab_flush(struct kmem_cache *s, int cpu)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__flush_cpu_slab(s, cpu);
-	local_irq_restore(flags);
-}
-
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -2715,13 +2685,21 @@ static int __cpuinit slab_cpuup_callback
 		unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	struct kmem_cache *s;
+	unsigned long flags;
 
 	switch (action) {
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		for_all_slabs(cpu_slab_flush, cpu);
+		down_read(&slub_lock);
+		list_for_each_entry(s, &slab_caches, list) {
+			local_irq_save(flags);
+			__flush_cpu_slab(s, cpu);
+			local_irq_restore(flags);
+		}
+		up_read(&slub_lock);
 		break;
 	default:
 		break;
@@ -3744,7 +3722,7 @@ static int sysfs_slab_alias(struct kmem_
 
 static int __init slab_sysfs_init(void)
 {
-	struct list_head *h;
+	struct kmem_cache *s;
 	int err;
 
 	err = subsystem_register(&slab_subsys);
@@ -3755,10 +3733,7 @@ static int __init slab_sysfs_init(void)
 
 	slab_state = SYSFS;
 
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
+	list_for_each_entry(s, &slab_caches, list) {
 		err = sysfs_slab_add(s);
 		BUG_ON(err);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
slab-fix-alien-cache-handling.patch
slub-return-zero_size_ptr-for-kmalloc0.patch
hexdump-more-output-formatting.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-remove-useless-export_symbol.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
