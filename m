From: akpm@linux-foundation.org
Subject: + pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch added to -mm tree
Date: Tue, 07 Aug 2007 00:32:41 -0700
Message-ID: <200708070732.l777WfDk006741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbXHGHei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 03:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org


The patch titled
     pid namespaces: define and use task_active_pid_ns() wrapper
has been added to the -mm tree.  Its filename is
     pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: define and use task_active_pid_ns() wrapper
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

With multiple pid namespaces, a process is known by some pid_t in every
ancestor pid namespace.  Every time the process forks, the child process also
gets a pid_t in every ancestor pid namespace.

While a process is visible in >=1 pid namespaces, it can see pid_t's in only
one pid namespace.  We call this pid namespace it's "active pid namespace",
and it is always the youngest pid namespace in which the process is known.

This patch defines and uses a wrapper to find the active pid namespace of a
process.  The implementation of the wrapper will be changed in when support
for multiple pid namespaces are added.

Changelog:
	2.6.22-rc4-mm2-pidns1:
	- [Pavel Emelianov, Alexey Dobriyan] Back out the change to use
	  task_active_pid_ns() in child_reaper() since task->nsproxy
	  can be NULL during task exit (so child_reaper() continues to
	  use init_pid_ns).

	  to implement child_reaper() since init_pid_ns.child_reaper to
	  implement child_reaper() since tsk->nsproxy can be NULL during exit.

	2.6.21-rc6-mm1:
	- Rename task_pid_ns() to task_active_pid_ns() to reflect that a
	  process can have multiple pid namespaces.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelianov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzel <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                     |    2 +-
 fs/proc/proc_misc.c           |    3 ++-
 include/linux/pid_namespace.h |    5 +++++
 kernel/nsproxy.c              |    2 +-
 kernel/pid.c                  |    4 ++--
 5 files changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper fs/exec.c
--- a/fs/exec.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper
+++ a/fs/exec.c
@@ -804,7 +804,7 @@ static int de_thread(struct task_struct 
 	 * so it is safe to do it under read_lock.
 	 */
 	if (unlikely(tsk->group_leader == child_reaper(tsk)))
-		tsk->nsproxy->pid_ns->child_reaper = tsk;
+		task_active_pid_ns(tsk)->child_reaper = tsk;
 
 	zap_other_threads(tsk);
 	read_unlock(&tasklist_lock);
diff -puN fs/proc/proc_misc.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper
+++ a/fs/proc/proc_misc.c
@@ -94,7 +94,8 @@ static int loadavg_read_proc(char *page,
 		LOAD_INT(a), LOAD_FRAC(a),
 		LOAD_INT(b), LOAD_FRAC(b),
 		LOAD_INT(c), LOAD_FRAC(c),
-		nr_running(), nr_threads, current->nsproxy->pid_ns->last_pid);
+		nr_running(), nr_threads,
+		task_active_pid_ns(current)->last_pid);
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
diff -puN include/linux/pid_namespace.h~pid-namespaces-define-and-use-task_active_pid_ns-wrapper include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-define-and-use-task_active_pid_ns-wrapper
+++ a/include/linux/pid_namespace.h
@@ -39,6 +39,11 @@ static inline void put_pid_ns(struct pid
 	kref_put(&ns->kref, free_pid_ns);
 }
 
+static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
+{
+	return tsk->nsproxy->pid_ns;
+}
+
 static inline struct task_struct *child_reaper(struct task_struct *tsk)
 {
 	return init_pid_ns.child_reaper;
diff -puN kernel/exit.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper kernel/exit.c
diff -puN kernel/nsproxy.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper kernel/nsproxy.c
--- a/kernel/nsproxy.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper
+++ a/kernel/nsproxy.c
@@ -86,7 +86,7 @@ static struct nsproxy *create_new_namesp
 		goto out_ipc;
 	}
 
-	new_nsp->pid_ns = copy_pid_ns(flags, tsk->nsproxy->pid_ns);
+	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
 		err = PTR_ERR(new_nsp->pid_ns);
 		goto out_pid;
diff -puN kernel/pid.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-define-and-use-task_active_pid_ns-wrapper
+++ a/kernel/pid.c
@@ -214,7 +214,7 @@ struct pid *alloc_pid(void)
 	int nr = -1;
 	struct pid_namespace *ns;
 
-	ns = current->nsproxy->pid_ns;
+	ns = task_active_pid_ns(current);
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
 		goto out;
@@ -364,7 +364,7 @@ struct pid *find_ge_pid(int nr)
 		pid = find_pid(nr);
 		if (pid)
 			break;
-		nr = next_pidmap(current->nsproxy->pid_ns, nr);
+		nr = next_pidmap(task_active_pid_ns(current), nr);
 	} while (nr > 0);
 
 	return pid;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
