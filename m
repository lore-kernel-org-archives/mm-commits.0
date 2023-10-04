Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F1BE936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbjJDUZ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245049AbjJDUYv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8D310FD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:24:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80536C433C7;
        Wed,  4 Oct 2023 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451055;
        bh=qKKjx3qtdo1ka5smzLK+eY2rZMu3xCcJvn8TH1WStDw=;
        h=Date:To:From:Subject:From;
        b=y0B42JfVEGHORpxFp5Wgv0B6DvGAYEoqSXtCu2bvisGCcgFa8EIhnEZBcS2G1ui3z
         QMPxEmjWzM/aoteEv9Rw/y8avYFGi4x9CZNWnxDA5/nhZYESXLMLDtns/67WJCW3rG
         qc/DhSB7GaA/glaFTOk4qB/J/DBYMq+Y5htOr564=
Date:   Wed, 04 Oct 2023 13:24:14 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch removed from -mm tree
Message-Id: <20231004202415.80536C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: kdump: use generic interface to simplify crashkernel reservation
has been removed from the -mm tree.  Its filename was
     arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arm64: kdump: use generic interface to simplify crashkernel reservation
Date: Thu, 14 Sep 2023 11:31:40 +0800

With the help of newly changed function parse_crashkernel() and generic
reserve_crashkernel_generic(), crashkernel reservation can be simplified
by steps:

1) Add a new header file <asm/crash_core.h>, and define CRASH_ALIGN,
   CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX and
   DEFAULT_CRASH_KERNEL_LOW_SIZE in <asm/crash_core.h>;

2) Add arch_reserve_crashkernel() to call parse_crashkernel() and
   reserve_crashkernel_generic();

3) Add ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION Kconfig in
   arch/arm64/Kconfig.

The old reserve_crashkernel_low() and reserve_crashkernel() can be
removed.

Link: https://lkml.kernel.org/r/20230914033142.676708-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                  |    3 
 arch/arm64/include/asm/crash_core.h |   10 +
 arch/arm64/mm/init.c                |  140 +-------------------------
 3 files changed, 21 insertions(+), 132 deletions(-)

--- /dev/null
+++ a/arch/arm64/include/asm/crash_core.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ARM64_CRASH_CORE_H
+#define _ARM64_CRASH_CORE_H
+
+/* Current arm64 boot protocol requires 2MB alignment */
+#define CRASH_ALIGN                     SZ_2M
+
+#define CRASH_ADDR_LOW_MAX              arm64_dma_phys_limit
+#define CRASH_ADDR_HIGH_MAX             (PHYS_MASK + 1)
+#endif
--- a/arch/arm64/Kconfig~arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation
+++ a/arch/arm64/Kconfig
@@ -1483,6 +1483,9 @@ config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_S
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+	def_bool CRASH_CORE
+
 config TRANS_TABLE
 	def_bool y
 	depends on HIBERNATION || KEXEC_CORE
--- a/arch/arm64/mm/init.c~arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation
+++ a/arch/arm64/mm/init.c
@@ -64,15 +64,6 @@ EXPORT_SYMBOL(memstart_addr);
  */
 phys_addr_t __ro_after_init arm64_dma_phys_limit;
 
-/* Current arm64 boot protocol requires 2MB alignment */
-#define CRASH_ALIGN			SZ_2M
-
-#define CRASH_ADDR_LOW_MAX		arm64_dma_phys_limit
-#define CRASH_ADDR_HIGH_MAX		(PHYS_MASK + 1)
-#define CRASH_HIGH_SEARCH_BASE		SZ_4G
-
-#define DEFAULT_CRASH_KERNEL_LOW_SIZE	(128UL << 20)
-
 /*
  * To make optimal use of block mappings when laying out the linear
  * mapping, round down the base of physical memory to a size that can
@@ -100,140 +91,25 @@ phys_addr_t __ro_after_init arm64_dma_ph
 #define ARM64_MEMSTART_ALIGN	(1UL << ARM64_MEMSTART_SHIFT)
 #endif
 
-static int __init reserve_crashkernel_low(unsigned long long low_size)
+static void __init arch_reserve_crashkernel(void)
 {
-	unsigned long long low_base;
-
-	low_base = memblock_phys_alloc_range(low_size, CRASH_ALIGN, 0, CRASH_ADDR_LOW_MAX);
-	if (!low_base) {
-		pr_err("cannot allocate crashkernel low memory (size:0x%llx).\n", low_size);
-		return -ENOMEM;
-	}
-
-	pr_info("crashkernel low memory reserved: 0x%08llx - 0x%08llx (%lld MB)\n",
-		low_base, low_base + low_size, low_size >> 20);
-
-	crashk_low_res.start = low_base;
-	crashk_low_res.end   = low_base + low_size - 1;
-	insert_resource(&iomem_resource, &crashk_low_res);
-
-	return 0;
-}
-
-/*
- * reserve_crashkernel() - reserves memory for crash kernel
- *
- * This function reserves memory area given in "crashkernel=" kernel command
- * line parameter. The memory reserved is used by dump capture kernel when
- * primary kernel is crashing.
- */
-static void __init reserve_crashkernel(void)
-{
-	unsigned long long crash_low_size = 0, search_base = 0;
-	unsigned long long crash_max = CRASH_ADDR_LOW_MAX;
+	unsigned long long low_size = 0;
 	unsigned long long crash_base, crash_size;
 	char *cmdline = boot_command_line;
-	bool fixed_base = false;
 	bool high = false;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
 		return;
 
-	/* crashkernel=X[@offset] */
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
-				&crash_size, &crash_base, NULL, NULL);
-	if (ret == -ENOENT) {
-		ret = parse_crashkernel_high(cmdline, 0, &crash_size, &crash_base);
-		if (ret || !crash_size)
-			return;
-
-		/*
-		 * crashkernel=Y,low can be specified or not, but invalid value
-		 * is not allowed.
-		 */
-		ret = parse_crashkernel_low(cmdline, 0, &crash_low_size, &crash_base);
-		if (ret == -ENOENT)
-			crash_low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
-		else if (ret)
-			return;
-
-		search_base = CRASH_HIGH_SEARCH_BASE;
-		crash_max = CRASH_ADDR_HIGH_MAX;
-		high = true;
-	} else if (ret || !crash_size) {
-		/* The specified value is invalid */
+				&crash_size, &crash_base,
+				&low_size, &high);
+	if (ret)
 		return;
-	}
-
-	crash_size = PAGE_ALIGN(crash_size);
-
-	/* User specifies base address explicitly. */
-	if (crash_base) {
-		fixed_base = true;
-		search_base = crash_base;
-		crash_max = crash_base + crash_size;
-	}
 
-retry:
-	crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
-					       search_base, crash_max);
-	if (!crash_base) {
-		/*
-		 * For crashkernel=size[KMG]@offset[KMG], print out failure
-		 * message if can't reserve the specified region.
-		 */
-		if (fixed_base) {
-			pr_warn("crashkernel reservation failed - memory is in use.\n");
-			return;
-		}
-
-		/*
-		 * For crashkernel=size[KMG], if the first attempt was for
-		 * low memory, fall back to high memory, the minimum required
-		 * low memory will be reserved later.
-		 */
-		if (!high && crash_max == CRASH_ADDR_LOW_MAX) {
-			crash_max = CRASH_ADDR_HIGH_MAX;
-			search_base = CRASH_ADDR_LOW_MAX;
-			crash_low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
-			goto retry;
-		}
-
-		/*
-		 * For crashkernel=size[KMG],high, if the first attempt was
-		 * for high memory, fall back to low memory.
-		 */
-		if (high && crash_max == CRASH_ADDR_HIGH_MAX) {
-			crash_max = CRASH_ADDR_LOW_MAX;
-			search_base = 0;
-			goto retry;
-		}
-		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
-			crash_size);
-		return;
-	}
-
-	if ((crash_base >= CRASH_ADDR_LOW_MAX) && crash_low_size &&
-	     reserve_crashkernel_low(crash_low_size)) {
-		memblock_phys_free(crash_base, crash_size);
-		return;
-	}
-
-	pr_info("crashkernel reserved: 0x%016llx - 0x%016llx (%lld MB)\n",
-		crash_base, crash_base + crash_size, crash_size >> 20);
-
-	/*
-	 * The crashkernel memory will be removed from the kernel linear
-	 * map. Inform kmemleak so that it won't try to access it.
-	 */
-	kmemleak_ignore_phys(crash_base);
-	if (crashk_low_res.end)
-		kmemleak_ignore_phys(crashk_low_res.start);
-
-	crashk_res.start = crash_base;
-	crashk_res.end = crash_base + crash_size - 1;
-	insert_resource(&iomem_resource, &crashk_res);
+	reserve_crashkernel_generic(cmdline, crash_size, crash_base,
+				    low_size, high);
 }
 
 /*
@@ -479,7 +355,7 @@ void __init bootmem_init(void)
 	 * request_standard_resources() depends on crashkernel's memory being
 	 * reserved, so do it here.
 	 */
-	reserve_crashkernel();
+	arch_reserve_crashkernel();
 
 	memblock_dump_all();
 }
_

Patches currently in -mm which might be from bhe@redhat.com are


