From: akpm@linux-foundation.org
Subject: + locking-hung_task-defer-showing-held-locks.patch added to -mm
 tree
Date: Mon, 13 Mar 2017 12:47:42 -0700
Message-ID: <58c6f75e./lg5fhF88dXzpg6K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdCMTro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2017 15:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mingo@kernel.org, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: defer showing held locks
has been added to the -mm tree.  Its filename is
     locking-hung_task-defer-showing-held-locks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/locking-hung_task-defer-showing-held-locks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/locking-hung_task-defer-showing-held-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kernel/hung_task.c: defer showing held locks

When I was running my testcase which may block hundreds of threads on fs
locks, I got lockup due to output from debug_show_all_locks() added by
commit b2d4c2edb2e4f89a ("locking/hung_task: Show all locks").

For example, if 1000 threads were blocked in TASK_UNINTERRUPTIBLE state
and 500 out of 1000 threads hold some lock, debug_show_all_locks() from
for_each_process_thread() loop will report locks held by 500 threads for
1000 times.  This is a too much noise.

In order to make sure rcu_lock_break() is called frequently, we should
avoid calling debug_show_all_locks() from for_each_process_thread() loop
because debug_show_all_locks() effectively calls for_each_process_thread()
loop.  Let's defer calling debug_show_all_locks() till before panic() or
leaving for_each_process_thread() loop.

Link: http://lkml.kernel.org/r/1489296834-60436-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/hung_task.c~locking-hung_task-defer-showing-held-locks kernel/hung_task.c
--- a/kernel/hung_task.c~locking-hung_task-defer-showing-held-locks
+++ a/kernel/hung_task.c
@@ -43,6 +43,7 @@ unsigned long __read_mostly sysctl_hung_
 int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
+static bool hung_task_show_lock;
 
 static struct task_struct *watchdog_task;
 
@@ -120,12 +121,14 @@ static void check_hung_task(struct task_
 		pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 		sched_show_task(t);
-		debug_show_all_locks();
+		hung_task_show_lock = true;
 	}
 
 	touch_nmi_watchdog();
 
 	if (sysctl_hung_task_panic) {
+		if (hung_task_show_lock)
+			debug_show_all_locks();
 		trigger_all_cpu_backtrace();
 		panic("hung_task: blocked tasks");
 	}
@@ -172,6 +175,7 @@ static void check_hung_uninterruptible_t
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
+	hung_task_show_lock = false;
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
 		if (!max_count--)
@@ -187,6 +191,8 @@ static void check_hung_uninterruptible_t
 	}
  unlock:
 	rcu_read_unlock();
+	if (hung_task_show_lock)
+		debug_show_all_locks();
 }
 
 static long hung_timeout_jiffies(unsigned long last_checked,
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

locking-hung_task-defer-showing-held-locks.patch

