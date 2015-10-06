From: akpm@linux-foundation.org
Subject: + mm-vmstatc-uninline-node_page_state.patch added to -mm tree
Date: Tue, 06 Oct 2015 15:13:04 -0700
Message-ID: <56144770.DrgDEjKmIT77bz2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbJFWNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 18:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: uninline node_page_state()
has been added to the -mm tree.  Its filename is
     mm-vmstatc-uninline-node_page_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-uninline-node_page_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-uninline-node_page_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/vmstat.c            |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 23 deletions(-)

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
@@ -591,6 +591,30 @@ void zone_statistics(struct zone *prefer
 	else
 		__inc_zone_state(z, NUMA_OTHER);
 }
+
+/*
+ * Determine the per node value of a stat item. This function
+ * is called frequently in a NUMA machine, so try to be as
+ * frugal as possible.
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
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

