Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3274833E7
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 00:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746319853; cv=none; b=g0zU/riC0GxLXMyPO670b7NsN2C6jCPnXsH7BShyZzdJVBPi2pKwAvKsQOKqtLmK9wLIV85yO1jAJJL/7eIO4X1v+i3yyKUFw8FQujNpZS12LVGhIi8wkgv/DLpjVXs+6IpkPN7FCZZDBZCKE34soXNd8deiKlXWO9wceeMK7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746319853; c=relaxed/simple;
	bh=E4srZPpjBwcwa8qhUqm3Lp+PCyVxnLEOVStLNgD6icY=;
	h=Date:To:From:Subject:Message-Id; b=NeT81usDaiMhQQXIJKcwGjPmBziCDr8gtA1scVRnOGJwv0/YmN12AXTLGPEIA0YpAR41Dk8GsbpMI9ButwWL5l+ld9dQuoD+aKJ52/RreTapBcHEycCTfis41ISgcQzoEBeQFwas8urVzbF7yiDTSxDoSEuG+HL8K1hnyJu1DG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnA60Fsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnA60Fsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D792C4CEE3;
	Sun,  4 May 2025 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746319852;
	bh=E4srZPpjBwcwa8qhUqm3Lp+PCyVxnLEOVStLNgD6icY=;
	h=Date:To:From:Subject:From;
	b=KnA60FsfatyI+rT9zv4cYQ8j0X2NLOYlKA5iGuo03v4PML/ot4bF16A35lHYza+Jt
	 XJDSv+uo24ZA+8U3oLi/Z+nBHkHmOHGbxPxAAxwK471LnBQAj7yjRKDXMaKNQWl6RT
	 5EGIDq7Nw6PvtJAI57REbC+SfhNm21h6DjXzvwic=
Date: Sat, 03 May 2025 17:50:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch added to mm-new branch
Message-Id: <20250504005052.4D792C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: driver/base: optimize memory block registration to reduce boot time
has been added to the -mm mm-new branch.  Its filename is
     driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: driver/base: optimize memory block registration to reduce boot time
Date: Sat, 3 May 2025 11:10:12 +0530

Patch series "driver/base: Optimize memory block registration to reduce
boot time", v3.


This patch (of 3):

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

for_each_online_node(nid):
  for_each_memory_region(r): // r => region
    if (r->nid != nid):
      continue;
    else
      for_each_memory_block_between(r->base, r->base + r->size - 1):
        do_register_memory_block_under_node(nid, mem_blk, MEMINIT_EARLY);

We iterate over all `memblock regions` and identify those that belong to
the current NUMA node.  For each `memblock region` associated with the
current node, we calculate the start and end `memory blocks` based on the
region's start and end PFNs.  We then register all `memory blocks` within
that range under the current node.

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

Link: https://lkml.kernel.org/r/b49ed289096643ff5b5fbedcf1d1c1be42845a74.1746250339.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/b49ed289096643ff5b5fbedcf1d1c1be42845a74.1746250339.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    4 ++--
 drivers/base/node.c    |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |    2 ++
 include/linux/node.h   |   11 +++++------
 4 files changed, 47 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~driver-base-optimize-memory-block-registration-to-reduce-boot-time
+++ a/drivers/base/memory.c
@@ -60,7 +60,7 @@ static inline unsigned long pfn_to_block
 	return memory_block_id(pfn_to_section_nr(pfn));
 }
 
-static inline unsigned long phys_to_block_id(unsigned long phys)
+unsigned long phys_to_block_id(unsigned long phys)
 {
 	return pfn_to_block_id(PFN_DOWN(phys));
 }
@@ -683,7 +683,7 @@ int __weak arch_get_memory_phys_device(u
  *
  * Called under device_hotplug_lock.
  */
-static struct memory_block *find_memory_block_by_id(unsigned long block_id)
+struct memory_block *find_memory_block_by_id(unsigned long block_id)
 {
 	struct memory_block *mem;
 
--- a/drivers/base/node.c~driver-base-optimize-memory-block-registration-to-reduce-boot-time
+++ a/drivers/base/node.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/memblock.h>
 
 static const struct bus_type node_subsys = {
 	.name = "node",
@@ -850,6 +851,43 @@ void unregister_memory_block_under_nodes
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
+/*
+ * register_memory_blocks_under_node_early : Register the memory
+ *		  blocks under the current node.
+ * @nid : Current node under registration
+ *
+ * This function iterates over all memblock regions and identifies the regions
+ * that belong to the current node. For each region which belongs to current
+ * node, it calculates the start and end memory blocks based on the region's
+ * start and end PFNs. It then registers all memory blocks within that range
+ * under the current node.
+ */
+void register_memory_blocks_under_node_early(int nid)
+{
+	struct memblock_region *r;
+
+	for_each_mem_region(r) {
+		if (r->nid != nid)
+			continue;
+
+		const unsigned long start_block_id = phys_to_block_id(r->base);
+		const unsigned long end_block_id = phys_to_block_id(r->base + r->size - 1);
+		unsigned long block_id;
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
--- a/include/linux/memory.h~driver-base-optimize-memory-block-registration-to-reduce-boot-time
+++ a/include/linux/memory.h
@@ -179,6 +179,8 @@ struct memory_group *memory_group_find_b
 typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
 int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 			       struct memory_group *excluded, void *arg);
+unsigned long phys_to_block_id(unsigned long phys);
+struct memory_block *find_memory_block_by_id(unsigned long block_id);
 #define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };\
--- a/include/linux/node.h~driver-base-optimize-memory-block-registration-to-reduce-boot-time
+++ a/include/linux/node.h
@@ -114,12 +114,16 @@ extern struct node *node_devices[];
 void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
 				       unsigned long end_pfn,
 				       enum meminit_context context);
+void register_memory_blocks_under_node_early(int nid);
 #else
 static inline void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
 						     unsigned long end_pfn,
 						     enum meminit_context context)
 {
 }
+static inline void register_memory_blocks_under_node_early(int nid)
+{
+}
 #endif
 
 extern void unregister_node(struct node *node);
@@ -134,15 +138,10 @@ static inline int register_one_node(int
 	int error = 0;
 
 	if (node_online(nid)) {
-		struct pglist_data *pgdat = NODE_DATA(nid);
-		unsigned long start_pfn = pgdat->node_start_pfn;
-		unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
-
 		error = __register_one_node(nid);
 		if (error)
 			return error;
-		register_memory_blocks_under_node(nid, start_pfn, end_pfn,
-						  MEMINIT_EARLY);
+		register_memory_blocks_under_node_early(nid);
 	}
 
 	return error;
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch
driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch
driver-base-remove-register_mem_block_under_node_early.patch
drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

