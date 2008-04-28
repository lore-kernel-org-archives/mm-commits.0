From: akpm@linux-foundation.org
Subject: - mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:06 -0700
Message-ID: <200804282154.m3SLs6Mk017969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936796AbYD1VyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: fix broken gfp_zone with __GFP_THISNODE
has been removed from the -mm tree.  Its filename was
     mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix broken gfp_zone with __GFP_THISNODE
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This hack, "base = MAX_NR_ZONES", at __GFP_THISNODE was used for old
zonliests.

Now, new zonelist[] have a list for __GFP_THISNODE and this hack is incorrect.
Should be removed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~mm-fix-broken-gfp_zone-with-__gfp_thisnode include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-broken-gfp_zone-with-__gfp_thisnode
+++ a/include/linux/gfp.h
@@ -119,29 +119,22 @@ static inline int allocflags_to_migratet
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
-	int base = 0;
-
-#ifdef CONFIG_NUMA
-	if (flags & __GFP_THISNODE)
-		base = MAX_NR_ZONES;
-#endif
-
 #ifdef CONFIG_ZONE_DMA
 	if (flags & __GFP_DMA)
-		return base + ZONE_DMA;
+		return ZONE_DMA;
 #endif
 #ifdef CONFIG_ZONE_DMA32
 	if (flags & __GFP_DMA32)
-		return base + ZONE_DMA32;
+		return ZONE_DMA32;
 #endif
 	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
-		return base + ZONE_MOVABLE;
+		return ZONE_MOVABLE;
 #ifdef CONFIG_HIGHMEM
 	if (flags & __GFP_HIGHMEM)
-		return base + ZONE_HIGHMEM;
+		return ZONE_HIGHMEM;
 #endif
-	return base + ZONE_NORMAL;
+	return ZONE_NORMAL;
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
mm-fix-usemap-initialization.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
cgroups-introduce-cft-read_seq-v2.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
memcg-remove-redundant-function-calls.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
memcg-remove-redundant-initialization-in-mem_cgroup_create.patch

