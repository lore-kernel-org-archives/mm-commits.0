From: akpm@linux-foundation.org
Subject: + proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:37:53 -0700
Message-ID: <201107222237.p6MMbrJC019264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376Ab1GVWiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, davem@davemloft.net, johnpol@2ka.mipt.ru, vzapolskiy@gmail.com, zbr@ioremap.net


The patch titled
     proc_fork_connector: a lockless ->real_parent usage is not safe
has been added to the -mm tree.  Its filename is
     proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fork_connector: a lockless ->real_parent usage is not safe
From: Oleg Nesterov <oleg@redhat.com>

proc_fork_connector() uses ->real_parent lockless.  This is not safe if
copy_process() was called with CLONE_THREAD or CLONE_PARENT, in this case
the parent != current can go away at any moment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/cn_proc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/connector/cn_proc.c~proc_fork_connector-a-lockless-real_parent-usage-is-not-safe drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~proc_fork_connector-a-lockless-real_parent-usage-is-not-safe
+++ a/drivers/connector/cn_proc.c
@@ -56,6 +56,7 @@ void proc_fork_connector(struct task_str
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
+	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -66,8 +67,11 @@ void proc_fork_connector(struct task_str
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_FORK;
-	ev->event_data.fork.parent_pid = task->real_parent->pid;
-	ev->event_data.fork.parent_tgid = task->real_parent->tgid;
+	rcu_read_lock();
+	parent = rcu_dereference(task->real_parent);
+	ev->event_data.fork.parent_pid = parent->pid;
+	ev->event_data.fork.parent_tgid = parent->tgid;
+	rcu_read_unlock();
 	ev->event_data.fork.child_pid = task->pid;
 	ev->event_data.fork.child_tgid = task->tgid;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

