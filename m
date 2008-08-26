From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 26 Aug 2008 10:52:35 -0700
Message-ID: <200808261752.m7QHqZRa019206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbYHZRxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 13:53:08 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7QHqaYV024995
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2008 10:52:37 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cyrix.c  |   20 --------------------
 arch/x86/kernel/paravirt.c   |   15 ---------------
 arch/x86/oprofile/nmi_int.c  |   22 +---------------------
 drivers/usb/core/usb.c       |    4 ----
 drivers/usb/musb/musb_core.c |    4 ----
 5 files changed, 1 insertion(+), 64 deletions(-)

diff -puN arch/x86/kernel/cpu/cyrix.c~linux-next-git-rejects arch/x86/kernel/cpu/cyrix.c
--- a/arch/x86/kernel/cpu/cyrix.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/cyrix.c
@@ -134,26 +134,6 @@ static void __cpuinit set_cx86_memwb(voi
 	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x14);
 }
 
-<<<<<<< HEAD:arch/x86/kernel/cpu/cyrix.c
-=======
-static void __cpuinit set_cx86_inc(void)
-{
-	unsigned char ccr3;
-
-	printk(KERN_INFO "Enable Incrementor on Cyrix/NSC processor.\n");
-
-	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
-	/* PCR1 -- Performance Control */
-	/* Incrementor on, whatever that is */
-	setCx86_old(CX86_PCR1, getCx86_old(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) | 0x04);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
-}
-
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/cyrix.c
 /*
  *	Configure later MediaGX and/or Geode processor.
  */
diff -puN arch/x86/kernel/paravirt.c~linux-next-git-rejects arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~linux-next-git-rejects
+++ a/arch/x86/kernel/paravirt.c
@@ -455,21 +455,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.set_fixmap = native_set_fixmap,
 };
 
-<<<<<<< HEAD:arch/x86/kernel/paravirt.c
-struct pv_lock_ops pv_lock_ops = {
-#ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
-#endif
-};
-EXPORT_SYMBOL(pv_lock_ops);
-
-=======
->>>>>>> FETCH_HEAD:arch/x86/kernel/paravirt.c
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
 EXPORT_SYMBOL    (pv_mmu_ops);
diff -puN arch/x86/oprofile/nmi_int.c~linux-next-git-rejects arch/x86/oprofile/nmi_int.c
--- a/arch/x86/oprofile/nmi_int.c~linux-next-git-rejects
+++ a/arch/x86/oprofile/nmi_int.c
@@ -32,15 +32,10 @@ static DEFINE_PER_CPU(unsigned long, sav
 
 static int nmi_start(void);
 static void nmi_stop(void);
-<<<<<<< HEAD:arch/x86/oprofile/nmi_int.c
-static void nmi_cpu_start(void *dummy);
-static void nmi_cpu_stop(void *dummy);
-=======
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs);
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs);
 static void nmi_cpu_stop(void *dummy);
 static void nmi_cpu_start(void *dummy);
->>>>>>> FETCH_HEAD:arch/x86/oprofile/nmi_int.c
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
@@ -579,16 +574,8 @@ int __init op_nmi_init(struct oprofile_o
 		return -ENODEV;
 	}
 
-<<<<<<< HEAD:arch/x86/oprofile/nmi_int.c
-	init_sysfs();
-#ifdef CONFIG_SMP
-	register_cpu_notifier(&oprofile_cpu_nb);
-#endif
-	using_nmi = 1;
-=======
 	/* default values, can be overwritten by model */
 	__get_cpu_var(switch_index) = 0;
->>>>>>> FETCH_HEAD:arch/x86/oprofile/nmi_int.c
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
@@ -610,15 +597,8 @@ int __init op_nmi_init(struct oprofile_o
 
 void op_nmi_exit(void)
 {
-	if (using_nmi) {
+	if (using_nmi)
 		exit_sysfs();
-<<<<<<< HEAD:arch/x86/oprofile/nmi_int.c
-#ifdef CONFIG_SMP
-		unregister_cpu_notifier(&oprofile_cpu_nb);
-#endif
-	}
-=======
 	if (model->exit)
 		model->exit();
->>>>>>> FETCH_HEAD:arch/x86/oprofile/nmi_int.c
 }
diff -puN drivers/usb/core/usb.c~linux-next-git-rejects drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~linux-next-git-rejects
+++ a/drivers/usb/core/usb.c
@@ -301,11 +301,7 @@ static struct pm_ops usb_device_pm_ops =
 
 #define ksuspend_usb_init()	0
 #define ksuspend_usb_cleanup()	do {} while (0)
-<<<<<<< HEAD:drivers/usb/core/usb.c
-#define usb_device_pm_ops	(*(struct pm_ops *)0)
-=======
 #define usb_device_pm_ops	(* (struct pm_ops *) 0)
->>>>>>> FETCH_HEAD:drivers/usb/core/usb.c
 
 #endif	/* CONFIG_PM */
 
diff -puN drivers/usb/musb/musb_core.c~linux-next-git-rejects drivers/usb/musb/musb_core.c
--- a/drivers/usb/musb/musb_core.c~linux-next-git-rejects
+++ a/drivers/usb/musb/musb_core.c
@@ -114,11 +114,7 @@
 
 
 
-<<<<<<< HEAD:drivers/usb/musb/musb_core.c
 unsigned debug;
-=======
-unsigned debug = 0;
->>>>>>> FETCH_HEAD:drivers/usb/musb/musb_core.c
 module_param(debug, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug message level. Default = 0");
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
git-acpi.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
git-alsa-tiwai.patch
git-powerpc-merge.patch
git-powerpc.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
git-drm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch
git-mtd.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

