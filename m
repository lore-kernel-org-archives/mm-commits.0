From: akpm@linux-foundation.org
Subject: - uninline-the-task_xid_nr_ns-calls.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:10 -0700
Message-ID: <200710192252.l9JMqA2R024248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966756AbXJSXGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Uninline the task_xid_nr_ns() calls
has been removed from the -mm tree.  Its filename was
     uninline-the-task_xid_nr_ns-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Uninline the task_xid_nr_ns() calls
From: Pavel Emelyanov <xemul@openvz.org>

Since these are expanded into call to pid_nr_ns() anyway, it's OK to move
the whole routine out-of-line.  This is a cheap way to save ~100 bytes from
vmlinux.  Together with the previous two patches, it saves half-a-kilo from
the vmlinux.

Un-inline other (currently inlined) functions must be done with additional
performance testing.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   24 ++++--------------------
 kernel/pid.c          |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff -puN include/linux/sched.h~uninline-the-task_xid_nr_ns-calls include/linux/sched.h
--- a/include/linux/sched.h~uninline-the-task_xid_nr_ns-calls
+++ a/include/linux/sched.h
@@ -1243,11 +1243,7 @@ static inline pid_t task_pid_nr(struct t
 	return tsk->pid;
 }
 
-static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pid(tsk), ns);
-}
+pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_pid_vnr(struct task_struct *tsk)
 {
@@ -1260,11 +1256,7 @@ static inline pid_t task_tgid_nr(struct 
 	return tsk->tgid;
 }
 
-static inline pid_t task_tgid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_tgid(tsk), ns);
-}
+pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 {
@@ -1277,11 +1269,7 @@ static inline pid_t task_pgrp_nr(struct 
 	return tsk->signal->pgrp;
 }
 
-static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pgrp(tsk), ns);
-}
+pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
 {
@@ -1294,11 +1282,7 @@ static inline pid_t task_session_nr(stru
 	return tsk->signal->__session;
 }
 
-static inline pid_t task_session_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_session(tsk), ns);
-}
+pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_session_vnr(struct task_struct *tsk)
 {
diff -puN kernel/pid.c~uninline-the-task_xid_nr_ns-calls kernel/pid.c
--- a/kernel/pid.c~uninline-the-task_xid_nr_ns-calls
+++ a/kernel/pid.c
@@ -443,6 +443,30 @@ pid_t pid_nr_ns(struct pid *pid, struct 
 	return nr;
 }
 
+pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pid(tsk), ns);
+}
+EXPORT_SYMBOL(task_pid_nr_ns);
+
+pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_tgid(tsk), ns);
+}
+EXPORT_SYMBOL(task_tgid_nr_ns);
+
+pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pgrp(tsk), ns);
+}
+EXPORT_SYMBOL(task_pgrp_nr_ns);
+
+pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_session(tsk), ns);
+}
+EXPORT_SYMBOL(task_session_nr_ns);
+
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
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
