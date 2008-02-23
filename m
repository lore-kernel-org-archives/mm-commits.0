From: akpm@linux-foundation.org
Subject: - git-agpgart-make-ia64-compile.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:36 -0800
Message-ID: <200802232021.m1NKLasp013349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760712AbYBWUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-agpgart: make ia64 compile
has been removed from the -mm tree.  Its filename was
     git-agpgart-make-ia64-compile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-agpgart: make ia64 compile
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dave Airlie <airlied@linux.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/generic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/generic.c~git-agpgart-make-ia64-compile drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~git-agpgart-make-ia64-compile
+++ a/drivers/char/agp/generic.c
@@ -925,7 +925,9 @@ int agp_generic_create_gatt_table(struct
 	agp_gatt_table = (void *)table;
 
 	bridge->driver->cache_flush();
+#ifdef CONFIG_X86
 	set_memory_uc((unsigned long)table, 1 << page_order);
+#endif
 	bridge->gatt_table = (void *)table;
 	bridge->driver->cache_flush();
 
@@ -973,8 +975,9 @@ int agp_generic_free_gatt_table(struct a
 	/* Do not worry about freeing memory, because if this is
 	 * called, then all agp memory is deallocated and removed
 	 * from the table. */
-
+#ifdef CONFIG_X86
 	set_memory_wb((unsigned long)bridge->gatt_table, 1 << page_order);
+#endif
 	free_gatt_pages(bridge->gatt_table_real, page_order);
 
 	agp_gatt_table = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
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
