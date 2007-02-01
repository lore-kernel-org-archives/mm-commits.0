From: akpm@osdl.org
Subject: - user-ns-add-user_namespace-ptr-to-vfsmount.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:24:52 -0800
Message-ID: <200702010125.l111Poii032635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161216AbXBAB1A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:27:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user ns: add user_namespace ptr to vfsmount
has been removed from the -mm tree.  Its filename was
     user-ns-add-user_namespace-ptr-to-vfsmount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: user ns: add user_namespace ptr to vfsmount


Add user_namespace ptr to vfsmount, and define a helper to compare it to the
task's user_ns.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namespace.c        |    3 +++
 include/linux/mount.h |    2 ++
 include/linux/sched.h |   28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff -puN fs/namespace.c~user-ns-add-user_namespace-ptr-to-vfsmount fs/namespace.c
--- a/fs/namespace.c~user-ns-add-user_namespace-ptr-to-vfsmount
+++ a/fs/namespace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -55,6 +56,7 @@ struct vfsmount *alloc_vfsmnt(const char
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
+		mnt->mnt_user_ns = get_user_ns(current->nsproxy->user_ns);
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -87,6 +89,7 @@ EXPORT_SYMBOL(simple_set_mnt);
 
 void free_vfsmnt(struct vfsmount *mnt)
 {
+	put_user_ns(mnt->mnt_user_ns);
 	kfree(mnt->mnt_devname);
 	kmem_cache_free(mnt_cache, mnt);
 }
diff -puN include/linux/mount.h~user-ns-add-user_namespace-ptr-to-vfsmount include/linux/mount.h
--- a/include/linux/mount.h~user-ns-add-user_namespace-ptr-to-vfsmount
+++ a/include/linux/mount.h
@@ -21,6 +21,7 @@ struct super_block;
 struct vfsmount;
 struct dentry;
 struct mnt_namespace;
+struct user_namespace;
 
 #define MNT_NOSUID	0x01
 #define MNT_NODEV	0x02
@@ -53,6 +54,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	struct user_namespace *mnt_user_ns; /* namespace for uid interpretation */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
diff -puN include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount include/linux/sched.h
--- a/include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount
+++ a/include/linux/sched.h
@@ -83,6 +83,8 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/nsproxy.h>
+#include <linux/mount.h>
 
 #include <asm/processor.h>
 
@@ -1598,6 +1600,32 @@ extern int cond_resched(void);
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
+#ifdef CONFIG_USER_NS
+/*
+ * Check whether a task and a vfsmnt belong to the same uidns.
+ * Since the initial namespace is exempt from these checks,
+ * return 1 if so.  Also return 1 if the vfsmnt is exempt from
+ * such checking.  Otherwise, if the uid namespaces are different,
+ * return 0.
+ */
+static inline int task_mnt_same_uidns(struct task_struct *tsk,
+					struct vfsmount *mnt)
+{
+	if (tsk->nsproxy == init_task.nsproxy)
+		return 1;
+	if (mnt->mnt_user_ns == tsk->nsproxy->user_ns)
+		return 1;
+	return 0;
+}
+#else
+static inline int task_mnt_same_uidns(struct task_struct *tsk,
+					struct vfsmount *mnt)
+{
+	return 1;
+}
+#endif
+
+
 /*
  * Does a critical section need to be broken due to another
  * task waiting?:
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
