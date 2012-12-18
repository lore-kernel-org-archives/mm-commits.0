From: akpm@linux-foundation.org
Subject: [merged] fs-notify-add-procfs-fdinfo-helper-v7.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:47 -0800
Message-ID: <20121218201248.7F8C220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:39549 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LRUMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:52 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so63479wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, notify: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: add procfs fdinfo helper

This allow us to print out fsnotify details such as watchee inode, device,
mask and optionally a file handle.

For inotify objects if kernel compiled with exportfs support the output
will be

 | pos:	0
 | flags:	02000000
 | inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
 | inotify wd:2 ino:a111 sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:11a1000020542153
 | inotify wd:1 ino:6b149 sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:49b1060023552153

If kernel compiled without exportfs support, the file handle
won't be provided but inode and device only.

 | pos:	0
 | flags:	02000000
 | inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0
 | inotify wd:2 ino:a111 sdev:800013 mask:800afce ignored_mask:0
 | inotify wd:1 ino:6b149 sdev:800013 mask:800afce ignored_mask:0

For fanotify the output is like

 | pos:	0
 | flags:	04002
 | fanotify flags:10 event-flags:0
 | fanotify mnt_id:12 mask:3b ignored_mask:0
 | fanotify ino:50205 sdev:800013 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:05020500fb1d47e7

To minimize impact on general fsnotify code the new functionality
is gathered in fs/notify/fdinfo.c file.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/Makefile                 |    2 
 fs/notify/fanotify/fanotify_user.c |    2 
 fs/notify/fdinfo.c                 |  175 +++++++++++++++++++++++++++
 fs/notify/fdinfo.h                 |   27 ++++
 fs/notify/inotify/inotify_user.c   |    2 
 5 files changed, 207 insertions(+), 1 deletion(-)

diff -puN fs/notify/Makefile~fs-notify-add-procfs-fdinfo-helper-v7 fs/notify/Makefile
--- a/fs/notify/Makefile~fs-notify-add-procfs-fdinfo-helper-v7
+++ a/fs/notify/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o \
-				   mark.o vfsmount_mark.o
+				   mark.o vfsmount_mark.o fdinfo.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff -puN fs/notify/fanotify/fanotify_user.c~fs-notify-add-procfs-fdinfo-helper-v7 fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fs-notify-add-procfs-fdinfo-helper-v7
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -17,6 +17,7 @@
 #include <asm/ioctls.h>
 
 #include "../../mount.h"
+#include "../fdinfo.h"
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
@@ -428,6 +429,7 @@ static long fanotify_ioctl(struct file *
 }
 
 static const struct file_operations fanotify_fops = {
+	.show_fdinfo	= fanotify_show_fdinfo,
 	.poll		= fanotify_poll,
 	.read		= fanotify_read,
 	.write		= fanotify_write,
diff -puN /dev/null fs/notify/fdinfo.c
--- /dev/null
+++ a/fs/notify/fdinfo.c
@@ -0,0 +1,175 @@
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify_backend.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/inotify.h>
+#include <linux/fanotify.h>
+#include <linux/kernel.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include <linux/exportfs.h>
+
+#include "inotify/inotify.h"
+#include "../fs/mount.h"
+
+#if defined(CONFIG_PROC_FS)
+
+#if defined(CONFIG_INOTIFY_USER) || defined(CONFIG_FANOTIFY)
+
+static int show_fdinfo(struct seq_file *m, struct file *f,
+		       int (*show)(struct seq_file *m, struct fsnotify_mark *mark))
+{
+	struct fsnotify_group *group = f->private_data;
+	struct fsnotify_mark *mark;
+	int ret = 0;
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry(mark, &group->marks_list, g_list) {
+		ret = show(m, mark);
+		if (ret)
+			break;
+	}
+	spin_unlock(&group->mark_lock);
+	return ret;
+}
+
+#if defined(CONFIG_EXPORTFS)
+static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+{
+	struct {
+		struct file_handle handle;
+		u8 pad[64];
+	} f;
+	int size, ret, i;
+
+	f.handle.handle_bytes = sizeof(f.pad);
+	size = f.handle.handle_bytes >> 2;
+
+	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
+	if ((ret == 255) || (ret == -ENOSPC)) {
+		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+		return 0;
+	}
+
+	f.handle.handle_type = ret;
+	f.handle.handle_bytes = size * sizeof(u32);
+
+	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
+			 f.handle.handle_bytes, f.handle.handle_type);
+
+	for (i = 0; i < f.handle.handle_bytes; i++)
+		ret |= seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
+
+	return ret;
+}
+#else
+static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+{
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_INOTIFY_USER
+
+static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+{
+	struct inotify_inode_mark *inode_mark;
+	struct inode *inode;
+	int ret = 0;
+
+	if (!(mark->flags & (FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_INODE)))
+		return 0;
+
+	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
+	inode = igrab(mark->i.inode);
+	if (inode) {
+		ret = seq_printf(m, "inotify wd:%x ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x ",
+				 inode_mark->wd, inode->i_ino,
+				 inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+		ret |= show_mark_fhandle(m, inode);
+		ret |= seq_putc(m, '\n');
+		iput(inode);
+	}
+
+	return ret;
+}
+
+int inotify_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	return show_fdinfo(m, f, inotify_fdinfo);
+}
+
+#endif /* CONFIG_INOTIFY_USER */
+
+#ifdef CONFIG_FANOTIFY
+
+static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+{
+	struct inode *inode;
+	int ret = 0;
+
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
+		return 0;
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
+		inode = igrab(mark->i.inode);
+		if (!inode)
+			goto out;
+		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x ",
+				 inode->i_ino, inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+		ret |= show_mark_fhandle(m, inode);
+		ret |= seq_putc(m, '\n');
+		iput(inode);
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
+		struct mount *mnt = real_mount(mark->m.mnt);
+
+		ret = seq_printf(m, "fanotify mnt_id:%x mask:%x "
+				 "ignored_mask:%x\n",
+				 mnt->mnt_id, mark->mask, mark->ignored_mask);
+	}
+out:
+	return ret;
+}
+
+int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct fsnotify_group *group = f->private_data;
+	unsigned int flags = 0;
+
+	switch (group->priority) {
+	case FS_PRIO_0:
+		flags |= FAN_CLASS_NOTIF;
+		break;
+	case FS_PRIO_1:
+		flags |= FAN_CLASS_CONTENT;
+		break;
+	case FS_PRIO_2:
+		flags |= FAN_CLASS_PRE_CONTENT;
+		break;
+	}
+
+	if (group->max_events == UINT_MAX)
+		flags |= FAN_UNLIMITED_QUEUE;
+
+	if (group->fanotify_data.max_marks == UINT_MAX)
+		flags |= FAN_UNLIMITED_MARKS;
+
+	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
+		   flags, group->fanotify_data.f_flags);
+
+	return show_fdinfo(m, f, fanotify_fdinfo);
+}
+
+#endif /* CONFIG_FANOTIFY */
+
+#endif /* CONFIG_INOTIFY_USER || CONFIG_FANOTIFY */
+
+#endif /* CONFIG_PROC_FS */
diff -puN /dev/null fs/notify/fdinfo.h
--- /dev/null
+++ a/fs/notify/fdinfo.h
@@ -0,0 +1,27 @@
+#ifndef __FSNOTIFY_FDINFO_H__
+#define __FSNOTIFY_FDINFO_H__
+
+#include <linux/errno.h>
+#include <linux/proc_fs.h>
+
+struct seq_file;
+struct file;
+
+#ifdef CONFIG_PROC_FS
+
+#ifdef CONFIG_INOTIFY_USER
+extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
+#endif
+
+#ifdef CONFIG_FANOTIFY
+extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
+#endif
+
+#else /* CONFIG_PROC_FS */
+
+#define inotify_show_fdinfo	NULL
+#define fanotify_show_fdinfo	NULL
+
+#endif /* CONFIG_PROC_FS */
+
+#endif /* __FSNOTIFY_FDINFO_H__ */
diff -puN fs/notify/inotify/inotify_user.c~fs-notify-add-procfs-fdinfo-helper-v7 fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fs-notify-add-procfs-fdinfo-helper-v7
+++ a/fs/notify/inotify/inotify_user.c
@@ -40,6 +40,7 @@
 #include <linux/wait.h>
 
 #include "inotify.h"
+#include "../fdinfo.h"
 
 #include <asm/ioctls.h>
 
@@ -335,6 +336,7 @@ static long inotify_ioctl(struct file *f
 }
 
 static const struct file_operations inotify_fops = {
+	.show_fdinfo	= inotify_show_fdinfo,
 	.poll		= inotify_poll,
 	.read		= inotify_read,
 	.fasync		= inotify_fasync,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

