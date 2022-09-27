Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599A1C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiI0Cty (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiI0Csp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503569E2F9
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 990616155B
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE555C433C1;
        Tue, 27 Sep 2022 02:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246894;
        bh=1/B1RO6ukWjqkN/tY/VNUI4pfQoP1L1ZOUo4e2n8Qas=;
        h=Date:To:From:Subject:From;
        b=Q+drshTWY1TzcUjhovoeRo+KkugJ1vULJS5oKXX2VgKIgHfz0b8oSqV1gm+lxVV9P
         DgfxVqGOrgJ1OUQ+vutU/k3rrMzRTWRaw2CSzwt6RvuUircAwY+x9UsS2OR4HD702U
         JxPvZApDHo5SkJYCXwXB85vS/y92p5CfGlKf3i50=
Date:   Mon, 26 Sep 2022 19:48:13 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-add-support-for-explicit-memory-tiers.patch removed from -mm tree
Message-Id: <20220927024813.EE555C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: add support for explicit memory tiers
has been removed from the -mm tree.  Its filename was
     mm-demotion-add-support-for-explicit-memory-tiers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: add support for explicit memory tiers
Date: Thu, 18 Aug 2022 18:40:33 +0530

Patch series "mm/demotion: Memory tiers and demotion", v15.

The current kernel has the basic memory tiering support: Inactive pages on
a higher tier NUMA node can be migrated (demoted) to a lower tier NUMA
node to make room for new allocations on the higher tier NUMA node. 
Frequently accessed pages on a lower tier NUMA node can be migrated
(promoted) to a higher tier NUMA node to improve the performance.

In the current kernel, memory tiers are defined implicitly via a demotion
path relationship between NUMA nodes, which is created during the kernel
initialization and updated when a NUMA node is hot-added or hot-removed. 
The current implementation puts all nodes with CPU into the highest tier,
and builds the tier hierarchy tier-by-tier by establishing the per-node
demotion targets based on the distances between nodes.

This current memory tier kernel implementation needs to be improved for
several important use cases:

* The current tier initialization code always initializes each
  memory-only NUMA node into a lower tier.  But a memory-only NUMA node
  may have a high performance memory device (e.g.  a DRAM-backed
  memory-only node on a virtual machine) and that should be put into a
  higher tier.

* The current tier hierarchy always puts CPU nodes into the top tier. 
  But on a system with HBM (e.g.  GPU memory) devices, these memory-only
  HBM NUMA nodes should be in the top tier, and DRAM nodes with CPUs are
  better to be placed into the next lower tier.

* Also because the current tier hierarchy always puts CPU nodes into the
  top tier, when a CPU is hot-added (or hot-removed) and triggers a memory
  node from CPU-less into a CPU node (or vice versa), the memory tier
  hierarchy gets changed, even though no memory node is added or removed. 
  This can make the tier hierarchy unstable and make it difficult to
  support tier-based memory accounting.

* A higher tier node can only be demoted to nodes with shortest distance
  on the next lower tier as defined by the demotion path, not any other
  node from any lower tier.  This strict, demotion order does not work in
  all use cases (e.g.  some use cases may want to allow cross-socket
  demotion to another node in the same demotion tier as a fallback when
  the preferred demotion node is out of space), and has resulted in the
  feature request for an interface to override the system-wide, per-node
  demotion order from the userspace.  This demotion order is also
  inconsistent with the page allocation fallback order when all the nodes
  in a higher tier are out of space: The page allocation can fall back to
  any node from any lower tier, whereas the demotion order doesn't allow
  that.

This patch series make the creation of memory tiers explicit under the
control of device driver.

Memory Tier Initialization
==========================

Linux kernel presents memory devices as NUMA nodes and each memory device
is of a specific type.  The memory type of a device is represented by its
abstract distance.  A memory tier corresponds to a range of abstract
distance.  This allows for classifying memory devices with a specific
performance range into a memory tier.

By default, all memory nodes are assigned to the default tier with
abstract distance 512.

A device driver can move its memory nodes from the default tier.  For
example, PMEM can move its memory nodes below the default tier, whereas
GPU can move its memory nodes above the default tier.

The kernel initialization code makes the decision on which exact tier a
memory node should be assigned to based on the requests from the device
drivers as well as the memory device hardware information provided by the
firmware.

Hot-adding/removing CPUs doesn't affect memory tier hierarchy.


This patch (of 10):

In the current kernel, memory tiers are defined implicitly via a demotion
path relationship between NUMA nodes, which is created during the kernel
initialization and updated when a NUMA node is hot-added or hot-removed. 
The current implementation puts all nodes with CPU into the highest tier,
and builds the tier hierarchy by establishing the per-node demotion
targets based on the distances between nodes.

This current memory tier kernel implementation needs to be improved for
several important use cases,

The current tier initialization code always initializes each memory-only
NUMA node into a lower tier.  But a memory-only NUMA node may have a high
performance memory device (e.g.  a DRAM-backed memory-only node on a
virtual machine) that should be put into a higher tier.

The current tier hierarchy always puts CPU nodes into the top tier.  But
on a system with HBM or GPU devices, the memory-only NUMA nodes mapping
these devices should be in the top tier, and DRAM nodes with CPUs are
better to be placed into the next lower tier.

With current kernel higher tier node can only be demoted to nodes with
shortest distance on the next lower tier as defined by the demotion path,
not any other node from any lower tier.  This strict, demotion order does
not work in all use cases (e.g.  some use cases may want to allow
cross-socket demotion to another node in the same demotion tier as a
fallback when the preferred demotion node is out of space), This demotion
order is also inconsistent with the page allocation fallback order when
all the nodes in a higher tier are out of space: The page allocation can
fall back to any node from any lower tier, whereas the demotion order
doesn't allow that.

This patch series address the above by defining memory tiers explicitly.

Linux kernel presents memory devices as NUMA nodes and each memory device
is of a specific type.  The memory type of a device is represented by its
abstract distance.  A memory tier corresponds to a range of abstract
distance.  This allows for classifying memory devices with a specific
performance range into a memory tier.

This patch configures the range/chunk size to be 128.  The default DRAM
abstract distance is 512.  We can have 4 memory tiers below the default
DRAM with abstract distance range 0 - 127, 127 - 255, 256- 383, 384 - 511.
Faster memory devices can be placed in these faster(higher) memory tiers.
Slower memory devices like persistent memory will have abstract distance
higher than the default DRAM level.

[akpm@linux-foundation.org: fix comment, per Aneesh]
Link: https://lkml.kernel.org/r/20220818131042.113280-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20220818131042.113280-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |   18 ++++
 mm/Makefile                  |    1 
 mm/memory-tiers.c            |  129 +++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)

--- /dev/null
+++ a/include/linux/memory-tiers.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMORY_TIERS_H
+#define _LINUX_MEMORY_TIERS_H
+
+/*
+ * Each tier cover a abstrace distance chunk size of 128
+ */
+#define MEMTIER_CHUNK_BITS	7
+#define MEMTIER_CHUNK_SIZE	(1 << MEMTIER_CHUNK_BITS)
+/*
+ * Smaller abstract distance values imply faster (higher) memory tiers. Offset
+ * the DRAM adistance so that we can accommodate devices with a slightly lower
+ * adistance value (slightly faster) than default DRAM adistance to be part of
+ * the same memory tier.
+ */
+#define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
+
+#endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/Makefile~mm-demotion-add-support-for-explicit-memory-tiers
+++ a/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
+obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
--- /dev/null
+++ a/mm/memory-tiers.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <linux/nodemask.h>
+#include <linux/slab.h>
+#include <linux/lockdep.h>
+#include <linux/memory-tiers.h>
+
+struct memory_tier {
+	/* hierarchy of memory tiers */
+	struct list_head list;
+	/* list of all memory types part of this tier */
+	struct list_head memory_types;
+	/*
+	 * start value of abstract distance. memory tier maps
+	 * an abstract distance  range,
+	 * adistance_start .. adistance_start + MEMTIER_CHUNK_SIZE
+	 */
+	int adistance_start;
+};
+
+struct memory_dev_type {
+	/* list of memory types that are part of same tier as this type */
+	struct list_head tier_sibiling;
+	/* abstract distance for this specific memory type */
+	int adistance;
+	/* Nodes of same abstract distance */
+	nodemask_t nodes;
+	struct memory_tier *memtier;
+};
+
+static DEFINE_MUTEX(memory_tier_lock);
+static LIST_HEAD(memory_tiers);
+static struct memory_dev_type *node_memory_types[MAX_NUMNODES];
+/*
+ * For now we can have 4 faster memory tiers with smaller adistance
+ * than default DRAM tier.
+ */
+static struct memory_dev_type default_dram_type  = {
+	.adistance = MEMTIER_ADISTANCE_DRAM,
+	.tier_sibiling = LIST_HEAD_INIT(default_dram_type.tier_sibiling),
+};
+
+static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memtype)
+{
+	bool found_slot = false;
+	struct memory_tier *memtier, *new_memtier;
+	int adistance = memtype->adistance;
+	unsigned int memtier_adistance_chunk_size = MEMTIER_CHUNK_SIZE;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	/*
+	 * If the memtype is already part of a memory tier,
+	 * just return that.
+	 */
+	if (memtype->memtier)
+		return memtype->memtier;
+
+	adistance = round_down(adistance, memtier_adistance_chunk_size);
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		if (adistance == memtier->adistance_start) {
+			memtype->memtier = memtier;
+			list_add(&memtype->tier_sibiling, &memtier->memory_types);
+			return memtier;
+		} else if (adistance < memtier->adistance_start) {
+			found_slot = true;
+			break;
+		}
+	}
+
+	new_memtier = kmalloc(sizeof(struct memory_tier), GFP_KERNEL);
+	if (!new_memtier)
+		return ERR_PTR(-ENOMEM);
+
+	new_memtier->adistance_start = adistance;
+	INIT_LIST_HEAD(&new_memtier->list);
+	INIT_LIST_HEAD(&new_memtier->memory_types);
+	if (found_slot)
+		list_add_tail(&new_memtier->list, &memtier->list);
+	else
+		list_add_tail(&new_memtier->list, &memory_tiers);
+	memtype->memtier = new_memtier;
+	list_add(&memtype->tier_sibiling, &new_memtier->memory_types);
+	return new_memtier;
+}
+
+static struct memory_tier *set_node_memory_tier(int node)
+{
+	struct memory_tier *memtier;
+	struct memory_dev_type *memtype;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	if (!node_state(node, N_MEMORY))
+		return ERR_PTR(-EINVAL);
+
+	if (!node_memory_types[node])
+		node_memory_types[node] = &default_dram_type;
+
+	memtype = node_memory_types[node];
+	node_set(node, memtype->nodes);
+	memtier = find_create_memory_tier(memtype);
+	return memtier;
+}
+
+static int __init memory_tier_init(void)
+{
+	int node;
+	struct memory_tier *memtier;
+
+	mutex_lock(&memory_tier_lock);
+	/*
+	 * Look at all the existing N_MEMORY nodes and add them to
+	 * default memory tier or to a tier if we already have memory
+	 * types assigned.
+	 */
+	for_each_node_state(node, N_MEMORY) {
+		memtier = set_node_memory_tier(node);
+		if (IS_ERR(memtier))
+			/*
+			 * Continue with memtiers we are able to setup
+			 */
+			break;
+	}
+	mutex_unlock(&memory_tier_lock);
+
+	return 0;
+}
+subsys_initcall(memory_tier_init);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


