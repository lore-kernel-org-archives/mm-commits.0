From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:27 -0800
Message-ID: <201002241939.o1OJdR9M016299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757862Ab0BXTk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, paulmck@us.ibm.com, serue@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: fix missing rcu protection for sys_getpriority()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: fix missing rcu protection for sys_getpriority()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

find_task_by_vpid() is not safe without rcu_read_lock().  2.6.33-rc7 got
RCU protection for sys_setpriority() but missed it for sys_getpriority().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sys.c~kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority
+++ a/kernel/sys.c
@@ -222,6 +222,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -267,6 +268,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return retval;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
linux-next.patch
kernel-pidc-update-comment-on-find_task_by_pid_ns.patch

