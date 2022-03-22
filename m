Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B97DC43219
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiCVVsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiCVVsI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2E35FF20
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E911F6100A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464CDC340EC;
        Tue, 22 Mar 2022 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985581;
        bh=hIclrAO0aJSlCuB+gAg4to78GxvsR5pR8C0Gwnzx6Lo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=2jujozzTHD90rlhhAPNDFauvplfQsZOaf1iDlhfJ54zquLzmxry0TbuvSPBVmeBgP
         2OYLIWcaUv7GZpGuJqCw+RykZnUHusBZjPzgMOYMnsyw2lI1uFY5IxNPsnl88nBeVJ
         HuM+a4GYa041+8rndz2073PoSv0E12eoe0ogqKK4=
Date:   Tue, 22 Mar 2022 14:46:20 -0700
To:     ziy@nvidia.com, zhongjiang-ali@linux.alibaba.com,
        weixugc@google.com, shy828301@gmail.com, shakeelb@google.com,
        riel@surriel.com, rdunlap@infradead.org, peterz@infradead.org,
        osalvador@suse.de, mhocko@suse.com, mgorman@techsingularity.net,
        hannes@cmpxchg.org, feng.tang@intel.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 154/227] NUMA Balancing: add page promotion counter
Message-Id: <20220322214621.464CDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: NUMA Balancing: add page promotion counter

Patch series "NUMA balancing: optimize memory placement for memory tiering system", v13

With the advent of various new memory types, some machines will have
multiple types of memory, e.g.  DRAM and PMEM (persistent memory).  The
memory subsystem of these machines can be called memory tiering system,
because the performance of the different types of memory are different.

After commit c221c0b0308f ("device-dax: "Hotplug" persistent memory for
use like normal RAM"), the PMEM could be used as the cost-effective
volatile memory in separate NUMA nodes.  In a typical memory tiering
system, there are CPUs, DRAM and PMEM in each physical NUMA node.  The
CPUs and the DRAM will be put in one logical node, while the PMEM will be
put in another (faked) logical node.

To optimize the system overall performance, the hot pages should be placed
in DRAM node.  To do that, we need to identify the hot pages in the PMEM
node and migrate them to DRAM node via NUMA migration.

In the original NUMA balancing, there are already a set of existing
mechanisms to identify the pages recently accessed by the CPUs in a node
and migrate the pages to the node.  So we can reuse these mechanisms to
build the mechanisms to optimize the page placement in the memory tiering
system.  This is implemented in this patchset.

At the other hand, the cold pages should be placed in PMEM node.  So, we
also need to identify the cold pages in the DRAM node and migrate them to
PMEM node.

In commit 26aa2d199d6f ("mm/migrate: demote pages during reclaim"), a
mechanism to demote the cold DRAM pages to PMEM node under memory pressure
is implemented.  Based on that, the cold DRAM pages can be demoted to PMEM
node proactively to free some memory space on DRAM node to accommodate the
promoted hot PMEM pages.  This is implemented in this patchset too.

We have tested the solution with the pmbench memory accessing benchmark
with the 80:20 read/write ratio and the Gauss access address distribution
on a 2 socket Intel server with Optane DC Persistent Memory Model.  The
test results shows that the pmbench score can improve up to 95.9%.


This patch (of 3):

In a system with multiple memory types, e.g.  DRAM and PMEM, the CPU
and DRAM in one socket will be put in one NUMA node as before, while
the PMEM will be put in another NUMA node as described in the
description of the commit c221c0b0308f ("device-dax: "Hotplug"
persistent memory for use like normal RAM").  So, the NUMA balancing
mechanism will identify all PMEM accesses as remote access and try to
promote the PMEM pages to DRAM.

To distinguish the number of the inter-type promoted pages from that of
the inter-socket migrated pages.  A new vmstat count is added.  The
counter is per-node (count in the target node).  So this can be used to
identify promotion imbalance among the NUMA nodes.

Link: https://lkml.kernel.org/r/20220301085329.3210428-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20220221084529.1052339-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20220221084529.1052339-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 include/linux/node.h   |    5 +++++
 mm/migrate.c           |   13 ++++++++++---
 mm/vmstat.c            |    3 +++
 4 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~numa-balancing-add-page-promotion-counter
+++ a/include/linux/mmzone.h
@@ -222,6 +222,9 @@ enum node_stat_item {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	PGPROMOTE_SUCCESS,	/* promote successfully */
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/include/linux/node.h~numa-balancing-add-page-promotion-counter
+++ a/include/linux/node.h
@@ -181,4 +181,9 @@ static inline void register_hugetlbfs_wi
 
 #define to_node(device) container_of(device, struct node, dev)
 
+static inline bool node_is_toptier(int node)
+{
+	return node_state(node, N_CPU);
+}
+
 #endif /* _LINUX_NODE_H_ */
--- a/mm/migrate.c~numa-balancing-add-page-promotion-counter
+++ a/mm/migrate.c
@@ -2069,6 +2069,7 @@ int migrate_misplaced_page(struct page *
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated;
 	int nr_remaining;
+	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
 	new_page_t *new;
 	bool compound;
@@ -2107,7 +2108,8 @@ int migrate_misplaced_page(struct page *
 
 	list_add(&page->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, *new, NULL, node,
-				     MIGRATE_ASYNC, MR_NUMA_MISPLACED, NULL);
+				     MIGRATE_ASYNC, MR_NUMA_MISPLACED,
+				     &nr_succeeded);
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
@@ -2116,8 +2118,13 @@ int migrate_misplaced_page(struct page *
 			putback_lru_page(page);
 		}
 		isolated = 0;
-	} else
-		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_pages);
+	}
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		if (!node_is_toptier(page_to_nid(page)) && node_is_toptier(node))
+			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
+					    nr_succeeded);
+	}
 	BUG_ON(!list_empty(&migratepages));
 	return isolated;
 
--- a/mm/vmstat.c~numa-balancing-add-page-promotion-counter
+++ a/mm/vmstat.c
@@ -1242,6 +1242,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_SWAP
 	"nr_swapcached",
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	"pgpromote_success",
+#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_
