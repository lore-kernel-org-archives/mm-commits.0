From: akpm@linux-foundation.org
Subject: - pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 17 Mar 2008 17:03:34 -0700
Message-ID: <200803180003.m2I03Z8X005096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYCRADs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 20:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need space after that ',' (ctx:VxV)
#98: FILE: include/linux/pm.h:229:
+		device_set_wakeup_enable(dev,val); \
 		                            ^

ERROR: need a space before the open parenthesis '('
#99: FILE: include/linux/pm.h:230:
+	} while(0)

ERROR: need space after that ',' (ctx:VxV)
#126: FILE: include/linux/pm.h:254:
+#define device_init_wakeup(dev,val)		do {} while (0)
                               ^

ERROR: need space after that ',' (ctx:VxV)
#127: FILE: include/linux/pm.h:255:
+#define device_set_wakeup_enable(dev,val)	do {} while (0)
                                     ^

total: 4 errors, 0 warnings, 113 lines checked

./patches/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <greg@kroah.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes include/linux/pm.h
--- a/include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes
+++ a/include/linux/pm.h
@@ -223,11 +223,11 @@ static inline int device_suspend(pm_mess
  */
 #define device_can_wakeup(dev) \
 	((dev)->power.can_wakeup)
-#define device_init_wakeup(dev,val) \
+#define device_init_wakeup(dev, val) \
 	do { \
 		device_can_wakeup(dev) = !!(val); \
-		device_set_wakeup_enable(dev,val); \
-	} while(0)
+		device_set_wakeup_enable(dev, val); \
+	} while (0)
 
 #define device_set_wakeup_enable(dev,val) \
 	((dev)->power.should_wakeup = !!(val))
@@ -251,8 +251,8 @@ static inline int call_platform_enable_w
 #else /* !CONFIG_PM */
 
 #define device_can_wakeup(dev)			0
-#define device_init_wakeup(dev,val)		do {} while (0)
-#define device_set_wakeup_enable(dev,val)	do {} while (0)
+#define device_init_wakeup(dev, val)		do {} while (0)
+#define device_set_wakeup_enable(dev, val)	do {} while (0)
 #define device_may_wakeup(dev)			0
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
git-input.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-mips-git-rejects.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
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

