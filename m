From: akpm@linux-foundation.org
Subject: [merged] user-namespace-make-signalc-respect-user-namespaces-v5.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:33:33 -0800
Message-ID: <20120111213334.170E61E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52712 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab2AKVde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:33:34 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137556ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:33:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, dan.carpenter@oracle.com, ebiederm@xmission.com, matthltc@us.ibm.com, oleg@redhat.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: user namespace: make signal.c respect user namespaces
has been removed from the -mm tree.  Its filename was
     user-namespace-make-signalc-respect-user-namespaces-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: user namespace: make signal.c respect user namespaces

ipc/mqueue.c: for __SI_MESQ, convert the uid being sent to recipient's
user namespace. (new, thanks Oleg)

__send_signal: convert current's uid to the recipient's user namespace
for any siginfo which is not SI_FROMKERNEL (patch from Oleg, thanks
again :)

do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
user namespace

ptrace_signal maps parent's uid into current's user namespace before
including in signal to current.  IIUC Oleg has argued that this shouldn't
matter as the debugger will play with it, but it seems like not converting
the value currently being set is misleading.

Changelog:
Sep 20: Inspired by Oleg's suggestion, define map_cred_ns() helper to
	simplify callers and help make clear what we are translating
        (which uid into which namespace).  Passing the target task would
	make callers even easier to read, but we pass in user_ns because
	current_user_ns() != task_cred_xxx(current, user_ns).
Sep 20: As recommended by Oleg, also put task_pid_vnr() under rcu_read_lock
	in ptrace_signal().
Sep 23: In send_signal(), detect when (user) signal is coming from an
	ancestor or unrelated user namespace.  Pass that on to __send_signal,
	which sets si_uid to 0 or overflowuid if needed.
Oct 12: Base on Oleg's fixup_uid() patch.  On top of that, handle all
	SI_FROMKERNEL cases at callers, because we can't assume sender is
	current in those cases.
Nov 10: (mhelsley) rename fixup_uid to more meaningful usern_fixup_signal_uid
Nov 10: (akpm) make the !CONFIG_USER_NS case clearer

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
From: Serge Hallyn <serge.hallyn@canonical.com>
Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid (v2)

Eric Biederman pointed out that passing info is a bug and could lead to a
NULL pointer deref to boot.

A collection of signal, securebits, filecaps, cap_bounds, and a few other
ltp tests passed with this kernel.

Changelog:
    Nov 18: previous patch missed a leading '&'

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ipc/mqueue: lock() => unlock() typo

There was a double lock typo introduced in b085f4bd6b21 "user namespace:
make signal.c respect user namespaces"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c    |    7 ++++++-
 kernel/signal.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 4 deletions(-)

diff -puN ipc/mqueue.c~user-namespace-make-signalc-respect-user-namespaces-v5 ipc/mqueue.c
--- a/ipc/mqueue.c~user-namespace-make-signalc-respect-user-namespaces-v5
+++ a/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
+#include <linux/user_namespace.h>
 #include <linux/slab.h>
 
 #include <net/sock.h>
@@ -542,9 +543,13 @@ static void __do_notify(struct mqueue_in
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
+			/* map current pid/uid into info->owner's namespaces */
+			rcu_read_lock();
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = current_uid();
+			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
+						current_cred(), current_uid());
+			rcu_read_unlock();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff -puN kernel/signal.c~user-namespace-make-signalc-respect-user-namespaces-v5 kernel/signal.c
--- a/kernel/signal.c~user-namespace-make-signalc-respect-user-namespaces-v5
+++ a/kernel/signal.c
@@ -28,6 +28,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/user_namespace.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
@@ -1019,6 +1020,34 @@ static inline int legacy_queue(struct si
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
+/*
+ * map the uid in struct cred into user namespace *ns
+ */
+static inline uid_t map_cred_ns(const struct cred *cred,
+				struct user_namespace *ns)
+{
+	return user_ns_map_uid(ns, cred, cred->uid);
+}
+
+#ifdef CONFIG_USER_NS
+static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
+{
+	if (current_user_ns() == task_cred_xxx(t, user_ns))
+		return;
+
+	if (SI_FROMKERNEL(info))
+		return;
+
+	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
+					current_cred(), info->si_uid);
+}
+#else
+static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
+{
+	return;
+}
+#endif
+
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group, int from_ancestor_ns)
 {
@@ -1088,6 +1117,9 @@ static int __send_signal(int sig, struct
 				q->info.si_pid = 0;
 			break;
 		}
+
+		userns_fixup_signal_uid(&q->info, t);
+
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
 			/*
@@ -1626,7 +1658,8 @@ bool do_notify_parent(struct task_struct
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+			task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
@@ -1709,7 +1742,8 @@ static void do_notify_parent_cldstop(str
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+			task_cred_xxx(parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2125,8 +2159,11 @@ static int ptrace_signal(int signr, sigi
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
+		rcu_read_lock();
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		info->si_uid = map_cred_ns(__task_cred(current->parent),
+				current_user_ns());
+		rcu_read_unlock();
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch

