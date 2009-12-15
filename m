From: akpm@linux-foundation.org
Subject: [folded] procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:06:22 -0800
Message-ID: <200912150106.nBF16N6B009632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758922AbZLOBG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup
has been removed from the -mm tree.  Its filename was
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch

This patch was dropped because it was folded into procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

convert into kernel code ;)

Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup fs/proc/base.c
--- a/fs/proc/base.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup
+++ a/fs/proc/base.c
@@ -1348,11 +1348,8 @@ static const struct file_operations proc
 
 #endif
 
-
-
-static ssize_t
-comm_write(struct file *file, const char __user *buf,
-	    size_t count, loff_t *offset)
+static ssize_t comm_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *offset)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct task_struct *p;
@@ -1378,7 +1375,6 @@ comm_write(struct file *file, const char
 	return count;
 }
 
-
 static int comm_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
@@ -1410,7 +1406,6 @@ static int comm_open(struct inode *inode
 	return ret;
 }
 
-
 static const struct file_operations proc_pid_set_comm_operations = {
 	.open		= comm_open,
 	.read		= seq_read,
@@ -1419,7 +1414,6 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

