From: akpm@linux-foundation.org
Subject: [merged] proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch removed from -mm tree
Date: Mon, 01 Aug 2011 11:49:27 -0700
Message-ID: <201108011847.p71IlJ9L005629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab1HASrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 14:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, davem@davemloft.net, johnpol@2ka.mipt.ru, vzapolskiy@gmail.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     proc_fork_connector: a lockless ->real_parent usage is not safe
has been removed from the -mm tree.  Its filename was
     proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -57,6 +57,7 @@ void proc_fork_connector(struct task_str
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
+	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -67,8 +68,11 @@ void proc_fork_connector(struct task_str
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

origin.patch
taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch
taskstats-add_del_listener-should-ignore-valid-listeners.patch
linux-next.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

