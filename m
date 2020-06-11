From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 12/25] stacktrace: cleanup inconsistent variable
 type
Date: Wed, 10 Jun 2020 18:41:56 -0700
Message-ID: <20200611014156.Epn9KpMe9%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBl6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:58 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bvanassche@acm.org, jpoimboe@redhat.com, linux-mm@kvack.org, matthias.bgg@gmail.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, walter-zh.wu@mediatek.com

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
