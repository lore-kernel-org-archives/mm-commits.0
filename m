From: akpm@linux-foundation.org
Subject: + smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:03:05 -0800
Message-ID: <20130219230305.BBBB45A43CB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:58289 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786Ab3BSXDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 18:03:07 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so447114ggn.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 15:03:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuansheng.liu@intel.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, mingo@elte.hu


The patch titled
     Subject: smp: Give WARN()ing when calling smp_call_function_many()/single() in serving irq
has been added to the -mm tree.  Its filename is
     smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: smp: Give WARN()ing when calling smp_call_function_many()/single() in serving irq

Currently the functions smp_call_function_many()/single() will give a
WARN()ing only in the case of irqs_disabled(), but that check is not
enough to guarantee execution of the SMP cross-calls.

In many other cases such as softirq handling/interrupt handling, the two
APIs still can not be called, just as the smp_call_function_many()
comments say:

  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.

There is a real case for softirq DEADLOCK case:

CPUA                            CPUB
                                spin_lock(&spinlock)
                                Any irq coming, call the irq handler
                                irq_exit()
spin_lock_irq(&spinlock)
<== Blocking here due to
CPUB hold it
                                  __do_softirq()
                                    run_timer_softirq()
                                      timer_cb()
                                        call smp_call_function_many()
                                          send IPI interrupt to CPUA
                                            wait_csd()

Then both CPUA and CPUB will be deadlocked here.

So we should give a warning in the nmi, hardirq or softirq context as well.

Moreover, adding one new macro in_serving_irq() which indicates we are
processing nmi, hardirq or sofirq.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hardirq.h |    5 +++++
 kernel/smp.c            |   11 +++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/hardirq.h~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq include/linux/hardirq.h
--- a/include/linux/hardirq.h~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq
+++ a/include/linux/hardirq.h
@@ -94,6 +94,11 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
+/*
+ * Are we in nmi,irq context, or softirq context?
+ */
+#define in_serving_irq() (in_nmi() || in_irq() || in_serving_softirq())
+
 #if defined(CONFIG_PREEMPT_COUNT)
 # define PREEMPT_CHECK_OFFSET 1
 #else
diff -puN kernel/smp.c~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq kernel/smp.c
--- a/kernel/smp.c~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq
+++ a/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -240,8 +241,9 @@ int smp_call_function_single(int cpu, sm
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(this_cpu)
+		&& (irqs_disabled() || in_serving_irq())
+		&& !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
@@ -378,8 +380,9 @@ void smp_call_function_many(const struct
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress && !early_boot_irqs_disabled);
+	WARN_ON_ONCE(cpu_online(this_cpu)
+		&& (irqs_disabled() || in_serving_irq())
+		&& !oops_in_progress && !early_boot_irqs_disabled);
 
 	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
_

Patches currently in -mm which might be from chuansheng.liu@intel.com are

linux-next.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch

