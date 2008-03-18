From: akpm@linux-foundation.org
Subject: - git-mips-git-rejects.patch removed from -mm tree
Date: Tue, 18 Mar 2008 16:11:18 -0700
Message-ID: <200803182311.m2INBIYC020860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbYCSTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     git-mips-git-rejects
has been removed from the -mm tree.  Its filename was
     git-mips-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-mips-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/traps.c |    6 +-----
 arch/mips/mm/c-r4k.c     |    6 +-----
 arch/mips/mm/uasm.c      |    6 +-----
 arch/mips/mm/uasm.h      |   26 ++++++++------------------
 4 files changed, 11 insertions(+), 33 deletions(-)

diff -puN arch/mips/kernel/traps.c~git-mips-git-rejects arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~git-mips-git-rejects
+++ a/arch/mips/kernel/traps.c
@@ -1306,9 +1306,6 @@ int cp0_compare_irq;
 int cp0_perfcount_irq;
 EXPORT_SYMBOL_GPL(cp0_perfcount_irq);
 
-<<<<<<< HEAD:arch/mips/kernel/traps.c
-void __cpuinit per_cpu_trap_init(void)
-=======
 static int __initdata noulri;
 
 static int __init ulri_disable(char *s)
@@ -1320,8 +1317,7 @@ static int __init ulri_disable(char *s)
 }
 __setup("noulri", ulri_disable);
 
-void __init per_cpu_trap_init(void)
->>>>>>> FETCH_HEAD:arch/mips/kernel/traps.c
+void __cpuinit per_cpu_trap_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned int status_set = ST0_CU0;
diff -puN arch/mips/mm/c-r4k.c~git-mips-git-rejects arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~git-mips-git-rejects
+++ a/arch/mips/mm/c-r4k.c
@@ -1207,9 +1207,6 @@ void au1x00_fixup_config_od(void)
 	}
 }
 
-<<<<<<< HEAD:arch/mips/mm/c-r4k.c
-static void __cpuinit coherency_setup(void)
-=======
 static int __initdata cca = -1;
 unsigned long _page_cachable_default;
 EXPORT_SYMBOL_GPL(_page_cachable_default);
@@ -1223,8 +1220,7 @@ static int __init cca_setup(char *str)
 
 __setup("cca=", cca_setup);
 
-static void __init coherency_setup(void)
->>>>>>> FETCH_HEAD:arch/mips/mm/c-r4k.c
+static void __cpuinit coherency_setup(void)
 {
 	if (cca < 0 || cca > 7)
 		cca = read_c0_config() & CONF_CM_CMASK;
diff -puN arch/mips/mm/uasm.c~git-mips-git-rejects arch/mips/mm/uasm.c
--- a/arch/mips/mm/uasm.c~git-mips-git-rejects
+++ a/arch/mips/mm/uasm.c
@@ -558,10 +558,7 @@ uasm_il_beqzl(u32 **p, struct uasm_reloc
 	uasm_i_beqzl(p, reg, 0);
 }
 
-<<<<<<< HEAD:arch/mips/mm/uasm.c
 void __cpuinit
-=======
-void __init
 uasm_il_bne(u32 **p, struct uasm_reloc **r, unsigned int reg1,
 	    unsigned int reg2, int lid)
 {
@@ -569,8 +566,7 @@ uasm_il_bne(u32 **p, struct uasm_reloc *
 	uasm_i_bne(p, reg1, reg2, 0);
 }
 
-void __init
->>>>>>> FETCH_HEAD:arch/mips/mm/uasm.c
+void __cpuinit
 uasm_il_bnez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
diff -puN arch/mips/mm/uasm.h~git-mips-git-rejects arch/mips/mm/uasm.h
--- a/arch/mips/mm/uasm.h~git-mips-git-rejects
+++ a/arch/mips/mm/uasm.h
@@ -175,29 +175,19 @@ void uasm_copy_handler(struct uasm_reloc
 int uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr);
 
 /* Convenience functions for labeled branches. */
-<<<<<<< HEAD:arch/mips/mm/uasm.h
-void uasm_il_bltz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void uasm_il_b(u32 **p, struct uasm_reloc **r, int lid);
-void uasm_il_beqz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void uasm_il_beqzl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void uasm_il_bnez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void uasm_il_bgezl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void uasm_il_bgez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-=======
-void __init
+void __cpuinit
 uasm_il_bltz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void __init uasm_il_b(u32 **p, struct uasm_reloc **r, int lid);
-void __init
+void __cpuinit uasm_il_b(u32 **p, struct uasm_reloc **r, int lid);
+void __cpuinit
 uasm_il_beqz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void __init
+void __cpuinit
 uasm_il_beqzl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void __init
+void __cpuinit
 uasm_il_bne(u32 **p, struct uasm_reloc **r, unsigned int reg1,
 	    unsigned int reg2, int lid);
-void __init
+void __cpuinit
 uasm_il_bnez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void __init
+void __cpuinit
 uasm_il_bgezl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
-void __init
+void __cpuinit
 uasm_il_bgez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid);
->>>>>>> FETCH_HEAD:arch/mips/mm/uasm.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zisofs-fix-readpage-outside-i_size-fix.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-mips-git-rejects.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-sched-make-sure-jiffies-is-up-to-date-before-calling-__update_rq_clock.patch
git-sh.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus.patch
netpoll-zap_completion_queue-adjust-skb-users-counter.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

