From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:16:17 -0700
Message-ID: <200803212016.m2LKGHCX008274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437AbYCUURK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, lenb@kernel.org, rjw@sisk.pl, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set
From: Andrew Morton <akpm@linux-foundation.org>

Greg has the old version (I think).

Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c  |    2 +
 drivers/base/power/sysfs.c |    2 -
 include/linux/pm.h         |   64 +++++++++++++++--------------------
 3 files changed, 30 insertions(+), 38 deletions(-)

diff -puN drivers/base/power/main.c~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set drivers/base/power/main.c
--- a/drivers/base/power/main.c~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/drivers/base/power/main.c
@@ -57,6 +57,8 @@ static DEFINE_MUTEX(dpm_list_mtx);
 /* 'true' if all devices have been suspended, protected by dpm_list_mtx */
 static bool all_sleeping;
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
diff -puN drivers/base/power/sysfs.c~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/drivers/base/power/sysfs.c
@@ -6,8 +6,6 @@
 #include <linux/string.h>
 #include "power.h"
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 
 /*
  *	wakeup - Report/change current wakeup option for device
diff -puN include/linux/pm.h~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set include/linux/pm.h
--- a/include/linux/pm.h~revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/include/linux/pm.h
@@ -183,9 +183,9 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
-	unsigned		should_wakeup:1;
 	bool			sleeping:1;	/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
+	unsigned		should_wakeup:1;
 	struct list_head	entry;
 #endif
 };
@@ -198,6 +198,11 @@ extern void device_resume(void);
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
+#define device_set_wakeup_enable(dev,val) \
+	((dev)->power.should_wakeup = !!(val))
+#define device_may_wakeup(dev) \
+	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
+
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -205,35 +210,6 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__FUNCTION__, fn, ret);		\
 	} while (0)
 
-#else /* !CONFIG_PM_SLEEP */
-
-static inline int device_suspend(pm_message_t state)
-{
-	return 0;
-}
-
-#define suspend_report_result(fn, ret) 		do {} while (0)
-
-#endif /* !CONFIG_PM_SLEEP */
-
-#ifdef CONFIG_PM
-
-/* changes to device_may_wakeup take effect on the next pm state change.
- * by default, devices should wakeup if they can.
- */
-#define device_can_wakeup(dev) \
-	((dev)->power.can_wakeup)
-#define device_init_wakeup(dev,val) \
-	do { \
-		device_can_wakeup(dev) = !!(val); \
-		device_set_wakeup_enable(dev,val); \
-	} while(0)
-
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
 /*
  * Platform hook to activate device wakeup capability, if that's not already
  * handled by enable_irq_wake() etc.
@@ -248,19 +224,35 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#else /* !CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
+
+static inline int device_suspend(pm_message_t state)
+{
+	return 0;
+}
+
+#define device_set_wakeup_enable(dev,val)	do{}while(0)
+#define device_may_wakeup(dev)			(0)
 
-#define device_can_wakeup(dev)			0
-#define device_init_wakeup(dev,val)		do {} while (0)
-#define device_set_wakeup_enable(dev,val)	do {} while (0)
-#define device_may_wakeup(dev)			0
+#define suspend_report_result(fn, ret) do { } while (0)
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
 {
 	return 0;
 }
 
-#endif /* !CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
+
+/* changes to device_may_wakeup take effect on the next pm state change.
+ * by default, devices should wakeup if they can.
+ */
+#define device_can_wakeup(dev) \
+	((dev)->power.can_wakeup)
+#define device_init_wakeup(dev,val) \
+	do { \
+		device_can_wakeup(dev) = !!(val); \
+		device_set_wakeup_enable(dev,val); \
+	} while(0)
 
 /*
  * Global Power Management flags
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mtd-memory-corruption-in-block2mtdc.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi-fixup.patch
git-acpi-arch-x86-kernel-apm_32c-fix-warning.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
git-drm.patch
git-drm-git-rejects.patch
git-drm-drivers-char-drm-ati_pcigartc-fix-printk-warning.patch
git-dvb.patch
git-dvb-drivers-media-video-bt8xx-bttv-cardsc-fix-warnings.patch
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
kvm-warning-fix.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-async-tx.patch
git-net-drivers-net-wireless-rt2x00-rt2x00devc-remove-dead-code-fix-warning.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
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
git-scsi-rc-fixes-fixup.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
scsi-add-iscsi-ibft-support-fix.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-watchdog.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
netpoll-zap_completion_queue-adjust-skb-users-counter.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
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
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
fbdev-driver-for-freescale-8610-and-5121-diu-fix.patch
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
sxc-fix-printk-warnings-on-sparc32.patch
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
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
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
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
w1-build-fix.patch

