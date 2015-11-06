From: akpm@linux-foundation.org
Subject: [merged] mm-vmstatc-uninline-node_page_state.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:15:51 -0800
Message-ID: <563d0a77.z44+MoXGgdCnHNgl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033352AbbKFUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: uninline node_page_state()
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-uninline-node_page_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmstat.c: uninline node_page_state()

With x86_64 (config http://ozlabs.org/~akpm/config-akpm2.txt) and old gcc
(4.4.4), drivers/base/node.c:node_read_meminfo() is using 2344 bytes of
stack.  Uninlining node_page_state() reduces this to 440 bytes.

The stack consumption issue is fixed by newer gcc (4.8.4) however with
that compiler this patch reduces the node.o text size from 7314 bytes to
4578.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   24 +-----------------------
 mm/vmstat.c            |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstatc-uninline-node_page_state include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstatc-uninline-node_page_state
+++ a/include/linux/vmstat.h
@@ -161,30 +161,8 @@ static inline unsigned long zone_page_st
 }
 
 #ifdef CONFIG_NUMA
-/*
- * Determine the per node value of a stat item. This function
- * is called frequently in a NUMA machine, so try to be as
- * frugal as possible.
- */
-static inline unsigned long node_page_state(int node,
-				 enum zone_stat_item item)
-{
-	struct zone *zones = NODE_DATA(node)->node_zones;
-
-	return
-#ifdef CONFIG_ZONE_DMA
-		zone_page_state(&zones[ZONE_DMA], item) +
-#endif
-#ifdef CONFIG_ZONE_DMA32
-		zone_page_state(&zones[ZONE_DMA32], item) +
-#endif
-#ifdef CONFIG_HIGHMEM
-		zone_page_state(&zones[ZONE_HIGHMEM], item) +
-#endif
-		zone_page_state(&zones[ZONE_NORMAL], item) +
-		zone_page_state(&zones[ZONE_MOVABLE], item);
-}
 
+extern unsigned long node_page_state(int node, enum zone_stat_item item);
 extern void zone_statistics(struct zone *, struct zone *, gfp_t gfp);
 
 #else
diff -puN mm/vmstat.c~mm-vmstatc-uninline-node_page_state mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-uninline-node_page_state
+++ a/mm/vmstat.c
@@ -591,6 +591,28 @@ void zone_statistics(struct zone *prefer
 	else
 		__inc_zone_state(z, NUMA_OTHER);
 }
+
+/*
+ * Determine the per node value of a stat item.
+ */
+unsigned long node_page_state(int node, enum zone_stat_item item)
+{
+	struct zone *zones = NODE_DATA(node)->node_zones;
+
+	return
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], item) +
+#endif
+#ifdef CONFIG_ZONE_DMA32
+		zone_page_state(&zones[ZONE_DMA32], item) +
+#endif
+#ifdef CONFIG_HIGHMEM
+		zone_page_state(&zones[ZONE_HIGHMEM], item) +
+#endif
+		zone_page_state(&zones[ZONE_NORMAL], item) +
+		zone_page_state(&zones[ZONE_MOVABLE], item);
+}
+
 #endif
 
 #ifdef CONFIG_COMPACTION
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

