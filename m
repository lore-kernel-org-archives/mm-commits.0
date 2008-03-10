From: akpm@linux-foundation.org
Subject: - devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:38:32 -0700
Message-ID: <200803101938.m2AJcWkl001958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbYCJTt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscontrol: make use of permissions, returned by kobj_lookup
has been removed from the -mm tree.  Its filename was
     devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch

This patch was dropped because of bunfight

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscontrol: make use of permissions, returned by kobj_lookup
From: Pavel Emelyanov <xemul@openvz.org>

Now check the requesting permissions against the granted (with the
dev_t-to-kobj map) ones.

The tricky place is chrdev_open - it caches the struct cdev on inode and thus,
we have to perform lookup each time if we are in a restricted mapping.

The task_cdev_map and task_bdev_map provide the map which the current task is
in, but now they just return NULL, which means, that the task is not in any.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c               |    8 +++++++-
 fs/block_dev.c              |    8 ++++++++
 fs/char_dev.c               |   18 ++++++++++++++++--
 include/linux/devscontrol.h |   12 ++++++++++++
 4 files changed, 43 insertions(+), 3 deletions(-)

diff -puN block/genhd.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup block/genhd.c
--- a/block/genhd.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup
+++ a/block/genhd.c
@@ -8,6 +8,7 @@
 #include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
+#include <linux/devscontrol.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/seq_file.h>
@@ -208,10 +209,15 @@ void unlink_gendisk(struct gendisk *disk
  */
 struct gendisk *get_gendisk(dev_t devt, mode_t *mode, int *part)
 {
+	struct kobj_map *map;
 	struct kobject *kobj;
 	struct device *dev;
 
-	kobj = kobj_lookup(bdev_map, devt, mode, part);
+	map = task_bdev_map(current);
+	if (map == NULL)
+		map = bdev_map;
+
+	kobj = kobj_lookup(map, devt, mode, part);
 	if (kobj == NULL)
 		return NULL;
 
diff -puN fs/block_dev.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup fs/block_dev.c
--- a/fs/block_dev.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup
+++ a/fs/block_dev.c
@@ -940,6 +940,14 @@ static int do_open(struct block_device *
 		bdput(bdev);
 		return ret;
 	}
+
+	if ((file->f_mode & mode) != file->f_mode) {
+		unlock_kernel();
+		bdput(bdev);
+		put_disk(disk);
+		return -EACCES;
+	}
+
 	owner = disk->fops->owner;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
diff -puN fs/char_dev.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup fs/char_dev.c
--- a/fs/char_dev.c~devscontrol-make-use-of-permissions-returned-by-kobj_lookup
+++ a/fs/char_dev.c
@@ -22,6 +22,8 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
+#include <linux/devscontrol.h>
+
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
 #endif
@@ -361,19 +363,31 @@ static int chrdev_open(struct inode *ino
 	struct cdev *p;
 	struct cdev *new = NULL;
 	int ret = 0;
+	struct kobj_map *map;
+
+	map = task_cdev_map(current);
+	if (map == NULL)
+		map = cdev_map;
 
 	spin_lock(&cdev_lock);
 	p = inode->i_cdev;
-	if (!p) {
+	if (!p || map != cdev_map) {
 		struct kobject *kobj;
 		int idx;
 		mode_t mode;
 
 		spin_unlock(&cdev_lock);
-		kobj = kobj_lookup(cdev_map, inode->i_rdev, &mode, &idx);
+		kobj = kobj_lookup(map, inode->i_rdev, &mode, &idx);
 		if (!kobj)
 			return -ENXIO;
 		new = container_of(kobj, struct cdev, kobj);
+		BUG_ON(p != NULL && p != new);
+
+		if ((filp->f_mode & mode) != filp->f_mode) {
+			cdev_put(new);
+			return -EACCES;
+		}
+
 		spin_lock(&cdev_lock);
 		p = inode->i_cdev;
 		if (!p) {
diff -puN /dev/null include/linux/devscontrol.h
--- /dev/null
+++ a/include/linux/devscontrol.h
@@ -0,0 +1,12 @@
+#ifndef __DEVS_CONTROL_H__
+#define __DEVS_CONTROL_H__
+static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
+{
+	return NULL;
+}
+
+static inline struct kobj_map *task_bdev_map(struct task_struct *tsk)
+{
+	return NULL;
+}
+#endif
_

Patches currently in -mm which might be from xemul@openvz.org are

git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch
devscontrol-extend-the-drivers-base-mapc-functionality.patch
devscontrol-provide-functions-to-manipulate-char-device-mappings.patch
devscontrol-provide-functions-to-manipulate-block-device-mappings.patch
devscontrol-devices-accessibility-control-group-itself.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

