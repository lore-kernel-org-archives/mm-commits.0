From: akpm@linux-foundation.org
Subject: - pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:19 -0700
Message-ID: <200805010931.m419VJHi030860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600AbYEAJbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: de_thread: don't clear session/pgrp pids for the old leader
has been removed from the -mm tree.  Its filename was
     pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: de_thread: don't clear session/pgrp pids for the old leader
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on Eric W. Biederman's idea.

Unless task == current, without tasklist_lock held task_session()/task_pgrp()
can return NULL if the caller races with de_thread() which switches the group
leader.

Change transfer_pid() to not clear old->pids[type].pid for the old leader. 
This means that its .pid can point to "nowhere", but this is already true for
sub-threads, and the old leader is not group_leader() any longer.  IOW, with
or without this change we can't trust task's special pids unless it is the
group leader.

With this change the following code

	rcu_read_lock();
	task = find_task_by_xxx();
	do_something(task_pgrp(task), task_session(task));
	rcu_read_unlock();

can't race with exec and hit the NULL pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc:  "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/pid.c~pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader kernel/pid.c
--- a/kernel/pid.c~pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader
+++ a/kernel/pid.c
@@ -354,7 +354,6 @@ void transfer_pid(struct task_struct *ol
 {
 	new->pids[type].pid = old->pids[type].pid;
 	hlist_replace_rcu(&old->pids[type].node, &new->pids[type].node);
-	old->pids[type].pid = NULL;
 }
 
 struct task_struct *pid_task(struct pid *pid, enum pid_type type)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

