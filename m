Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6BCC00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiHRXvI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiHRXvG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:51:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4327FCE46E
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1729B824EA
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6919BC433C1;
        Thu, 18 Aug 2022 23:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866662;
        bh=8IrS4/nSimy9tXON331FO3ISOFlIjtB7qmQOcnwncbM=;
        h=Date:To:From:Subject:From;
        b=UHzBOkGCRQ9P/Bg7r58OR0dgnyzZIdNKNZStN+ciHoufy4GJhyuFqHZJfzdeRN8Pd
         HQEp5XYmZKwQjSO5eJkeraM7i9Cako2Tms4/n0GPHJXyiZMSibKsevpXruag5gNXMi
         2iaeTd+46R1appVRfNYEGQPAvDBJip4QIuPIMPEE=
Date:   Thu, 18 Aug 2022 16:51:01 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-add-support-for-explicit-memory-tiers.patch added to mm-unstable branch
Message-Id: <20220818235102.6919BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion: add support for explicit memory tiers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-add-support-for-explicit-memory-tiers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-add-support-for-explicit-memory-tiers.patch

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

Link: https://lkml.kernel.org/r/20220818131042.113280-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20220818131042.113280-2-aneesh.kumar@linux.ibm.com
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
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
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
+ * Smaller abstract distance values imply faster(higher) memory tiers. Offset
+ * the DRAM adistance so that we can accommodate devices with a slightly lower
+ * adistance value (slightly slower) than default DRAM adistance to be part of
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

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

