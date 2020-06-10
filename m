From: akpm@linux-foundation.org
Subject: [merged] sched-print-stack-trace-with-kern_info.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:38:32 -0700
Message-ID: <20200610003832.POO5chxcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJAid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsegall@google.com, dietmar.eggemann@arm.com, dima@arista.com, juri.lelli@redhat.com, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org


The patch titled
     Subject: sched: print stack trace with KERN_INFO
has been removed from the -mm tree.  Its filename was
     sched-print-stack-trace-with-kern_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: sched: print stack trace with KERN_INFO

Aligning with other messages printed in sched_show_task() - use KERN_INFO
to print the backtrace.

Link: http://lkml.kernel.org/r/20200418201944.482088-49-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c~sched-print-stack-trace-with-kern_info
+++ a/kernel/sched/core.c
@@ -6025,7 +6025,7 @@ void sched_show_task(struct task_struct
 		(unsigned long)task_thread_info(p)->flags);
 
 	print_worker_info(KERN_INFO, p);
-	show_stack(p, NULL);
+	show_stack_loglvl(p, NULL, KERN_INFO);
 	put_task_stack(p);
 }
 EXPORT_SYMBOL_GPL(sched_show_task);
_

Patches currently in -mm which might be from dima@arista.com are
