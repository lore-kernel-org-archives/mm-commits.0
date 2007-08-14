From: akpm@linux-foundation.org
Subject: + pid-namespaces-allow-cloning-of-new-namespace.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:13 -0700
Message-ID: <200708142005.l7EK5Evg018693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbXHNUKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:10:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: allow cloning of new namespace
has been added to the -mm tree.  Its filename is
     pid-namespaces-allow-cloning-of-new-namespace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: allow cloning of new namespace
From: Pavel Emelyanov <xemul@openvz.org>

When clone() is invoked with CLONE_NEWPID, create a new pid namespace and then
create a new struct pid for the new process.  Allocate pid_t's for the new
process in the new pid namespace and all ancestor pid namespaces.  Make the
newly cloned process the session and process group leader.

Since the active pid namespace is special and expected to be the first entry
in pid->upid_list, preserve the order of pid namespaces.

The size of 'struct pid' is dependent on the the number of pid namespaces the
process exists in, so we use multiple pid-caches'.  Only one pid cache is
created during system startup and this used by processes that exist only in
init_pid_ns.

When a process clones its pid namespace, we create additional pid caches as
necessary and use the pid cache to allocate 'struct pids' for that depth.

Note, that with this patch the newly created namespace won't work, since the
rest of the kernel still uses global pids, but this is to be fixed soon.  Init
pid namespace still works.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 
 kernel/fork.c         |   48 ++++++++++++++-------
 kernel/nsproxy.c      |    3 -
 kernel/pid.c          |   88 +++++++++++++++++++++++++++++++++++++---
 4 files changed, 117 insertions(+), 23 deletions(-)

diff -puN include/linux/sched.h~pid-namespaces-allow-cloning-of-new-namespace include/linux/sched.h
--- a/include/linux/sched.h~pid-namespaces-allow-cloning-of-new-namespace
+++ a/include/linux/sched.h
@@ -25,6 +25,7 @@
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
+#define CLONE_NEWPID		0x20000000	/* New pid namespace */
 
 /*
  * Scheduling policies
diff -puN kernel/fork.c~pid-namespaces-allow-cloning-of-new-namespace kernel/fork.c
--- a/kernel/fork.c~pid-namespaces-allow-cloning-of-new-namespace
+++ a/kernel/fork.c
@@ -961,7 +961,6 @@ static struct task_struct *copy_process(
 					unsigned long stack_start,
 					struct pt_regs *regs,
 					unsigned long stack_size,
-					int __user *parent_tidptr,
 					int __user *child_tidptr,
 					struct pid *pid)
 {
@@ -1269,11 +1268,22 @@ static struct task_struct *copy_process(
 			__ptrace_link(p, current->parent);
 
 		if (thread_group_leader(p)) {
-			p->signal->tty = current->signal->tty;
-			p->signal->pgrp = task_pgrp_nr(current);
-			set_task_session(p, task_session_nr(current));
-			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
-			attach_pid(p, PIDTYPE_SID, task_session(current));
+			if (clone_flags & CLONE_NEWPID) {
+				p->nsproxy->pid_ns->child_reaper = p;
+				p->signal->tty = NULL;
+				p->signal->pgrp = p->pid;
+				set_task_session(p, p->pid);
+				attach_pid(p, PIDTYPE_PGID, pid);
+				attach_pid(p, PIDTYPE_SID, pid);
+			} else {
+				p->signal->tty = current->signal->tty;
+				p->signal->pgrp = task_pgrp_nr(current);
+				set_task_session(p, task_session_nr(current));
+				attach_pid(p, PIDTYPE_PGID,
+						task_pgrp(current));
+				attach_pid(p, PIDTYPE_SID,
+						task_session(current));
+			}
 
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
@@ -1286,13 +1296,6 @@ static struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 
-	/*
-	 * Now that we know the fork has succeeded, record the new
-	 * TID.  It's too late to back out if this fails.
-	 */
-	if (clone_flags & CLONE_PARENT_SETTID)
-		put_user(p->pid, parent_tidptr);
-
 	proc_fork_connector(p);
 	container_post_fork(p);
 	return p;
@@ -1353,7 +1356,7 @@ struct task_struct * __cpuinit fork_idle
 	struct task_struct *task;
 	struct pt_regs regs;
 
-	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL, NULL,
+	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
 				&init_struct_pid);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
@@ -1401,7 +1404,7 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			parent_tidptr, child_tidptr, NULL);
+			child_tidptr, NULL);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1409,7 +1412,20 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
-		nr = pid_nr(task_pid(p));
+		/*
+		 * this is enough to call pid_nr_ns here, but this if
+		 * improves optimisation of regular fork()
+		 */
+		nr = (clone_flags & CLONE_NEWPID) ?
+			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
+				task_pid_vnr(p);
+
+		/*
+		 * Now that we know the fork has succeeded, record the new
+		 * TID.  It's too late to back out if this fails.
+		 */
+		if (clone_flags & CLONE_PARENT_SETTID)
+			put_user(nr, parent_tidptr);
 
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
diff -puN kernel/nsproxy.c~pid-namespaces-allow-cloning-of-new-namespace kernel/nsproxy.c
--- a/kernel/nsproxy.c~pid-namespaces-allow-cloning-of-new-namespace
+++ a/kernel/nsproxy.c
@@ -124,7 +124,8 @@ int copy_namespaces(unsigned long flags,
 
 	get_nsproxy(old_ns);
 
-	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER)))
+	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
+					CLONE_NEWUSER | CLONE_NEWPID)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN)) {
diff -puN kernel/pid.c~pid-namespaces-allow-cloning-of-new-namespace kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-allow-cloning-of-new-namespace
+++ a/kernel/pid.c
@@ -18,6 +18,12 @@
  * allocation scenario when all but one out of 1 million PIDs possible are
  * allocated already: the scanning of 32 list entries and at most PAGE_SIZE
  * bytes. The typical fastpath is a single successful setbit. Freeing is O(1).
+ *
+ * Pid namespaces:
+ *    (C) 2007 Pavel Emelyanov <xemul@openvz.org>, OpenVZ, SWsoft Inc.
+ *    (C) 2007 Sukadev Bhattiprolu <sukadev@us.ibm.com>, IBM
+ *     Many thanks to Oleg Nesterov for comments and help
+ *
  */
 
 #include <linux/mm.h>
@@ -455,8 +461,8 @@ static struct kmem_cache *create_pid_cac
 
 	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
 	cachep = kmem_cache_create(pcache->name,
-			/* FIXME add numerical ids here */
-			sizeof(struct pid), 0, SLAB_HWCACHE_ALIGN, NULL);
+			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
+			0, SLAB_HWCACHE_ALIGN, NULL);
 	if (cachep == NULL)
 		goto err_cachep;
 
@@ -474,19 +480,89 @@ err_alloc:
 	return NULL;
 }
 
+static struct pid_namespace *create_pid_namespace(int level)
+{
+	struct pid_namespace *ns;
+	int i;
+
+	ns = kmalloc(sizeof(struct pid_namespace), GFP_KERNEL);
+	if (ns == NULL)
+		goto out;
+
+	ns->pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!ns->pidmap[0].page)
+		goto out_free;
+
+	ns->pid_cachep = create_pid_cachep(level + 1);
+	if (ns->pid_cachep == NULL)
+		goto out_free_map;
+
+	kref_init(&ns->kref);
+	ns->last_pid = 0;
+	ns->child_reaper = NULL;
+	ns->level = level;
+
+	set_bit(0, ns->pidmap[0].page);
+	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
+
+	for (i = 1; i < PIDMAP_ENTRIES; i++) {
+		ns->pidmap[i].page = 0;
+		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
+	}
+
+	return ns;
+
+out_free_map:
+	kfree(ns->pidmap[0].page);
+out_free:
+	kfree(ns);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+static void destroy_pid_namespace(struct pid_namespace *ns)
+{
+	int i;
+
+	for (i = 0; i < PIDMAP_ENTRIES; i++)
+		kfree(ns->pidmap[i].page);
+	kfree(ns);
+}
+
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
+	struct pid_namespace *new_ns;
+
 	BUG_ON(!old_ns);
-	get_pid_ns(old_ns);
-	return old_ns;
+	new_ns = get_pid_ns(old_ns);
+	if (!(flags & CLONE_NEWPID))
+		goto out;
+
+	new_ns = ERR_PTR(-EINVAL);
+	if (flags & CLONE_THREAD)
+		goto out_put;
+
+	new_ns = create_pid_namespace(old_ns->level + 1);
+	if (new_ns != NULL)
+		new_ns->parent = get_pid_ns(old_ns);
+
+out_put:
+	put_pid_ns(old_ns);
+out:
+	return new_ns;
 }
 
 void free_pid_ns(struct kref *kref)
 {
-	struct pid_namespace *ns;
+	struct pid_namespace *ns, *parent;
 
 	ns = container_of(kref, struct pid_namespace, kref);
-	kfree(ns);
+
+	parent = ns->parent;
+	destroy_pid_namespace(ns);
+
+	if (parent != NULL)
+		put_pid_ns(parent);
 }
 
 /*
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
