From: akpm@linux-foundation.org
Subject: + profile-likely-unlikely-macros-fix.patch added to -mm tree
Date: Wed, 05 Mar 2008 10:02:39 -0800
Message-ID: <200803051802.m25I2dqf013370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYCESEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 13:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, dwalker@mvista.com, hzhong@gmail.com


The patch titled
     profile-likely-unlikely-macros-fix
has been added to the -mm tree.  Its filename is
     profile-likely-unlikely-macros-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: profile-likely-unlikely-macros-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Daniel Walker <dwalker@mvista.com>
Cc: Hua Zhong <hzhong@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsyscall_64.c  |   11 ++---------
 arch/x86/vdso/vclock_gettime.c |   11 ++---------
 include/linux/compiler.h       |    3 ++-
 3 files changed, 6 insertions(+), 19 deletions(-)

diff -puN arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -17,6 +17,8 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -46,15 +48,6 @@
 #define __syscall_clobber "r11","cx","memory"
 
 /*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
-/*
  * vsyscall_gtod_data contains data that is :
  * - readonly from vsyscalls
  * - written by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
diff -puN arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -9,6 +9,8 @@
  * Also alternative() doesn't work.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
 #include <linux/time.h>
@@ -23,15 +25,6 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-/*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
 static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
diff -puN include/linux/compiler.h~profile-likely-unlikely-macros-fix include/linux/compiler.h
--- a/include/linux/compiler.h~profile-likely-unlikely-macros-fix
+++ a/include/linux/compiler.h
@@ -51,7 +51,8 @@ extern void __chk_io_ptr(const volatile 
 # include <linux/compiler-intel.h>
 #endif
 
-#if defined(CONFIG_PROFILE_LIKELY) && !(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
+#if defined(CONFIG_PROFILE_LIKELY) && !defined(SUPPRESS_LIKELY_PROFILING) && \
+	!(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
 struct likeliness {
 	const char *func;
 	char *file;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-powerpc-fix-git-rejects.patch
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
git-md-accel-fix-git-rejects.patch
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
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

