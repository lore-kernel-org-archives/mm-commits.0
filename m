Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FA3C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiI0Cuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiI0Cs4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D828642DD
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCE31B81910
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AB9C433D6;
        Tue, 27 Sep 2022 02:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246900;
        bh=6+pDATDx/RTJ4Lmv1+6QTAw6G82pnyVho3CnZXdEZZY=;
        h=Date:To:From:Subject:From;
        b=iQRBRo88VZHhtWjnLOclJHWnDIT184XyvU7jfZdIKc8GLnrGPRXX+KzWdAi9Seoak
         EmBlq1YF01NrP0VGeCMGfPEjwSgEBq88MS9v/FgCuiFqYdqpBqrdUYbRU5JRLMZmAA
         2Ml0HDw8XYxVY1katpXbJIxbBY7E7Tmr3Xnl+JAc=
Date:   Mon, 26 Sep 2022 19:48:19 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch removed from -mm tree
Message-Id: <20220927024820.83AB9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: add pg_data_t member to track node memory tier details
has been removed from the -mm tree.  Its filename was
     mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: add pg_data_t member to track node memory tier details
Date: Thu, 18 Aug 2022 18:40:38 +0530

Also update different helpes to use NODE_DATA()->memtier.  Since node
specific memtier can change based on the reassignment of NUMA node to a
different memory tiers, accessing NODE_DATA()->memtier needs to happen
under an rcu read lock or memory_tier_lock.

Link: https://lkml.kernel.org/r/20220818131042.113280-7-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++
 mm/memory-tiers.c      |   40 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details
+++ a/include/linux/mmzone.h
@@ -1246,6 +1246,9 @@ typedef struct pglist_data {
 	/* Per-node vmstats */
 	struct per_cpu_nodestat __percpu *per_cpu_nodestats;
 	atomic_long_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
+#ifdef CONFIG_NUMA
+	struct memory_tier __rcu *memtier;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
--- a/mm/memory-tiers.c~mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details
+++ a/mm/memory-tiers.c
@@ -4,6 +4,7 @@
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
 #include <linux/memory.h>
+#include <linux/mmzone.h>
 #include <linux/memory-tiers.h>
 
 #include "internal.h"
@@ -141,12 +142,18 @@ static struct memory_tier *find_create_m
 
 static struct memory_tier *__node_get_memory_tier(int node)
 {
-	struct memory_dev_type *memtype;
+	pg_data_t *pgdat;
 
-	memtype = node_memory_types[node];
-	if (memtype && node_isset(node, memtype->nodes))
-		return memtype->memtier;
-	return NULL;
+	pgdat = NODE_DATA(node);
+	if (!pgdat)
+		return NULL;
+	/*
+	 * Since we hold memory_tier_lock, we can avoid
+	 * RCU read locks when accessing the details. No
+	 * parallel updates are possible here.
+	 */
+	return rcu_dereference_check(pgdat->memtier,
+				     lockdep_is_held(&memory_tier_lock));
 }
 
 #ifdef CONFIG_MIGRATION
@@ -309,6 +316,8 @@ static struct memory_tier *set_node_memo
 {
 	struct memory_tier *memtier;
 	struct memory_dev_type *memtype;
+	pg_data_t *pgdat = NODE_DATA(node);
+
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
@@ -320,24 +329,45 @@ static struct memory_tier *set_node_memo
 	memtype = node_memory_types[node].memtype;
 	node_set(node, memtype->nodes);
 	memtier = find_create_memory_tier(memtype);
+	if (!IS_ERR(memtier))
+		rcu_assign_pointer(pgdat->memtier, memtier);
 	return memtier;
 }
 
 static void destroy_memory_tier(struct memory_tier *memtier)
 {
 	list_del(&memtier->list);
+	/*
+	 * synchronize_rcu in clear_node_memory_tier makes sure
+	 * we don't have rcu access to this memory tier.
+	 */
 	kfree(memtier);
 }
 
 static bool clear_node_memory_tier(int node)
 {
 	bool cleared = false;
+	pg_data_t *pgdat;
 	struct memory_tier *memtier;
 
+	pgdat = NODE_DATA(node);
+	if (!pgdat)
+		return false;
+
+	/*
+	 * Make sure that anybody looking at NODE_DATA who finds
+	 * a valid memtier finds memory_dev_types with nodes still
+	 * linked to the memtier. We achieve this by waiting for
+	 * rcu read section to finish using synchronize_rcu.
+	 * This also enables us to free the destroyed memory tier
+	 * with kfree instead of kfree_rcu
+	 */
 	memtier = __node_get_memory_tier(node);
 	if (memtier) {
 		struct memory_dev_type *memtype;
 
+		rcu_assign_pointer(pgdat->memtier, NULL);
+		synchronize_rcu();
 		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


