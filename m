From: akpm@linux-foundation.org
Subject: [merged]
 irq_work-fix-build-failure-when-config_irq_work-not-defined.patch removed
 from -mm tree
Date: Tue, 24 Mar 2015 12:22:19 -0700
Message-ID: <5511b96b./N8JZPpgXJo3CeYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbbCXTWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 15:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: irq_work: fix build failure when CONFIG_IRQ_WORK not defined
has been removed from the -mm tree.  Its filename was
     irq_work-fix-build-failure-when-config_irq_work-not-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
util_macrosh-add-find_closest-macro.patch
documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch
hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch
linux-next.patch

