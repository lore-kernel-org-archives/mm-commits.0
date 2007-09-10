From: akpm@linux-foundation.org
Subject: + config_zone_movable-config-zone-movable.patch added to -mm tree
Date: Mon, 10 Sep 2007 12:46:06 -0700
Message-ID: <200709101946.l8AJk6Tm007613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760976AbXIJTqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 15:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     CONFIG_ZONE_MOVABLE: config zone movable
has been added to the -mm tree.  Its filename is
     config_zone_movable-config-zone-movable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CONFIG_ZONE_MOVABLE: config zone movable
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Makes ZONE_MOVABLE as configurable

Based on "zone_ifdef_cleanup_by_renumbering.patch"

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    3 ++-
 include/linux/mmzone.h |   15 +++++++++++----
 include/linux/vmstat.h |   13 +++++++++++--
 mm/Kconfig             |   12 ++++++++++++
 mm/page_alloc.c        |    6 ++++++
 mm/vmstat.c            |    8 +++++++-
 6 files changed, 49 insertions(+), 8 deletions(-)

diff -puN include/linux/gfp.h~config_zone_movable-config-zone-movable include/linux/gfp.h
--- a/include/linux/gfp.h~config_zone_movable-config-zone-movable
+++ a/include/linux/gfp.h
@@ -130,7 +130,8 @@ static inline enum zone_type gfp_zone(gf
 	if (is_configured_zone(ZONE_DMA32) && (flags & __GFP_DMA32))
 		return base + ZONE_DMA32;
 
-	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
+	if (is_configured_zone(ZONE_MOVABLE) &&
+	    (flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
 		return base + ZONE_MOVABLE;
 
diff -puN include/linux/mmzone.h~config_zone_movable-config-zone-movable include/linux/mmzone.h
--- a/include/linux/mmzone.h~config_zone_movable-config-zone-movable
+++ a/include/linux/mmzone.h
@@ -177,7 +177,9 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	ZONE_MOVABLE,
+#endif
 	MAX_NR_ZONES,
 #ifndef CONFIG_ZONE_DMA
 	ZONE_DMA,
@@ -188,6 +190,9 @@ enum zone_type {
 #ifndef CONFIG_HIGHMEM
 	ZONE_HIGHMEM,
 #endif
+#ifndef CONFIG_ZONE_MOVABLE
+	ZONE_MOVABLE,
+#endif
 };
 
 /*
@@ -612,11 +617,13 @@ static inline int zone_idx_is(enum zone_
 
 static inline int zone_movable_is_highmem(void)
 {
-#if CONFIG_ARCH_POPULATES_NODE_MAP
-	if (is_configured_zone(ZONE_HIGHMEM))
-		return movable_zone == ZONE_HIGHMEM;
-#endif
+#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+	return is_configured_zone(ZONE_HIGHMEM) &&
+	       is_configured_zone(ZONE_MOVABLE) &&
+		(movable_zone == ZONE_HIGHMEM);
+#else
 	return 0;
+#endif
 }
 
 static inline int is_highmem_idx(enum zone_type idx)
diff -puN include/linux/vmstat.h~config_zone_movable-config-zone-movable include/linux/vmstat.h
--- a/include/linux/vmstat.h~config_zone_movable-config-zone-movable
+++ a/include/linux/vmstat.h
@@ -25,7 +25,14 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
+#ifdef CONFIG_ZONE_MOVABLE
+#define MOVABLE_ZONE(xx) , xx##_MOVABLE
+#else
+#define MOVABLE_ZONE(xx)
+#endif
+
+
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) MOVABLE_ZONE(xx)
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
@@ -170,7 +177,9 @@ static inline unsigned long node_page_st
 	if (is_configured_zone(ZONE_HIGHMEM))
 		val += zone_page_state(&zones[ZONE_HIGHMEM], item);
 
-	val += zone_page_state(&zones[ZONE_MOVABLE], item);
+	if (is_configured_zone(ZONE_MOVABLE))
+		val += zone_page_state(&zones[ZONE_MOVABLE], item);
+
 	return val;
 }
 
diff -puN mm/Kconfig~config_zone_movable-config-zone-movable mm/Kconfig
--- a/mm/Kconfig~config_zone_movable-config-zone-movable
+++ a/mm/Kconfig
@@ -125,6 +125,18 @@ config SPARSEMEM_VMEMMAP
 	depends on SPARSEMEM
 	default y if (SPARSEMEM_VMEMMAP_ENABLE)
 
+
+config ZONE_MOVABLE
+	bool	"Zone for movable pages"
+	depends on ARCH_POPULATES_NODE_MAP
+	help
+	  Allows creating a zone type only for movable pages, e.g. page cache
+	  and anonymous memory. Because movable pages are easily reclaimed
+	  and page migration technique can move them, your chance for allocating
+	  contiguous memory such as huge pages will be better than other zones.
+	  To use this zone, please see "kernelcore=" or "movablecore=" in
+	  Documentation/kernel-parameters.txt
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff -puN mm/page_alloc.c~config_zone_movable-config-zone-movable mm/page_alloc.c
--- a/mm/page_alloc.c~config_zone_movable-config-zone-movable
+++ a/mm/page_alloc.c
@@ -95,7 +95,9 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 #ifdef CONFIG_HIGHMEM
 	 32,
 #endif
+#ifdef CONFIG_ZONE_MOVABLE
 	 32,
+#endif
 };
 
 EXPORT_SYMBOL(totalram_pages);
@@ -3908,6 +3910,10 @@ static int __init cmdline_parse_core(cha
 	if (!p)
 		return -EINVAL;
 
+	if (!is_configured_zone(ZONE_MOVABLE)) {
+		printk ("ZONE_MOVABLE is not configured, %s is ignored.\n",p);
+		return 0;
+	}
 	coremem = memparse(p, &p);
 	*core = coremem >> PAGE_SHIFT;
 
diff -puN mm/vmstat.c~config_zone_movable-config-zone-movable mm/vmstat.c
--- a/mm/vmstat.c~config_zone_movable-config-zone-movable
+++ a/mm/vmstat.c
@@ -585,8 +585,14 @@ const struct seq_operations pagetypeinfo
 #define TEXT_FOR_HIGHMEM(xx)
 #endif
 
+#ifdef CONFIG_ZONE_MOVABLE
+#define TEXT_FOR_MOVABLE(xx) xx "_movable",
+#else
+#define TEXT_FOR_MOVABLE(xx)
+#endif
+
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx) xx "_movable",
+					TEXT_FOR_HIGHMEM(xx) xx TEXT_FOR_MOVABLE(xx)
 
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch
config_zone_movable-config-zone-movable.patch
