Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37F8C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiAaWS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:18:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:18:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA25AB82CB9
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A60C340E8;
        Mon, 31 Jan 2022 22:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667535;
        bh=Fme4pDClU+jwy+KPjlvqJPO3+isb2pC1ZwrDTmlVqgc=;
        h=Date:To:From:Subject:From;
        b=zagevtLV+5ZIUogn3IsrnrXXq5keKGW3T+RjlJzchYuhbSXNNvI4na2U+nfNxmel5
         MAtWFFycFwHHyQifoga72NQ9HmxU8/+RnjX5CAQ3rMPzVRu30Wi5aDnOJRYwF8DHp8
         vgUVdZ/VAiYxhfEX929PU7R6oPbUYljCmno/RsKo=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:18:53 -0800
Date:   Mon, 31 Jan 2022 14:18:53 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-reorganize-new-pgdat-initialization.patch added to -mm tree
Message-Id: <20220131221853.E8A60C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: reorganize new pgdat initialization
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-reorganize-new-pgdat-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-reorganize-new-pgdat-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -7551,12 +7551,33 @@ static void __meminit zone_init_internal
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

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
mm-handle-uninitialized-numa-nodes-gracefully.patch
mm-memory_hotplug-drop-arch_free_nodedata.patch
mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

