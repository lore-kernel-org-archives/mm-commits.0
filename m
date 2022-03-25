Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC3CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356377AbiCYBfZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357441AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B786BF967
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F5EB81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F30C340ED;
        Fri, 25 Mar 2022 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171955;
        bh=C840Ie257/iX5EWUSQPsuNqi1rNp/P8C0RU/x2jlq4M=;
        h=Date:To:From:Subject:From;
        b=ooiMBvDmGumrPUxkV+wIjBdb6LU6bfNvqPO2XrNZZDX1L6xyZQAH9NeTyQg262VDd
         +Eg4WrVGNnyBxt36epJOLMi00r3Kj78nqNkaLzGeLJZ54nc+8bkHlMWvqofILesZIC
         TrRjDaih14I2qchKVI512HLFAPz0/1BfqFmtLbyI=
Date:   Thu, 24 Mar 2022 18:32:34 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-handle-uninitialized-numa-nodes-gracefully.patch removed from -mm tree
Message-Id: <20220325013235.25F30C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle uninitialized numa nodes gracefully
has been removed from the -mm tree.  Its filename was
     mm-handle-uninitialized-numa-nodes-gracefully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: handle uninitialized numa nodes gracefully

We have had several reports [1][2][3] that page allocator blows up when an
allocation from a possible node is requested.  The underlying reason is
that NODE_DATA for the specific node is not allocated.

NUMA specific initialization is arch specific and it can vary a lot.  E.g.
x86 tries to initialize all nodes that have some cpu affinity (see
init_cpu_to_node) but this can be insufficient because the node might be
cpuless for example.

One way to address this problem would be to check for !node_online nodes
when trying to get a zonelist and silently fall back to another node. 
That is unfortunately adding a branch into allocator hot path and it
doesn't handle any other potential NODE_DATA users.

This patch takes a different approach (following a lead of [3]) and it pre
allocates pgdat for all possible nodes in an arch indipendent code -
free_area_init.  All uninitialized nodes are treated as memoryless nodes. 
node_state of the node is not changed because that would lead to other
side effects - e.g.  sysfs representation of such a node and from past
discussions [4] it is known that some tools might have problems digesting
that.

Newly allocated pgdat only gets a minimal initialization and the rest of
the work is expected to be done by the memory hotplug - hotadd_new_pgdat
(renamed to hotadd_init_pgdat).

generic_alloc_nodedata is changed to use the memblock allocator because
neither page nor slab allocators are available at the stage when all
pgdats are allocated.  Hotplug doesn't allocate pgdat anymore so we can
use the early boot allocator.  The only arch specific implementation is
ia64 and that is changed to use the early allocator as well.

[1] http://lkml.kernel.org/r/20211101201312.11589-1-amakhalov@vmware.com
[2] http://lkml.kernel.org/r/20211207224013.880775-1-npache@redhat.com
[3] http://lkml.kernel.org/r/20190114082416.30939-1-mhocko@kernel.org
[4] http://lkml.kernel.org/r/20200428093836.27190-1-srikar@linux.vnet.ibm.com

[akpm@linux-foundation.org: replace comment, per Mike]
Link: https://lkml.kernel.org/r/Yfe7RBeLCijnWBON@dhcp22.suse.cz
Reported-by: Alexey Makhalov <amakhalov@vmware.com>
Tested-by: Alexey Makhalov <amakhalov@vmware.com>
Reported-by: Nico Pache <npache@redhat.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Tested-by: Rafael Aquini <raquini@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c       |    4 +--
 include/linux/memory_hotplug.h |    2 -
 mm/internal.h                  |    2 +
 mm/memory_hotplug.c            |   21 ++++++----------
 mm/page_alloc.c                |   40 +++++++++++++++++++++++++++----
 5 files changed, 50 insertions(+), 19 deletions(-)

--- a/arch/ia64/mm/discontig.c~mm-handle-uninitialized-numa-nodes-gracefully
+++ a/arch/ia64/mm/discontig.c
@@ -608,11 +608,11 @@ void __init paging_init(void)
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
 
-pg_data_t *arch_alloc_nodedata(int nid)
+pg_data_t * __init arch_alloc_nodedata(int nid)
 {
 	unsigned long size = compute_pernodesize(nid);
 
-	return kzalloc(size, GFP_KERNEL);
+	return memblock_alloc(size, SMP_CACHE_BYTES);
 }
 
 void arch_free_nodedata(pg_data_t *pgdat)
--- a/include/linux/memory_hotplug.h~mm-handle-uninitialized-numa-nodes-gracefully
+++ a/include/linux/memory_hotplug.h
@@ -44,7 +44,7 @@ extern void arch_refresh_nodedata(int ni
  */
 #define generic_alloc_nodedata(nid)				\
 ({								\
-	kzalloc(sizeof(pg_data_t), GFP_KERNEL);			\
+	memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);	\
 })
 /*
  * This definition is just for error path in node hotadd.
--- a/mm/internal.h~mm-handle-uninitialized-numa-nodes-gracefully
+++ a/mm/internal.h
@@ -707,4 +707,6 @@ void vunmap_range_noflush(unsigned long
 int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 		      unsigned long addr, int page_nid, int *flags);
 
+DECLARE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory_hotplug.c~mm-handle-uninitialized-numa-nodes-gracefully
+++ a/mm/memory_hotplug.c
@@ -1162,19 +1162,21 @@ static void reset_node_present_pages(pg_
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-static pg_data_t __ref *hotadd_new_pgdat(int nid)
+static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
 	struct pglist_data *pgdat;
 
 	pgdat = NODE_DATA(nid);
-	if (!pgdat) {
-		pgdat = arch_alloc_nodedata(nid);
-		if (!pgdat)
-			return NULL;
 
+	/*
+	 * NODE_DATA is preallocated (free_area_init) but its internal
+	 * state is not allocated completely. Add missing pieces.
+	 * Completely offline nodes stay around and they just need
+	 * reintialization.
+	 */
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
-		arch_refresh_nodedata(nid, pgdat);
 	} else {
 		int cpu;
 		/*
@@ -1193,8 +1195,6 @@ static pg_data_t __ref *hotadd_new_pgdat
 		}
 	}
 
-	/* we can use NODE_DATA(nid) from here */
-	pgdat->node_id = nid;
 	pgdat->node_start_pfn = 0;
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
@@ -1246,7 +1246,7 @@ static int __try_online_node(int nid, bo
 	if (node_online(nid))
 		return 0;
 
-	pgdat = hotadd_new_pgdat(nid);
+	pgdat = hotadd_init_pgdat(nid);
 	if (!pgdat) {
 		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
 		ret = -ENOMEM;
@@ -1445,9 +1445,6 @@ int __ref add_memory_resource(int nid, s
 
 	return ret;
 error:
-	/* rollback pgdat allocation and others */
-	if (new_node)
-		rollback_node_hotadd(nid);
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
 error_mem_hotplug_end:
--- a/mm/page_alloc.c~mm-handle-uninitialized-numa-nodes-gracefully
+++ a/mm/page_alloc.c
@@ -6341,7 +6341,7 @@ static void per_cpu_pages_init(struct pe
 #define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pages, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
-static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
+DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
 static void __build_all_zonelists(void *data)
 {
@@ -6363,7 +6363,11 @@ static void __build_all_zonelists(void *
 	if (self && !node_online(self->node_id)) {
 		build_zonelists(self);
 	} else {
-		for_each_online_node(nid) {
+		/*
+		 * All possible nodes have pgdat preallocated
+		 * in free_area_init
+		 */
+		for_each_node(nid) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			build_zonelists(pgdat);
@@ -8063,8 +8067,36 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
+	for_each_node(nid) {
+		pg_data_t *pgdat;
+
+		if (!node_online(nid)) {
+			pr_info("Initializing node %d as memoryless\n", nid);
+
+			/* Allocator not initialized yet */
+			pgdat = arch_alloc_nodedata(nid);
+			if (!pgdat) {
+				pr_err("Cannot allocate %zuB for node %d.\n",
+						sizeof(*pgdat), nid);
+				continue;
+			}
+			arch_refresh_nodedata(nid, pgdat);
+			free_area_init_memoryless_node(nid);
+
+			/*
+			 * We do not want to confuse userspace by sysfs
+			 * files/directories for node without any memory
+			 * attached to it, so this node is not marked as
+			 * N_MEMORY and not marked online so that no sysfs
+			 * hierarchy will be created via register_one_node for
+			 * it. The pgdat will get fully initialized by
+			 * hotadd_init_pgdat() when memory is hotplugged into
+			 * this node.
+			 */
+			continue;
+		}
+
+		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
_

Patches currently in -mm which might be from mhocko@suse.com are


