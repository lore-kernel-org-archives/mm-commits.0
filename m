Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81F1ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiH0DB2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345100AbiH0DB0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:01:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482ECCCE04
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDE3ECE3217
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B79EC433D6;
        Sat, 27 Aug 2022 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661569278;
        bh=J8oMGNGpD3sGr/EySyHtjjMQsgAwRXOiU5REHfEjmrc=;
        h=Date:To:From:Subject:From;
        b=YsMH3t1BwvnvmJLiw/6WJbMqH/8jwgkuqfbGk/goRZk9kisvfktlJxliEgPALvWRA
         4DpuUY8gN1VrVuG5rd0LsCI8wBSDJpRpXa6afzaIDGW31DWl15blQmE8G+tH4IrYxz
         k1bJqolxXqgTq0NdUi5lUzZwFnL0uUzfbNoSMBrE=
Date:   Fri, 26 Aug 2022 20:01:17 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch added to mm-unstable branch
Message-Id: <20220827030118.1B79EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: assign correct memory type for multiple dax devices with the same node affinity
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch

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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: assign correct memory type for multiple dax devices with the same node affinity
Date: Fri, 26 Aug 2022 15:32:24 +0530

With multiple dax devices having the same node affinity, the kernel
wrongly assigned default_dram memory type to some devices after the memory
hotplug operation.  Fix this by not clearing node_memory_types on the dax
device remove.

The current kernel cleared node_memory_type on successful removal of a dax
device.  But then we can have multiple dax devices with the same node
affinity.  Clearing the node_memory_type results in assigning other dax
devices to the default dram type when we bring them online.

Link: https://lkml.kernel.org/r/20220826100224.542312-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/mm/memory-tiers.c~mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix
+++ a/mm/memory-tiers.c
@@ -19,9 +19,14 @@ struct memory_tier {
 	int adistance_start;
 };
 
+struct node_memory_type_map {
+	struct memory_dev_type *memtype;
+	int map_count;
+};
+
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
-static struct memory_dev_type *node_memory_types[MAX_NUMNODES];
+static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 static struct memory_dev_type *default_dram_type;
 
 static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memtype)
@@ -70,9 +75,19 @@ static struct memory_tier *find_create_m
 
 static inline void __init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
-	if (!node_memory_types[node]) {
-		node_memory_types[node] = memtype;
-		kref_get(&memtype->kref);
+	if (!node_memory_types[node].memtype)
+		node_memory_types[node].memtype = memtype;
+	/*
+	 * for each device getting added in the same NUMA node
+	 * with this specific memtype, bump the map count. We
+	 * Only take memtype device reference once, so that
+	 * changing a node memtype can be done by droping the
+	 * only reference count taken here.
+	 */
+
+	if (node_memory_types[node].memtype == memtype) {
+		if (!node_memory_types[node].map_count++)
+			kref_get(&memtype->kref);
 	}
 }
 
@@ -88,7 +103,7 @@ static struct memory_tier *set_node_memo
 
 	__init_node_memory_type(node, default_dram_type);
 
-	memtype = node_memory_types[node];
+	memtype = node_memory_types[node].memtype;
 	node_set(node, memtype->nodes);
 	memtier = find_create_memory_tier(memtype);
 	return memtier;
@@ -119,7 +134,7 @@ static bool clear_node_memory_tier(int n
 	if (memtier) {
 		struct memory_dev_type *memtype;
 
-		memtype = node_memory_types[node];
+		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
 			list_del_init(&memtype->tier_sibiling);
@@ -175,8 +190,14 @@ EXPORT_SYMBOL_GPL(init_node_memory_type)
 void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 {
 	mutex_lock(&memory_tier_lock);
-	if (node_memory_types[node] == memtype) {
-		node_memory_types[node] = NULL;
+	if (node_memory_types[node].memtype == memtype)
+		node_memory_types[node].map_count--;
+	/*
+	 * If we umapped all the attached devices to this node,
+	 * clear the node memory type.
+	 */
+	if (!node_memory_types[node].map_count) {
+		node_memory_types[node].memtype = NULL;
 		kref_put(&memtype->kref, release_memtype);
 	}
 	mutex_unlock(&memory_tier_lock);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch
a.patch

