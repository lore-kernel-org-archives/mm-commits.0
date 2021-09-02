Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA0AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AE760E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347967AbhIBWB0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347625AbhIBWBZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD2560F21;
        Thu,  2 Sep 2021 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620026;
        bh=YbOl4lPLGju8YCKYxif+v7fYvkD+Mz+EcM9kGoqe/Tc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HYlFD2Q8tgvjp+gfc87KqM9CULs7KmbgV75VBWGdcBagEP2WSeTmlg2Wcdyj5TOY9
         vPhy4DbeVx2AwUmEBTqtZ+vFWomI55srKnw4Bp0xPIgAzXK8KYJBfQX2B9OxykbfnK
         kk0gAZ9pAdxkdp900v2pHfCgkk6pC2kNPcO4ZdPE=
Date:   Thu, 02 Sep 2021 15:00:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        kirill.shtuemov@linux.intel.com, linux-mm@kvack.org,
        linux@roeck-us.net, mick@ics.forth.gr, mm-commits@vger.kernel.org,
        rafael.j.wysocki@intel.com, rmk+kernel@armlinux.org.uk,
        robh@kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 197/212] memblock: make memblock_find_in_range
 method private
Message-ID: <20210902220026.q4AhgXDR6%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: make memblock_find_in_range method private

There are a lot of uses of memblock_find_in_range() along with
memblock_reserve() from the times memblock allocation APIs did not exist.

memblock_find_in_range() is the very core of memblock allocations, so any
future changes to its internal behaviour would mandate updates of all the
users outside memblock.

Replace the calls to memblock_find_in_range() with an equivalent calls to
memblock_phys_alloc() and memblock_phys_alloc_range() and make
memblock_find_in_range() private method of memblock.

This simplifies the callers, ensures that (unlikely) errors in
memblock_reserve() are handled and improves maintainability of
memblock_find_in_range().

Link: https://lkml.kernel.org/r/20210816122622.30279-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>		[arm64]
Acked-by: Kirill A. Shutemov <kirill.shtuemov@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[ACPI]
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Nick Kossifidis <mick@ics.forth.gr>			[riscv]
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c           |   20 ++++--------
 arch/arm64/kvm/hyp/reserved_mem.c |    9 +----
 arch/arm64/mm/init.c              |   38 +++++++-----------------
 arch/mips/kernel/setup.c          |   14 +++-----
 arch/riscv/mm/init.c              |   44 ++++++++--------------------
 arch/s390/kernel/setup.c          |    9 +++--
 arch/x86/kernel/aperture_64.c     |    5 +--
 arch/x86/mm/init.c                |   23 +++++++++-----
 arch/x86/mm/numa.c                |    5 +--
 arch/x86/mm/numa_emulation.c      |    5 +--
 arch/x86/realmode/init.c          |    2 -
 drivers/acpi/tables.c             |    5 +--
 drivers/base/arch_numa.c          |    5 ---
 drivers/of/of_reserved_mem.c      |   12 +++++--
 include/linux/memblock.h          |    2 -
 mm/memblock.c                     |    2 -
 16 files changed, 82 insertions(+), 118 deletions(-)

--- a/arch/arm64/kvm/hyp/reserved_mem.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/arm64/kvm/hyp/reserved_mem.c
@@ -92,12 +92,10 @@ void __init kvm_hyp_reserve(void)
 	 * this is unmapped from the host stage-2, and fallback to PAGE_SIZE.
 	 */
 	hyp_mem_size = hyp_mem_pages << PAGE_SHIFT;
-	hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
-					      ALIGN(hyp_mem_size, PMD_SIZE),
-					      PMD_SIZE);
+	hyp_mem_base = memblock_phys_alloc(ALIGN(hyp_mem_size, PMD_SIZE),
+					   PMD_SIZE);
 	if (!hyp_mem_base)
-		hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
-						      hyp_mem_size, PAGE_SIZE);
+		hyp_mem_base = memblock_phys_alloc(hyp_mem_size, PAGE_SIZE);
 	else
 		hyp_mem_size = ALIGN(hyp_mem_size, PMD_SIZE);
 
@@ -105,7 +103,6 @@ void __init kvm_hyp_reserve(void)
 		kvm_err("Failed to reserve hyp memory\n");
 		return;
 	}
-	memblock_reserve(hyp_mem_base, hyp_mem_size);
 
 	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
 		 hyp_mem_base);
--- a/arch/arm64/mm/init.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/arm64/mm/init.c
@@ -74,6 +74,7 @@ phys_addr_t arm64_dma_phys_limit __ro_af
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long crash_base, crash_size;
+	unsigned long long crash_max = arm64_dma_phys_limit;
 	int ret;
 
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
@@ -84,33 +85,18 @@ static void __init reserve_crashkernel(v
 
 	crash_size = PAGE_ALIGN(crash_size);
 
-	if (crash_base == 0) {
-		/* Current arm64 boot protocol requires 2MB alignment */
-		crash_base = memblock_find_in_range(0, arm64_dma_phys_limit,
-				crash_size, SZ_2M);
-		if (crash_base == 0) {
-			pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
-				crash_size);
-			return;
-		}
-	} else {
-		/* User specifies base address explicitly. */
-		if (!memblock_is_region_memory(crash_base, crash_size)) {
-			pr_warn("cannot reserve crashkernel: region is not memory\n");
-			return;
-		}
-
-		if (memblock_is_region_reserved(crash_base, crash_size)) {
-			pr_warn("cannot reserve crashkernel: region overlaps reserved memory\n");
-			return;
-		}
-
-		if (!IS_ALIGNED(crash_base, SZ_2M)) {
-			pr_warn("cannot reserve crashkernel: base address is not 2MB aligned\n");
-			return;
-		}
+	/* User specifies base address explicitly. */
+	if (crash_base)
+		crash_max = crash_base + crash_size;
+
+	/* Current arm64 boot protocol requires 2MB alignment */
+	crash_base = memblock_phys_alloc_range(crash_size, SZ_2M,
+					       crash_base, crash_max);
+	if (!crash_base) {
+		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
+			crash_size);
+		return;
 	}
-	memblock_reserve(crash_base, crash_size);
 
 	pr_info("crashkernel reserved: 0x%016llx - 0x%016llx (%lld MB)\n",
 		crash_base, crash_base + crash_size, crash_size >> 20);
--- a/arch/arm/kernel/setup.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/arm/kernel/setup.c
@@ -1012,31 +1012,25 @@ static void __init reserve_crashkernel(v
 		unsigned long long lowmem_max = __pa(high_memory - 1) + 1;
 		if (crash_max > lowmem_max)
 			crash_max = lowmem_max;
-		crash_base = memblock_find_in_range(CRASH_ALIGN, crash_max,
-						    crash_size, CRASH_ALIGN);
+
+		crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
+						       CRASH_ALIGN, crash_max);
 		if (!crash_base) {
 			pr_err("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
+		unsigned long long crash_max = crash_base + crash_size;
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base,
-					       crash_base + crash_size,
-					       crash_size, SECTION_SIZE);
-		if (start != crash_base) {
+		start = memblock_phys_alloc_range(crash_size, SECTION_SIZE,
+						  crash_base, crash_max);
+		if (!start) {
 			pr_err("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
 
-	ret = memblock_reserve(crash_base, crash_size);
-	if (ret < 0) {
-		pr_warn("crashkernel reservation failed - memory is in use (0x%lx)\n",
-			(unsigned long)crash_base);
-		return;
-	}
-
 	pr_info("Reserving %ldMB of memory at %ldMB for crashkernel (System RAM: %ldMB)\n",
 		(unsigned long)(crash_size >> 20),
 		(unsigned long)(crash_base >> 20),
--- a/arch/mips/kernel/setup.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/mips/kernel/setup.c
@@ -452,8 +452,9 @@ static void __init mips_parse_crashkerne
 		return;
 
 	if (crash_base <= 0) {
-		crash_base = memblock_find_in_range(CRASH_ALIGN, CRASH_ADDR_MAX,
-							crash_size, CRASH_ALIGN);
+		crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
+						       CRASH_ALIGN,
+						       CRASH_ADDR_MAX);
 		if (!crash_base) {
 			pr_warn("crashkernel reservation failed - No suitable area found.\n");
 			return;
@@ -461,8 +462,9 @@ static void __init mips_parse_crashkerne
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, crash_base + crash_size,
-						crash_size, 1);
+		start = memblock_phys_alloc_range(crash_size, 1,
+						  crash_base,
+						  crash_base + crash_size);
 		if (start != crash_base) {
 			pr_warn("Invalid memory region reserved for crash kernel\n");
 			return;
@@ -656,10 +658,6 @@ static void __init arch_mem_init(char **
 	mips_reserve_vmcore();
 
 	mips_parse_crashkernel();
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end)
-		memblock_reserve(crashk_res.start, resource_size(&crashk_res));
-#endif
 	device_tree_init();
 
 	/*
--- a/arch/riscv/mm/init.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/riscv/mm/init.c
@@ -819,38 +819,22 @@ static void __init reserve_crashkernel(v
 
 	crash_size = PAGE_ALIGN(crash_size);
 
-	if (crash_base == 0) {
-		/*
-		 * Current riscv boot protocol requires 2MB alignment for
-		 * RV64 and 4MB alignment for RV32 (hugepage size)
-		 */
-		crash_base = memblock_find_in_range(search_start, search_end,
-						    crash_size, PMD_SIZE);
-
-		if (crash_base == 0) {
-			pr_warn("crashkernel: couldn't allocate %lldKB\n",
-				crash_size >> 10);
-			return;
-		}
-	} else {
-		/* User specifies base address explicitly. */
-		if (!memblock_is_region_memory(crash_base, crash_size)) {
-			pr_warn("crashkernel: requested region is not memory\n");
-			return;
-		}
-
-		if (memblock_is_region_reserved(crash_base, crash_size)) {
-			pr_warn("crashkernel: requested region is reserved\n");
-			return;
-		}
-
+	if (crash_base) {
+		search_start = crash_base;
+		search_end = crash_base + crash_size;
+	}
 
-		if (!IS_ALIGNED(crash_base, PMD_SIZE)) {
-			pr_warn("crashkernel: requested region is misaligned\n");
-			return;
-		}
+	/*
+	 * Current riscv boot protocol requires 2MB alignment for
+	 * RV64 and 4MB alignment for RV32 (hugepage size)
+	 */
+	crash_base = memblock_phys_alloc_range(crash_size, PMD_SIZE,
+					       search_start, search_end);
+	if (crash_base == 0) {
+		pr_warn("crashkernel: couldn't allocate %lldKB\n",
+			crash_size >> 10);
+		return;
 	}
-	memblock_reserve(crash_base, crash_size);
 
 	pr_info("crashkernel: reserved 0x%016llx - 0x%016llx (%lld MB)\n",
 		crash_base, crash_base + crash_size, crash_size >> 20);
--- a/arch/s390/kernel/setup.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/s390/kernel/setup.c
@@ -626,8 +626,9 @@ static void __init reserve_crashkernel(v
 			return;
 		}
 		low = crash_base ?: low;
-		crash_base = memblock_find_in_range(low, high, crash_size,
-						    KEXEC_CRASH_MEM_ALIGN);
+		crash_base = memblock_phys_alloc_range(crash_size,
+						       KEXEC_CRASH_MEM_ALIGN,
+						       low, high);
 	}
 
 	if (!crash_base) {
@@ -636,8 +637,10 @@ static void __init reserve_crashkernel(v
 		return;
 	}
 
-	if (register_memory_notifier(&kdump_mem_nb))
+	if (register_memory_notifier(&kdump_mem_nb)) {
+		memblock_free(crash_base, crash_size);
 		return;
+	}
 
 	if (!OLDMEM_BASE && MACHINE_IS_VM)
 		diag10_range(PFN_DOWN(crash_base), PFN_DOWN(crash_size));
--- a/arch/x86/kernel/aperture_64.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/x86/kernel/aperture_64.c
@@ -109,14 +109,13 @@ static u32 __init allocate_aperture(void
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
-				      aper_size, aper_size);
+	addr = memblock_phys_alloc_range(aper_size, aper_size,
+					 GART_MIN_ADDR, GART_MAX_ADDR);
 	if (!addr) {
 		pr_err("Cannot allocate aperture memory hole [mem %#010lx-%#010lx] (%uKB)\n",
 		       addr, addr + aper_size - 1, aper_size >> 10);
 		return 0;
 	}
-	memblock_reserve(addr, aper_size);
 	pr_info("Mapping aperture over RAM [mem %#010lx-%#010lx] (%uKB)\n",
 		addr, addr + aper_size - 1, aper_size >> 10);
 	register_nosave_region(addr >> PAGE_SHIFT,
--- a/arch/x86/mm/init.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/x86/mm/init.c
@@ -127,14 +127,12 @@ __ref void *alloc_low_pages(unsigned int
 		unsigned long ret = 0;
 
 		if (min_pfn_mapped < max_pfn_mapped) {
-			ret = memblock_find_in_range(
+			ret = memblock_phys_alloc_range(
+					PAGE_SIZE * num, PAGE_SIZE,
 					min_pfn_mapped << PAGE_SHIFT,
-					max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE * num , PAGE_SIZE);
+					max_pfn_mapped << PAGE_SHIFT);
 		}
-		if (ret)
-			memblock_reserve(ret, PAGE_SIZE * num);
-		else if (can_use_brk_pgt)
+		if (!ret && can_use_brk_pgt)
 			ret = __pa(extend_brk(PAGE_SIZE * num, PAGE_SIZE));
 
 		if (!ret)
@@ -610,8 +608,17 @@ static void __init memory_map_top_down(u
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
 
-	/* xen has big range in reserved near end of ram, skip it at first.*/
-	addr = memblock_find_in_range(map_start, map_end, PMD_SIZE, PMD_SIZE);
+	/*
+	 * Systems that have many reserved areas near top of the memory,
+	 * e.g. QEMU with less than 1G RAM and EFI enabled, or Xen, will
+	 * require lots of 4K mappings which may exhaust pgt_buf.
+	 * Start with top-most PMD_SIZE range aligned at PMD_SIZE to ensure
+	 * there is enough mapped memory that can be allocated from
+	 * memblock.
+	 */
+	addr = memblock_phys_alloc_range(PMD_SIZE, PMD_SIZE, map_start,
+					 map_end);
+	memblock_free(addr, PMD_SIZE);
 	real_end = addr + PMD_SIZE;
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
--- a/arch/x86/mm/numa.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/x86/mm/numa.c
@@ -376,15 +376,14 @@ static int __init numa_alloc_distance(vo
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);
 
-	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-				      size, PAGE_SIZE);
+	phys = memblock_phys_alloc_range(size, PAGE_SIZE, 0,
+					 PFN_PHYS(max_pfn_mapped));
 	if (!phys) {
 		pr_warn("Warning: can't allocate distance table!\n");
 		/* don't retry until explicitly reset */
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
-	memblock_reserve(phys, size);
 
 	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
--- a/arch/x86/mm/numa_emulation.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/x86/mm/numa_emulation.c
@@ -447,13 +447,12 @@ void __init numa_emulation(struct numa_m
 	if (numa_dist_cnt) {
 		u64 phys;
 
-		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-					      phys_size, PAGE_SIZE);
+		phys = memblock_phys_alloc_range(phys_size, PAGE_SIZE, 0,
+						 PFN_PHYS(max_pfn_mapped));
 		if (!phys) {
 			pr_warn("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
-		memblock_reserve(phys, phys_size);
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
--- a/arch/x86/realmode/init.c~memblock-make-memblock_find_in_range-method-private
+++ a/arch/x86/realmode/init.c
@@ -28,7 +28,7 @@ void __init reserve_real_mode(void)
 	WARN_ON(slab_is_available());
 
 	/* Has to be under 1M so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	mem = memblock_phys_alloc_range(size, PAGE_SIZE, 0, 1<<20);
 	if (!mem)
 		pr_info("No sub-1M memory is available for the trampoline\n");
 	else
--- a/drivers/acpi/tables.c~memblock-make-memblock_find_in_range-method-private
+++ a/drivers/acpi/tables.c
@@ -583,8 +583,8 @@ void __init acpi_table_upgrade(void)
 	}
 
 	acpi_tables_addr =
-		memblock_find_in_range(0, ACPI_TABLE_UPGRADE_MAX_PHYS,
-				       all_tables_size, PAGE_SIZE);
+		memblock_phys_alloc_range(all_tables_size, PAGE_SIZE,
+					  0, ACPI_TABLE_UPGRADE_MAX_PHYS);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
 		return;
@@ -599,7 +599,6 @@ void __init acpi_table_upgrade(void)
 	 * Both memblock_reserve and e820__range_add (via arch_reserve_mem_area)
 	 * works fine.
 	 */
-	memblock_reserve(acpi_tables_addr, all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	/*
--- a/drivers/base/arch_numa.c~memblock-make-memblock_find_in_range-method-private
+++ a/drivers/base/arch_numa.c
@@ -279,13 +279,10 @@ static int __init numa_alloc_distance(vo
 	int i, j;
 
 	size = nr_node_ids * nr_node_ids * sizeof(numa_distance[0]);
-	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn),
-				      size, PAGE_SIZE);
+	phys = memblock_phys_alloc_range(size, PAGE_SIZE, 0, PFN_PHYS(max_pfn));
 	if (WARN_ON(!phys))
 		return -ENOMEM;
 
-	memblock_reserve(phys, size);
-
 	numa_distance = __va(phys);
 	numa_distance_cnt = nr_node_ids;
 
--- a/drivers/of/of_reserved_mem.c~memblock-make-memblock_find_in_range-method-private
+++ a/drivers/of/of_reserved_mem.c
@@ -33,18 +33,22 @@ static int __init early_init_dt_alloc_re
 	phys_addr_t *res_base)
 {
 	phys_addr_t base;
+	int err = 0;
 
 	end = !end ? MEMBLOCK_ALLOC_ANYWHERE : end;
 	align = !align ? SMP_CACHE_BYTES : align;
-	base = memblock_find_in_range(start, end, size, align);
+	base = memblock_phys_alloc_range(size, align, start, end);
 	if (!base)
 		return -ENOMEM;
 
 	*res_base = base;
-	if (nomap)
-		return memblock_mark_nomap(base, size);
+	if (nomap) {
+		err = memblock_mark_nomap(base, size);
+		if (err)
+			memblock_free(base, size);
+	}
 
-	return memblock_reserve(base, size);
+	return err;
 }
 
 /*
--- a/include/linux/memblock.h~memblock-make-memblock_find_in_range-method-private
+++ a/include/linux/memblock.h
@@ -99,8 +99,6 @@ void memblock_discard(void);
 static inline void memblock_discard(void) {}
 #endif
 
-phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
-				   phys_addr_t size, phys_addr_t align);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
--- a/mm/memblock.c~memblock-make-memblock_find_in_range-method-private
+++ a/mm/memblock.c
@@ -315,7 +315,7 @@ static phys_addr_t __init_memblock membl
  * Return:
  * Found address on success, 0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
+static phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align)
 {
_
