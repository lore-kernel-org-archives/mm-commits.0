Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED642C25B0E
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiHRXvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240173AbiHRXvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:51:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71583D571C
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D239BCE238E
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231A6C433D6;
        Thu, 18 Aug 2022 23:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866683;
        bh=dLLNKpEwdHcM3nfaZtZYoQwCgIyFWc0EIxs3OEPE1dM=;
        h=Date:To:From:Subject:From;
        b=2CdBsde8Axr/QWbzw64fZis9JyaaHoaNabgtz4KheSDDam4OMFaTQFVRqeYp7Lp4o
         UwNIcSpXuaIGPuWE4tELwc4b629c8wYt9N319z/gfJVH7D9dvHma5HT7q0RLX1Rlpt
         XgoA96wq0aa44k+yqw4aD/EKphjE3iUGJLNOE5mE=
Date:   Thu, 18 Aug 2022 16:51:22 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, Jonathan.Cameron@huawei.com,
        hesham.almatary@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.hansen@intel.com, dan.j.williams@intel.com, bharata@amd.com,
        apopple@nvidia.com, aneesh.kumar@linux.ibm.com,
        jvgediya.oss@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-demote-pages-according-to-allocation-fallback-order.patch added to mm-unstable branch
Message-Id: <20220818235123.231A6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: demote pages according to allocation fallback order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-demote-pages-according-to-allocation-fallback-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-demote-pages-according-to-allocation-fallback-order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jagdish Gediya <jvgediya.oss@gmail.com>
Subject: mm/demotion: demote pages according to allocation fallback order
Date: Thu, 18 Aug 2022 18:40:40 +0530

Currently, a higher tier node can only be demoted to selected nodes on the
next lower tier as defined by the demotion path.  This strict demotion
order does not work in all use cases (e.g.  some use cases may want to
allow cross-socket demotion to another node in the same demotion tier as a
fallback when the preferred demotion node is out of space).  This demotion
order is also inconsistent with the page allocation fallback order when
all the nodes in a higher tier are out of space: The page allocation can
fall back to any node from any lower tier, whereas the demotion order
doesn't allow that currently.

This patch adds support to get all the allowed demotion targets for a
memory tier.  demote_page_list() function is now modified to utilize this
allowed node mask as the fallback allocation mask.

Link: https://lkml.kernel.org/r/20220818131042.113280-9-aneesh.kumar@linux.ibm.com
Signed-off-by: Jagdish Gediya <jvgediya.oss@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |   12 ++++++
 mm/memory-tiers.c            |   51 +++++++++++++++++++++++++++--
 mm/vmscan.c                  |   58 ++++++++++++++++++++++++---------
 3 files changed, 103 insertions(+), 18 deletions(-)

--- a/include/linux/memory-tiers.h~mm-demotion-demote-pages-according-to-allocation-fallback-order
+++ a/include/linux/memory-tiers.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/nodemask.h>
 #include <linux/kref.h>
+#include <linux/mmzone.h>
 /*
  * Each tier cover a abstrace distance chunk size of 128
  */
@@ -38,11 +39,17 @@ void init_node_memory_type(int node, str
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
+void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 #else
 static inline int next_demotion_node(int node)
 {
 	return NUMA_NO_NODE;
 }
+
+static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+{
+	*targets = NODE_MASK_NONE;
+}
 #endif
 
 #else
@@ -75,5 +82,10 @@ static inline int next_demotion_node(int
 {
 	return NUMA_NO_NODE;
 }
+
+static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+{
+	*targets = NODE_MASK_NONE;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~mm-demotion-demote-pages-according-to-allocation-fallback-order
+++ a/mm/memory-tiers.c
@@ -4,7 +4,6 @@
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
 #include <linux/memory.h>
-#include <linux/mmzone.h>
 #include <linux/memory-tiers.h>
 
 #include "internal.h"
@@ -20,6 +19,8 @@ struct memory_tier {
 	 * adistance_start .. adistance_start + MEMTIER_CHUNK_SIZE
 	 */
 	int adistance_start;
+	/* All the nodes that are part of all the lower memory tiers. */
+	nodemask_t lower_tier_mask;
 };
 
 struct demotion_nodes {
@@ -156,6 +157,24 @@ static struct memory_tier *__node_get_me
 }
 
 #ifdef CONFIG_MIGRATION
+void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+{
+	struct memory_tier *memtier;
+
+	/*
+	 * pg_data_t.memtier updates includes a synchronize_rcu()
+	 * which ensures that we either find NULL or a valid memtier
+	 * in NODE_DATA. protect the access via rcu_read_lock();
+	 */
+	rcu_read_lock();
+	memtier = rcu_dereference(pgdat->memtier);
+	if (memtier)
+		*targets = memtier->lower_tier_mask;
+	else
+		*targets = NODE_MASK_NONE;
+	rcu_read_unlock();
+}
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -203,10 +222,19 @@ int next_demotion_node(int node)
 
 static void disable_all_demotion_targets(void)
 {
+	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY)
+	for_each_node_state(node, N_MEMORY) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
+		/*
+		 * We are holding memory_tier_lock, it is safe
+		 * to access pgda->memtier.
+		 */
+		memtier = __node_get_memory_tier(node);
+		if (memtier)
+			memtier->lower_tier_mask = NODE_MASK_NONE;
+	}
 	/*
 	 * Ensure that the "disable" is visible across the system.
 	 * Readers will see either a combination of before+disable
@@ -238,7 +266,7 @@ static void establish_demotion_targets(v
 	struct demotion_nodes *nd;
 	int target = NUMA_NO_NODE, node;
 	int distance, best_distance;
-	nodemask_t tier_nodes;
+	nodemask_t tier_nodes, lower_tier;
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
@@ -286,6 +314,23 @@ static void establish_demotion_targets(v
 			}
 		} while (1);
 	}
+	/*
+	 * Now build the lower_tier mask for each node collecting node mask from
+	 * all memory tier below it. This allows us to fallback demotion page
+	 * allocation to a set of nodes that is closer the above selected
+	 * perferred node.
+	 */
+	lower_tier = node_states[N_MEMORY];
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		/*
+		 * Keep removing current tier from lower_tier nodes,
+		 * This will remove all nodes in current and above
+		 * memory tier from the lower_tier mask.
+		 */
+		tier_nodes = get_memtier_nodemask(memtier);
+		nodes_andnot(lower_tier, lower_tier, tier_nodes);
+		memtier->lower_tier_mask = lower_tier;
+	}
 }
 
 #else
--- a/mm/vmscan.c~mm-demotion-demote-pages-according-to-allocation-fallback-order
+++ a/mm/vmscan.c
@@ -1534,21 +1534,34 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-static struct page *alloc_demote_page(struct page *page, unsigned long node)
+static struct page *alloc_demote_page(struct page *page, unsigned long private)
 {
-	struct migration_target_control mtc = {
-		/*
-		 * Allocate from 'node', or fail quickly and quietly.
-		 * When this happens, 'page' will likely just be discarded
-		 * instead of migrated.
-		 */
-		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			    __GFP_THISNODE  | __GFP_NOWARN |
-			    __GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = node
-	};
+	struct page *target_page;
+	nodemask_t *allowed_mask;
+	struct migration_target_control *mtc;
+
+	mtc = (struct migration_target_control *)private;
+
+	allowed_mask = mtc->nmask;
+	/*
+	 * make sure we allocate from the target node first also trying to
+	 * demote or reclaim pages from the target node via kswapd if we are
+	 * low on free memory on target node. If we don't do this and if
+	 * we have free memory on the slower(lower) memtier, we would start
+	 * allocating pages from slower(lower) memory tiers without even forcing
+	 * a demotion of cold pages from the target memtier. This can result
+	 * in the kernel placing hot pages in slower(lower) memory tiers.
+	 */
+	mtc->nmask = NULL;
+	mtc->gfp_mask |= __GFP_THISNODE;
+	target_page = alloc_migration_target(page, (unsigned long)mtc);
+	if (target_page)
+		return target_page;
 
-	return alloc_migration_target(page, (unsigned long)&mtc);
+	mtc->gfp_mask &= ~__GFP_THISNODE;
+	mtc->nmask = allowed_mask;
+
+	return alloc_migration_target(page, (unsigned long)mtc);
 }
 
 /*
@@ -1561,6 +1574,19 @@ static unsigned int demote_page_list(str
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
+	nodemask_t allowed_mask;
+
+	struct migration_target_control mtc = {
+		/*
+		 * Allocate from 'node', or fail quickly and quietly.
+		 * When this happens, 'page' will likely just be discarded
+		 * instead of migrated.
+		 */
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
+			__GFP_NOMEMALLOC | GFP_NOWAIT,
+		.nid = target_nid,
+		.nmask = &allowed_mask
+	};
 
 	if (list_empty(demote_pages))
 		return 0;
@@ -1568,10 +1594,12 @@ static unsigned int demote_page_list(str
 	if (target_nid == NUMA_NO_NODE)
 		return 0;
 
+	node_get_allowed_targets(pgdat, &allowed_mask);
+
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_pages, alloc_demote_page, NULL,
-			    target_nid, MIGRATE_ASYNC, MR_DEMOTION,
-			    &nr_succeeded);
+		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
+		      &nr_succeeded);
 
 	if (current_is_kswapd())
 		__count_vm_events(PGDEMOTE_KSWAPD, nr_succeeded);
_

Patches currently in -mm which might be from jvgediya.oss@gmail.com are

mm-demotion-demote-pages-according-to-allocation-fallback-order.patch

