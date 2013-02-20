From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 20 Feb 2013 12:38:54 -0800
Message-ID: <20130220203854.879D15A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37158 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab3BTUiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 15:38:55 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so552913ggi.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 12:38:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig                  |   41 --------------------
 arch/x86/Kconfig                   |    5 --
 arch/x86/include/asm/pgtable.h     |   14 -------
 arch/x86/kernel/head32.c           |   17 --------
 arch/x86/kernel/head64.c           |    8 ----
 drivers/edac/amd64_edac.c          |   21 ----------
 drivers/gpio/Kconfig               |    3 -
 drivers/input/keyboard/tegra-kbc.c |    3 -
 drivers/pinctrl/pinctrl-nomadik.c  |    9 ----
 drivers/spi/spi-s3c64xx.c          |   53 ---------------------------
 include/asm-generic/vmlinux.lds.h  |    5 --
 include/linux/mfd/abx500/ab8500.h  |    3 -
 kernel/context_tracking.c          |   20 ----------
 13 files changed, 202 deletions(-)

diff -puN arch/s390/Kconfig~linux-next-git-rejects arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-next-git-rejects
+++ a/arch/s390/Kconfig
@@ -60,47 +60,6 @@ config PCI_QUIRKS
 
 config S390
 	def_bool y
-<<<<<<< HEAD
-	select USE_GENERIC_SMP_HELPERS if SMP
-	select GENERIC_CPU_DEVICES if !SMP
-	select HAVE_SYSCALL_WRAPPERS
-	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_FTRACE_MCOUNT_RECORD
-	select HAVE_C_RECORDMCOUNT
-	select HAVE_SYSCALL_TRACEPOINTS
-	select SYSCTL_EXCEPTION_TRACE
-	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_OPROFILE
-	select HAVE_KPROBES
-	select HAVE_KRETPROBES
-	select HAVE_KVM if 64BIT
-	select HAVE_ARCH_TRACEHOOK
-	select INIT_ALL_POSSIBLE
-	select HAVE_PERF_EVENTS
-	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select HAVE_DEBUG_KMEMLEAK
-	select HAVE_KERNEL_GZIP
-	select HAVE_KERNEL_BZIP2
-	select HAVE_KERNEL_LZMA
-	select HAVE_KERNEL_LZO
-	select HAVE_KERNEL_XZ
-	select HAVE_ARCH_MUTEX_CPU_RELAX
-	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
-	select HAVE_BPF_JIT if 64BIT && PACK_STACK
-	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_MEMBLOCK
-	select HAVE_MEMBLOCK_NODE_MAP
-	select HAVE_CMPXCHG_LOCAL
-	select HAVE_CMPXCHG_DOUBLE
-	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
-	select HAVE_VIRT_CPU_ACCOUNTING
-	select VIRT_CPU_ACCOUNTING
-=======
->>>>>>> linux-next/akpm-base
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
--- a/arch/x86/Kconfig~linux-next-git-rejects
+++ a/arch/x86/Kconfig
@@ -115,15 +115,10 @@ config X86
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
-<<<<<<< HEAD
-	select GENERIC_SIGALTSTACK
-	select ARCH_USE_BUILTIN_BSWAP
-=======
 	select ARCH_USE_BUILTIN_BSWAP
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
->>>>>>> linux-next/akpm-base
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/include/asm/pgtable.h~linux-next-git-rejects arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/pgtable.h
@@ -801,19 +801,6 @@ static inline void clone_pgd_range(pgd_t
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
-<<<<<<< HEAD
-/*
- * The x86 doesn't have any external MMU info: the kernel page
- * tables contain all the necessary information.
- */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-}
-static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmd)
-{
-=======
 #define PTE_SHIFT ilog2(PTRS_PER_PTE)
 static inline int page_level_shift(enum pg_level level)
 {
@@ -826,7 +813,6 @@ static inline unsigned long page_level_s
 static inline unsigned long page_level_mask(enum pg_level level)
 {
 	return ~(page_level_size(level) - 1);
->>>>>>> linux-next/akpm-base
 }
 
 #include <asm-generic/pgtable.h>
diff -puN arch/x86/kernel/head32.c~linux-next-git-rejects arch/x86/kernel/head32.c
--- a/arch/x86/kernel/head32.c~linux-next-git-rejects
+++ a/arch/x86/kernel/head32.c
@@ -32,23 +32,6 @@ static void __init i386_default_early_se
 void __init i386_start_kernel(void)
 {
 	sanitize_boot_params(&boot_params);
-<<<<<<< HEAD
-
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Reserve INITRD */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		/* Assume only end is not page aligned */
-		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
-	}
-#endif
-=======
->>>>>>> linux-next/akpm-base
 
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
diff -puN arch/x86/kernel/head64.c~linux-next-git-rejects arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~linux-next-git-rejects
+++ a/arch/x86/kernel/head64.c
@@ -26,10 +26,7 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 #include <asm/bootparam_utils.h>
-<<<<<<< HEAD
-=======
 #include <asm/microcode.h>
->>>>>>> linux-next/akpm-base
 
 /*
  * Manage page tables very early on.
@@ -132,14 +129,9 @@ static void __init copy_bootdata(char *r
 
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
 	sanitize_boot_params(&boot_params);
-<<<<<<< HEAD
-	if (boot_params.hdr.cmd_line_ptr) {
-		command_line = __va(boot_params.hdr.cmd_line_ptr);
-=======
 	cmd_line_ptr = get_cmd_line_ptr();
 	if (cmd_line_ptr) {
 		command_line = __va(cmd_line_ptr);
->>>>>>> linux-next/akpm-base
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
 }
diff -puN drivers/edac/amd64_edac.c~linux-next-git-rejects drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c~linux-next-git-rejects
+++ a/drivers/edac/amd64_edac.c
@@ -918,7 +918,6 @@ static void read_dram_base_limit_regs(st
 	nb = node_to_amd_nb(dram_dst_node(pvt, range));
 	if (WARN_ON(!nb))
 		return;
-<<<<<<< HEAD
 
 	misc = nb->misc;
 	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
@@ -937,26 +936,6 @@ static void read_dram_base_limit_regs(st
 				    /* [47:40] */
 	pvt->ranges[range].lim.hi |= llim >> 13;
 
-=======
-
-	misc = nb->misc;
-	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
-	if (WARN_ON(!f1))
-		return;
-
-	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
-
-	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
-
-				    /* {[39:27],111b} */
-	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
-
-	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
-
-				    /* [47:40] */
-	pvt->ranges[range].lim.hi |= llim >> 13;
-
->>>>>>> linux-next/akpm-base
 	pci_dev_put(f1);
 }
 
diff -puN drivers/gpio/Kconfig~linux-next-git-rejects drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~linux-next-git-rejects
+++ a/drivers/gpio/Kconfig
@@ -668,8 +668,6 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
-<<<<<<< HEAD
-=======
 config GPIO_PALMAS
 	bool "TI PALMAS series PMICs GPIO"
 	depends on MFD_PALMAS
@@ -677,7 +675,6 @@ config GPIO_PALMAS
 	  Select this option to enable GPIO driver for the TI PALMAS
 	  series chip family.
 
->>>>>>> linux-next/akpm-base
 config GPIO_TPS6586X
 	bool "TPS6586X GPIO"
 	depends on MFD_TPS6586X
diff -puN drivers/input/keyboard/tegra-kbc.c~linux-next-git-rejects drivers/input/keyboard/tegra-kbc.c
--- a/drivers/input/keyboard/tegra-kbc.c~linux-next-git-rejects
+++ a/drivers/input/keyboard/tegra-kbc.c
@@ -30,9 +30,7 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/input/matrix_keypad.h>
-<<<<<<< HEAD
 #include <mach/clk.h>
-=======
 #include <linux/clk/tegra.h>
 
 #define KBC_MAX_GPIO	24
@@ -41,7 +39,6 @@
 #define KBC_MAX_ROW	16
 #define KBC_MAX_COL	8
 #define KBC_MAX_KEY	(KBC_MAX_ROW * KBC_MAX_COL)
->>>>>>> linux-next/akpm-base
 
 #define KBC_MAX_GPIO	24
 #define KBC_MAX_KPENT	8
diff -puN drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects drivers/pinctrl/pinctrl-nomadik.c
--- a/drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-nomadik.c
@@ -1362,15 +1362,9 @@ static int nmk_gpio_probe(struct platfor
 	if (secondary_irq >= 0 && !pdata->get_secondary_status)
 		return -EINVAL;
 
-<<<<<<< HEAD
-	base = devm_request_and_ioremap(&dev->dev, res);
-	if (!base)
-		return -ENOMEM;
-=======
 	base = devm_ioremap_resource(&dev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
->>>>>>> linux-next/akpm-base
 
 	clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(clk))
@@ -2110,13 +2104,10 @@ static struct pinctrl_desc nmk_pinctrl_d
 
 static const struct of_device_id nmk_pinctrl_match[] = {
 	{
-<<<<<<< HEAD
-=======
 		.compatible = "stericsson,nmk-pinctrl-stn8815",
 		.data = (void *)PINCTRL_NMK_STN8815,
 	},
 	{
->>>>>>> linux-next/akpm-base
 		.compatible = "stericsson,nmk-pinctrl",
 		.data = (void *)PINCTRL_NMK_DB8500,
 	},
diff -puN drivers/spi/spi-s3c64xx.c~linux-next-git-rejects drivers/spi/spi-s3c64xx.c
--- a/drivers/spi/spi-s3c64xx.c~linux-next-git-rejects
+++ a/drivers/spi/spi-s3c64xx.c
@@ -1051,52 +1051,6 @@ static void s3c64xx_spi_hwinit(struct s3
 	flush_fifo(sdd);
 }
 
-<<<<<<< HEAD
-static int s3c64xx_spi_get_dmares(
-			struct s3c64xx_spi_driver_data *sdd, bool tx)
-{
-	struct platform_device *pdev = sdd->pdev;
-	struct s3c64xx_spi_dma_data *dma_data;
-	struct property *prop;
-	struct resource *res;
-	char prop_name[15], *chan_str;
-
-	if (tx) {
-		dma_data = &sdd->tx_dma;
-		dma_data->direction = DMA_MEM_TO_DEV;
-		chan_str = "tx";
-	} else {
-		dma_data = &sdd->rx_dma;
-		dma_data->direction = DMA_DEV_TO_MEM;
-		chan_str = "rx";
-	}
-
-	if (!sdd->pdev->dev.of_node) {
-		res = platform_get_resource(pdev, IORESOURCE_DMA, tx ? 0 : 1);
-		if (!res) {
-			dev_err(&pdev->dev, "Unable to get SPI-%s dma resource\n",
-				chan_str);
-			return -ENXIO;
-		}
-		dma_data->dmach = res->start;
-		return 0;
-	}
-
-	sprintf(prop_name, "%s-dma-channel", chan_str);
-	prop = of_find_property(pdev->dev.of_node, prop_name, NULL);
-	if (!prop) {
-		dev_err(&pdev->dev, "%s dma channel property not specified\n",
-					chan_str);
-		return -ENXIO;
-	}
-
-	dma_data->dmach = DMACH_DT_PROP;
-	dma_data->dma_prop = prop;
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_OF
 static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
 {
@@ -1287,16 +1241,9 @@ static int s3c64xx_spi_probe(struct plat
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
-<<<<<<< HEAD
-	sdd->regs = devm_request_and_ioremap(&pdev->dev, mem_res);
-	if (sdd->regs == NULL) {
-		dev_err(&pdev->dev, "Unable to remap IO\n");
-		ret = -ENXIO;
-=======
 	sdd->regs = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(sdd->regs)) {
 		ret = PTR_ERR(sdd->regs);
->>>>>>> linux-next/akpm-base
 		goto err0;
 	}
 
diff -puN include/asm-generic/vmlinux.lds.h~linux-next-git-rejects include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~linux-next-git-rejects
+++ a/include/asm-generic/vmlinux.lds.h
@@ -529,15 +529,10 @@
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
-<<<<<<< HEAD
-	CLK_OF_TABLES()							\
-	KERNEL_DTB()
-=======
 	CLKSRC_OF_TABLES()						\
 	CLK_OF_TABLES()							\
 	KERNEL_DTB()							\
 	IRQCHIP_OF_MATCH_TABLE()
->>>>>>> linux-next/akpm-base
 
 #define INIT_TEXT							\
 	*(.init.text)							\
diff -puN include/linux/mfd/abx500/ab8500.h~linux-next-git-rejects include/linux/mfd/abx500/ab8500.h
--- a/include/linux/mfd/abx500/ab8500.h~linux-next-git-rejects
+++ a/include/linux/mfd/abx500/ab8500.h
@@ -512,8 +512,6 @@ static inline int is_ab9540_2p0_or_earli
 	return (is_ab9540(ab) && (ab->chip_id < AB8500_CUT2P0));
 }
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_AB8500_DEBUG
 void ab8500_dump_all_banks(struct device *dev);
 void ab8500_debug_register_interrupt(int line);
@@ -522,5 +520,4 @@ static inline void ab8500_dump_all_banks
 static inline void ab8500_debug_register_interrupt(int line) {}
 #endif
 
->>>>>>> linux-next/akpm-base
 #endif /* MFD_AB8500_H */
diff -puN kernel/context_tracking.c~linux-next-git-rejects kernel/context_tracking.c
--- a/kernel/context_tracking.c~linux-next-git-rejects
+++ a/kernel/context_tracking.c
@@ -103,8 +103,6 @@ void user_exit(void)
 	local_irq_restore(flags);
 }
 
-<<<<<<< HEAD
-=======
 
 /**
  * context_tracking_task_switch - context switch the syscall callbacks
@@ -119,7 +117,6 @@ void user_exit(void)
  * migrate to some CPU that doesn't do the context tracking. As such the TIF
  * flag may not be desired there.
  */
->>>>>>> linux-next/akpm-base
 void guest_enter(void)
 {
 	if (vtime_accounting_enabled())
@@ -138,23 +135,6 @@ void guest_exit(void)
 }
 EXPORT_SYMBOL_GPL(guest_exit);
 
-<<<<<<< HEAD
-
-/**
- * context_tracking_task_switch - context switch the syscall callbacks
- * @prev: the task that is being switched out
- * @next: the task that is being switched in
- *
- * The context tracking uses the syscall slow path to implement its user-kernel
- * boundaries probes on syscalls. This way it doesn't impact the syscall fast
- * path on CPUs that don't do context tracking.
- *
- * But we need to clear the flag on the previous task because it may later
- * migrate to some CPU that doesn't do the context tracking. As such the TIF
- * flag may not be desired there.
- */
-=======
->>>>>>> linux-next/akpm-base
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
ocfs2-remove-kfree-redundant-null-checks-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
kernel-smpc-cleanups.patch
maintainers-remove-mark-m-hoffman-fix.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

