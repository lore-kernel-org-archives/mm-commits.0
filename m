Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8D3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A608C61994
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347854AbhI3UcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347824AbhI3UcK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C4761A51;
        Thu, 30 Sep 2021 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633033827;
        bh=npHbqkn/AVpiQSRq9rBit6uBNJXhFnqdAqlIkxgu2Bg=;
        h=Date:From:To:Subject:From;
        b=OG2UZKebmu9ZeNIyAaptzv5RgajdHX6Lp7V+ED2VJ68Izgc+tFQbIfrtFv+NI1QpN
         roqZw+eZpk+si+xNErduo8jU1AP6Fz8lbxQICXDFgYJmqgkAVCLUxtWordsn7r+I9C
         RCEHTXZ3j4t+jb33o8luo3mvMxwWvnxHlrJIzJ98=
Date:   Thu, 30 Sep 2021 13:30:26 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        Shahab.Vahedi@synopsys.com
Subject:  +
 memblock-rename-memblock_free-to-memblock_phys_free.patch added to -mm tree
Message-ID: <20210930203026.Rtr-uiieO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: rename memblock_free to memblock_phys_free
has been added to the -mm tree.  Its filename is
     memblock-rename-memblock_free-to-memblock_phys_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-rename-memblock_free-to-memblock_phys_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-rename-memblock_free-to-memblock_phys_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: rename memblock_free to memblock_phys_free

Since memblock_free() operates on a physical range, make its name reflect
it and rename it to memblock_phys_free(), so it will be a logical
counterpart to memblock_phys_alloc().

The callers are updated with the below semantic patch:

@@
expression addr;
expression size;
@@
- memblock_free(addr, size);
+ memblock_phys_free(addr, size);

Link: https://lkml.kernel.org/r/20210930185031.18648-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_irongate.c         |    3 ++-
 arch/arc/mm/init.c                        |    2 +-
 arch/arm/mach-hisi/platmcpm.c             |    2 +-
 arch/arm/mm/init.c                        |    2 +-
 arch/arm64/mm/mmu.c                       |    4 ++--
 arch/mips/mm/init.c                       |    2 +-
 arch/mips/sgi-ip30/ip30-setup.c           |    6 +++---
 arch/powerpc/kernel/dt_cpu_ftrs.c         |    4 ++--
 arch/powerpc/kernel/paca.c                |    8 ++++----
 arch/powerpc/kernel/setup-common.c        |    2 +-
 arch/powerpc/kernel/setup_64.c            |    2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |    2 +-
 arch/powerpc/platforms/pseries/svm.c      |    3 ++-
 arch/riscv/kernel/setup.c                 |    5 +++--
 arch/s390/kernel/setup.c                  |    8 ++++----
 arch/s390/kernel/smp.c                    |    4 ++--
 arch/s390/kernel/uv.c                     |    2 +-
 arch/s390/mm/kasan_init.c                 |    2 +-
 arch/sh/boards/mach-ap325rxa/setup.c      |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c      |    4 ++--
 arch/sh/boards/mach-kfr2r09/setup.c       |    2 +-
 arch/sh/boards/mach-migor/setup.c         |    2 +-
 arch/sh/boards/mach-se/7724/setup.c       |    4 ++--
 arch/sparc/kernel/smp_64.c                |    2 +-
 arch/um/kernel/mem.c                      |    2 +-
 arch/x86/kernel/setup.c                   |    4 ++--
 arch/x86/mm/init.c                        |    2 +-
 arch/x86/xen/mmu_pv.c                     |    6 +++---
 arch/x86/xen/setup.c                      |    6 +++---
 drivers/base/arch_numa.c                  |    2 +-
 drivers/firmware/efi/memmap.c             |    2 +-
 drivers/of/kexec.c                        |    3 +--
 drivers/of/of_reserved_mem.c              |    5 +++--
 drivers/s390/char/sclp_early.c            |    2 +-
 drivers/usb/early/xhci-dbc.c              |   10 +++++-----
 drivers/xen/swiotlb-xen.c                 |    2 +-
 include/linux/memblock.h                  |    2 +-
 init/initramfs.c                          |    2 +-
 kernel/dma/swiotlb.c                      |    2 +-
 lib/cpumask.c                             |    2 +-
 mm/cma.c                                  |    2 +-
 mm/memblock.c                             |    8 ++++----
 mm/memory_hotplug.c                       |    2 +-
 mm/percpu.c                               |    8 ++++----
 mm/sparse.c                               |    2 +-
 45 files changed, 79 insertions(+), 76 deletions(-)

--- a/arch/alpha/kernel/core_irongate.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/alpha/kernel/core_irongate.c
@@ -233,7 +233,8 @@ albacore_init_arch(void)
 			unsigned long size;
 
 			size = initrd_end - initrd_start;
-			memblock_free(__pa(initrd_start), PAGE_ALIGN(size));
+			memblock_phys_free(__pa(initrd_start),
+					   PAGE_ALIGN(size));
 			if (!move_initrd(pci_mem))
 				printk("irongate_init_arch: initrd too big "
 				       "(%ldK)\ndisabling initrd\n",
--- a/arch/arc/mm/init.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/arc/mm/init.c
@@ -173,7 +173,7 @@ static void __init highmem_init(void)
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
 
-	memblock_free(high_mem_start, high_mem_sz);
+	memblock_phys_free(high_mem_start, high_mem_sz);
 	for (tmp = min_high_pfn; tmp < max_high_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
 #endif
--- a/arch/arm64/mm/mmu.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/arm64/mm/mmu.c
@@ -738,8 +738,8 @@ void __init paging_init(void)
 	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
 	init_mm.pgd = swapper_pg_dir;
 
-	memblock_free(__pa_symbol(init_pg_dir),
-		      __pa_symbol(init_pg_end) - __pa_symbol(init_pg_dir));
+	memblock_phys_free(__pa_symbol(init_pg_dir),
+			   __pa_symbol(init_pg_end) - __pa_symbol(init_pg_dir));
 
 	memblock_allow_resize();
 }
--- a/arch/arm/mach-hisi/platmcpm.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/arm/mach-hisi/platmcpm.c
@@ -339,7 +339,7 @@ err_fabric:
 err_sysctrl:
 	iounmap(relocation);
 err_reloc:
-	memblock_free(hip04_boot_method[0], hip04_boot_method[1]);
+	memblock_phys_free(hip04_boot_method[0], hip04_boot_method[1]);
 err:
 	return ret;
 }
--- a/arch/arm/mm/init.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/arm/mm/init.c
@@ -158,7 +158,7 @@ phys_addr_t __init arm_memblock_steal(ph
 		panic("Failed to steal %pa bytes at %pS\n",
 		      &size, (void *)_RET_IP_);
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 
 	return phys;
--- a/arch/mips/mm/init.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/mips/mm/init.c
@@ -529,7 +529,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free(__pa(ptr), size);
+	memblock_phys_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/arch/mips/sgi-ip30/ip30-setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/mips/sgi-ip30/ip30-setup.c
@@ -69,10 +69,10 @@ static void __init ip30_mem_init(void)
 		total_mem += size;
 
 		if (addr >= IP30_REAL_MEMORY_START)
-			memblock_free(addr, size);
+			memblock_phys_free(addr, size);
 		else if ((addr + size) > IP30_REAL_MEMORY_START)
-			memblock_free(IP30_REAL_MEMORY_START,
-				     size - IP30_MAX_PROM_MEMORY);
+			memblock_phys_free(IP30_REAL_MEMORY_START,
+					   size - IP30_MAX_PROM_MEMORY);
 	}
 	pr_info("Detected %luMB of physical memory.\n", MEM_SHIFT(total_mem));
 }
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -1095,8 +1095,8 @@ static int __init dt_cpu_ftrs_scan_callb
 
 	cpufeatures_setup_finished();
 
-	memblock_free(__pa(dt_cpu_features),
-			sizeof(struct dt_cpu_feature)*nr_dt_cpu_features);
+	memblock_phys_free(__pa(dt_cpu_features),
+			   sizeof(struct dt_cpu_feature) * nr_dt_cpu_features);
 
 	return 0;
 }
--- a/arch/powerpc/kernel/paca.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/kernel/paca.c
@@ -322,8 +322,8 @@ void __init free_unused_pacas(void)
 
 	new_ptrs_size = sizeof(struct paca_struct *) * nr_cpu_ids;
 	if (new_ptrs_size < paca_ptrs_size)
-		memblock_free(__pa(paca_ptrs) + new_ptrs_size,
-					paca_ptrs_size - new_ptrs_size);
+		memblock_phys_free(__pa(paca_ptrs) + new_ptrs_size,
+				   paca_ptrs_size - new_ptrs_size);
 
 	paca_nr_cpu_ids = nr_cpu_ids;
 	paca_ptrs_size = new_ptrs_size;
@@ -331,8 +331,8 @@ void __init free_unused_pacas(void)
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (early_radix_enabled()) {
 		/* Ugly fixup, see new_slb_shadow() */
-		memblock_free(__pa(paca_ptrs[boot_cpuid]->slb_shadow_ptr),
-				sizeof(struct slb_shadow));
+		memblock_phys_free(__pa(paca_ptrs[boot_cpuid]->slb_shadow_ptr),
+				   sizeof(struct slb_shadow));
 		paca_ptrs[boot_cpuid]->slb_shadow_ptr = NULL;
 	}
 #endif
--- a/arch/powerpc/kernel/setup_64.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/kernel/setup_64.c
@@ -812,7 +812,7 @@ static void * __init pcpu_alloc_bootmem(
 
 static void __init pcpu_free_bootmem(void *ptr, size_t size)
 {
-	memblock_free(__pa(ptr), size);
+	memblock_phys_free(__pa(ptr), size);
 }
 
 static int pcpu_cpu_distance(unsigned int from, unsigned int to)
--- a/arch/powerpc/kernel/setup-common.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/kernel/setup-common.c
@@ -825,7 +825,7 @@ static void __init smp_setup_pacas(void)
 		set_hard_smp_processor_id(cpu, cpu_to_phys_id[cpu]);
 	}
 
-	memblock_free(__pa(cpu_to_phys_id), nr_cpu_ids * sizeof(u32));
+	memblock_phys_free(__pa(cpu_to_phys_id), nr_cpu_ids * sizeof(u32));
 	cpu_to_phys_id = NULL;
 }
 #endif
--- a/arch/powerpc/platforms/powernv/pci-ioda.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2981,7 +2981,7 @@ static void __init pnv_pci_init_ioda_phb
 	if (!phb->hose) {
 		pr_err("  Can't allocate PCI controller for %pOF\n",
 		       np);
-		memblock_free(__pa(phb), sizeof(struct pnv_phb));
+		memblock_phys_free(__pa(phb), sizeof(struct pnv_phb));
 		return;
 	}
 
--- a/arch/powerpc/platforms/pseries/svm.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/powerpc/platforms/pseries/svm.c
@@ -56,7 +56,8 @@ void __init svm_swiotlb_init(void)
 		return;
 
 
-	memblock_free(__pa(vstart), PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+	memblock_phys_free(__pa(vstart),
+			   PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	panic("SVM: Cannot allocate SWIOTLB buffer");
 }
 
--- a/arch/riscv/kernel/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/riscv/kernel/setup.c
@@ -230,13 +230,14 @@ static void __init init_resources(void)
 
 	/* Clean-up any unused pre-allocated resources */
 	if (res_idx >= 0)
-		memblock_free(__pa(mem_res), (res_idx + 1) * sizeof(*mem_res));
+		memblock_phys_free(__pa(mem_res),
+				   (res_idx + 1) * sizeof(*mem_res));
 	return;
 
  error:
 	/* Better an empty resource tree than an inconsistent one */
 	release_child_resources(&iomem_resource);
-	memblock_free(__pa(mem_res), mem_res_sz);
+	memblock_phys_free(__pa(mem_res), mem_res_sz);
 }
 
 
--- a/arch/s390/kernel/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/s390/kernel/setup.c
@@ -693,7 +693,7 @@ static void __init reserve_crashkernel(v
 	}
 
 	if (register_memory_notifier(&kdump_mem_nb)) {
-		memblock_free(crash_base, crash_size);
+		memblock_phys_free(crash_base, crash_size);
 		return;
 	}
 
@@ -748,7 +748,7 @@ static void __init free_mem_detect_info(
 
 	get_mem_detect_reserved(&start, &size);
 	if (size)
-		memblock_free(start, size);
+		memblock_phys_free(start, size);
 }
 
 static const char * __init get_mem_info_source(void)
@@ -793,7 +793,7 @@ static void __init check_initrd(void)
 	if (initrd_data.start && initrd_data.size &&
 	    !memblock_is_region_memory(initrd_data.start, initrd_data.size)) {
 		pr_err("The initial RAM disk does not fit into the memory\n");
-		memblock_free(initrd_data.start, initrd_data.size);
+		memblock_phys_free(initrd_data.start, initrd_data.size);
 		initrd_start = initrd_end = 0;
 	}
 #endif
@@ -890,7 +890,7 @@ static void __init setup_randomness(void
 
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
-	memblock_free((unsigned long) vmms, PAGE_SIZE);
+	memblock_phys_free((unsigned long)vmms, PAGE_SIZE);
 }
 
 /*
--- a/arch/s390/kernel/smp.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/s390/kernel/smp.c
@@ -723,7 +723,7 @@ void __init smp_save_dump_cpus(void)
 			/* Get the CPU registers */
 			smp_save_cpu_regs(sa, addr, is_boot_cpu, page);
 	}
-	memblock_free(page, PAGE_SIZE);
+	memblock_phys_free(page, PAGE_SIZE);
 	diag_amode31_ops.diag308_reset();
 	pcpu_set_smt(0);
 }
@@ -880,7 +880,7 @@ void __init smp_detect_cpus(void)
 
 	/* Add CPUs present at boot */
 	__smp_rescan_cpus(info, true);
-	memblock_free((unsigned long)info, sizeof(*info));
+	memblock_phys_free((unsigned long)info, sizeof(*info));
 }
 
 /*
--- a/arch/s390/kernel/uv.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/s390/kernel/uv.c
@@ -64,7 +64,7 @@ void __init setup_uv(void)
 	}
 
 	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
-		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
+		memblock_phys_free(uv_stor_base, uv_info.uv_base_stor_len);
 		goto fail;
 	}
 
--- a/arch/s390/mm/kasan_init.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/s390/mm/kasan_init.c
@@ -399,5 +399,5 @@ void __init kasan_copy_shadow_mapping(vo
 
 void __init kasan_free_early_identity(void)
 {
-	memblock_free(pgalloc_pos, pgalloc_freeable - pgalloc_pos);
+	memblock_phys_free(pgalloc_pos, pgalloc_freeable - pgalloc_pos);
 }
--- a/arch/sh/boards/mach-ap325rxa/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sh/boards/mach-ap325rxa/setup.c
@@ -560,7 +560,7 @@ static void __init ap325rxa_mv_mem_reser
 	if (!phys)
 		panic("Failed to allocate CEU memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 
 	ceu_dma_membase = phys;
--- a/arch/sh/boards/mach-ecovec24/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sh/boards/mach-ecovec24/setup.c
@@ -1502,7 +1502,7 @@ static void __init ecovec_mv_mem_reserve
 	if (!phys)
 		panic("Failed to allocate CEU0 memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 	ceu0_dma_membase = phys;
 
@@ -1510,7 +1510,7 @@ static void __init ecovec_mv_mem_reserve
 	if (!phys)
 		panic("Failed to allocate CEU1 memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 	ceu1_dma_membase = phys;
 }
--- a/arch/sh/boards/mach-kfr2r09/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sh/boards/mach-kfr2r09/setup.c
@@ -633,7 +633,7 @@ static void __init kfr2r09_mv_mem_reserv
 	if (!phys)
 		panic("Failed to allocate CEU memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 
 	ceu_dma_membase = phys;
--- a/arch/sh/boards/mach-migor/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sh/boards/mach-migor/setup.c
@@ -633,7 +633,7 @@ static void __init migor_mv_mem_reserve(
 	if (!phys)
 		panic("Failed to allocate CEU memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 
 	ceu_dma_membase = phys;
--- a/arch/sh/boards/mach-se/7724/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sh/boards/mach-se/7724/setup.c
@@ -966,7 +966,7 @@ static void __init ms7724se_mv_mem_reser
 	if (!phys)
 		panic("Failed to allocate CEU0 memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 	ceu0_dma_membase = phys;
 
@@ -974,7 +974,7 @@ static void __init ms7724se_mv_mem_reser
 	if (!phys)
 		panic("Failed to allocate CEU1 memory\n");
 
-	memblock_free(phys, size);
+	memblock_phys_free(phys, size);
 	memblock_remove(phys, size);
 	ceu1_dma_membase = phys;
 }
--- a/arch/sparc/kernel/smp_64.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/sparc/kernel/smp_64.c
@@ -1567,7 +1567,7 @@ static void * __init pcpu_alloc_bootmem(
 
 static void __init pcpu_free_bootmem(void *ptr, size_t size)
 {
-	memblock_free(__pa(ptr), size);
+	memblock_phys_free(__pa(ptr), size);
 }
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
--- a/arch/um/kernel/mem.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/um/kernel/mem.c
@@ -47,7 +47,7 @@ void __init mem_init(void)
 	 */
 	brk_end = (unsigned long) UML_ROUND_UP(sbrk(0));
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
-	memblock_free(__pa(brk_end), uml_reserved - brk_end);
+	memblock_phys_free(__pa(brk_end), uml_reserved - brk_end);
 	uml_reserved = brk_end;
 
 	/* this will put all low memory onto the freelists */
--- a/arch/x86/kernel/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/x86/kernel/setup.c
@@ -322,7 +322,7 @@ static void __init reserve_initrd(void)
 
 	relocate_initrd();
 
-	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
+	memblock_phys_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 
 #else
@@ -521,7 +521,7 @@ static void __init reserve_crashkernel(v
 	}
 
 	if (crash_base >= (1ULL << 32) && reserve_crashkernel_low()) {
-		memblock_free(crash_base, crash_size);
+		memblock_phys_free(crash_base, crash_size);
 		return;
 	}
 
--- a/arch/x86/mm/init.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/x86/mm/init.c
@@ -618,7 +618,7 @@ static void __init memory_map_top_down(u
 	 */
 	addr = memblock_phys_alloc_range(PMD_SIZE, PMD_SIZE, map_start,
 					 map_end);
-	memblock_free(addr, PMD_SIZE);
+	memblock_phys_free(addr, PMD_SIZE);
 	real_end = addr + PMD_SIZE;
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
--- a/arch/x86/xen/mmu_pv.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/x86/xen/mmu_pv.c
@@ -1025,7 +1025,7 @@ static void __init xen_free_ro_pages(uns
 	for (; vaddr < vaddr_end; vaddr += PAGE_SIZE)
 		make_lowmem_page_readwrite(vaddr);
 
-	memblock_free(paddr, size);
+	memblock_phys_free(paddr, size);
 }
 
 static void __init xen_cleanmfnmap_free_pgtbl(void *pgtbl, bool unpin)
@@ -1151,7 +1151,7 @@ static void __init xen_pagetable_p2m_fre
 		xen_cleanhighmap(addr, addr + size);
 		size = PAGE_ALIGN(xen_start_info->nr_pages *
 				  sizeof(unsigned long));
-		memblock_free(__pa(addr), size);
+		memblock_phys_free(__pa(addr), size);
 	} else {
 		xen_cleanmfnmap(addr);
 	}
@@ -1955,7 +1955,7 @@ void __init xen_relocate_p2m(void)
 		pfn_end = p2m_pfn_end;
 	}
 
-	memblock_free(PFN_PHYS(pfn), PAGE_SIZE * (pfn_end - pfn));
+	memblock_phys_free(PFN_PHYS(pfn), PAGE_SIZE * (pfn_end - pfn));
 	while (pfn < pfn_end) {
 		if (pfn == p2m_pfn) {
 			pfn = p2m_pfn_end;
--- a/arch/x86/xen/setup.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/arch/x86/xen/setup.c
@@ -153,7 +153,7 @@ static void __init xen_del_extra_mem(uns
 			break;
 		}
 	}
-	memblock_free(PFN_PHYS(start_pfn), PFN_PHYS(n_pfns));
+	memblock_phys_free(PFN_PHYS(start_pfn), PFN_PHYS(n_pfns));
 }
 
 /*
@@ -719,7 +719,7 @@ static void __init xen_reserve_xen_mfnli
 		return;
 
 	xen_relocate_p2m();
-	memblock_free(start, size);
+	memblock_phys_free(start, size);
 }
 
 /**
@@ -885,7 +885,7 @@ char * __init xen_memory_setup(void)
 		xen_phys_memcpy(new_area, start, size);
 		pr_info("initrd moved from [mem %#010llx-%#010llx] to [mem %#010llx-%#010llx]\n",
 			start, start + size, new_area, new_area + size);
-		memblock_free(start, size);
+		memblock_phys_free(start, size);
 		boot_params.hdr.ramdisk_image = new_area;
 		boot_params.ext_ramdisk_image = new_area >> 32;
 	}
--- a/drivers/base/arch_numa.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/base/arch_numa.c
@@ -165,7 +165,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free(__pa(ptr), size);
+	memblock_phys_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/drivers/firmware/efi/memmap.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/firmware/efi/memmap.c
@@ -35,7 +35,7 @@ void __init __efi_memmap_free(u64 phys,
 		if (slab_is_available())
 			memblock_free_late(phys, size);
 		else
-			memblock_free(phys, size);
+			memblock_phys_free(phys, size);
 	} else if (flags & EFI_MEMMAP_SLAB) {
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
--- a/drivers/of/kexec.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/of/kexec.c
@@ -171,8 +171,7 @@ int ima_free_kexec_buffer(void)
 	if (ret)
 		return ret;
 
-	return memblock_free(addr, size);
-
+	return memblock_phys_free(addr, size);
 }
 
 /**
--- a/drivers/of/of_reserved_mem.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/of/of_reserved_mem.c
@@ -45,7 +45,7 @@ static int __init early_init_dt_alloc_re
 	if (nomap) {
 		err = memblock_mark_nomap(base, size);
 		if (err)
-			memblock_free(base, size);
+			memblock_phys_free(base, size);
 	}
 
 	return err;
@@ -282,7 +282,8 @@ void __init fdt_init_reserved_mem(void)
 				if (nomap)
 					memblock_clear_nomap(rmem->base, rmem->size);
 				else
-					memblock_free(rmem->base, rmem->size);
+					memblock_phys_free(rmem->base,
+							   rmem->size);
 			}
 		}
 	}
--- a/drivers/s390/char/sclp_early.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/s390/char/sclp_early.c
@@ -139,7 +139,7 @@ int __init sclp_early_get_core_info(stru
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	memblock_free((unsigned long)sccb, length);
+	memblock_phys_free((unsigned long)sccb, length);
 	return rc;
 }
 
--- a/drivers/usb/early/xhci-dbc.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/usb/early/xhci-dbc.c
@@ -185,7 +185,7 @@ static void __init xdbc_free_ring(struct
 	if (!seg)
 		return;
 
-	memblock_free(seg->dma, PAGE_SIZE);
+	memblock_phys_free(seg->dma, PAGE_SIZE);
 	ring->segment = NULL;
 }
 
@@ -665,10 +665,10 @@ int __init early_xdbc_setup_hardware(voi
 		xdbc_free_ring(&xdbc.in_ring);
 
 		if (xdbc.table_dma)
-			memblock_free(xdbc.table_dma, PAGE_SIZE);
+			memblock_phys_free(xdbc.table_dma, PAGE_SIZE);
 
 		if (xdbc.out_dma)
-			memblock_free(xdbc.out_dma, PAGE_SIZE);
+			memblock_phys_free(xdbc.out_dma, PAGE_SIZE);
 
 		xdbc.table_base = NULL;
 		xdbc.out_buf = NULL;
@@ -987,8 +987,8 @@ free_and_quit:
 	xdbc_free_ring(&xdbc.evt_ring);
 	xdbc_free_ring(&xdbc.out_ring);
 	xdbc_free_ring(&xdbc.in_ring);
-	memblock_free(xdbc.table_dma, PAGE_SIZE);
-	memblock_free(xdbc.out_dma, PAGE_SIZE);
+	memblock_phys_free(xdbc.table_dma, PAGE_SIZE);
+	memblock_phys_free(xdbc.out_dma, PAGE_SIZE);
 	writel(0, &xdbc.xdbc_reg->control);
 	early_iounmap(xdbc.xhci_base, xdbc.xhci_length);
 
--- a/drivers/xen/swiotlb-xen.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/drivers/xen/swiotlb-xen.c
@@ -241,7 +241,7 @@ retry:
 	 */
 	rc = xen_swiotlb_fixup(start, nslabs);
 	if (rc) {
-		memblock_free(__pa(start), PAGE_ALIGN(bytes));
+		memblock_phys_free(__pa(start), PAGE_ALIGN(bytes));
 		if (nslabs > 1024 && repeat--) {
 			/* Min is 2MB */
 			nslabs = max(1024UL, ALIGN(nslabs >> 1, IO_TLB_SEGSIZE));
--- a/include/linux/memblock.h~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/include/linux/memblock.h
@@ -103,7 +103,7 @@ void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
-int memblock_free(phys_addr_t base, phys_addr_t size);
+int memblock_phys_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
--- a/init/initramfs.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/init/initramfs.c
@@ -607,7 +607,7 @@ void __weak __init free_initrd_mem(unsig
 	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
 	unsigned long aligned_end = ALIGN(end, PAGE_SIZE);
 
-	memblock_free(__pa(aligned_start), aligned_end - aligned_start);
+	memblock_phys_free(__pa(aligned_start), aligned_end - aligned_start);
 #endif
 
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
--- a/kernel/dma/swiotlb.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/kernel/dma/swiotlb.c
@@ -247,7 +247,7 @@ swiotlb_init(int verbose)
 	return;
 
 fail_free_mem:
-	memblock_free(__pa(tlb), bytes);
+	memblock_phys_free(__pa(tlb), bytes);
 fail:
 	pr_warn("Cannot allocate buffer");
 }
--- a/lib/cpumask.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/lib/cpumask.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	memblock_free(__pa(mask), cpumask_size());
+	memblock_phys_free(__pa(mask), cpumask_size());
 }
 #endif
 
--- a/mm/cma.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/mm/cma.c
@@ -378,7 +378,7 @@ int __init cma_declare_contiguous_nid(ph
 	return 0;
 
 free_mem:
-	memblock_free(base, size);
+	memblock_phys_free(base, size);
 err:
 	pr_err("Failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
 	return ret;
--- a/mm/memblock.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/mm/memblock.c
@@ -806,18 +806,18 @@ int __init_memblock memblock_remove(phys
 void __init_memblock memblock_free_ptr(void *ptr, size_t size)
 {
 	if (ptr)
-		memblock_free(__pa(ptr), size);
+		memblock_phys_free(__pa(ptr), size);
 }
 
 /**
- * memblock_free - free boot memory block
+ * memblock_phys_free - free boot memory block
  * @base: phys starting address of the  boot memory block
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_alloc_xx() API.
  * The freeing memory will not be released to the buddy allocator.
  */
-int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t end = base + size - 1;
 
@@ -1934,7 +1934,7 @@ static void __init free_memmap(unsigned
 	 * memmap array.
 	 */
 	if (pg < pgend)
-		memblock_free(pg, pgend - pg);
+		memblock_phys_free(pg, pgend - pg);
 }
 
 /*
--- a/mm/memory_hotplug.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/mm/memory_hotplug.c
@@ -2204,7 +2204,7 @@ static int __ref try_remove_memory(u64 s
 	arch_remove_memory(start, size, altmap);
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		memblock_free(start, size);
+		memblock_phys_free(start, size);
 		memblock_remove(start, size);
 	}
 
--- a/mm/percpu.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/mm/percpu.c
@@ -2472,7 +2472,7 @@ struct pcpu_alloc_info * __init pcpu_all
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	memblock_free(__pa(ai), ai->__ai_size);
+	memblock_phys_free(__pa(ai), ai->__ai_size);
 }
 
 /**
@@ -3134,7 +3134,7 @@ out_free_areas:
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
-		memblock_free(__pa(areas), areas_size);
+		memblock_phys_free(__pa(areas), areas_size);
 	return rc;
 }
 #endif /* BUILD_EMBED_FIRST_CHUNK */
@@ -3256,7 +3256,7 @@ enomem:
 		free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
-	memblock_free(__pa(pages), pages_size);
+	memblock_phys_free(__pa(pages), pages_size);
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
@@ -3286,7 +3286,7 @@ static void * __init pcpu_dfl_fc_alloc(u
 
 static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
 {
-	memblock_free(__pa(ptr), size);
+	memblock_phys_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/mm/sparse.c~memblock-rename-memblock_free-to-memblock_phys_free
+++ a/mm/sparse.c
@@ -451,7 +451,7 @@ static void *sparsemap_buf_end __meminit
 static inline void __meminit sparse_buffer_free(unsigned long size)
 {
 	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_free(__pa(sparsemap_buf), size);
+	memblock_phys_free(__pa(sparsemap_buf), size);
 }
 
 static void __init sparse_buffer_init(unsigned long size, int nid)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

arch_numa-simplify-numa_distance-allocation.patch
xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
memblock-drop-memblock_free_early_nid-and-memblock_free_early.patch
memblock-stop-aliasing-__memblock_free_late-with-memblock_free_late.patch
memblock-rename-memblock_free-to-memblock_phys_free.patch
memblock-use-memblock_free-for-freeing-virtual-pointers.patch

