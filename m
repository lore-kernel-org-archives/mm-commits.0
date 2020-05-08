From: akpm@linux-foundation.org
Subject: + stacktrace-cleanup-inconsistent-variable-type.patch
 added to -mm tree
Date: Thu, 07 May 2020 17:05:30 -0700
Message-ID: <20200508000530.nuRUTzJLb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgEHAFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 20:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bvanassche@acm.org, jpoimboe@redhat.com, matthias.bgg@gmail.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, walter-zh.wu@mediatek.com


The patch titled
     Subject: stacktrace: cleanup inconsistent variable type
has been added to the -mm tree.  Its filename is
     stacktrace-cleanup-inconsistent-variable-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stacktrace-cleanup-inconsistent-variable-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stacktrace-cleanup-inconsistent-variable-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

stacktrace-cleanup-inconsistent-variable-type.patch
