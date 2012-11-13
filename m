From: akpm@linux-foundation.org
Subject: + fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch added to -mm tree
Date: Mon, 12 Nov 2012 17:06:02 -0800
Message-ID: <20121113010602.E55E220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:48696 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2KMBGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 20:06:05 -0500
Received: by mail-bk0-f74.google.com with SMTP id jm19so116285bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 17:06:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, notify: add file handle entry into inotify_inode_mark
has been added to the -mm tree.  Its filename is
     fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: add file handle entry into inotify_inode_mark

This file handle will be used in /proc/pid/fdinfo/fd output, which in turn
will allow to restore a watch target after checkpoint (thus it's provided
for CONFIG_CHECKPOINT_RESTORE only).

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

 fs/notify/inotify/inotify.h      |    8 +++++
 fs/notify/inotify/inotify_user.c |   42 +++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 5 deletions(-)

diff -puN fs/notify/inotify/inotify.h~fs-notify-add-file-handle-entry-into-inotify_inode_mark fs/notify/inotify/inotify.h
--- a/fs/notify/inotify/inotify.h~fs-notify-add-file-handle-entry-into-inotify_inode_mark
+++ a/fs/notify/inotify/inotify.h
@@ -1,6 +1,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/inotify.h>
 #include <linux/slab.h> /* struct kmem_cache */
+#include <linux/exportfs.h>
 
 extern struct kmem_cache *event_priv_cachep;
 
@@ -9,9 +10,16 @@ struct inotify_event_private_data {
 	int wd;
 };
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_EXPORTFS) && defined(CONFIG_CHECKPOINT_RESTORE)
+# define INOTIFY_USE_FHANDLE
+#endif
+
 struct inotify_inode_mark {
 	struct fsnotify_mark fsn_mark;
 	int wd;
+#ifdef INOTIFY_USE_FHANDLE
+	__u8 fhandle[sizeof(struct file_handle) + MAX_HANDLE_SZ];
+#endif
 };
 
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
diff -puN fs/notify/inotify/inotify_user.c~fs-notify-add-file-handle-entry-into-inotify_inode_mark fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fs-notify-add-file-handle-entry-into-inotify_inode_mark
+++ a/fs/notify/inotify/inotify_user.c
@@ -561,6 +561,33 @@ static void inotify_free_mark(struct fsn
 	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
 }
 
+#ifdef INOTIFY_USE_FHANDLE
+static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
+{
+	struct file_handle *fhandle = (struct file_handle *)mark->fhandle;
+	int size, ret;
+
+	BUILD_BUG_ON(sizeof(mark->fhandle) <= sizeof(struct file_handle));
+
+	fhandle->handle_bytes = sizeof(mark->fhandle) - sizeof(struct file_handle);
+	size = fhandle->handle_bytes >> 2;
+
+	ret = exportfs_encode_fh(dentry, (struct fid *)fhandle->f_handle, &size,  0);
+	if ((ret == 255) || (ret == -ENOSPC))
+		return -EOVERFLOW;
+
+	fhandle->handle_type = ret;
+	fhandle->handle_bytes = size * sizeof(u32);
+
+	return 0;
+}
+# else
+static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
+{
+	return 0;
+}
+#endif
+
 static int inotify_update_existing_watch(struct fsnotify_group *group,
 					 struct inode *inode,
 					 u32 arg)
@@ -616,10 +643,11 @@ static int inotify_update_existing_watch
 }
 
 static int inotify_new_watch(struct fsnotify_group *group,
-			     struct inode *inode,
+			     struct dentry *dentry,
 			     u32 arg)
 {
 	struct inotify_inode_mark *tmp_i_mark;
+	struct inode *inode = dentry->d_inode;
 	__u32 mask;
 	int ret;
 	struct idr *idr = &group->inotify_data.idr;
@@ -642,6 +670,10 @@ static int inotify_new_watch(struct fsno
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
+	ret = inotify_encode_wd_fhandle(tmp_i_mark, dentry);
+	if (ret)
+		goto out_err;
+
 	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
 				 tmp_i_mark);
 	if (ret)
@@ -668,16 +700,16 @@ out_err:
 	return ret;
 }
 
-static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+static int inotify_update_watch(struct fsnotify_group *group, struct dentry *dentry, u32 arg)
 {
 	int ret = 0;
 
 retry:
 	/* try to update and existing watch with the new arg */
-	ret = inotify_update_existing_watch(group, inode, arg);
+	ret = inotify_update_existing_watch(group, dentry->d_inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
-		ret = inotify_new_watch(group, inode, arg);
+		ret = inotify_new_watch(group, dentry, arg);
 	/*
 	 * inotify_new_watch could race with another thread which did an
 	 * inotify_new_watch between the update_existing and the add watch
@@ -779,7 +811,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, 
 	group = f.file->private_data;
 
 	/* create/update an inode mark */
-	ret = inotify_update_watch(group, inode, mask);
+	ret = inotify_update_watch(group, path.dentry, mask);
 	path_put(&path);
 fput_and_out:
 	fdput(f);
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers-fix.patch
fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch
fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch
fs-notify-add-procfs-fdinfo-helper.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

