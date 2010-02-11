From: akpm@linux-foundation.org
Subject: + kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority.patch added to -mm tree
Date: Thu, 11 Feb 2010 14:49:13 -0800
Message-ID: <201002112249.o1BMnD1J000826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab0BKWuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 17:50:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, paulmck@us.ibm.com, tglx@linutronix.de


The patch titled
     kernel/sys.c: fix missing rcu protection for sys_getpriority()
has been added to the -mm tree.  Its filename is
     kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority.patch

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
Subject: kernel/sys.c: fix missing rcu protection for sys_getpriority()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

find_task_by_vpid() is not safe without rcu_read_lock().  2.6.33-rc7 got
RCU protection for sys_setpriority() but missed it for sys_getpriority().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sys.c~kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority
+++ a/kernel/sys.c
@@ -223,6 +223,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -268,6 +269,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
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
kernel-sysc-fix-missing-rcu-protection-for-sys_getpriority.patch
kernel-pidc-update-comment-on-find_task_by_pid_ns.patch

