From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 19 Nov 2012 12:19:28 -0800
Message-ID: <20121119201930.450D5200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:54349 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2KSUTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:19:33 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so132224fae.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:19:32 -0800 (PST)
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

 arch/arm/mach-highbank/system.c                       |    4 -
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c            |    4 -
 arch/s390/include/asm/topology.h                      |    8 ---
 arch/s390/kernel/topology.c                           |   22 ----------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    4 -
 drivers/usb/early/ehci-dbgp.c                         |    8 ---
 drivers/usb/musb/ux500.c                              |    4 -
 fs/pstore/platform.c                                  |    4 -
 include/linux/clk-provider.h                          |    5 --
 mm/memcontrol.c                                       |   10 ----
 sound/soc/codecs/wm5102.c                             |   10 ----
 11 files changed, 83 deletions(-)

diff -puN arch/arm/mach-highbank/system.c~linux-next-git-rejects arch/arm/mach-highbank/system.c
--- a/arch/arm/mach-highbank/system.c~linux-next-git-rejects
+++ a/arch/arm/mach-highbank/system.c
@@ -26,10 +26,6 @@ void highbank_restart(char mode, const c
 	else
 		hignbank_set_pwr_soft_reset();
 
-<<<<<<< HEAD
-	scu_power_mode(scu_base_addr, SCU_PM_POWEROFF);
-=======
->>>>>>> linux-next/akpm-base
 	while (1)
 		cpu_do_idle();
 }
diff -puN arch/arm/mach-omap2/omap_hwmod_44xx_data.c~linux-next-git-rejects arch/arm/mach-omap2/omap_hwmod_44xx_data.c
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -21,14 +21,10 @@
 #include <linux/io.h>
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/power/smartreflex.h>
-<<<<<<< HEAD
-#include <linux/platform_data/omap_ocp2scp.h>
-=======
 #include <linux/i2c-omap.h>
 #include <linux/platform_data/omap_ocp2scp.h>
 
 #include <plat-omap/dma-omap.h>
->>>>>>> linux-next/akpm-base
 
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
diff -puN arch/s390/include/asm/topology.h~linux-next-git-rejects arch/s390/include/asm/topology.h
--- a/arch/s390/include/asm/topology.h~linux-next-git-rejects
+++ a/arch/s390/include/asm/topology.h
@@ -8,13 +8,6 @@ struct cpu;
 
 #ifdef CONFIG_SCHED_BOOK
 
-<<<<<<< HEAD
-extern unsigned char cpu_socket_id[NR_CPUS];
-#define topology_physical_package_id(cpu) (cpu_socket_id[cpu])
-
-extern unsigned char cpu_core_id[NR_CPUS];
-extern cpumask_t cpu_core_map[NR_CPUS];
-=======
 struct cpu_topology_s390 {
 	unsigned short core_id;
 	unsigned short socket_id;
@@ -32,7 +25,6 @@ extern struct cpu_topology_s390 cpu_topo
 #define topology_book_cpumask(cpu)		(&cpu_topology[cpu].book_mask)
 
 #define mc_capable() 1
->>>>>>> linux-next/akpm-base
 
 static inline const struct cpumask *cpu_coregroup_mask(int cpu)
 {
diff -puN arch/s390/kernel/topology.c~linux-next-git-rejects arch/s390/kernel/topology.c
--- a/arch/s390/kernel/topology.c~linux-next-git-rejects
+++ a/arch/s390/kernel/topology.c
@@ -33,15 +33,8 @@ static void set_topology_timer(void);
 static void topology_work_fn(struct work_struct *work);
 static struct sysinfo_15_1_x *tl_info;
 
-<<<<<<< HEAD
-static struct mask_info core_info;
-cpumask_t cpu_core_map[NR_CPUS];
-unsigned char cpu_core_id[NR_CPUS];
-unsigned char cpu_socket_id[NR_CPUS];
-=======
 static int topology_enabled = 1;
 static DECLARE_WORK(topology_work, topology_work_fn);
->>>>>>> linux-next/akpm-base
 
 /* topology_lock protects the socket and book linked lists */
 static DEFINE_SPINLOCK(topology_lock);
@@ -77,20 +70,6 @@ static struct mask_info *add_cpus_to_mas
 
 		rcpu = TOPOLOGY_CPU_BITS - 1 - cpu + tl_cpu->origin;
 		lcpu = smp_find_processor_id(rcpu);
-<<<<<<< HEAD
-		if (lcpu >= 0) {
-			cpumask_set_cpu(lcpu, &book->mask);
-			cpu_book_id[lcpu] = book->id;
-			cpumask_set_cpu(lcpu, &core->mask);
-			cpu_core_id[lcpu] = rcpu;
-			if (one_core_per_cpu) {
-				cpu_socket_id[lcpu] = rcpu;
-				core = core->next;
-			} else {
-				cpu_socket_id[lcpu] = core->id;
-			}
-			smp_cpu_set_polarization(lcpu, tl_cpu->pp);
-=======
 		if (lcpu < 0)
 			continue;
 		cpumask_set_cpu(lcpu, &book->mask);
@@ -102,7 +81,6 @@ static struct mask_info *add_cpus_to_mas
 			socket = socket->next;
 		} else {
 			cpu_topology[lcpu].socket_id = socket->id;
->>>>>>> linux-next/akpm-base
 		}
 		smp_cpu_set_polarization(lcpu, tl_cpu->pp);
 	}
diff -puN drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c~linux-next-git-rejects drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c~linux-next-git-rejects
+++ a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3754,10 +3754,6 @@ static s32 brcmf_mode_to_nl80211_iftype(
 
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
-<<<<<<< HEAD
-#ifndef CONFIG_BRCMISCAN
-=======
->>>>>>> linux-next/akpm-base
 	/* scheduled scan settings */
 	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
diff -puN drivers/usb/early/ehci-dbgp.c~linux-next-git-rejects drivers/usb/early/ehci-dbgp.c
--- a/drivers/usb/early/ehci-dbgp.c~linux-next-git-rejects
+++ a/drivers/usb/early/ehci-dbgp.c
@@ -974,11 +974,7 @@ struct console early_dbgp_console = {
 	.index =	-1,
 };
 
-<<<<<<< HEAD
-#if IS_ENABLED(CONFIG_USB_EHCI_HCD)
-=======
 #if IS_ENABLED(CONFIG_USB)
->>>>>>> linux-next/akpm-base
 int dbgp_reset_prep(struct usb_hcd *hcd)
 {
 	int ret = xen_dbgp_reset_prep(hcd);
@@ -1012,11 +1008,7 @@ int dbgp_external_startup(struct usb_hcd
 	return xen_dbgp_external_startup(hcd) ?: _dbgp_external_startup();
 }
 EXPORT_SYMBOL_GPL(dbgp_external_startup);
-<<<<<<< HEAD
-#endif /* USB_EHCI_HCD */
-=======
 #endif /* USB */
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_KGDB
 
diff -puN drivers/usb/musb/ux500.c~linux-next-git-rejects drivers/usb/musb/ux500.c
--- a/drivers/usb/musb/ux500.c~linux-next-git-rejects
+++ a/drivers/usb/musb/ux500.c
@@ -87,10 +87,6 @@ static int __devinit ux500_probe(struct 
 	struct platform_device		*musb;
 	struct ux500_glue		*glue;
 	struct clk			*clk;
-<<<<<<< HEAD
-	int				musbid;
-=======
->>>>>>> linux-next/akpm-base
 	int				ret = -ENOMEM;
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
diff -puN fs/pstore/platform.c~linux-next-git-rejects fs/pstore/platform.c
--- a/fs/pstore/platform.c~linux-next-git-rejects
+++ a/fs/pstore/platform.c
@@ -173,11 +173,7 @@ static void pstore_console_write(struct 
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
 		memcpy(psinfo->buf, s, c);
-<<<<<<< HEAD
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
-=======
 		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, 0, c, psinfo);
->>>>>>> linux-next/akpm-base
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
diff -puN include/linux/clk-provider.h~linux-next-git-rejects include/linux/clk-provider.h
--- a/include/linux/clk-provider.h~linux-next-git-rejects
+++ a/include/linux/clk-provider.h
@@ -341,13 +341,8 @@ const char *__clk_get_name(struct clk *c
 struct clk_hw *__clk_get_hw(struct clk *clk);
 u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
-<<<<<<< HEAD
-int __clk_get_enable_count(struct clk *clk);
-int __clk_get_prepare_count(struct clk *clk);
-=======
 inline unsigned int __clk_get_enable_count(struct clk *clk);
 inline unsigned int __clk_get_prepare_count(struct clk *clk);
->>>>>>> linux-next/akpm-base
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
diff -puN mm/memcontrol.c~linux-next-git-rejects mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-git-rejects
+++ a/mm/memcontrol.c
@@ -3720,13 +3720,9 @@ unsigned long mem_cgroup_soft_limit_recl
 static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
 {
-<<<<<<< HEAD
 	struct lruvec *lruvec;
-	unsigned long flags, loop;
-=======
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
->>>>>>> linux-next/akpm-base
 	struct list_head *list;
 	struct page *busy;
 	struct zone *zone;
@@ -3735,12 +3731,6 @@ static void mem_cgroup_force_empty_list(
 	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 	list = &lruvec->lists[lru];
 
-<<<<<<< HEAD
-	loop = mem_cgroup_get_lru_size(lruvec, lru);
-	/* give some margin against EBUSY etc...*/
-	loop += 256;
-=======
->>>>>>> linux-next/akpm-base
 	busy = NULL;
 	do {
 		struct page_cgroup *pc;
diff -puN sound/soc/codecs/wm5102.c~linux-next-git-rejects sound/soc/codecs/wm5102.c
--- a/sound/soc/codecs/wm5102.c~linux-next-git-rejects
+++ a/sound/soc/codecs/wm5102.c
@@ -43,16 +43,6 @@ static DECLARE_TLV_DB_SCALE(eq_tlv, -120
 static DECLARE_TLV_DB_SCALE(digital_tlv, -6400, 50, 0);
 static DECLARE_TLV_DB_SCALE(noise_tlv, 0, 600, 0);
 
-<<<<<<< HEAD
-=======
-static const struct wm_adsp_region wm5102_dsp1_regions[] = {
-	{ .type = WMFW_ADSP2_PM, .base = 0x100000 },
-	{ .type = WMFW_ADSP2_ZM, .base = 0x180000 },
-	{ .type = WMFW_ADSP2_XM, .base = 0x190000 },
-	{ .type = WMFW_ADSP2_YM, .base = 0x1a0000 },
-};
-
->>>>>>> linux-next/akpm-base
 static const struct reg_default wm5102_sysclk_reva_patch[] = {
 	{ 0x3000, 0x2225 },
 	{ 0x3001, 0x3a03 },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-export-a-function-to-get-vm-committed-memory.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

