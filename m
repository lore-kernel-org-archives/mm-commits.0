From: akpm@linux-foundation.org
Subject: - git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:20 -0800
Message-ID: <200712132332.lBDNWK1i023954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069AbXLMXck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     git-dvb: drivers/media/video/et61x251/et61x251_core.c: fix warnings
has been removed from the -mm tree.  Its filename was
     git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-dvb: drivers/media/video/et61x251/et61x251_core.c: fix warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/et61x251/et61x251_core.c:390: warning: 'et61x251_i2c_read' defined but not used
drivers/media/video/et61x251/et61x251_core.c:397: warning: 'et61x251_i2c_write' defined but not used

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/et61x251/et61x251_core.c |  155 ++++++++---------
 1 file changed, 77 insertions(+), 78 deletions(-)

diff -puN drivers/media/video/et61x251/et61x251_core.c~git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings drivers/media/video/et61x251/et61x251_core.c
--- a/drivers/media/video/et61x251/et61x251_core.c~git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings
+++ a/drivers/media/video/et61x251/et61x251_core.c
@@ -268,72 +268,6 @@ et61x251_i2c_wait(struct et61x251_device
 }
 
 
-static int et61x251_i2c_try_read(struct et61x251_device* cam,
-				 const struct et61x251_sensor* sensor,
-				 u8 address)
-{
-	struct usb_device* udev = cam->usbdev;
-	u8* data = cam->control_buffer;
-	int err = 0, res;
-
-	data[0] = address;
-	data[1] = cam->sensor.i2c_slave_id;
-	data[2] = cam->sensor.rsta | 0x10;
-	data[3] = !(et61x251_read_reg(cam, 0x8b) & 0x02);
-	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
-			      0, 0x88, data, 4, ET61X251_CTRL_TIMEOUT);
-	if (res < 0)
-		err += res;
-
-	err += et61x251_i2c_wait(cam, sensor);
-
-	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00, 0xc1,
-			      0, 0x80, data, 8, ET61X251_CTRL_TIMEOUT);
-	if (res < 0)
-		err += res;
-
-	if (err)
-		DBG(3, "I2C read failed for %s image sensor", sensor->name);
-
-	PDBGG("I2C read: address 0x%02X, value: 0x%02X", address, data[0]);
-
-	return err ? -1 : (int)data[0];
-}
-
-
-static int et61x251_i2c_try_write(struct et61x251_device* cam,
-				  const struct et61x251_sensor* sensor,
-				  u8 address, u8 value)
-{
-	struct usb_device* udev = cam->usbdev;
-	u8* data = cam->control_buffer;
-	int err = 0, res;
-
-	data[0] = address;
-	data[1] = cam->sensor.i2c_slave_id;
-	data[2] = cam->sensor.rsta | 0x12;
-	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
-			      0, 0x88, data, 3, ET61X251_CTRL_TIMEOUT);
-	if (res < 0)
-		err += res;
-
-	data[0] = value;
-	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
-			      0, 0x80, data, 1, ET61X251_CTRL_TIMEOUT);
-	if (res < 0)
-		err += res;
-
-	err += et61x251_i2c_wait(cam, sensor);
-
-	if (err)
-		DBG(3, "I2C write failed for %s image sensor", sensor->name);
-
-	PDBGG("I2C write: address 0x%02X, value: 0x%02X", address, value);
-
-	return err ? -1 : 0;
-}
-
-
 int
 et61x251_i2c_raw_write(struct et61x251_device* cam, u8 n, u8 data1, u8 data2,
 		       u8 data3, u8 data4, u8 data5, u8 data6, u8 data7,
@@ -386,18 +320,6 @@ et61x251_i2c_raw_write(struct et61x251_d
 }
 
 
-static int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
-{
-	return et61x251_i2c_try_read(cam, &cam->sensor, address);
-}
-
-
-static int et61x251_i2c_write(struct et61x251_device* cam,
-			      u8 address, u8 value)
-{
-	return et61x251_i2c_try_write(cam, &cam->sensor, address, value);
-}
-
 /*****************************************************************************/
 
 static void et61x251_urb_complete(struct urb *urb)
@@ -675,6 +597,83 @@ static int et61x251_stream_interrupt(str
 /*****************************************************************************/
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+
+static int et61x251_i2c_try_read(struct et61x251_device* cam,
+				 const struct et61x251_sensor* sensor,
+				 u8 address)
+{
+	struct usb_device* udev = cam->usbdev;
+	u8* data = cam->control_buffer;
+	int err = 0, res;
+
+	data[0] = address;
+	data[1] = cam->sensor.i2c_slave_id;
+	data[2] = cam->sensor.rsta | 0x10;
+	data[3] = !(et61x251_read_reg(cam, 0x8b) & 0x02);
+	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
+			      0, 0x88, data, 4, ET61X251_CTRL_TIMEOUT);
+	if (res < 0)
+		err += res;
+
+	err += et61x251_i2c_wait(cam, sensor);
+
+	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00, 0xc1,
+			      0, 0x80, data, 8, ET61X251_CTRL_TIMEOUT);
+	if (res < 0)
+		err += res;
+
+	if (err)
+		DBG(3, "I2C read failed for %s image sensor", sensor->name);
+
+	PDBGG("I2C read: address 0x%02X, value: 0x%02X", address, data[0]);
+
+	return err ? -1 : (int)data[0];
+}
+
+
+static int et61x251_i2c_try_write(struct et61x251_device* cam,
+				  const struct et61x251_sensor* sensor,
+				  u8 address, u8 value)
+{
+	struct usb_device* udev = cam->usbdev;
+	u8* data = cam->control_buffer;
+	int err = 0, res;
+
+	data[0] = address;
+	data[1] = cam->sensor.i2c_slave_id;
+	data[2] = cam->sensor.rsta | 0x12;
+	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
+			      0, 0x88, data, 3, ET61X251_CTRL_TIMEOUT);
+	if (res < 0)
+		err += res;
+
+	data[0] = value;
+	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00, 0x41,
+			      0, 0x80, data, 1, ET61X251_CTRL_TIMEOUT);
+	if (res < 0)
+		err += res;
+
+	err += et61x251_i2c_wait(cam, sensor);
+
+	if (err)
+		DBG(3, "I2C write failed for %s image sensor", sensor->name);
+
+	PDBGG("I2C write: address 0x%02X, value: 0x%02X", address, value);
+
+	return err ? -1 : 0;
+}
+
+static int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
+{
+	return et61x251_i2c_try_read(cam, &cam->sensor, address);
+}
+
+static int et61x251_i2c_write(struct et61x251_device* cam,
+			      u8 address, u8 value)
+{
+	return et61x251_i2c_try_write(cam, &cam->sensor, address, value);
+}
+
 static u8 et61x251_strtou8(const char* buff, size_t len, ssize_t* count)
 {
 	char str[5];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi-ia64-build-fix.patch
git-acpi-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
git-dvb-one-videobuf_read_start-is-enough.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
gfs2-avoid-64-bit-divide.patch
git-hid.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-md-accel.patch
mips-fix-makefile-borkage.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
net-use-mutex_is_locked-for-assert_rtnl.patch
tipc-fix-semaphore-handling.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver-fix.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
git-sh.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
hptiop-add-more-adapter-models-and-other-fixes-fix-2.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-x86-fix-allnoconfig-build.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
iwlwifi3945-4965-fix-rate-control-algo-reference-leak-fix.patch
bcm43xx_debugfs-sscanf-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-optimise-the-clearing-of-__gfp_zero.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
sync_sb_inodes-propagate-errors.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
