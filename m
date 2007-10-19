From: akpm@linux-foundation.org
Subject: - pid-namespaces-introduce-ms_kernmount-flag.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:23 -0700
Message-ID: <200710192251.l9JMpNcd024179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934918AbXJSXGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: introduce MS_KERNMOUNT flag
has been removed from the -mm tree.  Its filename was
     pid-namespaces-introduce-ms_kernmount-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/namespace.c     |    2 +-
 fs/super.c         |    6 +++---
 include/linux/fs.h |    4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~pid-namespaces-introduce-ms_kernmount-flag fs/namespace.c
--- a/fs/namespace.c~pid-namespaces-introduce-ms_kernmount-flag
+++ a/fs/namespace.c
@@ -1411,7 +1411,7 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_RELATIME;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
diff -puN fs/super.c~pid-namespaces-introduce-ms_kernmount-flag fs/super.c
--- a/fs/super.c~pid-namespaces-introduce-ms_kernmount-flag
+++ a/fs/super.c
@@ -944,9 +944,9 @@ do_kern_mount(const char *fstype, int fl
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
@@ -123,6 +123,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -1459,7 +1460,8 @@ void unnamed_dev_init(void);
 
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

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
