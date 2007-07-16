From: akpm@linux-foundation.org
Subject: - slub-support-slub_debug-on-by-default.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:16 -0700
Message-ID: <200707162049.l6GKnGvE001148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760838AbXGPVVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: support slub_debug on by default
has been removed from the -mm tree.  Its filename was
     slub-support-slub_debug-on-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: support slub_debug on by default
From: Christoph Lameter <clameter@sgi.com>

Add a new configuration variable

CONFIG_SLUB_DEBUG_ON

If set then the kernel will be booted by default with slab debugging
switched on. Similar to CONFIG_SLAB_DEBUG. By default slab debugging
is available but must be enabled by specifying "slub_debug" as a
kernel parameter.

Also add support to switch off slab debugging for a kernel that was
built with CONFIG_SLUB_DEBUG_ON. This works by specifying

slub_debug=-

as a kernel parameter.

Dave Jones wanted this feature.
http://marc.info/?l=linux-kernel&m=118072189913045&w=2

[akpm@linux-foundation.org: clean up switch statement]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   38 ++++++------
 Documentation/vm/slub.txt           |    2 
 lib/Kconfig.debug                   |   13 ++++
 mm/slub.c                           |   79 ++++++++++++++++----------
 4 files changed, 87 insertions(+), 45 deletions(-)

diff -puN Documentation/kernel-parameters.txt~slub-support-slub_debug-on-by-default Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~slub-support-slub_debug-on-by-default
+++ a/Documentation/kernel-parameters.txt
@@ -1580,35 +1580,39 @@ and is between 256 and 4096 characters. 
 
 	slram=		[HW,MTD]
 
-	slub_debug	[MM, SLUB]
-			Enabling slub_debug allows one to determine the culprit
-			if slab objects become corrupted. Enabling slub_debug
-			creates guard zones around objects and poisons objects
-			when not in use. Also tracks the last alloc / free.
-			For more information see Documentation/vm/slub.txt.
+	slub_debug[=options[,slabs]]	[MM, SLUB]
+			Enabling slub_debug allows one to determine the
+			culprit if slab objects become corrupted. Enabling
+			slub_debug can create guard zones around objects and
+			may poison objects when not in use. Also tracks the
+			last alloc / free. For more information see
+			Documentation/vm/slub.txt.
 
 	slub_max_order= [MM, SLUB]
-			Determines the maximum allowed order for slabs. Setting
-			this too high may cause fragmentation.
-			For more information see Documentation/vm/slub.txt.
+			Determines the maximum allowed order for slabs.
+			A high setting may cause OOMs due to memory
+			fragmentation. For more information see
+			Documentation/vm/slub.txt.
 
 	slub_min_objects=	[MM, SLUB]
-			The minimum objects per slab. SLUB will increase the
-			slab order up to slub_max_order to generate a
-			sufficiently big slab to satisfy the number of objects.
-			The higher the number of objects the smaller the overhead
-			of tracking slabs.
+			The minimum number of objects per slab. SLUB will
+			increase the slab order up to slub_max_order to
+			generate a sufficiently large slab able to contain
+			the number of objects indicated. The higher the number
+			of objects the smaller the overhead of tracking slabs
+			and the less frequently locks need to be acquired.
 			For more information see Documentation/vm/slub.txt.
 
 	slub_min_order=	[MM, SLUB]
 			Determines the mininum page order for slabs. Must be
-			lower than slub_max_order
+			lower than slub_max_order.
 			For more information see Documentation/vm/slub.txt.
 
 	slub_nomerge	[MM, SLUB]
-			Disable merging of slabs of similar size. May be
+			Disable merging of slabs with similar size. May be
 			necessary if there is some reason to distinguish
-			allocs to different slabs.
+			allocs to different slabs. Debug options disable
+			merging on their own.
 			For more information see Documentation/vm/slub.txt.
 
 	smart2=		[HW]
diff -puN Documentation/vm/slub.txt~slub-support-slub_debug-on-by-default Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~slub-support-slub_debug-on-by-default
+++ a/Documentation/vm/slub.txt
@@ -41,6 +41,8 @@ Possible debug options are
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
+	-		Switch all debugging off (useful if the kernel is
+			configured with CONFIG_SLUB_DEBUG_ON)
 
 F.e. in order to boot just with sanity checks and red zoning one would specify:
 
diff -puN lib/Kconfig.debug~slub-support-slub_debug-on-by-default lib/Kconfig.debug
--- a/lib/Kconfig.debug~slub-support-slub_debug-on-by-default
+++ a/lib/Kconfig.debug
@@ -152,6 +152,19 @@ config DEBUG_SLAB_LEAK
 	bool "Memory leak debugging"
 	depends on DEBUG_SLAB
 
+config SLUB_DEBUG_ON
+	bool "SLUB debugging on by default"
+	depends on SLUB && SLUB_DEBUG
+	default n
+	help
+	  Boot with debugging on by default. SLUB boots by default with
+	  the runtime debug capabilities switched off. Enabling this is
+	  equivalent to specifying the "slub_debug" parameter on boot.
+	  There is no support for more fine grained debug control like
+	  possible with slub_debug=xxx. SLUB debugging may be switched
+	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
+	  "slub_debug=-".
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
diff -puN mm/slub.c~slub-support-slub_debug-on-by-default mm/slub.c
--- a/mm/slub.c~slub-support-slub_debug-on-by-default
+++ a/mm/slub.c
@@ -323,7 +323,11 @@ static inline int slab_index(void *p, st
 /*
  * Debug settings:
  */
+#ifdef CONFIG_SLUB_DEBUG_ON
+static int slub_debug = DEBUG_DEFAULT_FLAGS;
+#else
 static int slub_debug;
+#endif
 
 static char *slub_debug_slabs;
 
@@ -888,38 +892,57 @@ fail:
 
 static int __init setup_slub_debug(char *str)
 {
-	if (!str || *str != '=')
-		slub_debug = DEBUG_DEFAULT_FLAGS;
-	else {
-		str++;
-		if (*str == 0 || *str == ',')
-			slub_debug = DEBUG_DEFAULT_FLAGS;
-		else
-		for( ;*str && *str != ','; str++)
-			switch (*str) {
-			case 'f' : case 'F' :
-				slub_debug |= SLAB_DEBUG_FREE;
-				break;
-			case 'z' : case 'Z' :
-				slub_debug |= SLAB_RED_ZONE;
-				break;
-			case 'p' : case 'P' :
-				slub_debug |= SLAB_POISON;
-				break;
-			case 'u' : case 'U' :
-				slub_debug |= SLAB_STORE_USER;
-				break;
-			case 't' : case 'T' :
-				slub_debug |= SLAB_TRACE;
-				break;
-			default:
-				printk(KERN_ERR "slub_debug option '%c' "
-					"unknown. skipped\n",*str);
-			}
+	slub_debug = DEBUG_DEFAULT_FLAGS;
+	if (*str++ != '=' || !*str)
+		/*
+		 * No options specified. Switch on full debugging.
+		 */
+		goto out;
+
+	if (*str == ',')
+		/*
+		 * No options but restriction on slabs. This means full
+		 * debugging for slabs matching a pattern.
+		 */
+		goto check_slabs;
+
+	slub_debug = 0;
+	if (*str == '-')
+		/*
+		 * Switch off all debugging measures.
+		 */
+		goto out;
+
+	/*
+	 * Determine which debug features should be switched on
+	 */
+	for ( ;*str && *str != ','; str++) {
+		switch (tolower(*str)) {
+		case 'f':
+			slub_debug |= SLAB_DEBUG_FREE;
+			break;
+		case 'z':
+			slub_debug |= SLAB_RED_ZONE;
+			break;
+		case 'p':
+			slub_debug |= SLAB_POISON;
+			break;
+		case 'u':
+			slub_debug |= SLAB_STORE_USER;
+			break;
+		case 't':
+			slub_debug |= SLAB_TRACE;
+			break;
+		default:
+			printk(KERN_ERR "slub_debug option '%c' "
+				"unknown. skipped\n",*str);
+		}
 	}
 
+check_slabs:
 	if (*str == ',')
 		slub_debug_slabs = str + 1;
+out:
 	return 1;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch
make-slub-the-default-allocator.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
