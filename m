From: akpm@linux-foundation.org
Subject: +
 irq_work-fix-build-failure-when-config_irq_work-not-defined.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 13:02:29 -0700
Message-ID: <550c7cd5.ea3zDfIH+XUbOGFl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbCTUCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: irq_work: fix build failure when CONFIG_IRQ_WORK not defined
has been added to the -mm tree.  Its filename is
     irq_work-fix-build-failure-when-config_irq_work-not-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/irq_work-fix-build-failure-when-config_irq_work-not-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/irq_work-fix-build-failure-when-config_irq_work-not-defined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: irq_work: fix build failure when CONFIG_IRQ_WORK not defined

When CONFIG_IRQ_WORK is not defined (difficult to do, as it also requires
CONFIG_PRINTK not to be defined), we get a build failure:

kernel/built-in.o: In function `flush_smp_call_function_queue':
kernel/smp.c:263: undefined reference to `irq_work_run'
kernel/smp.c:263: undefined reference to `irq_work_run'
Makefile:933: recipe for target 'vmlinux' failed

Simplest thing to do is to make irq_work_run() a nop when not set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq_work.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/irq_work.h~irq_work-fix-build-failure-when-config_irq_work-not-defined include/linux/irq_work.h
--- a/include/linux/irq_work.h~irq_work-fix-build-failure-when-config_irq_work-not-defined
+++ a/include/linux/irq_work.h
@@ -38,16 +38,17 @@ bool irq_work_queue(struct irq_work *wor
 bool irq_work_queue_on(struct irq_work *work, int cpu);
 #endif
 
-void irq_work_run(void);
 void irq_work_tick(void);
 void irq_work_sync(struct irq_work *work);
 
 #ifdef CONFIG_IRQ_WORK
 #include <asm/irq_work.h>
 
+void irq_work_run(void);
 bool irq_work_needs_cpu(void);
 #else
 static inline bool irq_work_needs_cpu(void) { return false; }
+static inline void irq_work_run(void) { }
 #endif
 
 #endif /* _LINUX_IRQ_WORK_H */
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch
tracing-remove-use-of-seq_printf-return-value.patch
linux-next.patch
irq_work-fix-build-failure-when-config_irq_work-not-defined.patch

