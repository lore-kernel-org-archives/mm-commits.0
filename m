From: akpm@linux-foundation.org
Subject: [merged]
 stacktrace-cleanup-inconsistent-variable-type.patch removed from -mm tree
Date: Thu, 11 Jun 2020 15:23:10 -0700
Message-ID: <20200611222310.r9vycb1T5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWXL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bvanassche@acm.org, jpoimboe@redhat.com, matthias.bgg@gmail.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, walter-zh.wu@mediatek.com


The patch titled
     Subject: stacktrace: cleanup inconsistent variable type
has been removed from the -mm tree.  Its filename was
     stacktrace-cleanup-inconsistent-variable-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: stacktrace: cleanup inconsistent variable type

Modify the variable type of 'skip' member of struct stack_trace.
In theory, the 'skip' variable type should be unsigned int.
There are two reasons:
- The 'skip' only has two situation, 1)Positive value, 2)Zero
- The 'skip' of struct stack_trace has inconsistent type with struct
  stack_trace_data, it makes a bit confusion in the relationship between
  struct stack_trace and stack_trace_data.

Link: http://lkml.kernel.org/r/20200421013511.5960-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/stacktrace.h~stacktrace-cleanup-inconsistent-variable-type
+++ a/include/linux/stacktrace.h
@@ -64,7 +64,7 @@ void arch_stack_walk_user(stack_trace_co
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
-	int skip;	/* input argument: How many entries to skip */
+	unsigned int skip;	/* input argument: How many entries to skip */
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are
