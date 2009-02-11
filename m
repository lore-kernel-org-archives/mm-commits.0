From: akpm@linux-foundation.org
Subject: [merged] revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage.patch removed from -mm tree
Date: Wed, 11 Feb 2009 11:22:07 -0800
Message-ID: <200902111922.n1BJM72k019198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794AbZBKTWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 14:22:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     revert "Protect f_flags against races and eliminate fasync() BKL usage"
has been removed from the -mm tree.  Its filename was
     revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "Protect f_flags against races and eliminate fasync() BKL usage"
From: Andrew Morton <akpm@linux-foundation.org>

make new stuff apply.

Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    5 +--
 fs/fcntl.c            |   65 ++++++++--------------------------------
 fs/ioctl.c            |   25 ++++++++++++---
 fs/nfsd/vfs.c         |    5 ---
 include/linux/fs.h    |   17 ----------
 5 files changed, 37 insertions(+), 80 deletions(-)

diff -puN drivers/char/tty_io.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage
+++ a/drivers/char/tty_io.c
@@ -2162,12 +2162,13 @@ static int fionbio(struct file *file, in
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	lock_file_flags();
+	/* file->f_flags is still BKL protected in the fs layer - vomit */
+	lock_kernel();
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
-	unlock_file_flags();
+	unlock_kernel();
 	return 0;
 }
 
diff -puN fs/fcntl.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage fs/fcntl.c
--- a/fs/fcntl.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage
+++ a/fs/fcntl.c
@@ -19,16 +19,12 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-#include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-/* Serialize access to file->f_flags */
-DEFINE_SPINLOCK(file_flags_lock);
-EXPORT_SYMBOL(file_flags_lock);
-
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
@@ -145,7 +141,7 @@ SYSCALL_DEFINE1(dup, unsigned int, filde
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -180,60 +176,25 @@ static int setfl(int fd, struct file * f
 	if (error)
 		return error;
 
+	/*
+	 * We still need a lock here for now to keep multiple FASYNC calls
+	 * from racing with each other.
+	 */
+	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
-		error = fasync_change(fd, filp, (arg & FASYNC) != 0);
-		if (error == -ENOTTY)
-			/*
-			 * ABI compatibility: fcntl() has traditionally returned
-			 * zero in this case (but ioctl() does not).
-			 */
-			error = 0;
-		else if (error < 0)
-			goto out;
+		if (filp->f_op && filp->f_op->fasync) {
+			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
+			if (error < 0)
+				goto out;
+		}
 	}
 
-	lock_file_flags();
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
-	unlock_file_flags();
  out:
+	unlock_kernel();
 	return error;
 }
 
-
-
-/*
- * Change the setting of fasync, let the driver know.
- * Not static because ioctl_fioasync() uses it too.
- */
-int fasync_change(int fd, struct file *filp, int on)
-{
-	int ret = 0;
-	static DEFINE_MUTEX(fasync_mutex);
-
-	if (filp->f_op->fasync == NULL)
-		return -ENOTTY;
-
-	mutex_lock(&fasync_mutex);
-	/* Can test without flags lock, nobody else will change it */
-	if (((filp->f_flags & FASYNC) == 0) == (on == 0))
-		goto out;
-	ret = filp->f_op->fasync(fd, filp, on);
-	if (ret >= 0) {
-		lock_file_flags();
-		if (on)
-			filp->f_flags |= FASYNC;
-		else
-			filp->f_flags &= ~FASYNC;
-		unlock_file_flags();
-	}
-  out:
-	mutex_unlock(&fasync_mutex);
-	return ret;
-}
-
-
-
-
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
diff -puN fs/ioctl.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage fs/ioctl.c
--- a/fs/ioctl.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage
+++ a/fs/ioctl.c
@@ -404,12 +404,10 @@ static int ioctl_fionbio(struct file *fi
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
-	lock_file_flags();
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
-	unlock_file_flags();
 	return error;
 }
 
@@ -425,9 +423,20 @@ static int ioctl_fioasync(unsigned int f
 	flag = on ? FASYNC : 0;
 
 	/* Did FASYNC state change ? */
-	if ((flag ^ filp->f_flags) & FASYNC)
-		return fasync_change(fd, filp, on);
-	return 0;
+	if ((flag ^ filp->f_flags) & FASYNC) {
+		if (filp->f_op && filp->f_op->fasync)
+			error = filp->f_op->fasync(fd, filp, on);
+		else
+			error = -ENOTTY;
+	}
+	if (error)
+		return error;
+
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	return error;
 }
 
 static int ioctl_fsfreeze(struct file *filp)
@@ -490,11 +499,17 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIONBIO:
+		/* BKL needed to avoid races tweaking f_flags */
+		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOASYNC:
+		/* BKL needed to avoid races tweaking f_flags */
+		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff -puN fs/nfsd/vfs.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage
+++ a/fs/nfsd/vfs.c
@@ -998,11 +998,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	if (!EX_ISSYNC(exp))
 		stable = 0;
-	if (stable && !EX_WGATHER(exp)) {
-		lock_file_flags();
+	if (stable && !EX_WGATHER(exp))
 		file->f_flags |= O_SYNC;
-		unlock_file_flags();
-	}
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff -puN include/linux/fs.h~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage include/linux/fs.h
--- a/include/linux/fs.h~revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage
+++ a/include/linux/fs.h
@@ -885,23 +885,6 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
-/*
- * Serialize changes to file->f_flags.  These should not be called
- * from interrupt context.
- */
-extern spinlock_t file_flags_lock;
-
-static inline void lock_file_flags(void)
-{
-	spin_lock(&file_flags_lock);
-}
-
-static inline void unlock_file_flags(void)
-{
-	spin_unlock(&file_flags_lock);
-}
-extern int fasync_change(int fd, struct file *filp, int on);
-
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_assign_resources-fix.patch
pci-constify-pci_bus_add_devices.patch
cciss-pci-power-management-reset-for-kexec-cleanup.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void-fix.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch
writeback-fix-break-condition-checkpatch-fixes.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port-fix.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

