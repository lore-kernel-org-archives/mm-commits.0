Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC66CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiCVVsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiCVVsf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F20160062
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24C061668
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383FDC340EC;
        Tue, 22 Mar 2022 21:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985621;
        bh=qFI2ea2EzX/1UcA4g0drXk7gN/Plzy+8Oz6wAotqbmQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=DE5QrawLCW/RlnOs4KKa1VH6SlDXcjjmnkJW+ENvWfD192r5stsdiCxSrvgn3W12Q
         2I8fAWJuHTuMgN++v3p7QgivFfceBmuhpeEk8Rs6eHoEFlRunp5A6pqYsA+83fWOhy
         2IGK9meome+xJtdlPOCJ82Uh91uNluBStqlwq65g=
Date:   Tue, 22 Mar 2022 14:47:00 -0700
To:     tj@kernel.org, rppt@linux.ibm.com, richard.weiyang@gmail.com,
        raquini@redhat.com, osalvador@suse.de, npache@redhat.com,
        eric.dumazet@gmail.com, dennis@kernel.org, david@redhat.com,
        cl@linux.com, amakhalov@vmware.com, mhocko@suse.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 167/227] mm, memory_hotplug: reorganize new pgdat initialization
Message-Id: <20220322214701.383FDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: reorganize new pgdat initialization

When a !node_online node is brought up it needs a hotplug specific
initialization because the node could be either uninitialized yet or it
could have been recycled after previous hotremove.  hotadd_init_pgdat is
responsible for that.

Internal pgdat state is initialized at two places currently
	- hotadd_init_pgdat
	- free_area_init_core_hotplug

There is no real clear cut what should go where but this patch's chosen to
move the whole internal state initialization into
free_area_init_core_hotplug.  hotadd_init_pgdat is still responsible to
pull all the parts together - most notably to initialize zonelists because
those depend on the overall topology.

This patch doesn't introduce any functional change.

Link: https://lkml.kernel.org/r/20220127085305.20890-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 +-
 mm/memory_hotplug.c            |   28 +++-------------------------
 mm/page_alloc.c                |   25 +++++++++++++++++++++++--
 3 files changed, 27 insertions(+), 28 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-reorganize-new-pgdat-initialization
+++ a/include/linux/memory_hotplug.h
@@ -319,7 +319,7 @@ extern void set_zone_contiguous(struct z
 extern void clear_zone_contiguous(struct zone *zone);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void __ref free_area_init_core_hotplug(int nid);
+extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-reorganize-new-pgdat-initialization
+++ a/mm/memory_hotplug.c
@@ -1166,39 +1166,16 @@ static pg_data_t __ref *hotadd_init_pgda
 {
 	struct pglist_data *pgdat;
 
-	pgdat = NODE_DATA(nid);
-
 	/*
 	 * NODE_DATA is preallocated (free_area_init) but its internal
 	 * state is not allocated completely. Add missing pieces.
 	 * Completely offline nodes stay around and they just need
 	 * reintialization.
 	 */
-	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
-		pgdat->per_cpu_nodestats =
-			alloc_percpu(struct per_cpu_nodestat);
-	} else {
-		int cpu;
-		/*
-		 * Reset the nr_zones, order and highest_zoneidx before reuse.
-		 * Note that kswapd will init kswapd_highest_zoneidx properly
-		 * when it starts in the near future.
-		 */
-		pgdat->nr_zones = 0;
-		pgdat->kswapd_order = 0;
-		pgdat->kswapd_highest_zoneidx = 0;
-		for_each_online_cpu(cpu) {
-			struct per_cpu_nodestat *p;
-
-			p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
-			memset(p, 0, sizeof(*p));
-		}
-	}
-
-	pgdat->node_start_pfn = 0;
+	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(nid);
+	free_area_init_core_hotplug(pgdat);
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
@@ -1210,6 +1187,7 @@ static pg_data_t __ref *hotadd_init_pgda
 	 * When memory is hot-added, all the memory is in offline state. So
 	 * clear all zones' present_pages because they will be updated in
 	 * online_pages() and offline_pages().
+	 * TODO: should be in free_area_init_core_hotplug?
 	 */
 	reset_node_managed_pages(pgdat);
 	reset_node_present_pages(pgdat);
--- a/mm/page_alloc.c~mm-memory_hotplug-reorganize-new-pgdat-initialization
+++ a/mm/page_alloc.c
@@ -7466,12 +7466,33 @@ static void __meminit zone_init_internal
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(int nid)
+void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
+	int nid = pgdat->node_id;
 	enum zone_type z;
-	pg_data_t *pgdat = NODE_DATA(nid);
+	int cpu;
 
 	pgdat_init_internals(pgdat);
+
+	if (pgdat->per_cpu_nodestats == &boot_nodestats)
+		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+
+	/*
+	 * Reset the nr_zones, order and highest_zoneidx before reuse.
+	 * Note that kswapd will init kswapd_highest_zoneidx properly
+	 * when it starts in the near future.
+	 */
+	pgdat->nr_zones = 0;
+	pgdat->kswapd_order = 0;
+	pgdat->kswapd_highest_zoneidx = 0;
+	pgdat->node_start_pfn = 0;
+	for_each_online_cpu(cpu) {
+		struct per_cpu_nodestat *p;
+
+		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+		memset(p, 0, sizeof(*p));
+	}
+
 	for (z = 0; z < MAX_NR_ZONES; z++)
 		zone_init_internals(&pgdat->node_zones[z], z, nid, 0);
 }
_
