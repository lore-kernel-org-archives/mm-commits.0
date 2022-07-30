Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9192C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiG3BIc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiG3BIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D436D820D8
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93435B829FD
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C5CC433C1;
        Sat, 30 Jul 2022 01:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143301;
        bh=t1IuVB983e/KdnVxuWzi8r4RmwhL1kwt4AUjfUUOGro=;
        h=Date:To:From:Subject:From;
        b=sti42Yez0q5M33UMyVIsua4bmjPwy1/Z3j4EXIvlpuCizy7dxCdjjg32vwol16w2X
         7nrxmm+ZrPkCaTSn3qV0t7eSkNVEwg4cWQvx5LjSAKBEY365hwbqs3psP3MNBqbvkt
         /5NZnCZ79CZon5KUi52uV+r5bMANoIUihdXGEXDA=
Date:   Fri, 29 Jul 2022 18:08:20 -0700
To:     mm-commits@vger.kernel.org, xuqiang36@huawei.com, will@kernel.org,
        rppt@linux.ibm.com, darren@os.amperecomputing.com,
        anshuman.khandual@arm.com, zhouguanghui1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memblockarm64-expand-the-static-memblock-memory-table.patch removed from -mm tree
Message-Id: <20220730010821.46C5CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memblock,arm64: expand the static memblock memory table
has been removed from the -mm tree.  Its filename was
     memblockarm64-expand-the-static-memblock-memory-table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Subject: memblock,arm64: expand the static memblock memory table
Date: Wed, 15 Jun 2022 10:27:42 +0000

In a system(Huawei Ascend ARM64 SoC) using HBM, a multi-bit ECC error
occurs, and the BIOS will mark the corresponding area (for example, 2 MB)
as unusable.  When the system restarts next time, these areas are not
reported or reported as EFI_UNUSABLE_MEMORY.  Both cases lead to an
increase in the number of memblocks, whereas EFI_UNUSABLE_MEMORY leads to
a larger number of memblocks.

For example, if the EFI_UNUSABLE_MEMORY type is reported:
...
memory[0x92]    [0x0000200834a00000-0x0000200835bfffff], 0x0000000001200000 bytes on node 7 flags: 0x0
memory[0x93]    [0x0000200835c00000-0x0000200835dfffff], 0x0000000000200000 bytes on node 7 flags: 0x4
memory[0x94]    [0x0000200835e00000-0x00002008367fffff], 0x0000000000a00000 bytes on node 7 flags: 0x0
memory[0x95]    [0x0000200836800000-0x00002008369fffff], 0x0000000000200000 bytes on node 7 flags: 0x4
memory[0x96]    [0x0000200836a00000-0x0000200837bfffff], 0x0000000001200000 bytes on node 7 flags: 0x0
memory[0x97]    [0x0000200837c00000-0x0000200837dfffff], 0x0000000000200000 bytes on node 7 flags: 0x4
memory[0x98]    [0x0000200837e00000-0x000020087fffffff], 0x0000000048200000 bytes on node 7 flags: 0x0
memory[0x99]    [0x0000200880000000-0x0000200bcfffffff], 0x0000000350000000 bytes on node 6 flags: 0x0
memory[0x9a]    [0x0000200bd0000000-0x0000200bd01fffff], 0x0000000000200000 bytes on node 6 flags: 0x4
memory[0x9b]    [0x0000200bd0200000-0x0000200bd07fffff], 0x0000000000600000 bytes on node 6 flags: 0x0
memory[0x9c]    [0x0000200bd0800000-0x0000200bd09fffff], 0x0000000000200000 bytes on node 6 flags: 0x4
memory[0x9d]    [0x0000200bd0a00000-0x0000200fcfffffff], 0x00000003ff600000 bytes on node 6 flags: 0x0
memory[0x9e]    [0x0000200fd0000000-0x0000200fd01fffff], 0x0000000000200000 bytes on node 6 flags: 0x4
memory[0x9f]    [0x0000200fd0200000-0x0000200fffffffff], 0x000000002fe00000 bytes on node 6 flags: 0x0
...

The EFI memory map is parsed to construct the memblock arrays before the
memblock arrays can be resized.  As the result, memory regions beyond
INIT_MEMBLOCK_REGIONS are lost.

Add a new macro INIT_MEMBLOCK_MEMORY_REGIONS to replace
INIT_MEMBLOCK_REGTIONS to define the size of the static memblock.memory
array.

Allow overriding memblock.memory array size with architecture defined
INIT_MEMBLOCK_MEMORY_REGIONS and make arm64 to set
INIT_MEMBLOCK_MEMORY_REGIONS to 1024 when CONFIG_EFI is enabled.

Link: https://lkml.kernel.org/r/20220615102742.96450-1-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Darren Hart <darren@os.amperecomputing.com>
Acked-by: Will Deacon <will@kernel.org>		[arm64]
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Xu Qiang <xuqiang36@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |    9 +++++++++
 mm/memblock.c                   |   14 +++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/memory.h~memblockarm64-expand-the-static-memblock-memory-table
+++ a/arch/arm64/include/asm/memory.h
@@ -364,6 +364,15 @@ void dump_mem_limit(void);
 # define INIT_MEMBLOCK_RESERVED_REGIONS	(INIT_MEMBLOCK_REGIONS + NR_CPUS + 1)
 #endif
 
+/*
+ * memory regions which marked with flag MEMBLOCK_NOMAP(for example, the memory
+ * of the EFI_UNUSABLE_MEMORY type) may divide a continuous memory block into
+ * multiple parts. As a result, the number of memory regions is large.
+ */
+#ifdef CONFIG_EFI
+#define INIT_MEMBLOCK_MEMORY_REGIONS	(INIT_MEMBLOCK_REGIONS * 8)
+#endif
+
 #include <asm-generic/memory_model.h>
 
 #endif /* __ASM_MEMORY_H */
--- a/mm/memblock.c~memblockarm64-expand-the-static-memblock-memory-table
+++ a/mm/memblock.c
@@ -29,6 +29,10 @@
 # define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
 #endif
 
+#ifndef INIT_MEMBLOCK_MEMORY_REGIONS
+#define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
+#endif
+
 /**
  * DOC: memblock overview
  *
@@ -55,9 +59,9 @@
  * the allocator metadata. The "memory" and "reserved" types are nicely
  * wrapped with struct memblock. This structure is statically
  * initialized at build time. The region arrays are initially sized to
- * %INIT_MEMBLOCK_REGIONS for "memory" and %INIT_MEMBLOCK_RESERVED_REGIONS
- * for "reserved". The region array for "physmem" is initially sized to
- * %INIT_PHYSMEM_REGIONS.
+ * %INIT_MEMBLOCK_MEMORY_REGIONS for "memory" and
+ * %INIT_MEMBLOCK_RESERVED_REGIONS for "reserved". The region array
+ * for "physmem" is initially sized to %INIT_PHYSMEM_REGIONS.
  * The memblock_allow_resize() enables automatic resizing of the region
  * arrays during addition of new regions. This feature should be used
  * with care so that memory allocated for the region array will not
@@ -102,7 +106,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_MEMORY_REGIONS] __initdata_memblock;
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_RESERVED_REGIONS] __initdata_memblock;
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 static struct memblock_region memblock_physmem_init_regions[INIT_PHYSMEM_REGIONS];
@@ -111,7 +115,7 @@ static struct memblock_region memblock_p
 struct memblock memblock __initdata_memblock = {
 	.memory.regions		= memblock_memory_init_regions,
 	.memory.cnt		= 1,	/* empty dummy entry */
-	.memory.max		= INIT_MEMBLOCK_REGIONS,
+	.memory.max		= INIT_MEMBLOCK_MEMORY_REGIONS,
 	.memory.name		= "memory",
 
 	.reserved.regions	= memblock_reserved_init_regions,
_

Patches currently in -mm which might be from zhouguanghui1@huawei.com are


