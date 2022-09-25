Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FA3C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiIYTkt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiIYTks (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:40:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2142B193
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77C94CE0FBC
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D05C433C1;
        Sun, 25 Sep 2022 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664134843;
        bh=hN0DtUsSKIRpT7GKUvbzNRW1unIxgQcy16pZMnJaCAQ=;
        h=Date:To:From:Subject:From;
        b=YZzeK5F2I39fkNcSnbj9hzormrI4frGT+59zRiRzl8uUvnpVB0j1bwtI4vBqO84VL
         65NbSqBvRw/+1t75/zVdAbUBbAcZNeXG4Ays46lSNat9ZAj5Hy76VgDhOsVChoY0Ew
         pxlux/tIVR4Rjoe22A9c1c05fGollZPkHWMsSO/A=
Date:   Sun, 25 Sep 2022 12:40:41 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch added to mm-unstable branch
Message-Id: <20220925194043.25D05C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-demotion-expose-memory-tier-details-via-sysfs-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch

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
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined-fix.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance-fix.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-3.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch
mm-demotion-expose-memory-tier-details-via-sysfs.patch
mm-demotion-expose-memory-tier-details-via-sysfs-v4.patch

