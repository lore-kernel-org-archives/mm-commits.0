Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A2128467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126231; cv=none; b=NWP6lRUyhnNfx07G96Tn7GNu5hgMwzjSlSEEKTQ8c3HBLOQWKkVd0FIZzARQtPuWvZh1bVdR3hOpzX2gyWSN43ckndonSlYH7wbR8xnxdI1M1VYaclrZxncnoQsQsjiNdxosgIC8V9yXxuOPbALtlFgm0WuR4OPySjI1C1Aeuz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126231; c=relaxed/simple;
	bh=pS68Ya1mYx3b2+NXSa6C599x5f7h2u6sFq8lfYtQK/s=;
	h=Date:To:From:Subject:Message-Id; b=uWZYdJh1CSVEWwTuozgvMzC+cF1yKlfqmQf4FOzfw74U15zQR7VEjIyDG+848RSw3kA8qh7r8CCxPiXrBDl5Bt9FUn8NF8vKob3BYXOROTAO6igNoAZmJhPSqp6t6ZxEe14S59R/HkPxYcCRzAUELcdIwQIrckOCnPfFiH4seew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPft0M3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPft0M3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445CBC4CEE3;
	Thu, 10 Jul 2025 05:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126231;
	bh=pS68Ya1mYx3b2+NXSa6C599x5f7h2u6sFq8lfYtQK/s=;
	h=Date:To:From:Subject:From;
	b=pPft0M3GI2XuxQ+LlvWiZwifEyE44A+3p9Ff/vTbrfl+zb5Oq7aEbtH2BsDnL9HPP
	 0M0366jrpYFpswA2f3kHo+3APLJJWm+vssUqqVGt7GT0OXl5hTsyJgHlWDWmkdv21O
	 W/zjWyKvGnoQN8Te5dajN9hpoJDROE7e9Pr8EV9M=
Date: Wed, 09 Jul 2025 22:43:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch removed from -mm tree
Message-Id: <20250710054351.445CBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: optimize memory block registration to reduce boot time
has been removed from the -mm tree.  Its filename was
     drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: optimize memory block registration to reduce boot time
Date: Wed, 28 May 2025 12:18:00 -0500

Patch series "drivers/base/node.c: optimization and cleanups", v7.


This patch (of 7)

During node device initialization, `memory blocks` are registered under
each NUMA node.  The `memory blocks` to be registered are identified using
the node's start and end PFNs, which are obtained from the node's pg_data

However, not all PFNs within this range necessarily belong to the same
node—some may belong to other nodes.  Additionally, due to the
discontiguous nature of physical memory, certain sections within a `memory
block` may be absent.

As a result, `memory blocks` that fall between a node's start and end PFNs
may span across multiple nodes, and some sections within those blocks may
be missing.  `Memory blocks` have a fixed size, which is architecture
dependent.

Due to these considerations, the memory block registration is currently
performed as follows:

for_each_online_node(nid):
    start_pfn = pgdat->node_start_pfn;
    end_pfn = pgdat->node_start_pfn + node_spanned_pages;
    for_each_memory_block_between(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn))
        mem_blk = memory_block_id(pfn_to_section_nr(pfn));
        pfn_mb_start=section_nr_to_pfn(mem_blk->start_section_nr)
        pfn_mb_end = pfn_start + memory_block_pfns - 1
        for (pfn = pfn_mb_start; pfn < pfn_mb_end; pfn++):
            if (get_nid_for_pfn(pfn) != nid):
                continue;
            else
                do_register_memory_block_under_node(nid, mem_blk,
                                                        MEMINIT_EARLY);

Here, we derive the start and end PFNs from the node's pg_data, then
determine the memory blocks that may belong to the node.  For each `memory
block` in this range, we inspect all PFNs it contains and check their
associated NUMA node ID.  If a PFN within the block matches the current
node, the memory block is registered under that node.

If CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, get_nid_for_pfn() performs
a binary search in the `memblock regions` to determine the NUMA node ID
for a given PFN.  If it is not enabled, the node ID is retrieved directly
from the struct page.

On large systems, this process can become time-consuming, especially since
we iterate over each `memory block` and all PFNs within it until a match
is found.  When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, the
additional overhead of the binary search increases the execution time
significantly, potentially leading to soft lockups during boot.

In this patch, we iterate over `memblock region` to identify the `memory
blocks` that belong to the current NUMA node.  `memblock regions` are
contiguous memory ranges, each associated with a single NUMA node, and
they do not span across multiple nodes.

for_each_memory_region(r): // r => region
  if (!node_online(r->nid)):
    continue;
  else
    for_each_memory_block_between(r->base, r->base + r->size - 1):
      do_register_memory_block_under_node(r->nid, mem_blk, MEMINIT_EARLY);

We iterate over all memblock regions, and if the node associated with the
region is online, we calculate the start and end memory blocks based on
the region's start and end PFNs.  We then register all the memory blocks
within that range under the region node.

Test Results on My system with 32TB RAM
=======================================
1. Boot time with CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled.

Without this patch
------------------
Startup finished in 1min 16.528s (kernel)

With this patch
---------------
Startup finished in 17.236s (kernel) - 78% Improvement

2. Boot time with CONFIG_DEFERRED_STRUCT_PAGE_INIT disabled.

Without this patch
------------------
Startup finished in 28.320s (kernel)

With this patch
---------------
Startup finished in 15.621s (kernel) - 46% Improvement

[donettom@linux.ibm.com: restore removed extra line]
  Link: https://lkml.kernel.org/r/20250609140354.467908-1-donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/2a0a05c2dffc62a742bf1dd030098be4ce99be28.1748452241.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/2a0a05c2dffc62a742bf1dd030098be4ce99be28.1748452241.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   21 ++++-----------------
 drivers/base/node.c    |   35 +++++++++++++++++++++++++++++++++--
 include/linux/memory.h |   18 ++++++++++++++++++
 include/linux/node.h   |    3 +++
 4 files changed, 58 insertions(+), 19 deletions(-)

--- a/drivers/base/memory.c~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time
+++ a/drivers/base/memory.c
@@ -22,6 +22,7 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
+#include <linux/export.h>
 
 #include <linux/atomic.h>
 #include <linux/uaccess.h>
@@ -48,22 +49,8 @@ int mhp_online_type_from_str(const char
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
-static int sections_per_block;
-
-static inline unsigned long memory_block_id(unsigned long section_nr)
-{
-	return section_nr / sections_per_block;
-}
-
-static inline unsigned long pfn_to_block_id(unsigned long pfn)
-{
-	return memory_block_id(pfn_to_section_nr(pfn));
-}
-
-static inline unsigned long phys_to_block_id(unsigned long phys)
-{
-	return pfn_to_block_id(PFN_DOWN(phys));
-}
+int sections_per_block;
+EXPORT_SYMBOL(sections_per_block);
 
 static int memory_subsys_online(struct device *dev);
 static int memory_subsys_offline(struct device *dev);
@@ -683,7 +670,7 @@ int __weak arch_get_memory_phys_device(u
  *
  * Called under device_hotplug_lock.
  */
-static struct memory_block *find_memory_block_by_id(unsigned long block_id)
+struct memory_block *find_memory_block_by_id(unsigned long block_id)
 {
 	struct memory_block *mem;
 
--- a/drivers/base/node.c~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time
+++ a/drivers/base/node.c
@@ -21,6 +21,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/memblock.h>
 
 static const struct bus_type node_subsys = {
 	.name = "node",
@@ -859,6 +860,34 @@ void unregister_memory_block_under_nodes
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
+/* register all memory blocks under the corresponding nodes */
+static void register_memory_blocks_under_nodes(void)
+{
+	struct memblock_region *r;
+
+	for_each_mem_region(r) {
+		const unsigned long start_block_id = phys_to_block_id(r->base);
+		const unsigned long end_block_id = phys_to_block_id(r->base + r->size - 1);
+		const int nid = memblock_get_region_node(r);
+		unsigned long block_id;
+
+		if (!node_online(nid))
+			continue;
+
+		for (block_id = start_block_id; block_id <= end_block_id; block_id++) {
+			struct memory_block *mem;
+
+			mem = find_memory_block_by_id(block_id);
+			if (!mem)
+				continue;
+
+			do_register_memory_block_under_node(nid, mem, MEMINIT_EARLY);
+			put_device(&mem->dev);
+		}
+
+	}
+}
+
 void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
 				       unsigned long end_pfn,
 				       enum meminit_context context)
@@ -980,11 +1009,13 @@ void __init node_dev_init(void)
 
 	/*
 	 * Create all node devices, which will properly link the node
-	 * to applicable memory block devices and already created cpu devices.
+	 * to already created cpu devices.
 	 */
 	for_each_online_node(i) {
-		ret = register_one_node(i);
+		ret =  __register_one_node(i);
 		if (ret)
 			panic("%s() failed to add node: %d\n", __func__, ret);
 	}
+
+	register_memory_blocks_under_nodes();
 }
--- a/include/linux/memory.h~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time
+++ a/include/linux/memory.h
@@ -179,12 +179,30 @@ struct memory_group *memory_group_find_b
 typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
 int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 			       struct memory_group *excluded, void *arg);
+struct memory_block *find_memory_block_by_id(unsigned long block_id);
 #define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };\
 	register_memory_notifier(&fn##_mem_nb);			\
 })
 
+extern int sections_per_block;
+
+static inline unsigned long memory_block_id(unsigned long section_nr)
+{
+	return section_nr / sections_per_block;
+}
+
+static inline unsigned long pfn_to_block_id(unsigned long pfn)
+{
+	return memory_block_id(pfn_to_section_nr(pfn));
+}
+
+static inline unsigned long phys_to_block_id(unsigned long phys)
+{
+	return pfn_to_block_id(PFN_DOWN(phys));
+}
+
 #ifdef CONFIG_NUMA
 void memory_block_add_nid(struct memory_block *mem, int nid,
 			  enum meminit_context context);
--- a/include/linux/node.h~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time
+++ a/include/linux/node.h
@@ -120,6 +120,9 @@ static inline void register_memory_block
 						     enum meminit_context context)
 {
 }
+static inline void register_memory_blocks_under_nodes(void)
+{
+}
 #endif
 
 extern void unregister_node(struct node *node);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


