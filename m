From: akpm@linux-foundation.org
Subject: - include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 13 Feb 2008 14:24:47 -0800
Message-ID: <200802132233.m1DMXlFM017155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932926AbYBMWdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 17:33:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch

This patch was dropped because it was folded into include-linux-remove-all-users-of-fastcall-macro.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#106: FILE: include/linux/file.h:80:
+extern struct file * fget(unsigned int fd);

ERROR: "foo * bar" should be "foo *bar"
#107: FILE: include/linux/file.h:81:
+extern struct file * fget_light(unsigned int fd, int *fput_needed);

ERROR: "foo * bar" should be "foo *bar"
#122: FILE: include/linux/file.h:113:
+extern void fd_install(unsigned int fd, struct file * file);

WARNING: line over 80 characters
#220: FILE: include/linux/mm.h:832:
+extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);

WARNING: line over 80 characters
#245: FILE: include/linux/namei.h:66:
+extern int __user_walk_fd(int dfd, const char __user *, unsigned, struct nameidata *);

ERROR: "foo * bar" should be "foo *bar"
#392: FILE: include/linux/sched.h:1651:
+extern int wake_up_state(struct task_struct * tsk, unsigned int state);

ERROR: "foo * bar" should be "foo *bar"
#393: FILE: include/linux/sched.h:1652:
+extern int wake_up_process(struct task_struct * tsk);

ERROR: "foo * bar" should be "foo *bar"
#394: FILE: include/linux/sched.h:1653:
+extern void wake_up_new_task(struct task_struct * tsk,

ERROR: "foo * bar" should be "foo *bar"
#445: FILE: include/linux/wait.h:120:
+extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait);

ERROR: "foo * bar" should be "foo *bar"
#446: FILE: include/linux/wait.h:121:
+extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t * wait);

ERROR: "foo * bar" should be "foo *bar"
#447: FILE: include/linux/wait.h:122:
+extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t * wait);

WARNING: line over 80 characters
#469: FILE: include/linux/wait.h:148:
+int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);

WARNING: line over 80 characters
#470: FILE: include/linux/wait.h:149:
+int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);

WARNING: line over 80 characters
#488: FILE: include/linux/wait.h:441:
+void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);

WARNING: line over 80 characters
#517: FILE: include/linux/workqueue.h:191:
+extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);

total: 9 errors, 6 warnings, 413 lines checked

./patches/include-linux-remove-all-users-of-fastcall-macro.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <>
---

 include/linux/file.h  |    6 +++---
 include/linux/sched.h |    8 ++++----
 include/linux/wait.h  |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/file.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes include/linux/file.h
--- a/include/linux/file.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes
+++ a/include/linux/file.h
@@ -77,8 +77,8 @@ static inline void fput_light(struct fil
 		fput(file);
 }
 
-extern struct file * fget(unsigned int fd);
-extern struct file * fget_light(unsigned int fd, int *fput_needed);
+extern struct file *fget(unsigned int fd);
+extern struct file *fget_light(unsigned int fd, int *fput_needed);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern void put_filp(struct file *);
 extern int get_unused_fd(void);
@@ -110,7 +110,7 @@ static inline struct file * fcheck_files
  */
 #define fcheck(fd)	fcheck_files(current->files, fd)
 
-extern void fd_install(unsigned int fd, struct file * file);
+extern void fd_install(unsigned int fd, struct file *file);
 
 struct task_struct;
 
diff -puN include/linux/sched.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes include/linux/sched.h
--- a/include/linux/sched.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes
+++ a/include/linux/sched.h
@@ -1648,10 +1648,10 @@ extern void release_uids(struct user_nam
 
 extern void do_timer(unsigned long ticks);
 
-extern int wake_up_state(struct task_struct * tsk, unsigned int state);
-extern int wake_up_process(struct task_struct * tsk);
-extern void wake_up_new_task(struct task_struct * tsk,
-			     unsigned long clone_flags);
+extern int wake_up_state(struct task_struct *tsk, unsigned int state);
+extern int wake_up_process(struct task_struct *tsk);
+extern void wake_up_new_task(struct task_struct *tsk,
+				unsigned long clone_flags);
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
diff -puN include/linux/wait.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes include/linux/wait.h
--- a/include/linux/wait.h~include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes
+++ a/include/linux/wait.h
@@ -117,9 +117,9 @@ static inline int waitqueue_active(wait_
  */
 #define is_sync_wait(wait)	(!(wait) || ((wait)->private))
 
-extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait);
-extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t * wait);
-extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t * wait);
+extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
+extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
+extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 
 static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
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
fix-ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-conflicts.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-conflicts.patch
git-x86.patch
git-x86-vs-git-kvm.patch
git-x86-cpa-build-fix.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-conflicts.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
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
