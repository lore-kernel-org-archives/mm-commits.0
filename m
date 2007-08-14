From: akpm@linux-foundation.org
Subject: + pid-namespaces-helpers-to-obtain-pid-numbers.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:58 -0700
Message-ID: <200708142004.l7EK4wkh018606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764919AbXHNUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: helpers to obtain pid numbers
has been added to the -mm tree.  Its filename is
     pid-namespaces-helpers-to-obtain-pid-numbers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: helpers to obtain pid numbers
From: Pavel Emelyanov <xemul@openvz.org>

When showing pid to user or getting the pid numerical id for in-kernel use the
value of this id may differ depending on the namespace.

This set of helpers is used to get the global pid nr, the virtual (i.e.  seen
by task in its namespace) nr and the nr as it is seen from the specified
namespace.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h   |   24 ++++++++
 include/linux/sched.h |  108 ++++++++++++++++++++++++++++++++++++----
 kernel/pid.c          |   13 ++++
 3 files changed, 134 insertions(+), 11 deletions(-)

diff -puN include/linux/pid.h~pid-namespaces-helpers-to-obtain-pid-numbers include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-helpers-to-obtain-pid-numbers
+++ a/include/linux/pid.h
@@ -114,11 +114,33 @@ extern struct pid *find_ge_pid(int nr);
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void FASTCALL(free_pid(struct pid *pid));
 
+/*
+ * the helpers to get the pid's id seen from different namespaces
+ *
+ * pid_nr()    : global id, i.e. the id seen from the init namespace;
+ * pid_vnr()   : virtual id, i.e. the id seen from the namespace this pid
+ *               belongs to. this only makes sence when called in the
+ *               context of the task that belongs to the same namespace;
+ * pid_nr_ns() : id seen from the ns specified.
+ *
+ * see also task_xid_nr() etc in include/linux/sched.h
+ */
+
 static inline pid_t pid_nr(struct pid *pid)
 {
 	pid_t nr = 0;
 	if (pid)
-		nr = pid->nr;
+		nr = pid->numbers[0].nr;
+	return nr;
+}
+
+pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
+
+static inline pid_t pid_vnr(struct pid *pid)
+{
+	pid_t nr = 0;
+	if (pid)
+		nr = pid->numbers[pid->level].nr;
 	return nr;
 }
 
diff -puN include/linux/sched.h~pid-namespaces-helpers-to-obtain-pid-numbers include/linux/sched.h
--- a/include/linux/sched.h~pid-namespaces-helpers-to-obtain-pid-numbers
+++ a/include/linux/sched.h
@@ -1158,16 +1158,6 @@ static inline int rt_task(struct task_st
 	return rt_prio(p->prio);
 }
 
-static inline pid_t task_pgrp_nr(struct task_struct *tsk)
-{
-	return tsk->signal->pgrp;
-}
-
-static inline pid_t task_session_nr(struct task_struct *tsk)
-{
-	return tsk->signal->__session;
-}
-
 static inline void set_task_session(struct task_struct *tsk, pid_t session)
 {
 	tsk->signal->__session = session;
@@ -1193,6 +1183,104 @@ static inline struct pid *task_session(s
 	return task->group_leader->pids[PIDTYPE_SID].pid;
 }
 
+struct pid_namespace;
+
+/*
+ * the helpers to get the task's different pids as they are seen
+ * from various namespaces
+ *
+ * task_xid_nr()     : global id, i.e. the id seen from the init namespace;
+ * task_xid_vnr()    : virtual id, i.e. the id seen from the namespace the task
+ *                     belongs to. this only makes sence when called in the
+ *                     context of the task that belongs to the same namespace;
+ * task_xid_nr_ns()  : id seen from the ns specified;
+ *
+ * set_task_vxid()   : assigns a virtual id to a task;
+ *
+ * task_ppid_nr_ns() : the parent's id as seen from the namespace specified.
+ *                     the result depends on the namespace and whether the
+ *                     task in question is the namespace's init. e.g. for the
+ *                     namespace's init this will return 0 when called from
+ *                     the namespace of this init, or appropriate id otherwise.
+ *
+ *
+ * see also pid_nr() etc in include/linux/pid.h
+ */
+
+static inline pid_t task_pid_nr(struct task_struct *tsk)
+{
+	return tsk->pid;
+}
+
+static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
+		struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pid(tsk), ns);
+}
+
+static inline pid_t task_pid_vnr(struct task_struct *tsk)
+{
+	return pid_vnr(task_pid(tsk));
+}
+
+
+static inline pid_t task_tgid_nr(struct task_struct *tsk)
+{
+	return tsk->tgid;
+}
+
+static inline pid_t task_tgid_nr_ns(struct task_struct *tsk,
+		struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_tgid(tsk), ns);
+}
+
+static inline pid_t task_tgid_vnr(struct task_struct *tsk)
+{
+	return pid_vnr(task_tgid(tsk));
+}
+
+
+static inline pid_t task_pgrp_nr(struct task_struct *tsk)
+{
+	return tsk->signal->pgrp;
+}
+
+static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
+		struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pgrp(tsk), ns);
+}
+
+static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
+{
+	return pid_vnr(task_pgrp(tsk));
+}
+
+
+static inline pid_t task_session_nr(struct task_struct *tsk)
+{
+	return tsk->signal->__session;
+}
+
+static inline pid_t task_session_nr_ns(struct task_struct *tsk,
+		struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_session(tsk), ns);
+}
+
+static inline pid_t task_session_vnr(struct task_struct *tsk)
+{
+	return pid_vnr(task_session(tsk));
+}
+
+
+static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
+		struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pid(rcu_dereference(tsk->real_parent)), ns);
+}
+
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
diff -puN kernel/pid.c~pid-namespaces-helpers-to-obtain-pid-numbers kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-helpers-to-obtain-pid-numbers
+++ a/kernel/pid.c
@@ -376,6 +376,19 @@ struct pid *find_get_pid(pid_t nr)
 	return pid;
 }
 
+pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
+{
+	struct upid *upid;
+	pid_t nr = 0;
+
+	if (pid && ns->level <= pid->level) {
+		upid = &pid->numbers[ns->level];
+		if (upid->ns == ns)
+			nr = upid->nr;
+	}
+	return nr;
+}
+
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
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
