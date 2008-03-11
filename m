From: akpm@linux-foundation.org
Subject: - rename-declare_pci_device_table-to-define_pci_device_table.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:31 -0700
Message-ID: <200803110321.m2B3LVQ5019727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYCKDWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rename DECLARE_PCI_DEVICE_TABLE to DEFINE_PCI_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     rename-declare_pci_device_table-to-define_pci_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rename DECLARE_PCI_DEVICE_TABLE to DEFINE_PCI_DEVICE_TABLE
From: Andrew Morton <akpm@linux-foundation.org>

This macro is used to define tables, not to declare them.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pci.txt |    4 ++--
 include/linux/pci.h   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/pci.txt~rename-declare_pci_device_table-to-define_pci_device_table Documentation/pci.txt
--- a/Documentation/pci.txt~rename-declare_pci_device_table-to-define_pci_device_table
+++ a/Documentation/pci.txt
@@ -123,7 +123,7 @@ initialization with a pointer to a struc
 
 
 The ID table is an array of struct pci_device_id entries ending with an
-all-zero entry; use of the macro DECLARE_PCI_DEVICE_TABLE is the preferred
+all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
 method of declaring the table.  Each entry consists of:
 
 	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
@@ -193,7 +193,7 @@ Tips on when/where to use the above attr
 	o Do not mark the struct pci_driver.
 
 	o The ID table array should be marked __devinitconst; this is done
-	  automatically if the table is declared with DECLARE_PCI_DEVICE_TABLE().
+	  automatically if the table is declared with DEFINE_PCI_DEVICE_TABLE().
 
 	o The probe() and remove() functions should be marked __devinit
 	  and __devexit respectively.  All initialization functions
diff -puN include/linux/pci.h~rename-declare_pci_device_table-to-define_pci_device_table include/linux/pci.h
--- a/include/linux/pci.h~rename-declare_pci_device_table-to-define_pci_device_table
+++ a/include/linux/pci.h
@@ -389,13 +389,13 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
- * DECLARE_PCI_DEVICE_TABLE - macro used to describe a pci device table
+ * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
  * @_table: device table name
  *
  * This macro is used to create a struct pci_device_id array (a device table)
  * in a generic manner.
  */
-#define DECLARE_PCI_DEVICE_TABLE(_table) \
+#define DEFINE_PCI_DEVICE_TABLE(_table) \
 	const struct pci_device_id _table[] __devinitconst
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
poweroff-workaround.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-arm-master.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
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
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
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

