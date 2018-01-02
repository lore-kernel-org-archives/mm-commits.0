From: akpm@linux-foundation.org
Subject: [wrecked]
 ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces.patch removed from
 -mm tree
Date: Tue, 02 Jan 2018 11:54:07 -0800
Message-ID: <20180102195407.lL7KaH6WP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABTyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 14:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, gscrivan@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: ipc, mqueue: lazy call kern_mount_data in new namespaces
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: ipc, mqueue: lazy call kern_mount_data in new namespaces

kern_mount_data is a relatively expensive operation when creating a new
IPC namespace, so delay the mount until its first usage when not creating
the the global namespace.

This is a net saving for new IPC namespaces that don't use mq_open().  In
this case there won't be any kern_mount_data() cost at all.

On my machine, the time for creating 1000 new IPC namespaces dropped from
~8s to ~2s.

Link: http://lkml.kernel.org/r/20171206151422.9660-1-gscrivan@redhat.com
Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    4 +-
 ipc/mqueue.c                  |   49 +++++++++++++++++++++++++-------
 ipc/namespace.c               |    2 -
 3 files changed, 42 insertions(+), 13 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces
+++ a/include/linux/ipc_namespace.h
@@ -81,7 +81,7 @@ static inline void shm_destroy_orphaned(
 #endif /* CONFIG_SYSVIPC */
 
 #ifdef CONFIG_POSIX_MQUEUE
-extern int mq_init_ns(struct ipc_namespace *ns);
+extern int mq_init_ns(struct ipc_namespace *ns, bool mount);
 /*
  * POSIX Message Queue default values:
  *
@@ -116,7 +116,7 @@ extern int mq_init_ns(struct ipc_namespa
 #define DFLT_MSGSIZEMAX		     8192
 #define HARD_MSGSIZEMAX	    (16*1024*1024)
 #else
-static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
+static inline int mq_init_ns(struct ipc_namespace *ns, bool mount) { return 0; }
 #endif
 
 #if defined(CONFIG_IPC_NS)
diff -puN ipc/mqueue.c~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces
+++ a/ipc/mqueue.c
@@ -87,6 +87,7 @@ struct mqueue_inode_info {
 	unsigned long qsize; /* size of queue in memory (sum of all msgs) */
 };
 
+static struct file_system_type mqueue_fs_type;
 static const struct inode_operations mqueue_dir_inode_operations;
 static const struct file_operations mqueue_file_operations;
 static const struct super_operations mqueue_super_ops;
@@ -743,12 +744,28 @@ static int prepare_open(struct dentry *d
 static int do_mq_open(const char __user *u_name, int oflag, umode_t mode,
 		      struct mq_attr *attr)
 {
-	struct vfsmount *mnt = current->nsproxy->ipc_ns->mq_mnt;
-	struct dentry *root = mnt->mnt_root;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
+	struct vfsmount *mnt;
+	struct dentry *root;
 	struct filename *name;
 	struct path path;
 	int fd, error;
 	int ro;
+	static DEFINE_MUTEX(mnt_lock);
+
+	mutex_lock(&mnt_lock);
+	mnt = ipc_ns->mq_mnt;
+	if (unlikely(!mnt)) {
+		mnt = kern_mount_data(&mqueue_fs_type, ipc_ns);
+		if (IS_ERR(mnt)) {
+			mutex_unlock(&mnt_lock);
+			return PTR_ERR(mnt);
+		}
+		ipc_ns->mq_mnt = mnt;
+	}
+	mutex_unlock(&mnt_lock);
+
+	root = mnt->mnt_root;
 
 	audit_mq_open(oflag, mode, attr);
 
@@ -808,6 +825,9 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
 	struct vfsmount *mnt = ipc_ns->mq_mnt;
 
+	if (!mnt)
+		return -ENOENT;
+
 	name = getname(u_name);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
@@ -1526,7 +1546,8 @@ static struct file_system_type mqueue_fs
 	.fs_flags = FS_USERNS_MOUNT,
 };
 
-int mq_init_ns(struct ipc_namespace *ns)
+
+int mq_init_ns(struct ipc_namespace *ns, bool mount)
 {
 	ns->mq_queues_count  = 0;
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
@@ -1535,23 +1556,31 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_msg_default   = DFLT_MSG;
 	ns->mq_msgsize_default  = DFLT_MSGSIZE;
 
-	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
-	if (IS_ERR(ns->mq_mnt)) {
-		int err = PTR_ERR(ns->mq_mnt);
+	if (!mount)
 		ns->mq_mnt = NULL;
-		return err;
+	else {
+		int err;
+
+		ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
+		if (IS_ERR(ns->mq_mnt)) {
+			err = PTR_ERR(ns->mq_mnt);
+			ns->mq_mnt = NULL;
+			return err;
+		}
 	}
 	return 0;
 }
 
 void mq_clear_sbinfo(struct ipc_namespace *ns)
 {
-	ns->mq_mnt->mnt_sb->s_fs_info = NULL;
+	if (ns->mq_mnt)
+		ns->mq_mnt->mnt_sb->s_fs_info = NULL;
 }
 
 void mq_put_mnt(struct ipc_namespace *ns)
 {
-	kern_unmount(ns->mq_mnt);
+	if (ns->mq_mnt)
+		kern_unmount(ns->mq_mnt);
 }
 
 static int __init init_mqueue_fs(void)
@@ -1573,7 +1602,7 @@ static int __init init_mqueue_fs(void)
 
 	spin_lock_init(&mq_lock);
 
-	error = mq_init_ns(&init_ipc_ns);
+	error = mq_init_ns(&init_ipc_ns, true);
 	if (error)
 		goto out_filesystem;
 
diff -puN ipc/namespace.c~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces ipc/namespace.c
--- a/ipc/namespace.c~ipc-mqueue-lazy-call-kern_mount_data-in-new-namespaces
+++ a/ipc/namespace.c
@@ -65,7 +65,7 @@ static struct ipc_namespace *create_ipc_
 	if (err)
 		goto fail_destroy_msg;
 
-	err = mq_init_ns(ns);
+	err = mq_init_ns(ns, false);
 	if (err)
 		goto fail_destroy_shm;
 
_

Patches currently in -mm which might be from gscrivan@redhat.com are


