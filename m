From: akpm@linux-foundation.org
Subject: + devscontrol-devices-accessibility-control-group-itself.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:16:43 -0800
Message-ID: <200803060116.m261GilR001562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759969AbYCFBQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     devscontrol: devices accessibility control group itself
has been added to the -mm tree.  Its filename is
     devscontrol-devices-accessibility-control-group-itself.patch

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
Subject: devscontrol: devices accessibility control group itself
From: Pavel Emelyanov <xemul@openvz.org>

Finally, here's the control group, which makes full use of the interfaces,
declared in the previous patches.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/devices.txt |   61 ++++
 fs/Makefile                           |    2 
 fs/devscontrol.c                      |  314 ++++++++++++++++++++++++
 include/linux/cgroup_subsys.h         |    6 
 include/linux/devscontrol.h           |   14 +
 init/Kconfig                          |   13 
 6 files changed, 410 insertions(+)

diff -puN /dev/null Documentation/controllers/devices.txt
--- /dev/null
+++ a/Documentation/controllers/devices.txt
@@ -0,0 +1,61 @@
+
+	Devices visibility controller
+
+This controller allows to tune the devices accessibility by tasks,
+i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
+access to IDE devices and completely hide SCSI disks.
+
+Tasks still can call mknod to create device files, regardless of
+whether the particular device is visible or accessible, but they
+may not be able to open it later.
+
+This one hides under CONFIG_CGROUP_DEVS option.
+
+
+Configuring
+
+The controller provides a single file to configure itself -- the
+devices.permissions one. To change the accessibility level for some
+device write the following string into it:
+
+[cb] <major>:(<minor>|*) [r-][w-]
+ ^          ^               ^
+ |          |               |
+ |          |               +--- access rights (1)
+ |          |
+ |          +-- device major and minor numbers (2)
+ |
+ +-- device type (character / block)
+
+1) The access rights set to '--' remove the device from the group's
+access list, so that it will not even be shown in this file later.
+
+2) Setting the minor to '*' grants access to all the minors for
+particular major.
+
+When reading from it, one may see something like
+
+	c 1:5 rw
+	b 8:* r-
+
+Security issues, concerning who may grant access to what are governed
+at the cgroup infrastructure level.
+
+
+Examples:
+
+1. Grant full access to /dev/null
+	# echo 'c 1:3 rw' > /cgroups/<id>/devices.permissions
+
+2. Grant the read-only access to /dev/sda and partitions
+	# echo 'b 8:* r-' > ...
+
+3. Change the /dev/null access to write-only
+	# echo 'c 1:3 -w' > ...
+
+4. Revoke access to /dev/sda
+	# echo 'b 8:* --' > ...
+
+
+		Written by Pavel Emelyanov <xemul@openvz.org>
+
diff -puN fs/Makefile~devscontrol-devices-accessibility-control-group-itself fs/Makefile
--- a/fs/Makefile~devscontrol-devices-accessibility-control-group-itself
+++ a/fs/Makefile
@@ -64,6 +64,8 @@ obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
+
+obj-$(CONFIG_CGROUP_DEVS)	+= devscontrol.o
  
 # Do not add any filesystems before this line
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
diff -puN /dev/null fs/devscontrol.c
--- /dev/null
+++ a/fs/devscontrol.c
@@ -0,0 +1,314 @@
+/*
+ * devscontrol.c - Device Controller
+ *
+ * Copyright 2008 OpenVZ Parallels Inc
+ * Author: Pavel Emelyanov <xemul at openvz dot org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/cgroup.h>
+#include <linux/cdev.h>
+#include <linux/err.h>
+#include <linux/devscontrol.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+
+struct devs_cgroup {
+	/*
+	 * The subsys state to build into cgroups infrastructure
+	 */
+	struct cgroup_subsys_state css;
+
+	/*
+	 * The maps of character and block devices. They provide a
+	 * map from dev_t-s to struct cdev/gendisk. See fs/char_dev.c
+	 * and block/genhd.c to find out how the ->open() callbacks
+	 * work when opening a device.
+	 *
+	 * Each group will have its own maps, and at the open()
+	 * time code will lookup in this map to get the device
+	 * and permissions by its dev_t.
+	 */
+	struct kobj_map *cdev_map;
+	struct kobj_map *bdev_map;
+};
+
+static inline
+struct devs_cgroup *css_to_devs(struct cgroup_subsys_state *css)
+{
+	return container_of(css, struct devs_cgroup, css);
+}
+
+static inline
+struct devs_cgroup *cgroup_to_devs(struct cgroup *cont)
+{
+	return css_to_devs(cgroup_subsys_state(cont, devs_subsys_id));
+}
+
+struct kobj_map *task_cdev_map(struct task_struct *tsk)
+{
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state(tsk, devs_subsys_id);
+	if (css->cgroup->parent == NULL)
+		return NULL;
+	else
+		return css_to_devs(css)->cdev_map;
+}
+
+struct kobj_map *task_bdev_map(struct task_struct *tsk)
+{
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state(tsk, devs_subsys_id);
+	if (css->cgroup->parent == NULL)
+		return NULL;
+	else
+		return css_to_devs(css)->bdev_map;
+}
+
+static struct cgroup_subsys_state *
+devs_create(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct devs_cgroup *devs;
+
+	devs = kzalloc(sizeof(struct devs_cgroup), GFP_KERNEL);
+	if (devs == NULL)
+		goto out;
+
+	devs->cdev_map = cdev_map_init();
+	if (devs->cdev_map == NULL)
+		goto out_free;
+
+	devs->bdev_map = bdev_map_init();
+	if (devs->bdev_map == NULL)
+		goto out_free_cdev;
+
+	return &devs->css;
+
+out_free_cdev:
+	cdev_map_fini(devs->cdev_map);
+out_free:
+	kfree(devs);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+static void devs_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct devs_cgroup *devs;
+
+	devs = cgroup_to_devs(cont);
+	bdev_map_fini(devs->bdev_map);
+	cdev_map_fini(devs->cdev_map);
+	kfree(devs);
+}
+
+/*
+ * The devices.permissions file read/write functionality
+ *
+ * The following two routines parse and print the strings like
+ * [cb] <major>:(<minor>|*) [r-][w-]
+ */
+
+static int decode_perms_str(char *buf, int *chrdev, dev_t *dev,
+		int *all, mode_t *mode)
+{
+	unsigned int major, minor;
+	char *end;
+	mode_t tmp;
+
+	if (buf[0] == 'c')
+		*chrdev = 1;
+	else if (buf[0] == 'b')
+		*chrdev = 0;
+	else
+		return -EINVAL;
+
+	if (buf[1] != ' ')
+		return -EINVAL;
+
+	major = simple_strtoul(buf + 2, &end, 10);
+	if (*end != ':')
+		return -EINVAL;
+
+	if (end[1] == '*') {
+		if (end[2] != ' ')
+			return -EINVAL;
+
+		*all = 1;
+		minor = 0;
+		end += 2;
+	} else {
+		minor = simple_strtoul(end + 1, &end, 10);
+		if (*end != ' ')
+			return -EINVAL;
+
+		*all = 0;
+	}
+
+	tmp = 0;
+
+	if (end[1] == 'r')
+		tmp |= FMODE_READ;
+	else if (end[1] != '-')
+		return -EINVAL;
+	if (end[2] == 'w')
+		tmp |= FMODE_WRITE;
+	else if (end[2] != '-')
+		return -EINVAL;
+
+	*dev = MKDEV(major, minor);
+	*mode = tmp;
+	return 0;
+}
+
+static int encode_perms_str(char *buf, int len, int chrdev, dev_t dev,
+		int all, mode_t mode)
+{
+	int ret;
+
+	ret = snprintf(buf, len, "%c %d:", chrdev ? 'c' : 'b', MAJOR(dev));
+	if (all)
+		ret += snprintf(buf + ret, len - ret, "*");
+	else
+		ret += snprintf(buf + ret, len - ret, "%d", MINOR(dev));
+
+	ret += snprintf(buf + ret, len - ret, " %c%c\n",
+			(mode & FMODE_READ) ? 'r' : '-',
+			(mode & FMODE_WRITE) ? 'w' : '-');
+
+	return ret;
+}
+
+static ssize_t devs_write(struct cgroup *cont, struct cftype *cft,
+		struct file *f, const char __user *ubuf,
+		size_t nbytes, loff_t *pos)
+{
+	int err, all, chrdev;
+	dev_t dev;
+	char buf[64];
+	struct devs_cgroup *devs;
+	mode_t mode;
+
+	if (copy_from_user(buf, ubuf, sizeof(buf)))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] = 0;
+	err = decode_perms_str(buf, &chrdev, &dev, &all, &mode);
+	if (err < 0)
+		return err;
+
+	devs = cgroup_to_devs(cont);
+
+	/*
+	 * No locking here is required - all that we need
+	 * is provided inside the kobject mapping code
+	 */
+
+	if (mode == 0) {
+		if (chrdev)
+			err = cdev_del_from_map(devs->cdev_map, dev, all);
+		else
+			err = bdev_del_from_map(devs->bdev_map, dev, all);
+
+		if (err < 0)
+			return err;
+
+		css_put(&devs->css);
+	} else {
+		if (chrdev)
+			err = cdev_add_to_map(devs->cdev_map, dev, all, mode);
+		else
+			err = bdev_add_to_map(devs->bdev_map, dev, all, mode);
+
+		if (err < 0)
+			return err;
+
+		css_get(&devs->css);
+	}
+
+	return nbytes;
+}
+
+struct devs_dump_arg {
+	char *buf;
+	int pos;
+	int chrdev;
+};
+
+static int devs_dump_one(dev_t dev, int range, mode_t mode, void *x)
+{
+	struct devs_dump_arg *arg = x;
+	char tmp[64];
+	int len;
+
+	len = encode_perms_str(tmp, sizeof(tmp), arg->chrdev, dev,
+			range != 1, mode);
+
+	if (arg->pos >= PAGE_SIZE - len)
+		return 1;
+
+	memcpy(arg->buf + arg->pos, tmp, len);
+	arg->pos += len;
+	return 0;
+}
+
+static ssize_t devs_read(struct cgroup *cont, struct cftype *cft,
+		struct file *f, char __user *ubuf, size_t nbytes, loff_t *pos)
+{
+	struct devs_dump_arg arg;
+	struct devs_cgroup *devs;
+	ssize_t ret;
+
+	arg.buf = (char *)__get_free_page(GFP_KERNEL);
+	if (arg.buf == NULL)
+		return -ENOMEM;
+
+	devs = cgroup_to_devs(cont);
+	arg.pos = 0;
+
+	arg.chrdev = 1;
+	cdev_iterate_map(devs->cdev_map, devs_dump_one, &arg);
+
+	arg.chrdev = 0;
+	bdev_iterate_map(devs->bdev_map, devs_dump_one, &arg);
+
+	ret = simple_read_from_buffer(ubuf, nbytes, pos,
+			arg.buf, arg.pos);
+
+	free_page((unsigned long)arg.buf);
+	return ret;
+}
+
+static struct cftype devs_files[] = {
+	{
+		.name = "permissions",
+		.write = devs_write,
+		.read = devs_read,
+	},
+};
+
+static int devs_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss,
+			devs_files, ARRAY_SIZE(devs_files));
+}
+
+struct cgroup_subsys devs_subsys = {
+	.name = "devices",
+	.subsys_id = devs_subsys_id,
+	.create = devs_create,
+	.destroy = devs_destroy,
+	.populate = devs_populate,
+};
diff -puN include/linux/cgroup_subsys.h~devscontrol-devices-accessibility-control-group-itself include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~devscontrol-devices-accessibility-control-group-itself
+++ a/include/linux/cgroup_subsys.h
@@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_DEVS
+SUBSYS(devs)
+#endif
+
+/* */
diff -puN include/linux/devscontrol.h~devscontrol-devices-accessibility-control-group-itself include/linux/devscontrol.h
--- a/include/linux/devscontrol.h~devscontrol-devices-accessibility-control-group-itself
+++ a/include/linux/devscontrol.h
@@ -1,5 +1,18 @@
 #ifndef __DEVS_CONTROL_H__
 #define __DEVS_CONTROL_H__
+struct kobj_map;
+struct task_struct;
+
+/*
+ * task_[cb]dev_map - get a map from task. Both calls may return
+ * NULL, to indicate, that task doesn't belong to any group and
+ * that the global map is to be used.
+ */
+
+#ifdef CONFIG_CGROUP_DEVS
+struct kobj_map *task_cdev_map(struct task_struct *);
+struct kobj_map *task_bdev_map(struct task_struct *);
+#else
 static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
 {
 	return NULL;
@@ -10,3 +23,4 @@ static inline struct kobj_map *task_bdev
 	return NULL;
 }
 #endif
+#endif
diff -puN init/Kconfig~devscontrol-devices-accessibility-control-group-itself init/Kconfig
--- a/init/Kconfig~devscontrol-devices-accessibility-control-group-itself
+++ a/init/Kconfig
@@ -289,6 +289,19 @@ config CGROUP_DEBUG
 
 	  Say N if unsure
 
+config CGROUP_DEVS
+	bool "Devices cgroup subsystem"
+	depends on CGROUPS
+	help
+	  Controlls the access rights to devices, i.e. you may hide
+	  some of them from tasks, so that they will not be able
+	  to open them, or you may grant a read-only access to some
+	  of them.
+
+	  See Documentation/controllers/devices.txt for details.
+
+	  This is harmless to say N here, so do it if unsure.
+
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
         depends on CGROUPS
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
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
devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch
devscontrol-clean-up-get_gendisk-a-bit.patch
devscontrol-add-a-mode-on-the-struct-probe.patch
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

