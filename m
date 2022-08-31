Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25917ECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiHaBbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHaBbR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:31:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208956567A
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A788B81E3C
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A9DC433C1;
        Wed, 31 Aug 2022 01:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661909473;
        bh=QfOFu58KpGvaaQEyCqSmpn5CCgboISh0iFWxc4YMdRQ=;
        h=Date:To:From:Subject:From;
        b=mLDFJpGD/ZvyTpAk6uHPUka+TpR90Gr2opcPyVcGwQMu9HNWlH4VS4R4c4Moa3jBI
         6IMmM6Xbva+cGWZ0lRFlU/IaA50fvcxld1sKjDsqbFGb8acLNU+/Q2BM9tG7pR0S+g
         NymEQZGfe7bP9f3PiTBamXD2egupoXe8Ze02rl78=
Date:   Tue, 30 Aug 2022 18:31:12 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-expose-memory-tier-details-via-sysfs.patch added to mm-unstable branch
Message-Id: <20220831013113.29A9DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: expose memory tier details via sysfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-expose-memory-tier-details-via-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-expose-memory-tier-details-via-sysfs.patch

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
Subject: mm/demotion: expose memory tier details via sysfs
Date: Tue, 30 Aug 2022 13:47:36 +0530

Add /sys/devices/virtual/memory_tiering/ where all memory tier related
details can be found.  All allocated memory tiers will be listed there as
/sys/devices/virtual/memory_tiering/memory_tierN/

The nodes which are part of a specific memory tier can be listed via
/sys/devices/virtual/memory_tiering/memory_tierN/nodes

A directory hierarchy looks like
:/sys/devices/virtual/memory_tiering$ tree memory_tier4/
memory_tier4/
├── nodes
├── subsystem -> ../../../../bus/memory_tiering
└── uevent

All toptier nodes are listed via
/sys/devices/virtual/memory_tiering/toptier_nodes

:/sys/devices/virtual/memory_tiering$ cat toptier_nodes
0,2
:/sys/devices/virtual/memory_tiering$ cat memory_tier4/nodes
0,2

Link: https://lkml.kernel.org/r/20220830081736.119281-1-aneesh.kumar@linux.ibm.com
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

 Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers |   35 ++
 mm/memory-tiers.c                                      |  154 ++++++++--
 2 files changed, 167 insertions(+), 22 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
@@ -0,0 +1,35 @@
+What:		/sys/devices/virtual/memory_tiering/
+Date:		August 2022
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	A collection of all the memory tiers allocated.
+
+		Individual memory tier details are contained in subdirectories
+		named by the abstract distance of the memory tier.
+
+		/sys/devices/virtual/memory_tiering/memory_tierN/
+
+
+What:		/sys/devices/virtual/memory_tiering/memory_tierN/
+		/sys/devices/virtual/memory_tiering/memory_tierN/nodes
+Date:		August 2022
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Directory with details of a specific memory tier
+
+		This is the directory containing information about a particular
+		memory tier, memtierN, where N is derived based on abstract distance.
+
+		A smaller value of N implies a higher (faster) memory tier in the
+		hierarchy.
+
+		nodes: NUMA nodes that are part of this memory tier.
+
+
+What:		/sys/devices/virtual/memory_tiering/toptier_nodes
+Date:		August 2022
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Toptier node mask
+
+		A toptier is defined as the memory tier from which memory promotion
+		is not done by the kernel.
+
+		toptier_nodes: Union of NUMA nodes that are part of each toptier.
--- a/mm/memory-tiers.c~mm-demotion-expose-memory-tier-details-via-sysfs
+++ a/mm/memory-tiers.c
@@ -19,6 +19,7 @@ struct memory_tier {
 	 * adistance_start .. adistance_start + MEMTIER_CHUNK_SIZE
 	 */
 	int adistance_start;
+	struct device dev;
 	/* All the nodes that are part of all the lower memory tiers. */
 	nodemask_t lower_tier_mask;
 };
@@ -36,6 +37,12 @@ static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 static struct memory_dev_type *default_dram_type;
+
+static struct bus_type memory_tier_subsys = {
+	.name = "memory_tiering",
+	.dev_name = "memory_tier",
+};
+
 #ifdef CONFIG_MIGRATION
 static int top_tier_adistance;
 /*
@@ -98,8 +105,63 @@ static int top_tier_adistance;
 static struct demotion_nodes *node_demotion __read_mostly;
 #endif /* CONFIG_MIGRATION */
 
+static inline struct memory_tier *to_memory_tier(struct device *device)
+{
+	return container_of(device, struct memory_tier, dev);
+}
+
+static __always_inline nodemask_t get_memtier_nodemask(struct memory_tier *memtier)
+{
+	nodemask_t nodes = NODE_MASK_NONE;
+	struct memory_dev_type *memtype;
+
+	list_for_each_entry(memtype, &memtier->memory_types, tier_sibiling)
+		nodes_or(nodes, nodes, memtype->nodes);
+
+	return nodes;
+}
+
+static void memory_tier_device_release(struct device *dev)
+{
+	struct memory_tier *tier = to_memory_tier(dev);
+	/*
+	 * synchronize_rcu in clear_node_memory_tier makes sure
+	 * we don't have rcu access to this memory tier.
+	 */
+	kfree(tier);
+}
+
+static ssize_t nodes_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	int ret;
+	nodemask_t nmask;
+
+	mutex_lock(&memory_tier_lock);
+	nmask = get_memtier_nodemask(to_memory_tier(dev));
+	ret = sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&nmask));
+	mutex_unlock(&memory_tier_lock);
+	return ret;
+}
+static DEVICE_ATTR_RO(nodes);
+
+static struct attribute *memtier_dev_attrs[] = {
+	&dev_attr_nodes.attr,
+	NULL
+};
+
+static const struct attribute_group memtier_dev_group = {
+	.attrs = memtier_dev_attrs,
+};
+
+static const struct attribute_group *memtier_dev_groups[] = {
+	&memtier_dev_group,
+	NULL
+};
+
 static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memtype)
 {
+	int ret;
 	bool found_slot = false;
 	struct memory_tier *memtier, *new_memtier;
 	int adistance = memtype->adistance;
@@ -123,15 +185,14 @@ static struct memory_tier *find_create_m
 
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		if (adistance == memtier->adistance_start) {
-			list_add(&memtype->tier_sibiling, &memtier->memory_types);
-			return memtier;
+			goto link_memtype;
 		} else if (adistance < memtier->adistance_start) {
 			found_slot = true;
 			break;
 		}
 	}
 
-	new_memtier = kmalloc(sizeof(struct memory_tier), GFP_KERNEL);
+	new_memtier = kzalloc(sizeof(struct memory_tier), GFP_KERNEL);
 	if (!new_memtier)
 		return ERR_PTR(-ENOMEM);
 
@@ -142,8 +203,23 @@ static struct memory_tier *find_create_m
 		list_add_tail(&new_memtier->list, &memtier->list);
 	else
 		list_add_tail(&new_memtier->list, &memory_tiers);
-	list_add(&memtype->tier_sibiling, &new_memtier->memory_types);
-	return new_memtier;
+
+	new_memtier->dev.id = adistance >> MEMTIER_CHUNK_BITS;
+	new_memtier->dev.bus = &memory_tier_subsys;
+	new_memtier->dev.release = memory_tier_device_release;
+	new_memtier->dev.groups = memtier_dev_groups;
+
+	ret = device_register(&new_memtier->dev);
+	if (ret) {
+		list_del(&memtier->list);
+		put_device(&memtier->dev);
+		return ERR_PTR(ret);
+	}
+	memtier = new_memtier;
+
+link_memtype:
+	list_add(&memtype->tier_sibiling, &memtier->memory_types);
+	return memtier;
 }
 
 static struct memory_tier *__node_get_memory_tier(int node)
@@ -275,17 +351,6 @@ static void disable_all_demotion_targets
 	synchronize_rcu();
 }
 
-static __always_inline nodemask_t get_memtier_nodemask(struct memory_tier *memtier)
-{
-	nodemask_t nodes = NODE_MASK_NONE;
-	struct memory_dev_type *memtype;
-
-	list_for_each_entry(memtype, &memtier->memory_types, tier_sibiling)
-		nodes_or(nodes, nodes, memtype->nodes);
-
-	return nodes;
-}
-
 /*
  * Find an automatic demotion target for all memory
  * nodes. Failing here is OK.  It might just indicate
@@ -432,11 +497,7 @@ static struct memory_tier *set_node_memo
 static void destroy_memory_tier(struct memory_tier *memtier)
 {
 	list_del(&memtier->list);
-	/*
-	 * synchronize_rcu in clear_node_memory_tier makes sure
-	 * we don't have rcu access to this memory tier.
-	 */
-	kfree(memtier);
+	device_unregister(&memtier->dev);
 }
 
 static bool clear_node_memory_tier(int node)
@@ -563,11 +624,60 @@ static int __meminit memtier_hotplug_cal
 	return notifier_from_errno(0);
 }
 
+#ifdef CONFIG_MIGRATION
+static ssize_t toptier_nodes_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int ret;
+	nodemask_t nmask, top_tier_mask = NODE_MASK_NONE;
+	struct memory_tier *memtier = to_memory_tier(dev);
+
+	mutex_lock(&memory_tier_lock);
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		if (memtier->adistance_start > top_tier_adistance)
+			break;
+		nmask = get_memtier_nodemask(memtier);
+		nodes_or(top_tier_mask, top_tier_mask, nmask);
+	}
+
+	ret = sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&top_tier_mask));
+	mutex_unlock(&memory_tier_lock);
+	return ret;
+}
+#else
+static ssize_t toptier_nodes_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	nodemask_t top_tier_mask = node_states[N_MEMORY];
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&top_tier_mask));
+}
+#endif
+static DEVICE_ATTR_RO(toptier_nodes);
+
+static struct attribute *memtier_subsys_attrs[] = {
+	&dev_attr_toptier_nodes.attr,
+	NULL
+};
+
+static const struct attribute_group memtier_subsys_group = {
+	.attrs = memtier_subsys_attrs,
+};
+
+static const struct attribute_group *memtier_subsys_groups[] = {
+	&memtier_subsys_group,
+	NULL
+};
+
 static int __init memory_tier_init(void)
 {
-	int node;
+	int ret, node;
 	struct memory_tier *memtier;
 
+	ret = subsys_virtual_register(&memory_tier_subsys, memtier_subsys_groups);
+	if (ret)
+		panic("%s() failed to register memory tier subsystem\n", __func__);
+
 #ifdef CONFIG_MIGRATION
 	node_demotion = kcalloc(nr_node_ids, sizeof(struct demotion_nodes),
 				GFP_KERNEL);
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
mm-demotion-expose-memory-tier-details-via-sysfs.patch

