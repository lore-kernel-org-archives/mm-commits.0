From: akpm@linux-foundation.org
Subject: [merged] kernel-pidc-update-comment-on-find_task_by_pid_ns.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:36 -0800
Message-ID: <201003091906.o29J6aAY031268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab0CITW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/pid.c: update comment on find_task_by_pid_ns
has been removed from the -mm tree.  Its filename was
     kernel-pidc-update-comment-on-find_task_by_pid_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/pid.c: update comment on find_task_by_pid_ns
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

tasklist_lock does protect the task and its pid, it can't go away.  The
problem is that find_pid_ns() itself is unsafe without rcu lock, it can
race with copy_process()->free_pid(any_pid).

Protecting copy_process()->free_pid(any_pid) with tasklist_lock would make
it possible to call find_task_by_pid_ns() under tasklist safely, but we
don't do so because we are trying to get rid of the read_lock sites of
tasklist_lock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~kernel-pidc-update-comment-on-find_task_by_pid_ns kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-update-comment-on-find_task_by_pid_ns
+++ a/kernel/pid.c
@@ -376,7 +376,7 @@ struct task_struct *pid_task(struct pid 
 EXPORT_SYMBOL(pid_task);
 
 /*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
+ * Must be called under rcu_read_lock().
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


