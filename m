From: akpm@linux-foundation.org
Subject: - pid-namespaces-destroy-pid-namespace-on-inits-death.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:56 -0700
Message-ID: <200710192251.l9JMpu7U024224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966753AbXJSXGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: destroy pid namespace on init's death
has been removed from the -mm tree.  Its filename was
     pid-namespaces-destroy-pid-namespace-on-inits-death.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: destroy pid namespace on init's death
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Terminate all processes in a namespace when the reaper of the namespace is
exiting.  We do this by walking the pidmap of the namespace and sending
SIGKILL to all processes.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    1 +
 kernel/exit.c       |   27 ++++++++++++++++++++++++++-
 kernel/pid.c        |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff -puN include/linux/pid.h~pid-namespaces-destroy-pid-namespace-on-inits-death include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-destroy-pid-namespace-on-inits-death
+++ a/include/linux/pid.h
@@ -125,6 +125,7 @@ extern struct pid *find_ge_pid(int nr, s
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void FASTCALL(free_pid(struct pid *pid));
+extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 
 /*
  * the helpers to get the pid's id seen from different namespaces
diff -puN kernel/exit.c~pid-namespaces-destroy-pid-namespace-on-inits-death kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-destroy-pid-namespace-on-inits-death
+++ a/kernel/exit.c
@@ -879,7 +879,32 @@ static inline void exit_child_reaper(str
 	if (likely(tsk->group_leader != task_child_reaper(tsk)))
 		return;
 
-	panic("Attempted to kill init!");
+	if (tsk->nsproxy->pid_ns == &init_pid_ns)
+		panic("Attempted to kill init!");
+
+	/*
+	 * @tsk is the last thread in the 'cgroup-init' and is exiting.
+	 * Terminate all remaining processes in the namespace and reap them
+	 * before exiting @tsk.
+	 *
+	 * Note that @tsk (last thread of cgroup-init) may not necessarily
+	 * be the child-reaper (i.e main thread of cgroup-init) of the
+	 * namespace i.e the child_reaper may have already exited.
+	 *
+	 * Even after a child_reaper exits, we let it inherit orphaned children,
+	 * because, pid_ns->child_reaper remains valid as long as there is
+	 * at least one living sub-thread in the cgroup init.
+
+	 * This living sub-thread of the cgroup-init will be notified when
+	 * a child inherited by the 'child-reaper' exits (do_notify_parent()
+	 * uses __group_send_sig_info()). Further, when reaping child processes,
+	 * do_wait() iterates over children of all living sub threads.
+
+	 * i.e even though 'child_reaper' thread is listed as the parent of the
+	 * orphaned children, any living sub-thread in the cgroup-init can
+	 * perform the role of the child_reaper.
+	 */
+	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
 }
 
 fastcall NORET_TYPE void do_exit(long code)
diff -puN kernel/pid.c~pid-namespaces-destroy-pid-namespace-on-inits-death kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-destroy-pid-namespace-on-inits-death
+++ a/kernel/pid.c
@@ -34,6 +34,7 @@
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
+#include <linux/syscalls.h>
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
@@ -567,6 +568,43 @@ void free_pid_ns(struct kref *kref)
 		put_pid_ns(parent);
 }
 
+void zap_pid_ns_processes(struct pid_namespace *pid_ns)
+{
+	int nr;
+	int rc;
+
+	/*
+	 * The last thread in the cgroup-init thread group is terminating.
+	 * Find remaining pid_ts in the namespace, signal and wait for them
+	 * to exit.
+	 *
+	 * Note:  This signals each threads in the namespace - even those that
+	 * 	  belong to the same thread group, To avoid this, we would have
+	 * 	  to walk the entire tasklist looking a processes in this
+	 * 	  namespace, but that could be unnecessarily expensive if the
+	 * 	  pid namespace has just a few processes. Or we need to
+	 * 	  maintain a tasklist for each pid namespace.
+	 *
+	 */
+	read_lock(&tasklist_lock);
+	nr = next_pidmap(pid_ns, 1);
+	while (nr > 0) {
+		kill_proc_info(SIGKILL, SEND_SIG_PRIV, nr);
+		nr = next_pidmap(pid_ns, nr);
+	}
+	read_unlock(&tasklist_lock);
+
+	do {
+		clear_thread_flag(TIF_SIGPENDING);
+		rc = sys_wait4(-1, NULL, __WALL, NULL);
+	} while (rc != -ECHILD);
+
+
+	/* Child reaper for the pid namespace is going away */
+	pid_ns->child_reaper = NULL;
+	return;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch
