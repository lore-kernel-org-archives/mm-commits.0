From: akpm@linux-foundation.org
Subject: + pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:50 -0700
Message-ID: <200708142004.l7EK4plT018592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763706AbXHNUFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: prepare proc_flust_task() to flush entries from multiple proc trees
has been added to the -mm tree.  Its filename is
     pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: prepare proc_flust_task() to flush entries from multiple proc trees
From: Pavel Emelyanov <xemul@openvz.org>

The first part is trivial - we just make the proc_flush_task() to operate on
arbitrary vfsmount with arbitrary ids and pass the pid and global proc_mnt to
it.

The other change is more tricky: I moved the proc_flush_task() call in
release_task() higher to address the following problem.

When flushing task from many proc trees we need to know the set of ids (not
just one pid) to find the dentries' names to flush.  Thus we need to pass the
task's pid to proc_flush_task() as struct pid is the only object that can
provide all the pid numbers.  But after __exit_signal() task has detached all
his pids and this information is lost.

This creates a tiny gap for proc_pid_lookup() to bring some dentries back to
tree and keep them in hash (since pids are still alive before __exit_signal())
till the next shrink, but since proc_flush_task() does not provide a 100%
guarantee that the dentries will be flushed, this is OK to do so.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   27 ++++++++++++++++++++-------
 include/linux/proc_fs.h |    4 +++-
 kernel/exit.c           |    2 +-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff -puN fs/proc/base.c~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees
+++ a/fs/proc/base.c
@@ -74,6 +74,7 @@
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
+#include <linux/pid_namespace.h>
 #include "internal.h"
 
 /* NOTE:
@@ -2122,27 +2123,27 @@ static const struct inode_operations pro
  *       that no dcache entries will exist at process exit time it
  *       just makes it very unlikely that any will persist.
  */
-void proc_flush_task(struct task_struct *task)
+static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
 	char buf[PROC_NUMBUF];
 	struct qstr name;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", task->pid);
-	dentry = d_hash_and_lookup(proc_mnt->mnt_root, &name);
+	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
 		shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}
 
-	if (thread_group_leader(task))
+	if (tgid == 0)
 		goto out;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", task->tgid);
-	leader = d_hash_and_lookup(proc_mnt->mnt_root, &name);
+	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
+	leader = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (!leader)
 		goto out;
 
@@ -2153,7 +2154,7 @@ void proc_flush_task(struct task_struct 
 		goto out_put_leader;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", task->pid);
+	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(dir, &name);
 	if (dentry) {
 		shrink_dcache_parent(dentry);
@@ -2168,6 +2169,18 @@ out:
 	return;
 }
 
+/*
+ * when flushing dentries from proc one need to flush them from global
+ * proc (proc_mnt) and from all the namespaces' procs this task was seen
+ * in. this call is supposed to make all this job.
+ */
+
+void proc_flush_task(struct task_struct *task)
+{
+	proc_flush_task_mnt(proc_mnt, task->pid,
+			thread_group_leader(task) ? 0 : task->tgid);
+}
+
 static struct dentry *proc_pid_instantiate(struct inode *dir,
 					   struct dentry * dentry,
 					   struct task_struct *task, const void *ptr)
diff -puN include/linux/proc_fs.h~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees
+++ a/include/linux/proc_fs.h
@@ -222,7 +222,9 @@ static inline void proc_net_remove(const
 #define proc_net_create(name, mode, info)	({ (void)(mode), NULL; })
 static inline void proc_net_remove(const char *name) {}
 
-static inline void proc_flush_task(struct task_struct *task) { }
+static inline void proc_flush_task(struct task_struct *task)
+{
+}
 
 static inline struct proc_dir_entry *create_proc_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
diff -puN kernel/exit.c~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees
+++ a/kernel/exit.c
@@ -157,6 +157,7 @@ void release_task(struct task_struct * p
 	int zap_leader;
 repeat:
 	atomic_dec(&p->user->processes);
+	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	ptrace_unlink(p);
 	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
@@ -184,7 +185,6 @@ repeat:
 	}
 
 	write_unlock_irq(&tasklist_lock);
-	proc_flush_task(p);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
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
