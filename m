Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C24C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiAaWSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:18:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1730FC061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 14:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D97B82CB6
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C2BC340E8;
        Mon, 31 Jan 2022 22:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667499;
        bh=9rukGHtSTZJ4urSx859KKDuCL/Yn/94AnEE9bYldUcw=;
        h=Date:To:From:Subject:From;
        b=foDPBNUjyHp0uQgLDa0mu9KyilIpk69MNMtBJDC9Avn5LAaF07W/bin0UZcPfSsev
         QOwK3GNPX/MH/T3X53WxpiYUXwCltu5OTq3zmk2a6FIWWwC4lXiTiA9zRfES0RAUOX
         wAGLm2TWkGPVPdtapRI+hIr7b5lsNx3kbhDhf6uA=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:18:17 -0800
Date:   Mon, 31 Jan 2022 14:18:17 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-uninitialized-numa-nodes-gracefully.patch added to -mm tree
Message-Id: <20220131221818.10C2BC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle uninitialized numa nodes gracefully
has been added to the -mm tree.  Its filename is
     mm-handle-uninitialized-numa-nodes-gracefully.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-handle-uninitialized-numa-nodes-gracefully.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-handle-uninitialized-numa-nodes-gracefully.patch

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
 mm/memory_hotplug.c            |   21 +++++++-----------
 mm/page_alloc.c                |   36 +++++++++++++++++++++++++++----
 5 files changed, 46 insertions(+), 19 deletions(-)

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
@@ -6425,7 +6425,7 @@ static void per_cpu_pages_init(struct pe
 #define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pages, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
-static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
+DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
 static void __build_all_zonelists(void *data)
 {
@@ -6447,7 +6447,11 @@ static void __build_all_zonelists(void *
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
@@ -8141,8 +8145,32 @@ void __init free_area_init(unsigned long
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
+			/*
+			 * not marking this node online because we do not want to
+			 * confuse userspace by sysfs files/directories for node
+			 * without any memory attached to it (see topology_init)
+			 * The pgdat will get fully initialized when a memory is
+			 * hotpluged into it by hotadd_init_pgdat
+			 */
+			continue;
+		}
+
+		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
mm-handle-uninitialized-numa-nodes-gracefully.patch
mm-memory_hotplug-drop-arch_free_nodedata.patch
mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

