From: akpm@linux-foundation.org
Subject: - inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 16 Feb 2008 12:02:20 -0800
Message-ID: <200802162002.m1GK2Ktg007437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbYBPUC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 15:02:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     inflate-refactor-inflate-malloc-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inflate-refactor-inflate-malloc-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need spaces around that '<' (ctx:WxV)
#775: FILE: lib/inflate.c:245:
+       if (size <0)
                 ^

ERROR: use tabs not spaces
#776: FILE: lib/inflate.c:246:
+               error("Malloc error");$

ERROR: use tabs not spaces
#778: FILE: lib/inflate.c:248:
+               malloc_ptr = free_mem_ptr;$

ERROR: use tabs not spaces
#786: FILE: lib/inflate.c:256:
+               error("Out of memory");$

ERROR: use tabs not spaces
#796: FILE: lib/inflate.c:266:
+               malloc_ptr = free_mem_ptr;$

total: 5 errors, 0 warnings, 705 lines checked

./patches/inflate-refactor-inflate-malloc-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN lib/inflate.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes lib/inflate.c
--- a/lib/inflate.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes
+++ a/lib/inflate.c
@@ -242,10 +242,10 @@ static void *malloc(int size)
 {
        void *p;
 
-       if (size <0)
-               error("Malloc error");
+       if (size < 0)
+		error("Malloc error");
        if (!malloc_ptr)
-               malloc_ptr = free_mem_ptr;
+		malloc_ptr = free_mem_ptr;
 
        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
 
@@ -253,7 +253,7 @@ static void *malloc(int size)
        malloc_ptr += size;
 
        if (malloc_ptr >= free_mem_end_ptr)
-               error("Out of memory");
+		error("Out of memory");
 
        malloc_count++;
        return p;
@@ -263,7 +263,7 @@ static void free(void *where)
 {
        malloc_count--;
        if (!malloc_count)
-               malloc_ptr = free_mem_ptr;
+		malloc_ptr = free_mem_ptr;
 }
 #else
 #define malloc(a) kmalloc(a, GFP_KERNEL)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-send-a-single-notification-on-device-state-changes.patch
softlockup-workaround.patch
git-acpi-powerpc-kconfig-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-agpgart-make-ia64-compile.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-nfsd-fix.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-git-rejects.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-git-rejects.patch
unionfs-is-broken.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
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
