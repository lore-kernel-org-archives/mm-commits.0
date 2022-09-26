Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41507C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIZVAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIZVAt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:00:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DFD240B2
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9FE2B80A4A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F95C433C1;
        Mon, 26 Sep 2022 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226045;
        bh=rw6WW9pgS0gaLa1sm5S+vUJW1u3PX3i/8eMPt8AIYbQ=;
        h=Date:To:From:Subject:From;
        b=m4rCKu5ulbjzk+D6P9J8ZUBdiw53GO0T5iN047ai30uc623+COsGygJsv3PIAXy52
         AqiNNasB/BoJ91XYWVMsS5PElAhJYp3CsaEPvvo35zpxAjwTYdY66na0AuKRAdGsfq
         nMfnYEw02X9UcLVK3PnIDj8LMZRP4gaNSYGis1Rg=
Date:   Mon, 26 Sep 2022 14:00:44 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch removed from -mm tree
Message-Id: <20220926210045.61F95C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-demotion-expose-memory-tier-details-via-sysfs-v4
has been removed from the -mm tree.  Its filename was
     mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch

This patch was dropped because it was folded into mm-demotion-expose-memory-tier-details-via-sysfs.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-demotion-expose-memory-tier-details-via-sysfs-v4
Date: Thu, 22 Sep 2022 15:52:01 +0530

drop toptier_nodes from sysfs

Link: https://lkml.kernel.org/r/20220922102201.62168-1-aneesh.kumar@linux.ibm.com
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
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers |   10 --
 mm/memory-tiers.c                                      |   47 ----------
 2 files changed, 1 insertion(+), 56 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers~mm-demotion-expose-memory-tier-details-via-sysfs-v4
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
@@ -23,13 +23,3 @@ Description:	Directory with details of a
 
 		nodes: NUMA nodes that are part of this memory tier.
 
-
-What:		/sys/devices/virtual/memory_tiering/toptier_nodes
-Date:		August 2022
-Contact:	Linux memory management mailing list <linux-mm@kvack.org>
-Description:	Toptier node mask
-
-		A toptier is defined as the memory tier from which memory promotion
-		is not done by the kernel.
-
-		toptier_nodes: Union of NUMA nodes that are part of each toptier.
--- a/mm/memory-tiers.c~mm-demotion-expose-memory-tier-details-via-sysfs-v4
+++ a/mm/memory-tiers.c
@@ -625,57 +625,12 @@ static int __meminit memtier_hotplug_cal
 	return notifier_from_errno(0);
 }
 
-#ifdef CONFIG_MIGRATION
-static ssize_t toptier_nodes_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	int ret;
-	nodemask_t nmask, top_tier_mask = NODE_MASK_NONE;
-	struct memory_tier *memtier = to_memory_tier(dev);
-
-	mutex_lock(&memory_tier_lock);
-	list_for_each_entry(memtier, &memory_tiers, list) {
-		if (memtier->adistance_start > top_tier_adistance)
-			break;
-		nmask = get_memtier_nodemask(memtier);
-		nodes_or(top_tier_mask, top_tier_mask, nmask);
-	}
-
-	ret = sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&top_tier_mask));
-	mutex_unlock(&memory_tier_lock);
-	return ret;
-}
-#else
-static ssize_t toptier_nodes_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	nodemask_t top_tier_mask = node_states[N_MEMORY];
-
-	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&top_tier_mask));
-}
-#endif
-static DEVICE_ATTR_RO(toptier_nodes);
-
-static struct attribute *memtier_subsys_attrs[] = {
-	&dev_attr_toptier_nodes.attr,
-	NULL
-};
-
-static const struct attribute_group memtier_subsys_group = {
-	.attrs = memtier_subsys_attrs,
-};
-
-static const struct attribute_group *memtier_subsys_groups[] = {
-	&memtier_subsys_group,
-	NULL
-};
-
 static int __init memory_tier_init(void)
 {
 	int ret, node;
 	struct memory_tier *memtier;
 
-	ret = subsys_virtual_register(&memory_tier_subsys, memtier_subsys_groups);
+	ret = subsys_virtual_register(&memory_tier_subsys, NULL);
 	if (ret)
 		panic("%s() failed to register memory tier subsystem\n", __func__);
 
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
mm-demotion-expose-memory-tier-details-via-sysfs.patch

