Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCE1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37AB46113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhKKCtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81AD86103C;
        Thu, 11 Nov 2021 02:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598788;
        bh=2Aq+pUHI12hkb+3A8titHNY3uhPZC39H7qJUYbKiRXE=;
        h=Date:From:To:Subject:From;
        b=yUxrzj23G7FP6eIA2ubvVuqND+YF0zHNsdG5Nh8aV+qRxSKVvBxVR95/E9rAAetul
         kso5OU3rt+C/iWINbN3phBkrOcYAyOof4H/r3AAQI8lLhNTE83DqnwLt9XTkfx9BKK
         T+6HtiASXVB8Fy9yAtHTqcYmgDdZ4v8SoynSdkOo=
Date:   Wed, 10 Nov 2021 18:46:28 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au, Shahab.Vahedi@synopsys.com
Subject:  [merged]
 memblock-use-memblock_free-for-freeing-virtual-pointers.patch removed from
 -mm tree
Message-ID: <20211111024628.1Mkh7RaoX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: use memblock_free for freeing virtual pointers
has been removed from the -mm tree.  Its filename was
     memblock-use-memblock_free-for-freeing-virtual-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: use memblock_free for freeing virtual pointers

Rename memblock_free_ptr() to memblock_free() and use memblock_free() when
freeing a virtual pointer so that memblock_free() will be a counterpart of
memblock_alloc()

The callers are updated with the below semantic patch and manual addition
of (void *) casting to pointers that are represented by unsigned long
variables.

@@
identifier vaddr;
expression size;
@@
(
- memblock_phys_free(__pa(vaddr), size);
+ memblock_free(vaddr, size);
|
- memblock_free_ptr(vaddr, size);
+ memblock_free(vaddr, size);
)

[sfr@canb.auug.org.au: fixup]
  Link: https://lkml.kernel.org/r/20211018192940.3d1d532f@canb.auug.org.au
Link: https://lkml.kernel.org/r/20210930185031.18648-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_irongate.c         |    3 +--
 arch/mips/mm/init.c                       |    2 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c         |    4 ++--
 arch/powerpc/kernel/setup-common.c        |    2 +-
 arch/powerpc/kernel/setup_64.c            |    2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |    2 +-
 arch/powerpc/platforms/pseries/svm.c      |    3 +--
 arch/riscv/kernel/setup.c                 |    5 ++---
 arch/sparc/kernel/smp_64.c                |    2 +-
 arch/um/kernel/mem.c                      |    2 +-
 arch/x86/kernel/setup_percpu.c            |    2 +-
 arch/x86/mm/kasan_init_64.c               |    4 ++--
 arch/x86/mm/numa.c                        |    2 +-
 arch/x86/mm/numa_emulation.c              |    2 +-
 arch/x86/xen/mmu_pv.c                     |    2 +-
 arch/x86/xen/p2m.c                        |    2 +-
 drivers/base/arch_numa.c                  |    4 ++--
 drivers/macintosh/smu.c                   |    2 +-
 drivers/xen/swiotlb-xen.c                 |    2 +-
 include/linux/memblock.h                  |    2 +-
 init/initramfs.c                          |    2 +-
 init/main.c                               |    4 ++--
 kernel/dma/swiotlb.c                      |    2 +-
 kernel/printk/printk.c                    |    4 ++--
 lib/bootconfig.c                          |    2 +-
 lib/cpumask.c                             |    2 +-
 mm/memblock.c                             |    6 +++---
 mm/percpu.c                               |    8 ++++----
 mm/sparse.c                               |    2 +-
 29 files changed, 40 insertions(+), 43 deletions(-)

--- a/arch/alpha/kernel/core_irongate.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/alpha/kernel/core_irongate.c
@@ -233,8 +233,7 @@ albacore_init_arch(void)
 			unsigned long size;
 
 			size = initrd_end - initrd_start;
-			memblock_phys_free(__pa(initrd_start),
-					   PAGE_ALIGN(size));
+			memblock_free((void *)initrd_start, PAGE_ALIGN(size));
 			if (!move_initrd(pci_mem))
 				printk("irongate_init_arch: initrd too big "
 				       "(%ldK)\ndisabling initrd\n",
--- a/arch/mips/mm/init.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/mips/mm/init.c
@@ -529,7 +529,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_phys_free(__pa(ptr), size);
+	memblock_free(ptr, size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -1095,8 +1095,8 @@ static int __init dt_cpu_ftrs_scan_callb
 
 	cpufeatures_setup_finished();
 
-	memblock_phys_free(__pa(dt_cpu_features),
-			   sizeof(struct dt_cpu_feature) * nr_dt_cpu_features);
+	memblock_free(dt_cpu_features,
+		      sizeof(struct dt_cpu_feature) * nr_dt_cpu_features);
 
 	return 0;
 }
--- a/arch/powerpc/kernel/setup_64.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/powerpc/kernel/setup_64.c
@@ -812,7 +812,7 @@ static void * __init pcpu_alloc_bootmem(
 
 static void __init pcpu_free_bootmem(void *ptr, size_t size)
 {
-	memblock_phys_free(__pa(ptr), size);
+	memblock_free(ptr, size);
 }
 
 static int pcpu_cpu_distance(unsigned int from, unsigned int to)
--- a/arch/powerpc/kernel/setup-common.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/powerpc/kernel/setup-common.c
@@ -825,7 +825,7 @@ static void __init smp_setup_pacas(void)
 		set_hard_smp_processor_id(cpu, cpu_to_phys_id[cpu]);
 	}
 
-	memblock_phys_free(__pa(cpu_to_phys_id), nr_cpu_ids * sizeof(u32));
+	memblock_free(cpu_to_phys_id, nr_cpu_ids * sizeof(u32));
 	cpu_to_phys_id = NULL;
 }
 #endif
--- a/arch/powerpc/platforms/powernv/pci-ioda.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2981,7 +2981,7 @@ static void __init pnv_pci_init_ioda_phb
 	if (!phb->hose) {
 		pr_err("  Can't allocate PCI controller for %pOF\n",
 		       np);
-		memblock_phys_free(__pa(phb), sizeof(struct pnv_phb));
+		memblock_free(phb, sizeof(struct pnv_phb));
 		return;
 	}
 
--- a/arch/powerpc/platforms/pseries/svm.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/powerpc/platforms/pseries/svm.c
@@ -56,8 +56,7 @@ void __init svm_swiotlb_init(void)
 		return;
 
 
-	memblock_phys_free(__pa(vstart),
-			   PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+	memblock_free(vstart, PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	panic("SVM: Cannot allocate SWIOTLB buffer");
 }
 
--- a/arch/riscv/kernel/setup.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/riscv/kernel/setup.c
@@ -230,14 +230,13 @@ static void __init init_resources(void)
 
 	/* Clean-up any unused pre-allocated resources */
 	if (res_idx >= 0)
-		memblock_phys_free(__pa(mem_res),
-				   (res_idx + 1) * sizeof(*mem_res));
+		memblock_free(mem_res, (res_idx + 1) * sizeof(*mem_res));
 	return;
 
  error:
 	/* Better an empty resource tree than an inconsistent one */
 	release_child_resources(&iomem_resource);
-	memblock_phys_free(__pa(mem_res), mem_res_sz);
+	memblock_free(mem_res, mem_res_sz);
 }
 
 
--- a/arch/sparc/kernel/smp_64.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/sparc/kernel/smp_64.c
@@ -1567,7 +1567,7 @@ static void * __init pcpu_alloc_bootmem(
 
 static void __init pcpu_free_bootmem(void *ptr, size_t size)
 {
-	memblock_phys_free(__pa(ptr), size);
+	memblock_free(ptr, size);
 }
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
--- a/arch/um/kernel/mem.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/um/kernel/mem.c
@@ -47,7 +47,7 @@ void __init mem_init(void)
 	 */
 	brk_end = (unsigned long) UML_ROUND_UP(sbrk(0));
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
-	memblock_phys_free(__pa(brk_end), uml_reserved - brk_end);
+	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
 
 	/* this will put all low memory onto the freelists */
--- a/arch/x86/kernel/setup_percpu.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/kernel/setup_percpu.c
@@ -135,7 +135,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free_ptr(ptr, size);
+	memblock_free(ptr, size);
 }
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
--- a/arch/x86/mm/kasan_init_64.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/mm/kasan_init_64.c
@@ -49,7 +49,7 @@ static void __init kasan_populate_pmd(pm
 			p = early_alloc(PMD_SIZE, nid, false);
 			if (p && pmd_set_huge(pmd, __pa(p), PAGE_KERNEL))
 				return;
-			memblock_free_ptr(p, PMD_SIZE);
+			memblock_free(p, PMD_SIZE);
 		}
 
 		p = early_alloc(PAGE_SIZE, nid, true);
@@ -85,7 +85,7 @@ static void __init kasan_populate_pud(pu
 			p = early_alloc(PUD_SIZE, nid, false);
 			if (p && pud_set_huge(pud, __pa(p), PAGE_KERNEL))
 				return;
-			memblock_free_ptr(p, PUD_SIZE);
+			memblock_free(p, PUD_SIZE);
 		}
 
 		p = early_alloc(PAGE_SIZE, nid, true);
--- a/arch/x86/mm/numa.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/mm/numa.c
@@ -355,7 +355,7 @@ void __init numa_reset_distance(void)
 
 	/* numa_distance could be 1LU marking allocation failure, test cnt */
 	if (numa_distance_cnt)
-		memblock_free_ptr(numa_distance, size);
+		memblock_free(numa_distance, size);
 	numa_distance_cnt = 0;
 	numa_distance = NULL;	/* enable table creation */
 }
--- a/arch/x86/mm/numa_emulation.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/mm/numa_emulation.c
@@ -517,7 +517,7 @@ void __init numa_emulation(struct numa_m
 	}
 
 	/* free the copied physical distance table */
-	memblock_free_ptr(phys_dist, phys_size);
+	memblock_free(phys_dist, phys_size);
 	return;
 
 no_emu:
--- a/arch/x86/xen/mmu_pv.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/xen/mmu_pv.c
@@ -1151,7 +1151,7 @@ static void __init xen_pagetable_p2m_fre
 		xen_cleanhighmap(addr, addr + size);
 		size = PAGE_ALIGN(xen_start_info->nr_pages *
 				  sizeof(unsigned long));
-		memblock_phys_free(__pa(addr), size);
+		memblock_free((void *)addr, size);
 	} else {
 		xen_cleanmfnmap(addr);
 	}
--- a/arch/x86/xen/p2m.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/arch/x86/xen/p2m.c
@@ -197,7 +197,7 @@ static void * __ref alloc_p2m_page(void)
 static void __ref free_p2m_page(void *p)
 {
 	if (unlikely(!slab_is_available())) {
-		memblock_free_ptr(p, PAGE_SIZE);
+		memblock_free(p, PAGE_SIZE);
 		return;
 	}
 
--- a/drivers/base/arch_numa.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/drivers/base/arch_numa.c
@@ -166,7 +166,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_phys_free(__pa(ptr), size);
+	memblock_free(ptr, size);
 }
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
@@ -326,7 +326,7 @@ void __init numa_free_distance(void)
 	size = numa_distance_cnt * numa_distance_cnt *
 		sizeof(numa_distance[0]);
 
-	memblock_free_ptr(numa_distance, size);
+	memblock_free(numa_distance, size);
 	numa_distance_cnt = 0;
 	numa_distance = NULL;
 }
--- a/drivers/macintosh/smu.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/drivers/macintosh/smu.c
@@ -570,7 +570,7 @@ fail_msg_node:
 fail_db_node:
 	of_node_put(smu->db_node);
 fail_bootmem:
-	memblock_free_ptr(smu, sizeof(struct smu_device));
+	memblock_free(smu, sizeof(struct smu_device));
 	smu = NULL;
 fail_np:
 	of_node_put(np);
--- a/drivers/xen/swiotlb-xen.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/drivers/xen/swiotlb-xen.c
@@ -241,7 +241,7 @@ retry:
 	 */
 	rc = xen_swiotlb_fixup(start, nslabs);
 	if (rc) {
-		memblock_phys_free(__pa(start), PAGE_ALIGN(bytes));
+		memblock_free(start, PAGE_ALIGN(bytes));
 		if (nslabs > 1024 && repeat--) {
 			/* Min is 2MB */
 			nslabs = max(1024UL, ALIGN(nslabs >> 1, IO_TLB_SEGSIZE));
--- a/include/linux/memblock.h~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/include/linux/memblock.h
@@ -118,7 +118,7 @@ int memblock_mark_nomap(phys_addr_t base
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 
 void memblock_free_all(void);
-void memblock_free_ptr(void *ptr, size_t size);
+void memblock_free(void *ptr, size_t size);
 void reset_node_managed_pages(pg_data_t *pgdat);
 void reset_all_zones_managed_pages(void);
 
--- a/init/initramfs.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/init/initramfs.c
@@ -607,7 +607,7 @@ void __weak __init free_initrd_mem(unsig
 	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
 	unsigned long aligned_end = ALIGN(end, PAGE_SIZE);
 
-	memblock_phys_free(__pa(aligned_start), aligned_end - aligned_start);
+	memblock_free((void *)aligned_start, aligned_end - aligned_start);
 #endif
 
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
--- a/init/main.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/init/main.c
@@ -382,7 +382,7 @@ static char * __init xbc_make_cmdline(co
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
-		memblock_free_ptr(new_cmdline, len + 1);
+		memblock_free(new_cmdline, len + 1);
 		return NULL;
 	}
 
@@ -925,7 +925,7 @@ static void __init print_unknown_bootopt
 		end += sprintf(end, " %s", *p);
 
 	pr_notice("Unknown command line parameters:%s\n", unknown_options);
-	memblock_free_ptr(unknown_options, len);
+	memblock_free(unknown_options, len);
 }
 
 asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
--- a/kernel/dma/swiotlb.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/kernel/dma/swiotlb.c
@@ -247,7 +247,7 @@ swiotlb_init(int verbose)
 	return;
 
 fail_free_mem:
-	memblock_phys_free(__pa(tlb), bytes);
+	memblock_free(tlb, bytes);
 fail:
 	pr_warn("Cannot allocate buffer");
 }
--- a/kernel/printk/printk.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/kernel/printk/printk.c
@@ -1166,9 +1166,9 @@ void __init setup_log_buf(int early)
 	return;
 
 err_free_descs:
-	memblock_free_ptr(new_descs, new_descs_size);
+	memblock_free(new_descs, new_descs_size);
 err_free_log_buf:
-	memblock_free_ptr(new_log_buf, new_log_buf_len);
+	memblock_free(new_log_buf, new_log_buf_len);
 }
 
 static bool __read_mostly ignore_loglevel;
--- a/lib/bootconfig.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/lib/bootconfig.c
@@ -792,7 +792,7 @@ void __init xbc_destroy_all(void)
 	xbc_data = NULL;
 	xbc_data_size = 0;
 	xbc_node_num = 0;
-	memblock_free_ptr(xbc_nodes, sizeof(struct xbc_node) * XBC_NODE_MAX);
+	memblock_free(xbc_nodes, sizeof(struct xbc_node) * XBC_NODE_MAX);
 	xbc_nodes = NULL;
 	brace_index = 0;
 }
--- a/lib/cpumask.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/lib/cpumask.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	memblock_phys_free(__pa(mask), cpumask_size());
+	memblock_free(mask, cpumask_size());
 }
 #endif
 
--- a/mm/memblock.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/mm/memblock.c
@@ -472,7 +472,7 @@ static int __init_memblock memblock_doub
 		kfree(old_array);
 	else if (old_array != memblock_memory_init_regions &&
 		 old_array != memblock_reserved_init_regions)
-		memblock_free_ptr(old_array, old_alloc_size);
+		memblock_free(old_array, old_alloc_size);
 
 	/*
 	 * Reserve the new array if that comes from the memblock.  Otherwise, we
@@ -796,14 +796,14 @@ int __init_memblock memblock_remove(phys
 }
 
 /**
- * memblock_free_ptr - free boot memory allocation
+ * memblock_free - free boot memory allocation
  * @ptr: starting address of the  boot memory allocation
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_alloc_xx() API.
  * The freeing memory will not be released to the buddy allocator.
  */
-void __init_memblock memblock_free_ptr(void *ptr, size_t size)
+void __init_memblock memblock_free(void *ptr, size_t size)
 {
 	if (ptr)
 		memblock_phys_free(__pa(ptr), size);
--- a/mm/percpu.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/mm/percpu.c
@@ -2472,7 +2472,7 @@ struct pcpu_alloc_info * __init pcpu_all
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	memblock_phys_free(__pa(ai), ai->__ai_size);
+	memblock_free(ai, ai->__ai_size);
 }
 
 /**
@@ -3134,7 +3134,7 @@ out_free_areas:
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
-		memblock_phys_free(__pa(areas), areas_size);
+		memblock_free(areas, areas_size);
 	return rc;
 }
 #endif /* BUILD_EMBED_FIRST_CHUNK */
@@ -3256,7 +3256,7 @@ enomem:
 		free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
-	memblock_phys_free(__pa(pages), pages_size);
+	memblock_free(pages, pages_size);
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
@@ -3286,7 +3286,7 @@ static void * __init pcpu_dfl_fc_alloc(u
 
 static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
 {
-	memblock_phys_free(__pa(ptr), size);
+	memblock_free(ptr, size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/mm/sparse.c~memblock-use-memblock_free-for-freeing-virtual-pointers
+++ a/mm/sparse.c
@@ -451,7 +451,7 @@ static void *sparsemap_buf_end __meminit
 static inline void __meminit sparse_buffer_free(unsigned long size)
 {
 	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_phys_free(__pa(sparsemap_buf), size);
+	memblock_free(sparsemap_buf, size);
 }
 
 static void __init sparse_buffer_init(unsigned long size, int nid)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


