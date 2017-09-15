From: akpm@linux-foundation.org
Subject: [merged]
 arm64-stacktrace-avoid-listing-stacktrace-functions-in-stacktrace.patch
 removed from -mm tree
Date: Fri, 15 Sep 2017 10:51:31 -0700
Message-ID: <20170915175131.09O2uUafA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdIORvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, guptap@codeaurora.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, vbabka@suse.cz, will.deacon@arm.com


The patch titled
     Subject: arm64: stacktrace: avoid listing stacktrace functions in stacktrace
has been removed from the -mm tree.  Its filename was
     arm64-stacktrace-avoid-listing-stacktrace-functions-in-stacktrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prakash Gupta <guptap@codeaurora.org>
Subject: arm64: stacktrace: avoid listing stacktrace functions in stacktrace

The stacktraces always begin as follows:

 [<c00117b4>] save_stack_trace_tsk+0x0/0x98
 [<c0011870>] save_stack_trace+0x24/0x28
 ...

This is because the stack trace code includes the stack frames for itself.
This is incorrect behaviour, and also leads to "skip" doing the wrong
thing (which is the number of stack frames to avoid recording.)

Perversely, it does the right thing when passed a non-current thread.  Fix
this by ensuring that we have a known constant number of frames above the
main stack trace function, and always skip these.

This was fixed for arch arm by 3683f44c42e9 ("ARM: stacktrace: avoid
listing stacktrace functions in stacktrace")

Link: http://lkml.kernel.org/r/1504078343-28754-1-git-send-email-guptap@codeaurora.org
Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/stacktrace.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN arch/arm64/kernel/stacktrace.c~arm64-stacktrace-avoid-listing-stacktrace-functions-in-stacktrace arch/arm64/kernel/stacktrace.c
--- a/arch/arm64/kernel/stacktrace.c~arm64-stacktrace-avoid-listing-stacktrace-functions-in-stacktrace
+++ a/arch/arm64/kernel/stacktrace.c
@@ -140,7 +140,8 @@ void save_stack_trace_regs(struct pt_reg
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
-void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+static noinline void __save_stack_trace(struct task_struct *tsk,
+	struct stack_trace *trace, unsigned int nosched)
 {
 	struct stack_trace_data data;
 	struct stackframe frame;
@@ -150,15 +151,16 @@ void save_stack_trace_tsk(struct task_st
 
 	data.trace = trace;
 	data.skip = trace->skip;
+	data.no_sched_functions = nosched;
 
 	if (tsk != current) {
-		data.no_sched_functions = 1;
 		frame.fp = thread_saved_fp(tsk);
 		frame.pc = thread_saved_pc(tsk);
 	} else {
-		data.no_sched_functions = 0;
+		/* We don't want this function nor the caller */
+		data.skip += 2;
 		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.pc = (unsigned long)save_stack_trace_tsk;
+		frame.pc = (unsigned long)__save_stack_trace;
 	}
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	frame.graph = tsk->curr_ret_stack;
@@ -172,9 +174,15 @@ void save_stack_trace_tsk(struct task_st
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	__save_stack_trace(tsk, trace, 1);
+}
+
 void save_stack_trace(struct stack_trace *trace)
 {
-	save_stack_trace_tsk(current, trace);
+	__save_stack_trace(current, trace, 0);
 }
+
 EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
_

Patches currently in -mm which might be from guptap@codeaurora.org are


