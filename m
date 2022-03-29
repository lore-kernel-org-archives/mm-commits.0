Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44852C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiC2BV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiC2BVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19E72C10D
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DAEE611D0
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B19C340EC;
        Tue, 29 Mar 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516811;
        bh=dVzocLZ+IsIk7EYpTSFWSya4TAfCIcba95vMBFkpPoQ=;
        h=Date:To:From:Subject:From;
        b=18HVXhf2KcsHC6UZFN7hhzMvwVJ63cci4RlWr9+SOnXPaTMszSOboDI1WwVcYCQ4S
         l1c2h3WbPAaIaeU3P5dHmKLQAB1+e1IDVgcNfUwcmzbJWm9ZUCyCVCzngBb2oF0TVb
         pOxMsvrfXO0jHSYlFY7Gym3VuVhmaz7LDvMbdrD0=
Date:   Mon, 28 Mar 2022 18:20:11 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        mhocko@kernel.org, linmiaohe@huawei.com, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch added to -mm tree
Message-Id: <20220329012011.D3B19C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: reset node's state when empty during offline
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20220307150725.6810-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 -
 mm/memory_hotplug.c            |   60 +++++++++++++++++++------------
 mm/page_alloc.c                |   49 ++++---------------------
 3 files changed, 46 insertions(+), 65 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline
+++ a/include/linux/memory_hotplug.h
@@ -317,7 +317,7 @@ extern void set_zone_contiguous(struct z
 extern void clear_zone_contiguous(struct zone *zone);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+extern bool pgdat_has_boot_nodestats(pg_data_t *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline
+++ a/mm/memory_hotplug.c
@@ -1158,18 +1158,18 @@ static void reset_node_present_pages(pg_
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
@@ -1177,15 +1177,6 @@ static pg_data_t __ref *hotadd_init_pgda
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
 
@@ -1764,6 +1755,30 @@ static void node_states_clear_node(int n
 		node_clear_state(node, N_MEMORY);
 }
 
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
@@ -1923,10 +1938,9 @@ int __ref offline_pages(unsigned long st
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
@@ -6391,6 +6391,13 @@ static DEFINE_PER_CPU(struct per_cpu_pag
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
@@ -7499,7 +7506,7 @@ static void __meminit pgdat_init_interna
 	lruvec_init(&pgdat->__lruvec);
 }
 
-static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
+static void __init zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
 							unsigned long remaining_pages)
 {
 	atomic_long_set(&zone->managed_pages, remaining_pages);
@@ -7512,46 +7519,6 @@ static void __meminit zone_init_internal
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

mm-untangle-config-dependencies-for-demote-on-reclaim.patch
mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch
mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

