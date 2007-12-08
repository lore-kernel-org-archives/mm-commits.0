From: akpm@linux-foundation.org
Subject: - gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:30:22 -0800
Message-ID: <200712080130.lB81UMKo013535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbXLHBjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix
has been removed from the -mm tree.  Its filename was
     gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/base/module.c: In function 'module_add_driver':
drivers/base/module.c:44: error: dereferencing pointer to incomplete type
drivers/base/module.c: In function 'module_remove_driver':
drivers/base/module.c:84: error: dereferencing pointer to incomplete type

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Makefile |    5 +++--
 drivers/base/base.h   |   10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/base/Makefile~gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix drivers/base/Makefile
--- a/drivers/base/Makefile~gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix
+++ a/drivers/base/Makefile
@@ -3,8 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o \
-			   module.o
+			   attribute_container.o transport_class.o
+
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o dmapool.o
 obj-$(CONFIG_ISA)	+= isa.o
@@ -12,6 +12,7 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_clas
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff -puN drivers/base/base.h~gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix drivers/base/base.h
--- a/drivers/base/base.h~gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix
+++ a/drivers/base/base.h
@@ -82,5 +82,15 @@ extern int devres_release_all(struct dev
 
 extern struct kset *devices_kset;
 
+#ifdef CONFIG_MODULES
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
 extern void module_remove_driver(struct device_driver *drv);
+#else
+static inline void module_add_driver(struct module *mod,
+				struct device_driver *drv)
+{
+}
+static inline void module_remove_driver(struct device_driver *drv)
+{
+}
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
aoe-properly-initialise-the-request_queues-backing_dev_info.patch
revert-dpt_i2o-convert-to-scsi-hotplug-model.patch
revert-fix-proc-net-breakage.patch
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
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
acpi-fix-autloading-of-dock-video-bay-and-all-linux-specific-hid-drivers-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
v4l-nopage-fix.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-kvm-fixup.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
kernel-time-make-tick_do_broadcast-static.patch
git-sh.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
git-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
bcm43xx_debugfs-sscanf-fix.patch
git-ipwireless_cs.patch
git-x86.patch
revert-revert-git-kvm-changes-in-arch-x86-kconfig.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
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
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
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
