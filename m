From: akpm@linux-foundation.org
Subject: [merged] namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:41 -0700
Message-ID: <200904071907.n37J7fv9011442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401AbZDGTK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: ipc namespaces: implement support for posix msqueues
has been removed from the -mm tree.  Its filename was
     namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: ipc namespaces: implement support for posix msqueues
From: "Serge E. Hallyn" <serue@us.ibm.com>

Implement multiple mounts of the mqueue file system, and link it to usage
of CLONE_NEWIPC.

Each ipc ns has a corresponding mqueuefs superblock.  When a user does
clone(CLONE_NEWIPC) or unshare(CLONE_NEWIPC), the unshare will cause an
internal mount of a new mqueuefs sb linked to the new ipc ns.

When a user does 'mount -t mqueue mqueue /dev/mqueue', he mounts the
mqueuefs superblock.

Posix message queues can be worked with both through the mq_* system calls
(see mq_overview(7)), and through the VFS through the mqueue mount.  Any
usage of mq_open() and friends will work with the acting task's ipc
namespace.  Any actions through the VFS will work with the mqueuefs in
which the file was created.  So if a user doesn't remount mqueuefs after
unshare(CLONE_NEWIPC), mq_open("/ab") will not be reflected in "ls
/dev/mqueue".

If task a mounts mqueue for ipc_ns:1, then clones task b with a new ipcns,
ipcns:2, and then task a is the last task in ipc_ns:1 to exit, then (1)
ipc_ns:1 will be freed, (2) it's superblock will live on until task b
umounts the corresponding mqueuefs, and vfs actions will continue to
succeed, but (3) sb->s_fs_info will be NULL for the sb corresponding to
the deceased ipc_ns:1.

To make this happen, we must protect the ipc reference count when

a) a task exits and drops its ipcns->count, since it might be dropping
   it to 0 and freeing the ipcns

b) a task accesses the ipcns through its mqueuefs interface, since it
   bumps the ipcns refcount and might race with the last task in the ipcns
   exiting.

So the kref is changed to an atomic_t so we can use
atomic_dec_and_lock(&ns->count,mq_lock), and every access to the ipcns
through ns = mqueuefs_sb->s_fs_info is protected by the same lock.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |   16 ++--
 ipc/mqueue.c                  |  111 +++++++++++++++++++++++---------
 ipc/msgutil.c                 |    9 --
 ipc/namespace.c               |   41 ++++++++++-
 ipc/util.h                    |    6 +
 5 files changed, 131 insertions(+), 52 deletions(-)

diff -puN include/linux/ipc_namespace.h~namespaces-ipc-namespaces-implement-support-for-posix-msqueues include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~namespaces-ipc-namespaces-implement-support-for-posix-msqueues
+++ a/include/linux/ipc_namespace.h
@@ -25,7 +25,7 @@ struct ipc_ids {
 };
 
 struct ipc_namespace {
-	struct kref	kref;
+	atomic_t	count;
 	struct ipc_ids	ids[3];
 
 	int		sem_ctls[4];
@@ -61,6 +61,7 @@ struct ipc_namespace {
 extern struct ipc_namespace init_ipc_ns;
 extern atomic_t nr_ipc_ns;
 
+extern spinlock_t mq_lock;
 #if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
 #else
@@ -82,18 +83,18 @@ static inline int ipcns_notify(unsigned 
 #endif /* CONFIG_SYSVIPC */
 
 #ifdef CONFIG_POSIX_MQUEUE
-extern void mq_init_ns(struct ipc_namespace *ns);
+extern int mq_init_ns(struct ipc_namespace *ns);
 /* default values */
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (131072/sizeof(void *))
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #else
-#define mq_init_ns(ns) ((void) 0)
+static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
 
 #if defined(CONFIG_IPC_NS)
-extern void free_ipc_ns(struct kref *kref);
+extern void free_ipc_ns(struct ipc_namespace *ns);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 				       struct ipc_namespace *ns);
 extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
@@ -103,14 +104,11 @@ extern void free_ipcs(struct ipc_namespa
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
-		kref_get(&ns->kref);
+		atomic_inc(&ns->count);
 	return ns;
 }
 
-static inline void put_ipc_ns(struct ipc_namespace *ns)
-{
-	kref_put(&ns->kref, free_ipc_ns);
-}
+extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
 		struct ipc_namespace *ns)
diff -puN ipc/mqueue.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues ipc/mqueue.c
--- a/ipc/mqueue.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues
+++ a/ipc/mqueue.c
@@ -88,7 +88,6 @@ static const struct file_operations mque
 static struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
 
-static spinlock_t mq_lock;
 static struct kmem_cache *mqueue_inode_cachep;
 
 static struct ctl_table_header * mq_sysctl_table;
@@ -98,27 +97,30 @@ static inline struct mqueue_inode_info *
 	return container_of(inode, struct mqueue_inode_info, vfs_inode);
 }
 
-void mq_init_ns(struct ipc_namespace *ns)
+/*
+ * This routine should be called with the mq_lock held.
+ */
+static inline struct ipc_namespace *__get_ns_from_inode(struct inode *inode)
 {
-	ns->mq_queues_count  = 0;
-	ns->mq_queues_max    = DFLT_QUEUESMAX;
-	ns->mq_msg_max       = DFLT_MSGMAX;
-	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
-	ns->mq_mnt           = mntget(init_ipc_ns.mq_mnt);
+	return get_ipc_ns(inode->i_sb->s_fs_info);
 }
 
-void mq_exit_ns(struct ipc_namespace *ns)
+static struct ipc_namespace *get_ns_from_inode(struct inode *inode)
 {
-	/* will need to clear out ns->mq_mnt->mnt_sb->s_fs_info here */
-	mntput(ns->mq_mnt);
+	struct ipc_namespace *ns;
+
+	spin_lock(&mq_lock);
+	ns = __get_ns_from_inode(inode);
+	spin_unlock(&mq_lock);
+	return ns;
 }
 
-static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
-							struct mq_attr *attr)
+static struct inode *mqueue_get_inode(struct super_block *sb,
+		struct ipc_namespace *ipc_ns, int mode,
+		struct mq_attr *attr)
 {
 	struct user_struct *u = current_user();
 	struct inode *inode;
-	struct ipc_namespace *ipc_ns = &init_ipc_ns;
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -193,30 +195,38 @@ out_inode:
 static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
+	struct ipc_namespace *ns = data;
+	int error = 0;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = MQUEUE_MAGIC;
 	sb->s_op = &mqueue_super_ops;
 
-	inode = mqueue_get_inode(sb, S_IFDIR | S_ISVTX | S_IRWXUGO, NULL);
-	if (!inode)
-		return -ENOMEM;
+	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
+				NULL);
+	if (!inode) {
+		error = -ENOMEM;
+		goto out;
+	}
 
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root) {
 		iput(inode);
-		return -ENOMEM;
+		error = -ENOMEM;
 	}
 
-	return 0;
+out:
+	return error;
 }
 
 static int mqueue_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *dev_name,
 			 void *data, struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, mqueue_fill_super, mnt);
+	if (!(flags & MS_KERNMOUNT))
+		data = current->nsproxy->ipc_ns;
+	return get_sb_ns(fs_type, flags, data, mqueue_fill_super, mnt);
 }
 
 static void init_once(void *foo)
@@ -247,12 +257,13 @@ static void mqueue_delete_inode(struct i
 	struct user_struct *user;
 	unsigned long mq_bytes;
 	int i;
-	struct ipc_namespace *ipc_ns = &init_ipc_ns;
+	struct ipc_namespace *ipc_ns;
 
 	if (S_ISDIR(inode->i_mode)) {
 		clear_inode(inode);
 		return;
 	}
+	ipc_ns = get_ns_from_inode(inode);
 	info = MQUEUE_I(inode);
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
@@ -268,10 +279,19 @@ static void mqueue_delete_inode(struct i
 	if (user) {
 		spin_lock(&mq_lock);
 		user->mq_bytes -= mq_bytes;
-		ipc_ns->mq_queues_count--;
+		/*
+		 * get_ns_from_inode() ensures that the
+		 * (ipc_ns = sb->s_fs_info) is either a valid ipc_ns
+		 * to which we now hold a reference, or it is NULL.
+		 * We can't put it here under mq_lock, though.
+		 */
+		if (ipc_ns)
+			ipc_ns->mq_queues_count--;
 		spin_unlock(&mq_lock);
 		free_uid(user);
 	}
+	if (ipc_ns)
+		put_ipc_ns(ipc_ns);
 }
 
 static int mqueue_create(struct inode *dir, struct dentry *dentry,
@@ -280,9 +300,14 @@ static int mqueue_create(struct inode *d
 	struct inode *inode;
 	struct mq_attr *attr = dentry->d_fsdata;
 	int error;
-	struct ipc_namespace *ipc_ns = &init_ipc_ns;
+	struct ipc_namespace *ipc_ns;
 
 	spin_lock(&mq_lock);
+	ipc_ns = __get_ns_from_inode(dir);
+	if (!ipc_ns) {
+		error = -EACCES;
+		goto out_unlock;
+	}
 	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
 			!capable(CAP_SYS_RESOURCE)) {
 		error = -ENOSPC;
@@ -291,7 +316,7 @@ static int mqueue_create(struct inode *d
 	ipc_ns->mq_queues_count++;
 	spin_unlock(&mq_lock);
 
-	inode = mqueue_get_inode(dir->i_sb, mode, attr);
+	inode = mqueue_get_inode(dir->i_sb, ipc_ns, mode, attr);
 	if (!inode) {
 		error = -ENOMEM;
 		spin_lock(&mq_lock);
@@ -299,6 +324,7 @@ static int mqueue_create(struct inode *d
 		goto out_unlock;
 	}
 
+	put_ipc_ns(ipc_ns);
 	dir->i_size += DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = dir->i_atime = CURRENT_TIME;
 
@@ -307,6 +333,8 @@ static int mqueue_create(struct inode *d
 	return 0;
 out_unlock:
 	spin_unlock(&mq_lock);
+	if (ipc_ns)
+		put_ipc_ns(ipc_ns);
 	return error;
 }
 
@@ -668,7 +696,7 @@ SYSCALL_DEFINE4(mq_open, const char __us
 	char *name;
 	struct mq_attr attr;
 	int fd, error;
-	struct ipc_namespace *ipc_ns = &init_ipc_ns;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
 
 	if (u_attr && copy_from_user(&attr, u_attr, sizeof(struct mq_attr)))
 		return -EFAULT;
@@ -738,7 +766,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 	char *name;
 	struct dentry *dentry;
 	struct inode *inode = NULL;
-	struct ipc_namespace *ipc_ns = &init_ipc_ns;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
 
 	name = getname(u_name);
 	if (IS_ERR(name))
@@ -1217,6 +1245,32 @@ static struct file_system_type mqueue_fs
 	.kill_sb = kill_litter_super,
 };
 
+int mq_init_ns(struct ipc_namespace *ns)
+{
+	ns->mq_queues_count  = 0;
+	ns->mq_queues_max    = DFLT_QUEUESMAX;
+	ns->mq_msg_max       = DFLT_MSGMAX;
+	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+
+	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
+	if (IS_ERR(ns->mq_mnt)) {
+		int err = PTR_ERR(ns->mq_mnt);
+		ns->mq_mnt = NULL;
+		return err;
+	}
+	return 0;
+}
+
+void mq_clear_sbinfo(struct ipc_namespace *ns)
+{
+	ns->mq_mnt->mnt_sb->s_fs_info = NULL;
+}
+
+void mq_put_mnt(struct ipc_namespace *ns)
+{
+	mntput(ns->mq_mnt);
+}
+
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = MAX_MSGMAX;
 
@@ -1288,15 +1342,14 @@ static int __init init_mqueue_fs(void)
 	if (error)
 		goto out_sysctl;
 
-	init_ipc_ns.mq_mnt = kern_mount(&mqueue_fs_type);
+	spin_lock_init(&mq_lock);
+
+	init_ipc_ns.mq_mnt = kern_mount_data(&mqueue_fs_type, &init_ipc_ns);
 	if (IS_ERR(init_ipc_ns.mq_mnt)) {
 		error = PTR_ERR(init_ipc_ns.mq_mnt);
 		goto out_filesystem;
 	}
 
-	/* internal initialization - not common for vfs */
-	spin_lock_init(&mq_lock);
-
 	return 0;
 
 out_filesystem:
diff -puN ipc/msgutil.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues ipc/msgutil.c
--- a/ipc/msgutil.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues
+++ a/ipc/msgutil.c
@@ -18,19 +18,16 @@
 
 #include "util.h"
 
+DEFINE_SPINLOCK(mq_lock);
+
 /*
  * The next 2 defines are here bc this is the only file
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
  * and not CONFIG_IPC_NS.
  */
 struct ipc_namespace init_ipc_ns = {
-	.kref = {
-		/* It's not for this patch to change, but should this be 1? */
-		.refcount	= ATOMIC_INIT(2),
-	},
+	.count		= ATOMIC_INIT(1),
 #ifdef CONFIG_POSIX_MQUEUE
-	.mq_mnt          = NULL,
-	.mq_queues_count = 0,
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
 	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
diff -puN ipc/namespace.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues ipc/namespace.c
--- a/ipc/namespace.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues
+++ a/ipc/namespace.c
@@ -9,23 +9,31 @@
 #include <linux/rcupdate.h>
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
 
 #include "util.h"
 
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	struct ipc_namespace *ns;
+	int err;
 
 	ns = kmalloc(sizeof(struct ipc_namespace), GFP_KERNEL);
 	if (ns == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	atomic_set(&ns->count, 1);
+	err = mq_init_ns(ns);
+	if (err) {
+		kfree(ns);
+		return ERR_PTR(err);
+	}
 	atomic_inc(&nr_ipc_ns);
 
 	sem_init_ns(ns);
 	msg_init_ns(ns);
 	shm_init_ns(ns);
-	mq_init_ns(ns);
 
 	/*
 	 * msgmni has already been computed for the new ipc ns.
@@ -35,7 +43,6 @@ static struct ipc_namespace *clone_ipc_n
 	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
-	kref_init(&ns->kref);
 	return ns;
 }
 
@@ -85,11 +92,34 @@ void free_ipcs(struct ipc_namespace *ns,
 	up_write(&ids->rw_mutex);
 }
 
-void free_ipc_ns(struct kref *kref)
+/*
+ * put_ipc_ns - drop a reference to an ipc namespace.
+ * @ns: the namespace to put
+ *
+ * If this is the last task in the namespace exiting, and
+ * it is dropping the refcount to 0, then it can race with
+ * a task in another ipc namespace but in a mounts namespace
+ * which has this ipcns's mqueuefs mounted, doing some action
+ * with one of the mqueuefs files.  That can raise the refcount.
+ * So dropping the refcount, and raising the refcount when
+ * accessing it through the VFS, are protected with mq_lock.
+ *
+ * (Clearly, a task raising the refcount on its own ipc_ns
+ * needn't take mq_lock since it can't race with the last task
+ * in the ipcns exiting).
+ */
+void put_ipc_ns(struct ipc_namespace *ns)
 {
-	struct ipc_namespace *ns;
+	if (atomic_dec_and_lock(&ns->count, &mq_lock)) {
+		mq_clear_sbinfo(ns);
+		spin_unlock(&mq_lock);
+		mq_put_mnt(ns);
+		free_ipc_ns(ns);
+	}
+}
 
-	ns = container_of(kref, struct ipc_namespace, kref);
+void free_ipc_ns(struct ipc_namespace *ns)
+{
 	/*
 	 * Unregistering the hotplug notifier at the beginning guarantees
 	 * that the ipc namespace won't be freed while we are inside the
@@ -102,7 +132,6 @@ void free_ipc_ns(struct kref *kref)
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	mq_exit_ns(ns);
 	kfree(ns);
 	atomic_dec(&nr_ipc_ns);
 
diff -puN ipc/util.h~namespaces-ipc-namespaces-implement-support-for-posix-msqueues ipc/util.h
--- a/ipc/util.h~namespaces-ipc-namespaces-implement-support-for-posix-msqueues
+++ a/ipc/util.h
@@ -21,9 +21,11 @@ void shm_init (void);
 struct ipc_namespace;
 
 #ifdef CONFIG_POSIX_MQUEUE
-void mq_exit_ns(struct ipc_namespace *ns);
+extern void mq_clear_sbinfo(struct ipc_namespace *ns);
+extern void mq_put_mnt(struct ipc_namespace *ns);
 #else
-static inline void mq_exit_ns(struct ipc_namespace *ns) { }
+static inline void mq_clear_sbinfo(struct ipc_namespace *ns) { }
+static inline void mq_put_mnt(struct ipc_namespace *ns) { }
 #endif
 
 #ifdef CONFIG_SYSVIPC
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
linux-next.patch
reiser4.patch

