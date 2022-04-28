Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0946EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiD1Vyy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352692AbiD1Vyt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC374475F
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CCF62005
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EE1C385AF;
        Thu, 28 Apr 2022 21:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651182681;
        bh=LidyWgpyhN8ycbXKcYgGAWCtTC+AbpMn29dc4VtobUw=;
        h=Date:To:From:Subject:From;
        b=1M2EBqgJtDZD0+puaiIvSc2q92563ZlNuoJAoCp8Xs0XTFaYvvs0gpPeqkLoF6pw4
         qIGTon0P9M5b6eBp9/lX6JRvbhHBzl3MkOW/q/ThjGfdFqQqOpoVmnsZlQxcHr92Q9
         Nm9gVrC05OeadJaLy5UgRLmPv78/rCHv2lArqA58=
Date:   Thu, 28 Apr 2022 14:51:20 -0700
To:     mm-commits@vger.kernel.org, yuehaibing@huawei.com,
        richard.weiyang@gmail.com, mhocko@kernel.org, linmiaohe@huawei.com,
        david@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch removed from -mm tree
Message-Id: <20220428215121.80EE1C385AF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: reset node's state when empty during offline
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/memory_hotplug: reset node's state when empty during offline

All possible nodes are now pre-allocated at boot time by
free_area_init()-> free_area_init_node(), and those which are to be
hot-plugged are initialized later on by
hotadd_init_pgdat()->free_area_init_core_hotplug() when they become
online.

free_area_init_core_hotplug() calls pgdat_init_internals() and
zone_init_internals() to initialize some internal data structures and
zeroes a few pgdat fields.

But we do already call pgdat_init_internals() and zone_init_internals()
for all possible nodes back in free_area_init_core(), and pgdat fields are
already zeroed because the pre-allocation memsets with 0s the structure,
meaning we do not need to repeat the process when the node becomes online.

So initialize it only once when booting, and make sure to reset the fields
we care about to 0 when the node goes empty.  The only thing we need to
check for is to allocate per_cpu_nodestats struct the very first time this
node goes online.

node_reset_state() is the function in charge of resetting pgdat's fields,
and it is called when offline_pages() detects that the node becomes empty
worth of memory.

[yuehaibing@huawei.com: fix build warning without CONFIG_MEMORY_HOTREMOVE]
  Link: https://lkml.kernel.org/r/20220408022402.29668-1-yuehaibing@huawei.com
Link: https://lkml.kernel.org/r/20220307150725.6810-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 
 mm/memory_hotplug.c            |   80 ++++++++++++++++++-------------
 mm/page_alloc.c                |   49 +++---------------
 3 files changed, 56 insertions(+), 75 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline
+++ a/include/linux/memory_hotplug.h
@@ -319,7 +319,7 @@ extern void set_zone_contiguous(struct z
 extern void clear_zone_contiguous(struct zone *zone);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+extern bool pgdat_has_boot_nodestats(pg_data_t *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline
+++ a/mm/memory_hotplug.c
@@ -1146,31 +1146,21 @@ failed_addition:
 	return ret;
 }
 
-static void reset_node_present_pages(pg_data_t *pgdat)
-{
-	struct zone *z;
-
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->present_pages = 0;
-
-	pgdat->node_present_pages = 0;
-}
-
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
-	struct pglist_data *pgdat;
+	struct pglist_data *pgdat = NODE_DATA(nid);
 
 	/*
-	 * NODE_DATA is preallocated (free_area_init) but its internal
-	 * state is not allocated completely. Add missing pieces.
-	 * Completely offline nodes stay around and they just need
-	 * reintialization.
-	 */
-	pgdat = NODE_DATA(nid);
-
-	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	 * NODE_DATA is preallocated (free_area_init), the only thing missing
+	 * is to allocate its per_cpu_nodestats struct and to build node's
+	 * zonelists. The allocation of per_cpu_nodestats only needs to be done
+	 * the very first time this node is brought up, as we reset its state
+	 * when all node's memory goes offline.
+	 */
+	if (pgdat_has_boot_nodestats(pgdat))
+		pgdat->per_cpu_nodestats = alloc_percpu_gfp(struct per_cpu_nodestat,
+							    __GFP_ZERO);
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
@@ -1178,15 +1168,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 */
 	build_all_zonelists(pgdat);
 
-	/*
-	 * When memory is hot-added, all the memory is in offline state. So
-	 * clear all zones' present_pages because they will be updated in
-	 * online_pages() and offline_pages().
-	 * TODO: should be in free_area_init_core_hotplug?
-	 */
-	reset_node_managed_pages(pgdat);
-	reset_node_present_pages(pgdat);
-
 	return pgdat;
 }
 
@@ -1765,6 +1746,40 @@ static void node_states_clear_node(int n
 		node_clear_state(node, N_MEMORY);
 }
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		z->present_pages = 0;
+
+	pgdat->node_present_pages = 0;
+}
+
+static void node_reset_state(int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	int cpu;
+
+	kswapd_stop(node);
+	kcompactd_stop(node);
+
+	reset_node_managed_pages(pgdat);
+	reset_node_present_pages(pgdat);
+
+	pgdat->nr_zones = 0;
+	pgdat->kswapd_order = 0;
+	pgdat->kswapd_highest_zoneidx = 0;
+	pgdat->node_start_pfn = 0;
+
+	for_each_online_cpu(cpu) {
+		struct per_cpu_nodestat *p;
+
+		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+		memset(p, 0, sizeof(*p));
+	}
+}
+
 static int count_system_ram_pages_cb(unsigned long start_pfn,
 				     unsigned long nr_pages, void *data)
 {
@@ -1924,10 +1939,9 @@ int __ref offline_pages(unsigned long st
 	}
 
 	node_states_clear_node(node, &arg);
-	if (arg.status_change_nid >= 0) {
-		kswapd_stop(node);
-		kcompactd_stop(node);
-	}
+	if (arg.status_change_nid >= 0)
+		/* Reset node's state as all its memory went offline. */
+		node_reset_state(node);
 
 	writeback_set_ratelimit();
 
--- a/mm/page_alloc.c~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline
+++ a/mm/page_alloc.c
@@ -6346,6 +6346,13 @@ static DEFINE_PER_CPU(struct per_cpu_pag
 static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
 DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+bool pgdat_has_boot_nodestats(pg_data_t *pgdat)
+{
+	return pgdat->per_cpu_nodestats == &boot_nodestats;
+}
+#endif
+
 static void __build_all_zonelists(void *data)
 {
 	int nid;
@@ -7469,7 +7476,7 @@ static void __meminit pgdat_init_interna
 	lruvec_init(&pgdat->__lruvec);
 }
 
-static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
+static void __init zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
 							unsigned long remaining_pages)
 {
 	atomic_long_set(&zone->managed_pages, remaining_pages);
@@ -7482,46 +7489,6 @@ static void __meminit zone_init_internal
 }
 
 /*
- * Set up the zone data structures
- * - init pgdat internals
- * - init all zones belonging to this node
- *
- * NOTE: this function is only called during memory hotplug
- */
-#ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
-{
-	int nid = pgdat->node_id;
-	enum zone_type z;
-	int cpu;
-
-	pgdat_init_internals(pgdat);
-
-	if (pgdat->per_cpu_nodestats == &boot_nodestats)
-		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
-
-	/*
-	 * Reset the nr_zones, order and highest_zoneidx before reuse.
-	 * Note that kswapd will init kswapd_highest_zoneidx properly
-	 * when it starts in the near future.
-	 */
-	pgdat->nr_zones = 0;
-	pgdat->kswapd_order = 0;
-	pgdat->kswapd_highest_zoneidx = 0;
-	pgdat->node_start_pfn = 0;
-	for_each_online_cpu(cpu) {
-		struct per_cpu_nodestat *p;
-
-		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
-		memset(p, 0, sizeof(*p));
-	}
-
-	for (z = 0; z < MAX_NR_ZONES; z++)
-		zone_init_internals(&pgdat->node_zones[z], z, nid, 0);
-}
-#endif
-
-/*
  * Set up the zone data structures:
  *   - mark all pages reserved
  *   - mark all memory queues empty
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

