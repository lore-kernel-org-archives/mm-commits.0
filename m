From: akpm@linux-foundation.org
Subject: - fix-stop_machine_run-problem-with-naughty-real-time-process.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:18 -0700
Message-ID: <200707162053.l6GKrIrK001616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759966AbXGPVgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, ashok.raj@intel.com, ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix stop_machine_run problem with naughty real time process
has been removed from the -mm tree.  Its filename was
     fix-stop_machine_run-problem-with-naughty-real-time-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix stop_machine_run problem with naughty real time process
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

stop_machine_run() does its work on "kstopmachine" thread having max
priority.  However that thread get such priority after woken up. 
Therefore, in the following case ...

  - "kstopmachine" try to run on CPU1

  - There is a real time process which doesn't relinquish CPU time
    voluntary on CPU1

...  "kstopmachine" can't start to run and the CPU on which
    stop_machine_run() is runing hangs up.  To fix this problem, call
    sched_setscheduler() before waking up that thread.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/stop_machine.c~fix-stop_machine_run-problem-with-naughty-real-time-process kernel/stop_machine.c
--- a/kernel/stop_machine.c~fix-stop_machine_run-problem-with-naughty-real-time-process
+++ a/kernel/stop_machine.c
@@ -93,10 +93,6 @@ static void stopmachine_set_state(enum s
 static int stop_machine(void)
 {
 	int i, ret = 0;
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-	/* One high-prio thread per cpu.  We'll do this one. */
-	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	atomic_set(&stopmachine_thread_ack, 0);
 	stopmachine_num_threads = 0;
@@ -189,6 +185,10 @@ struct task_struct *__stop_machine_run(i
 
 	p = kthread_create(do_stop, &smdata, "kstopmachine");
 	if (!IS_ERR(p)) {
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+
+		/* One high-prio thread per cpu.  We'll do this one. */
+		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

origin.patch
