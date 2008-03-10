From: akpm@linux-foundation.org
Subject: - devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:38:29 -0700
Message-ID: <200803101938.m2AJcT66001951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYCJToJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscontrol: make kobj_lookup() return the mapping's permissions
has been removed from the -mm tree.  Its filename was
     devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch

This patch was dropped because of bunfight

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscontrol: make kobj_lookup() return the mapping's permissions
From: Pavel Emelyanov <xemul@openvz.org>

The kobj_lookup() searches the kobject by its dev_t.  Since this mapping is
going to be restricted with permissions, make the kobj_lookup() return the
mapping's permissions.

Currently the mode returned is unused.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c            |    4 ++--
 drivers/base/map.c       |    8 ++++++--
 fs/block_dev.c           |    3 ++-
 fs/char_dev.c            |    4 +++-
 include/linux/genhd.h    |    2 +-
 include/linux/kobj_map.h |    2 +-
 6 files changed, 15 insertions(+), 8 deletions(-)

diff -puN block/genhd.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions block/genhd.c
--- a/block/genhd.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/block/genhd.c
@@ -206,12 +206,12 @@ void unlink_gendisk(struct gendisk *disk
  * This function gets the structure containing partitioning
  * information for the given device @dev.
  */
-struct gendisk *get_gendisk(dev_t devt, int *part)
+struct gendisk *get_gendisk(dev_t devt, mode_t *mode, int *part)
 {
 	struct kobject *kobj;
 	struct device *dev;
 
-	kobj = kobj_lookup(bdev_map, devt, part);
+	kobj = kobj_lookup(bdev_map, devt, mode, part);
 	if (kobj == NULL)
 		return NULL;
 
diff -puN drivers/base/map.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions drivers/base/map.c
--- a/drivers/base/map.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/drivers/base/map.c
@@ -117,7 +117,8 @@ void kobj_unmap(struct kobj_map *domain,
 	kfree(found);
 }
 
-struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, int *index)
+struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, mode_t *mode,
+		int *index)
 {
 	struct kobject *kobj;
 	struct probe *p;
@@ -149,8 +150,11 @@ retry:
 		kobj = probe(dev, index, data);
 		/* Currently ->owner protects _only_ ->probe() itself. */
 		module_put(owner);
-		if (kobj)
+		if (kobj) {
+			if (mode)
+				*mode = p->mode;
 			return kobj;
+		}
 		goto retry;
 	}
 	mutex_unlock(domain->lock);
diff -puN fs/block_dev.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions fs/block_dev.c
--- a/fs/block_dev.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/fs/block_dev.c
@@ -929,11 +929,12 @@ static int do_open(struct block_device *
 	struct module *owner = NULL;
 	struct gendisk *disk;
 	int ret = -ENXIO;
+	mode_t mode;
 	int part;
 
 	file->f_mapping = bdev->bd_inode->i_mapping;
 	lock_kernel();
-	disk = get_gendisk(bdev->bd_dev, &part);
+	disk = get_gendisk(bdev->bd_dev, &mode, &part);
 	if (!disk) {
 		unlock_kernel();
 		bdput(bdev);
diff -puN fs/char_dev.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions fs/char_dev.c
--- a/fs/char_dev.c~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/fs/char_dev.c
@@ -367,8 +367,10 @@ static int chrdev_open(struct inode *ino
 	if (!p) {
 		struct kobject *kobj;
 		int idx;
+		mode_t mode;
+
 		spin_unlock(&cdev_lock);
-		kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
+		kobj = kobj_lookup(cdev_map, inode->i_rdev, &mode, &idx);
 		if (!kobj)
 			return -ENXIO;
 		new = container_of(kobj, struct cdev, kobj);
diff -puN include/linux/genhd.h~devscontrol-make-kobj_lookup-return-the-mappings-permissions include/linux/genhd.h
--- a/include/linux/genhd.h~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/include/linux/genhd.h
@@ -373,7 +373,7 @@ extern int get_blkdev_list(char *, int);
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
-extern struct gendisk *get_gendisk(dev_t dev, int *part);
+extern struct gendisk *get_gendisk(dev_t dev, mode_t *mode, int *part);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
diff -puN include/linux/kobj_map.h~devscontrol-make-kobj_lookup-return-the-mappings-permissions include/linux/kobj_map.h
--- a/include/linux/kobj_map.h~devscontrol-make-kobj_lookup-return-the-mappings-permissions
+++ a/include/linux/kobj_map.h
@@ -8,7 +8,7 @@ struct kobj_map;
 int kobj_map(struct kobj_map *, dev_t, unsigned long, struct module *,
 	     kobj_probe_t *, int (*)(dev_t, void *), void *);
 void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
-struct kobject *kobj_lookup(struct kobj_map *, dev_t, int *);
+struct kobject *kobj_lookup(struct kobj_map *, dev_t, mode_t *, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
 
 #endif
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
devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch
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

