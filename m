From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:04:03 -0700
Message-ID: <200906181804.n5II43b3002801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbZFRSEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/executive/cvmx-helper-errata.c |    8 -
 arch/mips/mm/tlbex.c                                   |    6 -
 arch/mips/sibyte/swarm/setup.c                         |    3 
 arch/x86/mm/init_32.c                                  |    4 
 arch/x86/mm/init_64.c                                  |   10 --
 arch/x86/mm/kmemcheck/kmemcheck.c                      |   16 ---
 drivers/net/wireless/ath/ath5k/Kconfig                 |    4 
 drivers/scsi/lpfc/lpfc_debugfs.c                       |    3 
 drivers/staging/Makefile                               |    4 
 drivers/staging/octeon/Kconfig                         |    4 
 include/linux/kmemcheck.h                              |   11 --
 kernel/sysctl.c                                        |    3 
 kernel/trace/trace.c                                   |    3 
 mm/Makefile                                            |    3 
 mm/page_alloc.c                                        |   48 ----------
 mm/slab.c                                              |    4 
 mm/slub.c                                              |    4 
 scripts/tracing/draw_functrace.py                      |    4 
 18 files changed, 142 deletions(-)

diff -puN arch/x86/mm/init_32.c~linux-next-git-rejects arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~linux-next-git-rejects
+++ a/arch/x86/mm/init_32.c
@@ -116,12 +116,8 @@ static pte_t * __init one_page_table_ini
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
-<<<<<<< HEAD:arch/x86/mm/init_32.c
-		if (after_bootmem) {
-=======
 		switch (bootmem_state) {
 		case DURING_BOOTMEM:
->>>>>>> FETCH_HEAD:arch/x86/mm/init_32.c
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
diff -puN arch/x86/mm/init_64.c~linux-next-git-rejects arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~linux-next-git-rejects
+++ a/arch/x86/mm/init_64.c
@@ -103,17 +103,11 @@ static __ref void *spp_getpage(void)
 {
 	void *ptr = NULL;
 
-<<<<<<< HEAD:arch/x86/mm/init_64.c
-	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
-	else
-=======
 	switch (bootmem_state) {
 	case AFTER_BOOTMEM:
 		ptr = (void *) get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
 		break;
 	case DURING_BOOTMEM:
->>>>>>> FETCH_HEAD:arch/x86/mm/init_64.c
 		ptr = alloc_bootmem_pages(PAGE_SIZE);
 		break;
 	default:
@@ -292,11 +286,7 @@ static __ref void *alloc_low_page(unsign
 	unsigned long pfn;
 	void *adr;
 
-<<<<<<< HEAD:arch/x86/mm/init_64.c
-	if (after_bootmem) {
-=======
 	if (bootmem_state == AFTER_BOOTMEM) {
->>>>>>> FETCH_HEAD:arch/x86/mm/init_64.c
 		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
 		*phys = __pa(adr);
 
diff -puN arch/x86/mm/kmemcheck/kmemcheck.c~linux-next-git-rejects arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c~linux-next-git-rejects
+++ a/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -47,11 +47,7 @@
 
 int kmemcheck_enabled = KMEMCHECK_ENABLED;
 
-<<<<<<< HEAD:arch/x86/mm/kmemcheck/kmemcheck.c
-int __init kmemcheck_init(void)
-=======
 void __init kmemcheck_init(void)
->>>>>>> FETCH_HEAD:arch/x86/mm/kmemcheck/kmemcheck.c
 {
 #ifdef CONFIG_SMP
 	/*
@@ -68,24 +64,12 @@ void __init kmemcheck_init(void)
 	if (!kmemcheck_selftest()) {
 		printk(KERN_INFO "kmemcheck: self-tests failed; disabling\n");
 		kmemcheck_enabled = 0;
-<<<<<<< HEAD:arch/x86/mm/kmemcheck/kmemcheck.c
-		return -EINVAL;
-	}
-
-	printk(KERN_INFO "kmemcheck: Initialized\n");
-	return 0;
-}
-
-early_initcall(kmemcheck_init);
-
-=======
 		return;
 	}
 
 	printk(KERN_INFO "kmemcheck: Initialized\n");
 }
 
->>>>>>> FETCH_HEAD:arch/x86/mm/kmemcheck/kmemcheck.c
 /*
  * We need to parse the kmemcheck= option before any memory is allocated.
  */
diff -puN drivers/net/wireless/ath/ath5k/Kconfig~linux-next-git-rejects drivers/net/wireless/ath/ath5k/Kconfig
--- a/drivers/net/wireless/ath/ath5k/Kconfig~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/ath5k/Kconfig
@@ -28,12 +28,8 @@ config ATH5K_DEBUG
 	  Say Y, if and you will get debug options for ath5k.
 	  To use this, you need to mount debugfs:
 
-<<<<<<< HEAD:drivers/net/wireless/ath/ath5k/Kconfig
-	  mount -t debugfs debug /sys/kernel/debug
-=======
 	  mkdir /sys/kernel/debug/
 	  mount -t debugfs debug /sys/kernel/debug/
->>>>>>> FETCH_HEAD:drivers/net/wireless/ath/ath5k/Kconfig
 
 	  You will get access to files under:
 	  /sys/kernel/debug/ath5k/phy0/
diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~linux-next-git-rejects drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~linux-next-git-rejects
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -53,10 +53,7 @@
  * debugfs interface
  *
  * To access this interface the user should:
-<<<<<<< HEAD:drivers/scsi/lpfc/lpfc_debugfs.c
-=======
  * # mkdir /sys/kernel/debug
->>>>>>> FETCH_HEAD:drivers/scsi/lpfc/lpfc_debugfs.c
  * # mount -t debugfs none /sys/kernel/debug
  *
  * The lpfc debugfs directory hierarchy is:
diff -puN include/linux/kmemcheck.h~linux-next-git-rejects include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h~linux-next-git-rejects
+++ a/include/linux/kmemcheck.h
@@ -7,11 +7,8 @@
 #ifdef CONFIG_KMEMCHECK
 extern int kmemcheck_enabled;
 
-<<<<<<< HEAD:include/linux/kmemcheck.h
-=======
 void kmemcheck_init(void);
 
->>>>>>> FETCH_HEAD:include/linux/kmemcheck.h
 /* The slab-related functions. */
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node);
 void kmemcheck_free_shadow(struct page *page, int order);
@@ -42,13 +39,10 @@ int kmemcheck_hide_addr(unsigned long ad
 #else
 #define kmemcheck_enabled 0
 
-<<<<<<< HEAD:include/linux/kmemcheck.h
-=======
 static inline void kmemcheck_init(void)
 {
 }
 
->>>>>>> FETCH_HEAD:include/linux/kmemcheck.h
 static inline void
 kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
 {
@@ -114,11 +108,6 @@ static inline void kmemcheck_mark_initia
 #endif /* CONFIG_KMEMCHECK */
 
 /*
-<<<<<<< HEAD:include/linux/kmemcheck.h
- * Bitfield annotations
- *
-=======
->>>>>>> FETCH_HEAD:include/linux/kmemcheck.h
  * How to use: If you have a struct using bitfields, for example
  *
  *     struct a {
diff -puN kernel/sysctl.c~linux-next-git-rejects kernel/sysctl.c
--- a/kernel/sysctl.c~linux-next-git-rejects
+++ a/kernel/sysctl.c
@@ -1337,8 +1337,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-<<<<<<< HEAD:kernel/sysctl.c
-=======
 #ifdef CONFIG_KMEMCHECK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1350,7 +1348,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 #ifdef CONFIG_UNEVICTABLE_LRU
->>>>>>> FETCH_HEAD:kernel/sysctl.c
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "scan_unevictable_pages",
diff -puN kernel/trace/trace.c~linux-next-git-rejects kernel/trace/trace.c
--- a/kernel/trace/trace.c~linux-next-git-rejects
+++ a/kernel/trace/trace.c
@@ -2412,10 +2412,7 @@ static const struct file_operations trac
 
 static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
-<<<<<<< HEAD:kernel/trace/trace.c
-=======
 	"# mkdir /sys/kernel/debug\n"
->>>>>>> FETCH_HEAD:kernel/trace/trace.c
 	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
 	"# cat /sys/kernel/debug/tracing/available_tracers\n"
 	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
diff -puN mm/Makefile~linux-next-git-rejects mm/Makefile
--- a/mm/Makefile~linux-next-git-rejects
+++ a/mm/Makefile
@@ -28,10 +28,7 @@ obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifi
 obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
-<<<<<<< HEAD:mm/Makefile
-=======
 obj-$(CONFIG_SLQB) += slqb.o
->>>>>>> FETCH_HEAD:mm/Makefile
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
diff -puN mm/page_alloc.c~linux-next-git-rejects mm/page_alloc.c
--- a/mm/page_alloc.c~linux-next-git-rejects
+++ a/mm/page_alloc.c
@@ -1851,54 +1851,6 @@ nopage:
 got_pg:
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
-<<<<<<< HEAD:mm/page_alloc.c
-	return page;
-
-}
-
-/*
- * This is the 'heart' of the zoned buddy allocator.
- */
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-			struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	struct zone *preferred_zone;
-	struct page *page;
-	int migratetype = allocflags_to_migratetype(gfp_mask);
-
-	lockdep_trace_alloc(gfp_mask);
-
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	if (should_fail_alloc_page(gfp_mask, order))
-		return NULL;
-
-	/*
-	 * Check the zones suitable for the gfp_mask contain at least one
-	 * valid zone. It's possible to have an empty zonelist as a result
-	 * of GFP_THISNODE and a memoryless node
-	 */
-	if (unlikely(!zonelist->_zonerefs->zone))
-		return NULL;
-
-	/* The preferred zone is used for statistics later */
-	first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
-	if (!preferred_zone)
-		return NULL;
-
-	/* First allocation attempt */
-	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
-			preferred_zone, migratetype);
-	if (unlikely(!page))
-		page = __alloc_pages_slowpath(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
-
-=======
->>>>>>> FETCH_HEAD:mm/page_alloc.c
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
diff -puN mm/slab.c~linux-next-git-rejects mm/slab.c
--- a/mm/slab.c~linux-next-git-rejects
+++ a/mm/slab.c
@@ -1625,11 +1625,7 @@ static void *kmem_getpages(struct kmem_c
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-<<<<<<< HEAD:mm/slab.c
-	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
-=======
 	page = alloc_pages_node(nodeid, flags & ~__GFP_NOTRACK, cachep->gfporder);
->>>>>>> FETCH_HEAD:mm/slab.c
 	if (!page)
 		return NULL;
 
diff -puN mm/slub.c~linux-next-git-rejects mm/slub.c
--- a/mm/slub.c~linux-next-git-rejects
+++ a/mm/slub.c
@@ -2733,11 +2733,7 @@ static noinline struct kmem_cache *dma_k
 	 * need to do anything because our sysfs initcall will start by
 	 * adding all existing slabs to sysfs.
 	 */
-<<<<<<< HEAD:mm/slub.c
-	slabflags = SLAB_CACHE_DMA|SLAB_NOTRACK;
-=======
 	slabflags = SLAB_CACHE_DMA | SLAB_NOTRACK;
->>>>>>> FETCH_HEAD:mm/slub.c
 	if (slab_state >= SYSFS)
 		slabflags |= __SYSFS_ADD_DEFERRED;
 
diff -puN scripts/tracing/draw_functrace.py~linux-next-git-rejects scripts/tracing/draw_functrace.py
--- a/scripts/tracing/draw_functrace.py~linux-next-git-rejects
+++ a/scripts/tracing/draw_functrace.py
@@ -12,12 +12,8 @@ calls. Only the functions's names and th
 
 Usage:
 	Be sure that you have CONFIG_FUNCTION_TRACER
-<<<<<<< HEAD:scripts/tracing/draw_functrace.py
-	# mount -t debugfs nodev /sys/kernel/debug
-=======
 	# mkdir /sys/kernel/debug
 	# mount -t debug debug /sys/kernel/debug
->>>>>>> FETCH_HEAD:scripts/tracing/draw_functrace.py
 	# echo function > /sys/kernel/debug/tracing/current_tracer
 	$ cat /sys/kernel/debug/tracing/trace_pipe > ~/raw_trace_func
 	Wait some times but not too much, the script is a bit slow.
diff -puN arch/mips/cavium-octeon/executive/cvmx-helper-errata.c~linux-next-git-rejects arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-errata.c~linux-next-git-rejects
+++ a/arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
@@ -33,11 +33,6 @@
  * these functions directly.
  *
  */
-<<<<<<< HEAD:arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
-#include <linux/module.h>
-
-=======
->>>>>>> FETCH_HEAD:arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
 #include <asm/octeon/octeon.h>
 
 #include <asm/octeon/cvmx-helper-jtag.h>
@@ -73,7 +68,4 @@ void __cvmx_helper_errata_qlm_disable_2n
 	}
 	cvmx_helper_qlm_jtag_update(qlm);
 }
-<<<<<<< HEAD:arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
 EXPORT_SYMBOL(__cvmx_helper_errata_qlm_disable_2nd_order_cdr);
-=======
->>>>>>> FETCH_HEAD:arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
diff -puN arch/mips/mm/tlbex.c~linux-next-git-rejects arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~linux-next-git-rejects
+++ a/arch/mips/mm/tlbex.c
@@ -844,13 +844,7 @@ static void __cpuinit build_r4000_tlb_re
 		uasm_copy_handler(relocs, labels, tlb_handler, p, f);
 		final_len = p - tlb_handler;
 	} else {
-<<<<<<< HEAD:arch/mips/mm/tlbex.c
-#if defined(CONFIG_HUGETLB_PAGE)
-		const enum label_id ls = label_tlb_huge_update;
-#elif defined(MODULE_START)
-=======
 #ifdef MODULE_START
->>>>>>> FETCH_HEAD:arch/mips/mm/tlbex.c
 		const enum label_id ls = label_module_alloc;
 #else
 		const enum label_id ls = label_vmalloc;
diff -puN arch/mips/sibyte/swarm/setup.c~linux-next-git-rejects arch/mips/sibyte/swarm/setup.c
--- a/arch/mips/sibyte/swarm/setup.c~linux-next-git-rejects
+++ a/arch/mips/sibyte/swarm/setup.c
@@ -136,8 +136,6 @@ void __init plat_mem_setup(void)
 	if (m41t81_probe())
 		swarm_rtc_type = RTC_M4LT81;
 
-<<<<<<< HEAD:arch/mips/sibyte/swarm/setup.c
-=======
 	printk("This kernel optimized for "
 	       "board"
 	       " runs "
@@ -148,7 +146,6 @@ void __init plat_mem_setup(void)
 #endif
 	       " CFE\n");
 
->>>>>>> FETCH_HEAD:arch/mips/sibyte/swarm/setup.c
 #ifdef CONFIG_VT
 	screen_info = (struct screen_info) {
 		0, 0,           /* orig-x, orig-y */
diff -puN drivers/staging/Makefile~linux-next-git-rejects drivers/staging/Makefile
--- a/drivers/staging/Makefile~linux-next-git-rejects
+++ a/drivers/staging/Makefile
@@ -40,13 +40,9 @@ obj-$(CONFIG_IDE_PHISON)	+= phison/
 obj-$(CONFIG_PLAN9AUTH)		+= p9auth/
 obj-$(CONFIG_HECI)		+= heci/
 obj-$(CONFIG_LINE6_USB)		+= line6/
-<<<<<<< HEAD:drivers/staging/Makefile
-obj-$(CONFIG_USB_SERIAL_QUATECH_ESU100)	+= serqt_usb/
-=======
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
 obj-$(CONFIG_VT6655)		+= vt6655/
 obj-$(CONFIG_USB_CPC)		+= cpc-usb/
 obj-$(CONFIG_RDC_17F3101X)	+= pata_rdc/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
->>>>>>> FETCH_HEAD:drivers/staging/Makefile
 obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
diff -puN drivers/staging/octeon/Kconfig~linux-next-git-rejects drivers/staging/octeon/Kconfig
--- a/drivers/staging/octeon/Kconfig~linux-next-git-rejects
+++ a/drivers/staging/octeon/Kconfig
@@ -1,10 +1,6 @@
 config OCTEON_ETHERNET
 	tristate "Cavium Networks Octeon Ethernet support"
-<<<<<<< HEAD:drivers/staging/octeon/Kconfig
-	depends on CPU_CAVIUM_OCTEON
-=======
 	depends on CPU_CAVIUM_OCTEON && BROKEN
->>>>>>> FETCH_HEAD:drivers/staging/octeon/Kconfig
 	select MII
 	help
 	  This driver supports the builtin ethernet ports on Cavium
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
lib-add-lib-gcdc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix.patch
char-moxa-prevent-opening-unavailable-ports.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

