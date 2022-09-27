Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5941C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiI0Cuu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiI0Cs4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D72642C6
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC6961566
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6807C433C1;
        Tue, 27 Sep 2022 02:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246901;
        bh=g5g23ADBo92dTWnry+gDRF12CTligz/E0mx24qlKuG4=;
        h=Date:To:From:Subject:From;
        b=CXRouukPZg2h+lvtdp/2zxGh7fPC0x+e434x1Iv8PbV9Q0ddXYZpp0t4f1tixsyvS
         AMUWEJQGrbceJChtMnfMOJJfQHB/R2qCNqVqBZfPqET1jYsQdxPB5eHe8kSDeDkFFg
         mIOV4SWw9rKPX1PjcMVC1n3YTgtC86xb54sQpzwc=
Date:   Mon, 26 Sep 2022 19:48:21 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-drop-memtier-from-memtype.patch removed from -mm tree
Message-Id: <20220927024821.C6807C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: drop memtier from memtype
has been removed from the -mm tree.  Its filename was
     mm-demotion-drop-memtier-from-memtype.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: drop memtier from memtype
Date: Thu, 18 Aug 2022 18:40:39 +0530

Now that we track node-specific memtier in pg_data_t, we can drop memtier
from memtype.

Link: https://lkml.kernel.org/r/20220818131042.113280-8-aneesh.kumar@linux.ibm.com
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

 include/linux/memory-tiers.h |    1 -
 mm/memory-tiers.c            |   16 +++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/memory-tiers.h~mm-demotion-drop-memtier-from-memtype
+++ a/include/linux/memory-tiers.h
@@ -28,7 +28,6 @@ struct memory_dev_type {
 	/* Nodes of same abstract distance */
 	nodemask_t nodes;
 	struct kref kref;
-	struct memory_tier *memtier;
 };
 
 #ifdef CONFIG_NUMA
--- a/mm/memory-tiers.c~mm-demotion-drop-memtier-from-memtype
+++ a/mm/memory-tiers.c
@@ -105,17 +105,22 @@ static struct memory_tier *find_create_m
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
+	adistance = round_down(adistance, memtier_adistance_chunk_size);
 	/*
 	 * If the memtype is already part of a memory tier,
 	 * just return that.
 	 */
-	if (memtype->memtier)
-		return memtype->memtier;
+	if (!list_empty(&memtype->tier_sibiling)) {
+		list_for_each_entry(memtier, &memory_tiers, list) {
+			if (adistance == memtier->adistance_start)
+				return memtier;
+		}
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
 
-	adistance = round_down(adistance, memtier_adistance_chunk_size);
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		if (adistance == memtier->adistance_start) {
-			memtype->memtier = memtier;
 			list_add(&memtype->tier_sibiling, &memtier->memory_types);
 			return memtier;
 		} else if (adistance < memtier->adistance_start) {
@@ -135,7 +140,6 @@ static struct memory_tier *find_create_m
 		list_add_tail(&new_memtier->list, &memtier->list);
 	else
 		list_add_tail(&new_memtier->list, &memory_tiers);
-	memtype->memtier = new_memtier;
 	list_add(&memtype->tier_sibiling, &new_memtier->memory_types);
 	return new_memtier;
 }
@@ -372,7 +376,6 @@ static bool clear_node_memory_tier(int n
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
 			list_del_init(&memtype->tier_sibiling);
-			memtype->memtier = NULL;
 			if (list_empty(&memtier->memory_types))
 				destroy_memory_tier(memtier);
 		}
@@ -400,7 +403,6 @@ struct memory_dev_type *alloc_memory_typ
 	memtype->adistance = adistance;
 	INIT_LIST_HEAD(&memtype->tier_sibiling);
 	memtype->nodes  = NODE_MASK_NONE;
-	memtype->memtier = NULL;
 	kref_init(&memtype->kref);
 	return memtype;
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


