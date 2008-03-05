From: akpm@linux-foundation.org
Subject: - ndelay-switch-to-c-function-to-avoid-64-bit-division.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:23 -0800
Message-ID: <200803050744.m257iNeZ021500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762091AbYCEHqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@kernel.org, herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru, mingo@elte.hu, ralf@linux-mips.org, tbm@cyrius.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ndelay(): switch to C function to avoid 64-bit division
has been removed from the -mm tree.  Its filename was
     ndelay-switch-to-c-function-to-avoid-64-bit-division.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ndelay(): switch to C function to avoid 64-bit division
From: Andrew Morton <akpm@linux-foundation.org>

We should be able to do ndelay(some_u64), but that can cause a call to
__divdi3() to be emitted because the ndelay() macros does a divide.

Fix it by switching to static inline which will force the u64 arg to be
treated as an unsigned long.  udelay() takes an unsigned long arg.

[bunk@kernel.org: reported m68k build breakage]
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delay.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/delay.h~ndelay-switch-to-c-function-to-avoid-64-bit-division include/linux/delay.h
--- a/include/linux/delay.h~ndelay-switch-to-c-function-to-avoid-64-bit-division
+++ a/include/linux/delay.h
@@ -7,6 +7,8 @@
  * Delay routines, using a pre-computed "loops_per_jiffy" value.
  */
 
+#include <linux/kernel.h>
+
 extern unsigned long loops_per_jiffy;
 
 #include <asm/delay.h>
@@ -32,7 +34,11 @@ extern unsigned long loops_per_jiffy;
 #endif
 
 #ifndef ndelay
-#define ndelay(x)	udelay(((x)+999)/1000)
+static inline void ndelay(unsigned long x)
+{
+	udelay(DIV_ROUND_UP(x, 1000));
+}
+#define ndelay(x) ndelay(x)
 #endif
 
 void calibrate_delay(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
oz99x-i2c-button-and-led-support-driver.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means.patch
git-md-accel.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
sh-export-copy-page-to-modules.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-v9fs.patch
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
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

