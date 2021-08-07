Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E42C4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C103261042
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHGTNn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGTNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829C460F14;
        Sat,  7 Aug 2021 19:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363605;
        bh=/CmwGA/sZ8btgaU2wKmPNeLotgdp0rs7lcS2DaFnE2g=;
        h=Date:From:To:Subject:From;
        b=zq7qSq7OpqBdg+lf+BJPPzRsyzL56QYh1yqT8B+5jtXNwWujZPUDVxtPVbB+rHh4Q
         rL356IHYfb55f5KjgN2HtO8G5P6ldsC8+vcW/sOdVCLjAI9+DC8I4HQ8o1ZL+iAFJW
         belvJ+TSCr8vXpHJTUm+QXgXY0vISaaLTZsh74qk=
Date:   Sat, 07 Aug 2021 12:13:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vkuznets@redhat.com, vbabka@suse.cz,
        teawater@gmail.com, rppt@kernel.org, rjw@rjwysocki.net,
        richard.weiyang@linux.alibaba.com, rafael.j.wysocki@intel.com,
        pasha.tatashin@soleen.com, pankaj.gupta.linux@gmail.com,
        osalvador@suse.de, mst@redhat.com, mkedzier@redhat.com,
        mhocko@kernel.org, lenb@kernel.org, jasowang@redhat.com,
        gregkh@linuxfoundation.org, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, anshuman.khandual@arm.com,
        david@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?drivers-base-memory-introduce-memory-groups-to-logically-g?=
 =?us-ascii?Q?roup-memory-blocks.patch?= removed from -mm tree
Message-ID: <20210807191325.qzsAs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: introduce "memory groups" to logically group memory blocks
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

1) Static memory group: E.g., a single ACPI memory device, consisting of
   1..X memory resources. A memory group consists of 1..Y memory blocks.
   The whole group is added/removed in one go. If any part cannot get
   offlined, the whole group cannot be removed.

2) Dynamic memory group: E.g., a single virtio-mem device. Memory is
   dynamically added/removed in a fixed granularity, called a "unit",
   consisting of 1..X memory blocks. A unit is added/removed in one go.
   If any part of a unit cannot get offlined, the whole unit cannot be
   removed.

In case of 1) we usually want either all memory managed by ZONE_MOVABLE or
none.  In case of 2) we usually want to have as many units as possible
managed by ZONE_MOVABLE.  We want a single unit to be of the same type.

For now, memory groups are an internal concept that is not exposed to user
space; we might want to change that in the future, though.

add_memory() users can specify a mgid instead of a nid when passing the
MHP_NID_IS_MGID flag.

Link: https://lkml.kernel.org/r/20210723125210.29987-4-david@redhat.com
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

 drivers/base/memory.c          |  102 +++++++++++++++++++++++++++++--
 include/linux/memory.h         |   46 +++++++++++++
 include/linux/memory_hotplug.h |    6 +
 mm/memory_hotplug.c            |   11 +++
 4 files changed, 158 insertions(+), 7 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/drivers/base/memory.c
@@ -82,6 +82,11 @@ static struct bus_type memory_subsys = {
  */
 static DEFINE_XARRAY(memory_blocks);
 
+/*
+ * Memory groups, indexed by memory group identification (mgid).
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
@@ -653,6 +659,11 @@ static int init_memory_block(unsigned lo
 	mem->nid = NUMA_NO_NODE;
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 
+	if (group) {
+		mem->group = group;
+		refcount_inc(&group->refcount);
+	}
+
 	ret = register_memory(mem);
 
 	return ret;
@@ -671,7 +682,7 @@ static int add_memory_block(unsigned lon
 	if (section_count == 0)
 		return 0;
 	return init_memory_block(memory_block_id(base_section_nr),
-				 MEM_ONLINE, 0);
+				 MEM_ONLINE, 0,  NULL);
 }
 
 static void unregister_memory(struct memory_block *memory)
@@ -681,6 +692,11 @@ static void unregister_memory(struct mem
 
 	WARN_ON(xa_erase(&memory_blocks, memory->dev.id) == NULL);
 
+	if (memory->group) {
+		refcount_dec(&memory->group->refcount);
+		memory->group = NULL;
+	}
+
 	/* drop the ref. we got via find_memory_block() */
 	put_device(&memory->dev);
 	device_unregister(&memory->dev);
@@ -694,7 +710,8 @@ static void unregister_memory(struct mem
  * Called under device_hotplug_lock.
  */
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				unsigned long vmemmap_pages)
+				unsigned long vmemmap_pages,
+				struct memory_group *group)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
 	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
@@ -707,7 +724,8 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages);
+		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages,
+					group);
 		if (ret)
 			break;
 	}
@@ -891,3 +909,79 @@ int for_each_memory_block(void *arg, wal
 	return bus_for_each_dev(&memory_subsys, NULL, &cb_data,
 				for_each_memory_block_cb);
 }
+
+static int register_memory_group(struct memory_group group)
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
+	refcount_set(&new_group->refcount, 1);
+
+	ret = xa_alloc(&memory_groups, &mgid, new_group, xa_limit_31b,
+		       GFP_KERNEL);
+	if (ret)
+		kfree(new_group);
+	return ret ? ret : mgid;
+}
+
+int register_static_memory_group(int nid, unsigned long max_pages)
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
+	return register_memory_group(group);
+}
+EXPORT_SYMBOL_GPL(register_static_memory_group);
+
+int register_dynamic_memory_group(int nid, unsigned long unit_pages)
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
+	return register_memory_group(group);
+}
+EXPORT_SYMBOL_GPL(register_dynamic_memory_group);
+
+int unregister_memory_group(int mgid)
+{
+	struct memory_group *group;
+
+	if (mgid < 0)
+		return -EINVAL;
+
+	group = xa_load(&memory_groups, mgid);
+	if (!group || refcount_read(&group->refcount) > 1)
+		return -EINVAL;
+
+	xa_erase(&memory_groups, mgid);
+	kfree(group);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(unregister_memory_group);
+
+struct memory_group *get_memory_group(int mgid)
+{
+	return xa_load(&memory_groups, mgid);
+}
--- a/include/linux/memory.h~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/include/linux/memory.h
@@ -23,6 +23,42 @@
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
+struct memory_group {
+	/* Nid the whole group belongs to. */
+	int nid;
+	/* References from memory blocks + 1. */
+	refcount_t refcount;
+	/*
+	 * Memory group type: static vs. dynamic.
+	 *
+	 * Static: All memory in the group belongs to a single unit, such as,
+	 * a DIMM. All memory belonging to the group will be added in
+	 * one go and removed in one go -- it's static.
+	 *
+	 * Dynamic: Memory within the group is added/removed dynamically in
+	 * units of the specified granularity of at least one memory block.
+	 */
+	bool is_dynamic;
+
+	union {
+		struct {
+			/*
+			 * Maximum number of pages we'll have in this static
+			 * memory group.
+			 */
+			unsigned long max_pages;
+		} s;
+		struct {
+			/*
+			 * Unit in pages in which memory is added/removed in
+			 * this dynamic memory group. This granularity defines
+			 * the alignment of a unit in physical address space.
+			 */
+			unsigned long unit_pages;
+		} d;
+	};
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
@@ -34,6 +70,7 @@ struct memory_block {
 	 * lay at the beginning of the memory block.
 	 */
 	unsigned long nr_vmemmap_pages;
+	struct memory_group *group;	/* group (if any) for this block */
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
@@ -86,7 +123,8 @@ static inline int memory_notify(unsigned
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				unsigned long vmemmap_pages);
+				unsigned long vmemmap_pages,
+				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
@@ -95,6 +133,12 @@ typedef int (*walk_memory_blocks_func_t)
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
 extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
+
+extern int register_static_memory_group(int nid, unsigned long max_pages);
+extern int register_dynamic_memory_group(int nid, unsigned long unit_pages);
+extern int unregister_memory_group(int mgid);
+struct memory_group *get_memory_group(int mgid);
+
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
--- a/include/linux/memory_hotplug.h~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/include/linux/memory_hotplug.h
@@ -42,7 +42,6 @@ typedef int __bitwise mhp_t;
  * might be stale, or the resource might have changed.
  */
 #define MHP_MERGE_RESOURCE	((__force mhp_t)BIT(0))
-
 /*
  * We want memmap (struct page array) to be self contained.
  * To do so, we will use the beginning of the hot-added range to build
@@ -50,6 +49,11 @@ typedef int __bitwise mhp_t;
  * Only selected architectures support it with SPARSE_VMEMMAP.
  */
 #define MHP_MEMMAP_ON_MEMORY   ((__force mhp_t)BIT(1))
+/*
+ * The nid field specifies a memory group identifier (mgid) instead. The memory
+ * group implies the nid.
+ */
+#define MHP_NID_IS_MGID		((__force mhp_t)BIT(2))
 
 /*
  * Extended parameters for memory hotplug:
--- a/mm/memory_hotplug.c~drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks
+++ a/mm/memory_hotplug.c
@@ -1256,6 +1256,7 @@ int __ref add_memory_resource(int nid, s
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	struct vmem_altmap mhp_altmap = {};
+	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1267,6 +1268,13 @@ int __ref add_memory_resource(int nid, s
 	if (ret)
 		return ret;
 
+	if (mhp_flags & MHP_NID_IS_MGID) {
+		group = get_memory_group(nid);
+		if (!group)
+			return -EINVAL;
+		nid = group->nid;
+	}
+
 	if (!node_possible(nid)) {
 		WARN(1, "node %d was absent from the node_possible_map\n", nid);
 		return -EINVAL;
@@ -1301,7 +1309,8 @@ int __ref add_memory_resource(int nid, s
 		goto error;
 
 	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, mhp_altmap.alloc);
+	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
+					  group);
 	if (ret) {
 		arch_remove_memory(start, size, NULL);
 		goto error;
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-memory_hotplug-track-present-pages-in-memory-groups.patch
acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch

