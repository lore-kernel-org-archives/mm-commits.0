From: akpm@linux-foundation.org
Subject: - pidns-remove-now-unused-find_pid-function.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:31 -0700
Message-ID: <200807252302.m6PN2VIE003831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408AbYGYXGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pidns: remove now unused find_pid function.
has been removed from the -mm tree.  Its filename was
     pidns-remove-now-unused-find_pid-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: remove now unused find_pid function.
From: Pavel Emelyanov <xemul@openvz.org>

This one had the only users so far - the kill_proc, which is removed, so
drop this (invalid in namespaced world) call too.

And of course - erase all references on it from comments.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h   |    4 +---
 include/linux/sched.h |    2 +-
 kernel/pid.c          |    8 +-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff -puN include/linux/pid.h~pidns-remove-now-unused-find_pid-function include/linux/pid.h
--- a/include/linux/pid.h~pidns-remove-now-unused-find_pid-function
+++ a/include/linux/pid.h
@@ -48,7 +48,7 @@ enum pid_type
  */
 
 struct upid {
-	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
 	int nr;
 	struct pid_namespace *ns;
 	struct hlist_node pid_chain;
@@ -105,14 +105,12 @@ extern struct pid_namespace init_pid_ns;
  * or rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
- * find_pid() find the pid by its global id, i.e. in the init namespace
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
  * see also find_task_by_pid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
-extern struct pid *find_pid(int nr);
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
diff -puN include/linux/sched.h~pidns-remove-now-unused-find_pid-function include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-now-unused-find_pid-function
+++ a/include/linux/sched.h
@@ -1718,7 +1718,7 @@ extern struct pid_namespace init_pid_ns;
  * find_task_by_pid():
  *      finds a task by its global pid
  *
- * see also find_pid() etc in include/linux/pid.h
+ * see also find_vpid() etc in include/linux/pid.h
  */
 
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
diff -puN kernel/pid.c~pidns-remove-now-unused-find_pid-function kernel/pid.c
--- a/kernel/pid.c~pidns-remove-now-unused-find_pid-function
+++ a/kernel/pid.c
@@ -309,12 +309,6 @@ struct pid *find_vpid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_vpid);
 
-struct pid *find_pid(int nr)
-{
-	return find_pid_ns(nr, &init_pid_ns);
-}
-EXPORT_SYMBOL_GPL(find_pid);
-
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
@@ -483,7 +477,7 @@ EXPORT_SYMBOL(task_session_nr_ns);
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
- * If there is a pid at nr this function is exactly the same as find_pid.
+ * If there is a pid at nr this function is exactly the same as find_pid_ns.
  */
 struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

