From: akpm@linux-foundation.org
Subject: + pid-namespaces-initialize-the-namespaces-proc_mnt.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:17 -0700
Message-ID: <200708142005.l7EK5HeW018699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765480AbXHNUFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: initialize the namespace's proc_mnt
has been added to the -mm tree.  Its filename is
     pid-namespaces-initialize-the-namespaces-proc_mnt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: initialize the namespace's proc_mnt
From: Pavel Emelyanov <xemul@openvz.org>

The namespace's proc_mnt must be kern_mount-ed to make this pointer always
valid, independently of whether the user space mounted the proc or not.  This
solves raced in proc_flush_task, etc.  with the proc_mnt switching from NULL
to not-NULL.

The initialization is done after the init's pid is created and hashed to make
proc_get_sb() finr it and get for root inode.

Sice the namespace holds the vfsmnt, vfsmnt holds the superblock and the
superblock holds the namespace we must explicitly break this circle to destroy
all the stuff.  This is done after the init of the namespace dies.  Running a
few steps forward - when init exits it will kill all its children, so no
proc_mnt will be needed after its death.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |    4 ++++
 fs/proc/root.c          |   16 ++++++++++++++++
 include/linux/proc_fs.h |   12 ++++++++++++
 kernel/fork.c           |    7 +++++++
 4 files changed, 39 insertions(+)

diff -puN fs/proc/base.c~pid-namespaces-initialize-the-namespaces-proc_mnt fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-initialize-the-namespaces-proc_mnt
+++ a/fs/proc/base.c
@@ -2193,6 +2193,10 @@ void proc_flush_task(struct task_struct 
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
 				leader ? 0 : tgid->numbers[i].nr);
 	}
+
+	upid = &pid->numbers[pid->level];
+	if (upid->nr == 1)
+		pid_ns_release_proc(upid->ns);
 }
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
diff -puN fs/proc/root.c~pid-namespaces-initialize-the-namespaces-proc_mnt fs/proc/root.c
--- a/fs/proc/root.c~pid-namespaces-initialize-the-namespaces-proc_mnt
+++ a/fs/proc/root.c
@@ -212,6 +212,22 @@ struct proc_dir_entry proc_root = {
 	.parent		= &proc_root,
 };
 
+int pid_ns_prepare_proc(struct pid_namespace *ns)
+{
+	struct vfsmount *mnt;
+
+	mnt = kern_mount_data(&proc_fs_type, ns);
+	if (IS_ERR(mnt))
+		return PTR_ERR(mnt);
+
+	return 0;
+}
+
+void pid_ns_release_proc(struct pid_namespace *ns)
+{
+	mntput(ns->proc_mnt);
+}
+
 EXPORT_SYMBOL(proc_symlink);
 EXPORT_SYMBOL(proc_mkdir);
 EXPORT_SYMBOL(create_proc_entry);
diff -puN include/linux/proc_fs.h~pid-namespaces-initialize-the-namespaces-proc_mnt include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~pid-namespaces-initialize-the-namespaces-proc_mnt
+++ a/include/linux/proc_fs.h
@@ -143,6 +143,9 @@ extern const struct file_operations proc
 extern const struct file_operations proc_kmsg_operations;
 extern const struct file_operations ppc_htab_operations;
 
+extern int pid_ns_prepare_proc(struct pid_namespace *ns);
+extern void pid_ns_release_proc(struct pid_namespace *ns);
+
 /*
  * proc_tty.c
  */
@@ -250,6 +253,15 @@ static inline void proc_tty_unregister_d
 
 extern struct proc_dir_entry proc_root;
 
+static inline int pid_ns_prepare_proc(struct pid_namespace *ns)
+{
+	return 0;
+}
+
+static inline void pid_ns_release_proc(struct pid_namespace *ns)
+{
+}
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
diff -puN kernel/fork.c~pid-namespaces-initialize-the-namespaces-proc_mnt kernel/fork.c
--- a/kernel/fork.c~pid-namespaces-initialize-the-namespaces-proc_mnt
+++ a/kernel/fork.c
@@ -50,6 +50,7 @@
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
 #include <linux/tty.h>
+#include <linux/proc_fs.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1136,6 +1137,12 @@ static struct task_struct *copy_process(
 		pid = alloc_pid(task_active_pid_ns(p));
 		if (!pid)
 			goto bad_fork_cleanup_namespaces;
+
+		if (clone_flags & CLONE_NEWPID) {
+			retval = pid_ns_prepare_proc(task_active_pid_ns(p));
+			if (retval < 0)
+				goto bad_fork_free_pid;
+		}
 	}
 
 	p->pid = pid_nr(pid);
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
