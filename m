From: akpm@linux-foundation.org
Subject: + pid-namespaces-introduce-ms_kernmount-flag.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:48 -0700
Message-ID: <200708142004.l7EK4mi0018589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbXHNUFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: introduce MS_KERNMOUNT flag
has been added to the -mm tree.  Its filename is
     pid-namespaces-introduce-ms_kernmount-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: introduce MS_KERNMOUNT flag
From: Pavel Emelyanov <xemul@openvz.org>

This flag tells the .get_sb callback that this is a kern_mount() call so that
it can trust *data pointer to be valid in-kernel one.  If this flag is passed
from the user process, it is cleared since the *data pointer is not a valid
kernel object.

Running a few steps forward - this will be needed for proc to create the
superblock and store a valid pid namespace on it during the namespace
creation.  The reason, why the namespace cannot live without proc mount is
described in the appropriate patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |    3 ++-
 fs/super.c         |    6 +++---
 include/linux/fs.h |    4 +++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~pid-namespaces-introduce-ms_kernmount-flag fs/namespace.c
--- a/fs/namespace.c~pid-namespaces-introduce-ms_kernmount-flag
+++ a/fs/namespace.c
@@ -1605,7 +1605,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NOMNT;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME |
+		   MS_NOMNT | MS_KERNMOUNT);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
diff -puN fs/super.c~pid-namespaces-introduce-ms_kernmount-flag fs/super.c
--- a/fs/super.c~pid-namespaces-introduce-ms_kernmount-flag
+++ a/fs/super.c
@@ -918,9 +918,9 @@ do_kern_mount(const char *fstype, int fl
 	return mnt;
 }
 
-struct vfsmount *kern_mount(struct file_system_type *type)
+struct vfsmount *kern_mount_data(struct file_system_type *type, void *data)
 {
-	return vfs_kern_mount(type, 0, type->name, NULL);
+	return vfs_kern_mount(type, MS_KERNMOUNT, type->name, data);
 }
 
-EXPORT_SYMBOL(kern_mount);
+EXPORT_SYMBOL_GPL(kern_mount_data);
diff -puN include/linux/fs.h~pid-namespaces-introduce-ms_kernmount-flag include/linux/fs.h
--- a/include/linux/fs.h~pid-namespaces-introduce-ms_kernmount-flag
+++ a/include/linux/fs.h
@@ -129,6 +129,7 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_SETUSER	(1<<23) /* set mnt_uid to current user */
 #define MS_NOMNT	(1<<24) /* don't allow unprivileged submounts */
+#define MS_KERNMOUNT	(1<<25) /* this is a kern_mount call */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -1458,7 +1459,8 @@ void unnamed_dev_init(void);
 
 extern int register_filesystem(struct file_system_type *);
 extern int unregister_filesystem(struct file_system_type *);
-extern struct vfsmount *kern_mount(struct file_system_type *);
+extern struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
+#define kern_mount(type) kern_mount_data(type, NULL)
 extern int may_umount_tree(struct vfsmount *);
 extern int may_umount(struct vfsmount *);
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
