From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 48/93] sched: print stack trace with KERN_INFO
Date: Mon, 08 Jun 2020 21:32:23 -0700
Message-ID: <20200609043223.MjVgfyjyQ%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:24 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsegall@google.com, dietmar.eggemann@arm.com, dima@arista.com, juri.lelli@redhat.com, linux-mm@kvack.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, vincent.guittot@linaro.org

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
