From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-notify-add-procfs-fdinfo-helper.patch removed from -mm tree
Date: Tue, 13 Nov 2012 11:43:49 -0800
Message-ID: <20121113194350.46D4A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60119 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2KMTny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:43:54 -0500
Received: by mail-wi0-f202.google.com with SMTP id hm14so59237wib.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:43:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, notify: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: add procfs fdinfo helper

This allow us to print out fsnotify details such as watchee inode, device,
mask and optionally a file handle.

For inotify objects if kernel compiled with exportfs support
the output will be

 | pos:	0
 | flags:	02000000
 | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
 | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
 | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153

If kernel compiled without exportfs support, the file handle
won't be provided but inode and device only.

 | pos:	0
 | flags:	02000000
 | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0
 | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0
 | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0

For fanotify the output is like

 | pos:	0
 | flags:	02
 | fanotify ino:            68f71 sdev:   800013 mask:        1 ignored_mask: 40000000
 | fanotify mnt_id:       13 mask:        1 ignored_mask: 40000000

To minimize impact on general fsnotify code the new functionality
is gathered in fs/notify/fdinfo.c file.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/Makefile                 |    2 
 fs/notify/fanotify/fanotify_user.c |    4 
 fs/notify/fdinfo.c                 |  124 +++++++++++++++++++++++++++
 fs/notify/fdinfo.h                 |   22 ++++
 fs/notify/inotify/inotify_user.c   |    4 
 5 files changed, 155 insertions(+), 1 deletion(-)

diff -puN fs/notify/Makefile~fs-notify-add-procfs-fdinfo-helper fs/notify/Makefile
--- a/fs/notify/Makefile~fs-notify-add-procfs-fdinfo-helper
+++ a/fs/notify/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o \
-				   mark.o vfsmount_mark.o
+				   mark.o vfsmount_mark.o fdinfo.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff -puN fs/notify/fanotify/fanotify_user.c~fs-notify-add-procfs-fdinfo-helper fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fs-notify-add-procfs-fdinfo-helper
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -17,6 +17,7 @@
 #include <asm/ioctls.h>
 
 #include "../../mount.h"
+#include "../fdinfo.h"
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
@@ -431,6 +432,9 @@ static long fanotify_ioctl(struct file *
 }
 
 static const struct file_operations fanotify_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= fanotify_show_fdinfo,
+#endif
 	.poll		= fanotify_poll,
 	.read		= fanotify_read,
 	.write		= fanotify_write,
diff -puN /dev/null fs/notify/fdinfo.c
--- /dev/null
+++ a/fs/notify/fdinfo.c
@@ -0,0 +1,124 @@
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify_backend.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/inotify.h>
+#include <linux/kernel.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
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
+		ret = seq_printf(m, "inotify wd: %8d ino: %16lx sdev: %8x "
+				 "mask: %8x ignored_mask: %8x ",
+				 inode_mark->wd, inode->i_ino,
+				 inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+#ifdef INOTIFY_USE_FHANDLE
+		if (!ret) {
+			int i;
+			struct file_handle *fhandle = (struct file_handle *)inode_mark->fhandle;
+			ret = seq_printf(m, "fhandle-bytes: %8x "
+					 "fhandle-type: %8x f_handle: ",
+					fhandle->handle_bytes,
+					fhandle->handle_type);
+
+			for (i = 0; i < fhandle->handle_bytes; i++) {
+				ret |= seq_printf(m, "%02x",
+						  (int)(unsigned char)fhandle->f_handle[i]);
+			}
+		}
+#endif
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
+		ret = seq_printf(m, "fanotify ino: %16lx sdev: %8x "
+				 "mask: %8x ignored_mask: %8x\n",
+				 inode->i_ino, inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+		iput(inode);
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
+		struct mount *mnt = real_mount(mark->m.mnt);
+
+		ret = seq_printf(m, "fanotify mnt_id: %8x mask: %8x ignored_mask: %8x\n",
+				 mnt->mnt_id, mark->mask, mark->ignored_mask);
+	}
+out:
+	return ret;
+}
+
+int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
+{
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
@@ -0,0 +1,22 @@
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
+#endif /* CONFIG_PROC_FS */
+
+#endif /* __FSNOTIFY_FDINFO_H__ */
diff -puN fs/notify/inotify/inotify_user.c~fs-notify-add-procfs-fdinfo-helper fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fs-notify-add-procfs-fdinfo-helper
+++ a/fs/notify/inotify/inotify_user.c
@@ -40,6 +40,7 @@
 #include <linux/wait.h>
 
 #include "inotify.h"
+#include "../fdinfo.h"
 
 #include <asm/ioctls.h>
 
@@ -329,6 +330,9 @@ static long inotify_ioctl(struct file *f
 }
 
 static const struct file_operations inotify_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= inotify_show_fdinfo,
+#endif
 	.poll		= inotify_poll,
 	.read		= inotify_read,
 	.fasync		= fsnotify_fasync,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

