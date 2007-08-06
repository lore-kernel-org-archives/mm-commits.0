From: akpm@linux-foundation.org
Subject: + apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:44:12 -0700
Message-ID: <200708061944.l76JiC88011557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760685AbXHFTof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, lethal@linux-sh.org


The patch titled
     Apply memory policies to top two highest zones when highest zone is ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Apply memory policies to top two highest zones when highest zone is ZONE_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

The NUMA layer only supports NUMA policies for the highest zone.  When
ZONE_MOVABLE is configured with kernelcore=, the the highest zone becomes
ZONE_MOVABLE.  The result is that policies are only applied to allocations
like anonymous pages and page cache allocated from ZONE_MOVABLE when the
zone is used.

This patch applies policies to the two highest zones when the highest zone
is ZONE_MOVABLE.  As ZONE_MOVABLE consists of pages from the highest "real"
zone, it's always functionally equivalent.

The patch has been tested on a variety of machines both NUMA and non-NUMA
covering x86, x86_64 and ppc64.  No abnormal results were seen in
kernbench, tbench, dbench or hackbench.  It passes regression tests from
the numactl package with and without kernelcore= once numactl tests are
patched to wait for vmstat counters to update.

akpm: this is a nasty hack to fix NUMA mempolicies in the presence of
ZONE_MOVABLE in 2.6.23.  Christoph says "For .24 either merge the mobility or
get the other solution that Mel is working on.  That solution would only use a
single zonelist per node and filter on the fly.  That may help performance and
also help to make memory policies work better."

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 include/linux/mmzone.h    |   18 ++++++++++++++++++
 mm/mempolicy.c            |    2 +-
 mm/page_alloc.c           |   13 +++++++++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff -puN include/linux/mempolicy.h~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable
+++ a/include/linux/mempolicy.h
@@ -166,7 +166,7 @@ extern enum zone_type policy_zone;
 
 static inline void check_highest_zone(enum zone_type k)
 {
-	if (k > policy_zone)
+	if (k > policy_zone && k != ZONE_MOVABLE)
 		policy_zone = k;
 }
 
diff -puN include/linux/mmzone.h~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable include/linux/mmzone.h
--- a/include/linux/mmzone.h~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable
+++ a/include/linux/mmzone.h
@@ -410,6 +410,24 @@ struct zonelist {
 #endif
 };
 
+#ifdef CONFIG_NUMA
+/*
+ * Only custom zonelists like MPOL_BIND need to be filtered as part of
+ * policies. As described in the comment for struct zonelist_cache, these
+ * zonelists will not have a zlcache so zlcache_ptr will not be set. Use
+ * that to determine if the zonelists needs to be filtered or not.
+ */
+static inline int alloc_should_filter_zonelist(struct zonelist *zonelist)
+{
+	return !zonelist->zlcache_ptr;
+}
+#else
+static inline int alloc_should_filter_zonelist(struct zonelist *zonelist)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA */
+
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 struct node_active_region {
 	unsigned long start_pfn;
diff -puN mm/mempolicy.c~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable mm/mempolicy.c
--- a/mm/mempolicy.c~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable
+++ a/mm/mempolicy.c
@@ -149,7 +149,7 @@ static struct zonelist *bind_zonelist(no
 	   lower zones etc. Avoid empty zones because the memory allocator
 	   doesn't like them. If you implement node hot removal you
 	   have to fix that. */
-	k = policy_zone;
+	k = MAX_NR_ZONES - 1;
 	while (1) {
 		for_each_node_mask(nd, *nodes) { 
 			struct zone *z = &NODE_DATA(nd)->node_zones[k];
diff -puN mm/page_alloc.c~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable mm/page_alloc.c
--- a/mm/page_alloc.c~apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable
+++ a/mm/page_alloc.c
@@ -1157,6 +1157,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
+	enum zone_type highest_zoneidx = -1; /* Gets set for policy zonelists */
 
 zonelist_scan:
 	/*
@@ -1166,6 +1167,18 @@ zonelist_scan:
 	z = zonelist->zones;
 
 	do {
+		/*
+		 * In NUMA, this could be a policy zonelist which contains
+		 * zones that may not be allowed by the current gfp_mask.
+		 * Check the zone is allowed by the current flags
+		 */
+		if (unlikely(alloc_should_filter_zonelist(zonelist))) {
+			if (highest_zoneidx == -1)
+				highest_zoneidx = gfp_zone(gfp_mask);
+			if (zone_idx(*z) > highest_zoneidx)
+				continue;
+		}
+
 		if (NUMA_BUILD && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

fix-missing-numa_zonelist_order-sysctl.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
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
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
