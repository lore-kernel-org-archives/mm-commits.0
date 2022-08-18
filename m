Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4866C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344239AbiHRXvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241673AbiHRXv0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2805D2931
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518CE6174E
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3576C433C1;
        Thu, 18 Aug 2022 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866680;
        bh=RYS65d3HkVk2Np8yZFoGnUMex2W3FZFA0/6EHr0LbXI=;
        h=Date:To:From:Subject:From;
        b=Rzb0MQwtJUrTyodXLcCIIVPtBZu6n0cWw6fb9LS2Un64f6mnDXrfL1qmpoIxH0AaK
         W+2OjB7CZ2B3eUMOoxqDWav2yasia6rkD5kGnG4q/amnmPcBrF8IvcipApJ24E7sRW
         WvHauWFoNoPWRT0ZyoW5sOcAHeXfTmQJ6prpjVPM=
Date:   Thu, 18 Aug 2022 16:51:19 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-drop-memtier-from-memtype.patch added to mm-unstable branch
Message-Id: <20220818235120.A3576C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: drop memtier from memtype
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-drop-memtier-from-memtype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-drop-memtier-from-memtype.patch

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
Subject: mm/demotion: drop memtier from memtype
Date: Thu, 18 Aug 2022 18:40:39 +0530

Now that we track node-specific memtier in pg_data_t, we can drop memtier
from memtype.

Link: https://lkml.kernel.org/r/20220818131042.113280-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
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
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
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
@@ -100,17 +100,22 @@ static struct memory_tier *find_create_m
 
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
@@ -130,7 +135,6 @@ static struct memory_tier *find_create_m
 		list_add_tail(&new_memtier->list, &memtier->list);
 	else
 		list_add_tail(&new_memtier->list, &memory_tiers);
-	memtype->memtier = new_memtier;
 	list_add(&memtype->tier_sibiling, &new_memtier->memory_types);
 	return new_memtier;
 }
@@ -357,7 +361,6 @@ static bool clear_node_memory_tier(int n
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
 			list_del(&memtype->tier_sibiling);
-			memtype->memtier = NULL;
 			if (list_empty(&memtier->memory_types))
 				destroy_memory_tier(memtier);
 		}
@@ -385,7 +388,6 @@ struct memory_dev_type *alloc_memory_typ
 	memtype->adistance = adistance;
 	INIT_LIST_HEAD(&memtype->tier_sibiling);
 	memtype->nodes  = NODE_MASK_NONE;
-	memtype->memtier = NULL;
 	kref_init(&memtype->kref);
 	return memtype;
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

