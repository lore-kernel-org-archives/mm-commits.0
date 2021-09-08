Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C1CC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEA661130
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347442AbhIHC4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347231AbhIHC4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C89F61131;
        Wed,  8 Sep 2021 02:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069727;
        bh=Ti1142ciZKrcjcwpDlcI88kab8c/ZoAsSddHfINkWYA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uJB6NFGzJ4W/w3z14jgfIDa9YLsKUUiejVdSIRgLTe0KWx3DlcsDvZjLCkzputYUx
         QmZjWJV8bhyaLw3gGe1dpJ2A87L/hLO+FLsU7u85CNQNYO7uQVcjZxMLLTK5LK2pQr
         gxVFNO3LasJJalyYmZHF5Rfb0RdA5KU5gbZMgGCg=
Date:   Tue, 07 Sep 2021 19:55:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, jasowang@redhat.com,
        lenb@kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
        mkedzier@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, teawater@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, vkuznets@redhat.com
Subject:  [patch 044/147] drivers/base/memory: introduce "memory
 groups" to logically group memory blocks
Message-ID: <20210908025526.zp_x2c6yS%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: introduce "memory groups" to logically group memory blocks

In our "auto-movable" memory onlining policy, we want to make decisions
across memory blocks of a single memory device.  Examples of memory
devices include ACPI memory devices (in the simplest case a single DIMM)
and virtio-mem.  For now, we don't have a connection between a single
memory block device and the real memory device.  Each memory device
consists of 1..X memory block devices.

Let's logically group memory blocks belonging to the same memory device in
"memory groups".  Memory groups can span multiple physical ranges and a
memory group itself does not contain any information regarding physical
ranges, only properties (e.g., "max_pages") necessary for improved memory
onlining.

Introduce two memory group types:

1) Static memory group: E.g., a single ACPI memory device, consisting
   of 1..X memory resources.  A memory group consists of 1..Y memory
   blocks.  The whole group is added/removed in one go.  If any part
   cannot get offlined, the whole group cannot be removed.

2) Dynamic memory group: E.g., a single virtio-mem device.  Memory is
   dynamically added/removed in a fixed granularity, called a "unit",
   consisting of 1..X memory blocks.  A unit is added/removed in one go. 
   If any part of a unit cannot get offlined, the whole unit cannot be
   removed.

In case of 1) we usually want either all memory managed by ZONE_MOVABLE or
none.  In case of 2) we usually want to have as many units as possible
managed by ZONE_MOVABLE.  We want a single unit to be of the same type.

For now, memory groups are an internal concept that is not exposed to user
space; we might want to change that in the future, though.

add_memory() users can specify a mgid instead of a nid when passing the
MHP_NID_IS_MGID flag.

Link: https://lkml.kernel.org/r/20210806124715.17090-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Marek Kedzierski <mkedzier@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |  159 ++++++++++++++++++++++++++++++-
 include/linux/memory.h         |   46 ++++++++
 include/linux/memory_hotplug.h |    5 
 mm/memory_hotplug.c            |   11 +-
 4 files changed, 215 insertions(+), 6 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/drivers/base/memory.c
@@ -82,6 +82,11 @@ static struct bus_type memory_subsys = {
  */
 static DEFINE_XARRAY(memory_blocks);
 
+/*
+ * Memory groups, indexed by memory group id (mgid).
+ */
+static DEFINE_XARRAY_FLAGS(memory_groups, XA_FLAGS_ALLOC);
+
 static BLOCKING_NOTIFIER_HEAD(memory_chain);
 
 int register_memory_notifier(struct notifier_block *nb)
@@ -634,7 +639,8 @@ int register_memory(struct memory_block
 }
 
 static int init_memory_block(unsigned long block_id, unsigned long state,
-			     unsigned long nr_vmemmap_pages)
+			     unsigned long nr_vmemmap_pages,
+			     struct memory_group *group)
 {
 	struct memory_block *mem;
 	int ret = 0;
@@ -652,6 +658,12 @@ static int init_memory_block(unsigned lo
 	mem->state = state;
 	mem->nid = NUMA_NO_NODE;
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
+	INIT_LIST_HEAD(&mem->group_next);
+
+	if (group) {
+		mem->group = group;
+		list_add(&mem->group_next, &group->memory_blocks);
+	}
 
 	ret = register_memory(mem);
 
@@ -671,7 +683,7 @@ static int add_memory_block(unsigned lon
 	if (section_count == 0)
 		return 0;
 	return init_memory_block(memory_block_id(base_section_nr),
-				 MEM_ONLINE, 0);
+				 MEM_ONLINE, 0,  NULL);
 }
 
 static void unregister_memory(struct memory_block *memory)
@@ -681,6 +693,11 @@ static void unregister_memory(struct mem
 
 	WARN_ON(xa_erase(&memory_blocks, memory->dev.id) == NULL);
 
+	if (memory->group) {
+		list_del(&memory->group_next);
+		memory->group = NULL;
+	}
+
 	/* drop the ref. we got via find_memory_block() */
 	put_device(&memory->dev);
 	device_unregister(&memory->dev);
@@ -694,7 +711,8 @@ static void unregister_memory(struct mem
  * Called under device_hotplug_lock.
  */
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				unsigned long vmemmap_pages)
+				unsigned long vmemmap_pages,
+				struct memory_group *group)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
 	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
@@ -707,7 +725,8 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages);
+		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages,
+					group);
 		if (ret)
 			break;
 	}
@@ -891,3 +910,135 @@ int for_each_memory_block(void *arg, wal
 	return bus_for_each_dev(&memory_subsys, NULL, &cb_data,
 				for_each_memory_block_cb);
 }
+
+/*
+ * This is an internal helper to unify allocation and initialization of
+ * memory groups. Note that the passed memory group will be copied to a
+ * dynamically allocated memory group. After this call, the passed
+ * memory group should no longer be used.
+ */
+static int memory_group_register(struct memory_group group)
+{
+	struct memory_group *new_group;
+	uint32_t mgid;
+	int ret;
+
+	if (!node_possible(group.nid))
+		return -EINVAL;
+
+	new_group = kzalloc(sizeof(group), GFP_KERNEL);
+	if (!new_group)
+		return -ENOMEM;
+	*new_group = group;
+	INIT_LIST_HEAD(&new_group->memory_blocks);
+
+	ret = xa_alloc(&memory_groups, &mgid, new_group, xa_limit_31b,
+		       GFP_KERNEL);
+	if (ret) {
+		kfree(new_group);
+		return ret;
+	}
+	return mgid;
+}
+
+/**
+ * memory_group_register_static() - Register a static memory group.
+ * @nid: The node id.
+ * @max_pages: The maximum number of pages we'll have in this static memory
+ *	       group.
+ *
+ * Register a new static memory group and return the memory group id.
+ * All memory in the group belongs to a single unit, such as a DIMM. All
+ * memory belonging to a static memory group is added in one go to be removed
+ * in one go -- it's static.
+ *
+ * Returns an error if out of memory, if the node id is invalid, if no new
+ * memory groups can be registered, or if max_pages is invalid (0). Otherwise,
+ * returns the new memory group id.
+ */
+int memory_group_register_static(int nid, unsigned long max_pages)
+{
+	struct memory_group group = {
+		.nid = nid,
+		.s = {
+			.max_pages = max_pages,
+		},
+	};
+
+	if (!max_pages)
+		return -EINVAL;
+	return memory_group_register(group);
+}
+EXPORT_SYMBOL_GPL(memory_group_register_static);
+
+/**
+ * memory_group_register_dynamic() - Register a dynamic memory group.
+ * @nid: The node id.
+ * @unit_pages: Unit in pages in which is memory added/removed in this dynamic
+ *		memory group.
+ *
+ * Register a new dynamic memory group and return the memory group id.
+ * Memory within a dynamic memory group is added/removed dynamically
+ * in unit_pages.
+ *
+ * Returns an error if out of memory, if the node id is invalid, if no new
+ * memory groups can be registered, or if unit_pages is invalid (0, not a
+ * power of two, smaller than a single memory block). Otherwise, returns the
+ * new memory group id.
+ */
+int memory_group_register_dynamic(int nid, unsigned long unit_pages)
+{
+	struct memory_group group = {
+		.nid = nid,
+		.is_dynamic = true,
+		.d = {
+			.unit_pages = unit_pages,
+		},
+	};
+
+	if (!unit_pages || !is_power_of_2(unit_pages) ||
+	    unit_pages < PHYS_PFN(memory_block_size_bytes()))
+		return -EINVAL;
+	return memory_group_register(group);
+}
+EXPORT_SYMBOL_GPL(memory_group_register_dynamic);
+
+/**
+ * memory_group_unregister() - Unregister a memory group.
+ * @mgid: the memory group id
+ *
+ * Unregister a memory group. If any memory block still belongs to this
+ * memory group, unregistering will fail.
+ *
+ * Returns -EINVAL if the memory group id is invalid, returns -EBUSY if some
+ * memory blocks still belong to this memory group and returns 0 if
+ * unregistering succeeded.
+ */
+int memory_group_unregister(int mgid)
+{
+	struct memory_group *group;
+
+	if (mgid < 0)
+		return -EINVAL;
+
+	group = xa_load(&memory_groups, mgid);
+	if (!group)
+		return -EINVAL;
+	if (!list_empty(&group->memory_blocks))
+		return -EBUSY;
+	xa_erase(&memory_groups, mgid);
+	kfree(group);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(memory_group_unregister);
+
+/*
+ * This is an internal helper only to be used in core memory hotplug code to
+ * lookup a memory group. We don't care about locking, as we don't expect a
+ * memory group to get unregistered while adding memory to it -- because
+ * the group and the memory is managed by the same driver.
+ */
+struct memory_group *memory_group_find_by_id(int mgid)
+{
+	return xa_load(&memory_groups, mgid);
+}
--- a/include/linux/memory.h~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/include/linux/memory.h
@@ -23,6 +23,42 @@
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
+/**
+ * struct memory_group - a logical group of memory blocks
+ * @nid: The node id for all memory blocks inside the memory group.
+ * @blocks: List of all memory blocks belonging to this memory group.
+ * @is_dynamic: The memory group type: static vs. dynamic
+ * @s.max_pages: Valid with &memory_group.is_dynamic == false. The maximum
+ *		 number of pages we'll have in this static memory group.
+ * @d.unit_pages: Valid with &memory_group.is_dynamic == true. Unit in pages
+ *		  in which memory is added/removed in this dynamic memory group.
+ *		  This granularity defines the alignment of a unit in physical
+ *		  address space; it has to be at least as big as a single
+ *		  memory block.
+ *
+ * A memory group logically groups memory blocks; each memory block
+ * belongs to at most one memory group. A memory group corresponds to
+ * a memory device, such as a DIMM or a NUMA node, which spans multiple
+ * memory blocks and might even span multiple non-contiguous physical memory
+ * ranges.
+ *
+ * Modification of members after registration is serialized by memory
+ * hot(un)plug code.
+ */
+struct memory_group {
+	int nid;
+	struct list_head memory_blocks;
+	bool is_dynamic;
+	union {
+		struct {
+			unsigned long max_pages;
+		} s;
+		struct {
+			unsigned long unit_pages;
+		} d;
+	};
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
@@ -34,6 +70,8 @@ struct memory_block {
 	 * lay at the beginning of the memory block.
 	 */
 	unsigned long nr_vmemmap_pages;
+	struct memory_group *group;	/* group (if any) for this block */
+	struct list_head group_next;	/* next block inside memory group */
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
@@ -86,7 +124,8 @@ static inline int memory_notify(unsigned
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				unsigned long vmemmap_pages);
+				unsigned long vmemmap_pages,
+				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
@@ -96,6 +135,11 @@ extern int walk_memory_blocks(unsigned l
 			      void *arg, walk_memory_blocks_func_t func);
 extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
+
+extern int memory_group_register_static(int nid, unsigned long max_pages);
+extern int memory_group_register_dynamic(int nid, unsigned long unit_pages);
+extern int memory_group_unregister(int mgid);
+struct memory_group *memory_group_find_by_id(int mgid);
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
--- a/include/linux/memory_hotplug.h~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/include/linux/memory_hotplug.h
@@ -50,6 +50,11 @@ typedef int __bitwise mhp_t;
  * Only selected architectures support it with SPARSE_VMEMMAP.
  */
 #define MHP_MEMMAP_ON_MEMORY   ((__force mhp_t)BIT(1))
+/*
+ * The nid field specifies a memory group id (mgid) instead. The memory group
+ * implies the node id (nid).
+ */
+#define MHP_NID_IS_MGID		((__force mhp_t)BIT(2))
 
 /*
  * Extended parameters for memory hotplug:
--- a/mm/memory_hotplug.c~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/mm/memory_hotplug.c
@@ -1258,6 +1258,7 @@ int __ref add_memory_resource(int nid, s
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	struct vmem_altmap mhp_altmap = {};
+	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1269,6 +1270,13 @@ int __ref add_memory_resource(int nid, s
 	if (ret)
 		return ret;
 
+	if (mhp_flags & MHP_NID_IS_MGID) {
+		group = memory_group_find_by_id(nid);
+		if (!group)
+			return -EINVAL;
+		nid = group->nid;
+	}
+
 	if (!node_possible(nid)) {
 		WARN(1, "node %d was absent from the node_possible_map\n", nid);
 		return -EINVAL;
@@ -1303,7 +1311,8 @@ int __ref add_memory_resource(int nid, s
 		goto error;
 
 	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, mhp_altmap.alloc);
+	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
+					  group);
 	if (ret) {
 		arch_remove_memory(start, size, NULL);
 		goto error;
_
