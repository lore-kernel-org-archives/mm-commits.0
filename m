From: akpm@linux-foundation.org
Subject: + kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:01:13 -0800
Message-ID: <200802290101.m1T11DOL030056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbYB2BBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, harvey.harrison@gmail.com, mchehab@infradead.org


The patch titled
     kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch

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
Subject: kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need space after that ',' (ctx:VxV)
#53: FILE: include/linux/kernel.h:354:
+#define clamp(val,min,max) ({			\
                  ^

ERROR: need space after that ',' (ctx:VxV)
#74: FILE: include/linux/kernel.h:369:
+#define min_t(type,x,y) ({			\
                   ^

ERROR: need space after that ',' (ctx:VxV)
#79: FILE: include/linux/kernel.h:374:
+#define max_t(type,x,y) ({			\
                   ^

ERROR: need space after that ',' (ctx:VxV)
#84: FILE: include/linux/kernel.h:379:
+#define clamp_t(type,val,min,max) ({		\
                     ^

ERROR: need space after that ',' (ctx:VxV)
#84: FILE: include/linux/kernel.h:379:
+#define clamp_t(type,val,min,max) ({		\
                         ^

total: 5 errors, 0 warnings, 71 lines checked

./patches/kernel-add-clamp-and-clamp_t-macros.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes
+++ a/include/linux/kernel.h
@@ -351,7 +351,7 @@ static inline int __attribute__ ((format
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-#define clamp(val,min,max) ({			\
+#define clamp(val, min, max) ({			\
 	typeof(val) __val = (val);		\
 	typeof(min) __min = (min);		\
 	typeof(max) __max = (max);		\
@@ -366,17 +366,17 @@ static inline int __attribute__ ((format
  *
  * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type,x,y) ({			\
+#define min_t(type, x, y) ({			\
 	type __min1 = (x);			\
 	type __min2 = (y);			\
 	__min1 < __min2 ? __min1: __min2; })
 
-#define max_t(type,x,y) ({			\
+#define max_t(type, x, y) ({			\
 	type __max1 = (x);			\
 	type __max2 = (y);			\
 	__max1 > __max2 ? __max1: __max2; })
 
-#define clamp_t(type,val,min,max) ({		\
+#define clamp_t(type, val, min, max) ({		\
 	type __val = (val);			\
 	type __min = (min);			\
 	type __max = (max);			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
git-x86.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
git-v9fs.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
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

