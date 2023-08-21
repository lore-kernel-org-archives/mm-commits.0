Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499B5EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjHUUmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjHUUl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7E7E57
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E98B6156C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8769BC433C8;
        Mon, 21 Aug 2023 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650450;
        bh=+CtkOZ2mi9woUapo3WzQJDveaV9hTJdhHdESPA2VZ9Q=;
        h=Date:To:From:Subject:From;
        b=C4hRWm3/obCUnB2sKbCZNn+2GcbU6i7diDFllIzjDLMTlKgx+NR8t35OCKvCos+fy
         ecFPvrezrJiDpj/VTfM6iKIe8GehK71G2oonIDONYOzhI+3UgM6lihPq/FeUFdzIig
         I7i5rYbxpDNs09AcjCQQjUtdqoKcJ0rL2xP3DA4w=
Date:   Mon, 21 Aug 2023 13:40:50 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch removed from -mm tree
Message-Id: <20230821204050.8769BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: support memmap_on_memory when memmap is not aligned to pageblocks
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/memory_hotplug: support memmap_on_memory when memmap is not aligned to pageblocks
Date: Tue, 8 Aug 2023 14:44:59 +0530

Currently, memmap_on_memory feature is only supported with memory block
sizes that result in vmemmap pages covering full page blocks.  This is
because memory onlining/offlining code requires applicable ranges to be
pageblock-aligned, for example, to set the migratetypes properly.

This patch helps to lift that restriction by reserving more pages than
required for vmemmap space.  This helps the start address to be page block
aligned with different memory block sizes.  Using this facility implies
the kernel will be reserving some pages for every memoryblock.  This
allows the memmap on memory feature to be widely useful with different
memory block size values.

For ex: with 64K page size and 256MiB memory block size, we require 4
pages to map vmemmap pages, To align things correctly we end up adding a
reserve of 28 pages.  ie, for every 4096 pages 28 pages get reserved.

Link: https://lkml.kernel.org/r/20230808091501.287660-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |   12 +
 mm/memory_hotplug.c                             |  120 +++++++++++---
 2 files changed, 113 insertions(+), 19 deletions(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -433,6 +433,18 @@ The following module parameters are curr
 				 memory in a way that huge pages in bigger
 				 granularity cannot be formed on hotplugged
 				 memory.
+
+				 With value "force" it could result in memory
+				 wastage due to memmap size limitations. For
+				 example, if the memmap for a memory block
+				 requires 1 MiB, but the pageblock size is 2
+				 MiB, 1 MiB of hotplugged memory will be wasted.
+				 Note that there are still cases where the
+				 feature cannot be enforced: for example, if the
+				 memmap is smaller than a single page, or if the
+				 architecture does not support the forced mode
+				 in all configurations.
+
 ``online_policy``		 read-write: Set the basic policy used for
 				 automatic zone selection when onlining memory
 				 blocks without specifying a target zone.
--- a/mm/memory_hotplug.c~mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks
+++ a/mm/memory_hotplug.c
@@ -41,17 +41,83 @@
 #include "internal.h"
 #include "shuffle.h"
 
+enum {
+	MEMMAP_ON_MEMORY_DISABLE = 0,
+	MEMMAP_ON_MEMORY_ENABLE,
+	MEMMAP_ON_MEMORY_FORCE,
+};
+
+static int memmap_mode __read_mostly = MEMMAP_ON_MEMORY_DISABLE;
+
+static inline unsigned long memory_block_memmap_size(void)
+{
+	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
+}
+
+static inline unsigned long memory_block_memmap_on_memory_pages(void)
+{
+	unsigned long nr_pages = PFN_UP(memory_block_memmap_size());
+
+	/*
+	 * In "forced" memmap_on_memory mode, we add extra pages to align the
+	 * vmemmap size to cover full pageblocks. That way, we can add memory
+	 * even if the vmemmap size is not properly aligned, however, we might waste
+	 * memory.
+	 */
+	if (memmap_mode == MEMMAP_ON_MEMORY_FORCE)
+		return pageblock_align(nr_pages);
+	return nr_pages;
+}
+
 #ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
 /*
  * memory_hotplug.memmap_on_memory parameter
  */
-static bool memmap_on_memory __ro_after_init;
-module_param(memmap_on_memory, bool, 0444);
-MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
+static int set_memmap_mode(const char *val, const struct kernel_param *kp)
+{
+	int ret, mode;
+	bool enabled;
+
+	if (sysfs_streq(val, "force") ||  sysfs_streq(val, "FORCE")) {
+		mode = MEMMAP_ON_MEMORY_FORCE;
+	} else {
+		ret = kstrtobool(val, &enabled);
+		if (ret < 0)
+			return ret;
+		if (enabled)
+			mode = MEMMAP_ON_MEMORY_ENABLE;
+		else
+			mode = MEMMAP_ON_MEMORY_DISABLE;
+	}
+	*((int *)kp->arg) = mode;
+	if (mode == MEMMAP_ON_MEMORY_FORCE) {
+		unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
+
+		pr_info_once("Memory hotplug will waste %ld pages in each memory block\n",
+			     memmap_pages - PFN_UP(memory_block_memmap_size()));
+	}
+	return 0;
+}
+
+static int get_memmap_mode(char *buffer, const struct kernel_param *kp)
+{
+	if (*((int *)kp->arg) == MEMMAP_ON_MEMORY_FORCE)
+		return sprintf(buffer,  "force\n");
+	return param_get_bool(buffer, kp);
+}
+
+static const struct kernel_param_ops memmap_mode_ops = {
+	.set = set_memmap_mode,
+	.get = get_memmap_mode,
+};
+module_param_cb(memmap_on_memory, &memmap_mode_ops, &memmap_mode, 0444);
+MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug\n"
+		 "With value \"force\" it could result in memory wastage due "
+		 "to memmap size limitations (Y/N/force)");
 
 static inline bool mhp_memmap_on_memory(void)
 {
-	return memmap_on_memory;
+	return memmap_mode != MEMMAP_ON_MEMORY_DISABLE;
 }
 #else
 static inline bool mhp_memmap_on_memory(void)
@@ -1247,11 +1313,6 @@ static int online_memory_block(struct me
 	return device_online(&mem->dev);
 }
 
-static inline unsigned long memory_block_memmap_size(void)
-{
-	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
-}
-
 #ifndef arch_supports_memmap_on_memory
 static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 {
@@ -1267,7 +1328,7 @@ static inline bool arch_supports_memmap_
 static bool mhp_supports_memmap_on_memory(unsigned long size)
 {
 	unsigned long vmemmap_size = memory_block_memmap_size();
-	unsigned long remaining_size = size - vmemmap_size;
+	unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
 
 	/*
 	 * Besides having arch support and the feature enabled at runtime, we
@@ -1295,10 +1356,28 @@ static bool mhp_supports_memmap_on_memor
 	 *       altmap as an alternative source of memory, and we do not exactly
 	 *       populate a single PMD.
 	 */
-	return mhp_memmap_on_memory() &&
-	       size == memory_block_size_bytes() &&
-	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT)) &&
-	       arch_supports_memmap_on_memory(vmemmap_size);
+	if (!mhp_memmap_on_memory() || size != memory_block_size_bytes())
+		return false;
+
+	/*
+	 * Make sure the vmemmap allocation is fully contained
+	 * so that we always allocate vmemmap memory from altmap area.
+	 */
+	if (!IS_ALIGNED(vmemmap_size, PAGE_SIZE))
+		return false;
+
+	/*
+	 * start pfn should be pageblock_nr_pages aligned for correctly
+	 * setting migrate types
+	 */
+	if (!pageblock_aligned(memmap_pages))
+		return false;
+
+	if (memmap_pages == PHYS_PFN(memory_block_size_bytes()))
+		/* No effective hotplugged memory doesn't make sense. */
+		return false;
+
+	return arch_supports_memmap_on_memory(vmemmap_size);
 }
 
 /*
@@ -1311,7 +1390,10 @@ int __ref add_memory_resource(int nid, s
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
-	struct vmem_altmap mhp_altmap = {};
+	struct vmem_altmap mhp_altmap = {
+		.base_pfn =  PHYS_PFN(res->start),
+		.end_pfn  =  PHYS_PFN(res->end),
+	};
 	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
@@ -1356,8 +1438,7 @@ int __ref add_memory_resource(int nid, s
 	 */
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
 		if (mhp_supports_memmap_on_memory(size)) {
-			mhp_altmap.free = PHYS_PFN(size);
-			mhp_altmap.base_pfn = PHYS_PFN(start);
+			mhp_altmap.free = memory_block_memmap_on_memory_pages();
 			params.altmap = &mhp_altmap;
 		}
 		/* fallback to not using altmap  */
@@ -1369,8 +1450,7 @@ int __ref add_memory_resource(int nid, s
 		goto error;
 
 	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
-					  group);
+	ret = create_memory_block_devices(start, size, mhp_altmap.free, group);
 	if (ret) {
 		arch_remove_memory(start, size, NULL);
 		goto error;
@@ -2096,6 +2176,8 @@ static int __ref try_remove_memory(u64 s
 			 * right thing if we used vmem_altmap when hot-adding
 			 * the range.
 			 */
+			mhp_altmap.base_pfn = PHYS_PFN(start);
+			mhp_altmap.free = nr_vmemmap_pages;
 			mhp_altmap.alloc = nr_vmemmap_pages;
 			altmap = &mhp_altmap;
 		}
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


