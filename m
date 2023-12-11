Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC4C23B8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LD9bach/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C60C433C7;
	Mon, 11 Dec 2023 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256043;
	bh=Q69intSTbeG/shLjHWFcYk3zC3+rgpxFjT6fc/VSuiY=;
	h=Date:To:From:Subject:From;
	b=LD9bach/M7dCsQczEAZZebW2jxhPu+7ZLkGNprWpxhzakWRk7J6CPF0REkJLvU1Mv
	 eXN14OmdekQFVufWAJNn4acnib1w4hei5OfO0kujN1rqbAdrf/Dhh9uuYiopQMp4dZ
	 1xfs9PLQRYwDIZRvRh/SKdTdy0/zwZn8LGVMdluI=
Date: Sun, 10 Dec 2023 16:54:03 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,osalvador@suse.de,mhocko@suse.com,Jonathan.Cameron@huawei.com,jmoyer@redhat.com,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@linux.ibm.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-split-memmap_on_memory-requests-across-memblocks.patch removed from -mm tree
Message-Id: <20231211005403.B6C60C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: split memmap_on_memory requests across memblocks
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-split-memmap_on_memory-requests-across-memblocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: split memmap_on_memory requests across memblocks
Date: Tue, 07 Nov 2023 00:22:42 -0700

The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is restricted to
'memblock_size' chunks of memory being added.  Adding a larger span of
memory precludes memmap_on_memory semantics.

For users of hotplug such as kmem, large amounts of memory might get added
from the CXL subsystem.  In some cases, this amount may exceed the
available 'main memory' to store the memmap for the memory being added. 
In this case, it is useful to have a way to place the memmap on the memory
being added, even if it means splitting the addition into memblock-sized
chunks.

Change add_memory_resource() to loop over memblock-sized chunks of memory
if caller requested memmap_on_memory, and if other conditions for it are
met.  Teach try_remove_memory() to also expect that a memory range being
removed might have been split up into memblock sized chunks, and to loop
through those as needed.

This does preclude being able to use PUD mappings in the direct map; a
proposal to how this could be optimized in the future is laid out here[1].

[1]: https://lore.kernel.org/linux-mm/b6753402-2de9-25b2-36e9-eacd49752b19@redhat.com/

Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-2-1253ec050ed0@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Fan Ni <fan.ni@samsung.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |  212 ++++++++++++++++++++++++++----------------
 1 file changed, 136 insertions(+), 76 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-split-memmap_on_memory-requests-across-memblocks
+++ a/mm/memory_hotplug.c
@@ -1380,6 +1380,85 @@ static bool mhp_supports_memmap_on_memor
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
 
+static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
+{
+	unsigned long memblock_size = memory_block_size_bytes();
+	u64 cur_start;
+
+	/*
+	 * For memmap_on_memory, the altmaps were added on a per-memblock
+	 * basis; we have to process each individual memory block.
+	 */
+	for (cur_start = start; cur_start < start + size;
+	     cur_start += memblock_size) {
+		struct vmem_altmap *altmap = NULL;
+		struct memory_block *mem;
+
+		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
+		if (WARN_ON_ONCE(!mem))
+			continue;
+
+		altmap = mem->altmap;
+		mem->altmap = NULL;
+
+		remove_memory_block_devices(cur_start, memblock_size);
+
+		arch_remove_memory(cur_start, memblock_size, altmap);
+
+		/* Verify that all vmemmap pages have actually been freed. */
+		WARN(altmap->alloc, "Altmap not fully unmapped");
+		kfree(altmap);
+	}
+}
+
+static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
+					    u64 start, u64 size)
+{
+	unsigned long memblock_size = memory_block_size_bytes();
+	u64 cur_start;
+	int ret;
+
+	for (cur_start = start; cur_start < start + size;
+	     cur_start += memblock_size) {
+		struct mhp_params params = { .pgprot =
+						     pgprot_mhp(PAGE_KERNEL) };
+		struct vmem_altmap mhp_altmap = {
+			.base_pfn = PHYS_PFN(cur_start),
+			.end_pfn = PHYS_PFN(cur_start + memblock_size - 1),
+		};
+
+		mhp_altmap.free = memory_block_memmap_on_memory_pages();
+		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
+					GFP_KERNEL);
+		if (!params.altmap) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/* call arch's memory hotadd */
+		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
+		if (ret < 0) {
+			kfree(params.altmap);
+			goto out;
+		}
+
+		/* create memory block devices after memory was added */
+		ret = create_memory_block_devices(cur_start, memblock_size,
+						  params.altmap, group);
+		if (ret) {
+			arch_remove_memory(cur_start, memblock_size, NULL);
+			kfree(params.altmap);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	if (ret && cur_start != start)
+		remove_memory_blocks_and_altmaps(start, cur_start - start);
+	return ret;
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1390,10 +1469,6 @@ int __ref add_memory_resource(int nid, s
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
-	struct vmem_altmap mhp_altmap = {
-		.base_pfn =  PHYS_PFN(res->start),
-		.end_pfn  =  PHYS_PFN(res->end),
-	};
 	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
@@ -1436,30 +1511,22 @@ int __ref add_memory_resource(int nid, s
 	/*
 	 * Self hosted memmap array
 	 */
-	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
-		if (mhp_supports_memmap_on_memory(size)) {
-			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmemdup(&mhp_altmap,
-						sizeof(struct vmem_altmap),
-						GFP_KERNEL);
-			if (!params.altmap) {
-				ret = -ENOMEM;
-				goto error;
-			}
-		}
-		/* fallback to not using altmap  */
-	}
-
-	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, &params);
-	if (ret < 0)
-		goto error_free;
+	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
+	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
+		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
+		if (ret)
+			goto error;
+	} else {
+		ret = arch_add_memory(nid, start, size, &params);
+		if (ret < 0)
+			goto error;
 
-	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, params.altmap, group);
-	if (ret) {
-		arch_remove_memory(start, size, params.altmap);
-		goto error_free;
+		/* create memory block devices after memory was added */
+		ret = create_memory_block_devices(start, size, NULL, group);
+		if (ret) {
+			arch_remove_memory(start, size, params.altmap);
+			goto error;
+		}
 	}
 
 	if (new_node) {
@@ -1496,8 +1563,6 @@ int __ref add_memory_resource(int nid, s
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
-error_free:
-	kfree(params.altmap);
 error:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
@@ -2067,17 +2132,13 @@ static int check_memblock_offlined_cb(st
 	return 0;
 }
 
-static int test_has_altmap_cb(struct memory_block *mem, void *arg)
+static int count_memory_range_altmaps_cb(struct memory_block *mem, void *arg)
 {
-	struct memory_block **mem_ptr = (struct memory_block **)arg;
-	/*
-	 * return the memblock if we have altmap
-	 * and break callback.
-	 */
-	if (mem->altmap) {
-		*mem_ptr = mem;
-		return 1;
-	}
+	u64 *num_altmaps = (u64 *)arg;
+
+	if (mem->altmap)
+		*num_altmaps += 1;
+
 	return 0;
 }
 
@@ -2151,11 +2212,29 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
+static int memory_blocks_have_altmaps(u64 start, u64 size)
+{
+	u64 num_memblocks = size / memory_block_size_bytes();
+	u64 num_altmaps = 0;
+
+	if (!mhp_memmap_on_memory())
+		return 0;
+
+	walk_memory_blocks(start, size, &num_altmaps,
+			   count_memory_range_altmaps_cb);
+
+	if (num_altmaps == 0)
+		return 0;
+
+	if (WARN_ON_ONCE(num_memblocks != num_altmaps))
+		return -EINVAL;
+
+	return 1;
+}
+
 static int __ref try_remove_memory(u64 start, u64 size)
 {
-	struct memory_block *mem;
-	int rc = 0, nid = NUMA_NO_NODE;
-	struct vmem_altmap *altmap = NULL;
+	int rc, nid = NUMA_NO_NODE;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -2172,45 +2251,26 @@ static int __ref try_remove_memory(u64 s
 	if (rc)
 		return rc;
 
-	/*
-	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
-	 * the same granularity it was added - a single memory block.
-	 */
-	if (mhp_memmap_on_memory()) {
-		rc = walk_memory_blocks(start, size, &mem, test_has_altmap_cb);
-		if (rc) {
-			if (size != memory_block_size_bytes()) {
-				pr_warn("Refuse to remove %#llx - %#llx,"
-					"wrong granularity\n",
-					start, start + size);
-				return -EINVAL;
-			}
-			altmap = mem->altmap;
-			/*
-			 * Mark altmap NULL so that we can add a debug
-			 * check on memblock free.
-			 */
-			mem->altmap = NULL;
-		}
-	}
-
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
-	/*
-	 * Memory block device removal under the device_hotplug_lock is
-	 * a barrier against racing online attempts.
-	 */
-	remove_memory_block_devices(start, size);
-
 	mem_hotplug_begin();
 
-	arch_remove_memory(start, size, altmap);
-
-	/* Verify that all vmemmap pages have actually been freed. */
-	if (altmap) {
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
+	rc = memory_blocks_have_altmaps(start, size);
+	if (rc < 0) {
+		mem_hotplug_done();
+		return rc;
+	} else if (!rc) {
+		/*
+		 * Memory block device removal under the device_hotplug_lock is
+		 * a barrier against racing online attempts.
+		 * No altmaps present, do the removal directly
+		 */
+		remove_memory_block_devices(start, size);
+		arch_remove_memory(start, size, NULL);
+	} else {
+		/* all memblocks in the range have altmaps */
+		remove_memory_blocks_and_altmaps(start, size);
 	}
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


