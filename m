From: akpm@linux-foundation.org
Subject: + smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch added to -mm tree
Date: Mon, 06 Feb 2012 15:31:07 -0800
Message-ID: <20120206233108.39B0CA01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56913 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2BFXbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 18:31:09 -0500
Received: by yenm1 with SMTP id m1so41573yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 15:31:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update
has been added to the -mm tree.  Its filename is
     smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update

Add the on_each_cpu_cond() function that wraps on_each_cpu_mask()
and calculates the cpumask of cpus to IPI by calling a function supplied
as a parameter in order to determine whether to IPI each specific cpu.

The function works around allocation failure of cpumask variable in
CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a
time via smp_call_function_single().

The function is useful since it allows to seperate the specific
code that decided in each case whether to IPI a specific cpu for
a specific request from the common boilerplate code of handling
creating the mask, handling failures etc.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    4 ++++
 kernel/smp.c        |    2 ++
 2 files changed, 6 insertions(+)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update
+++ a/include/linux/smp.h
@@ -162,6 +162,10 @@ static inline int up_smp_call_function(s
 			local_irq_enable();		\
 		}					\
 	} while (0)
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
 #define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
 	do {							\
 		preempt_disable();				\
diff -puN kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-update kernel/smp.c
--- a/kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-update
+++ a/kernel/smp.c
@@ -771,6 +771,8 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * The function might sleep if the GFP flags indicates a non
  * atomic allocation is allowed.
  *
+ * Preemption is disabled to protect against a hotplug event.
+ *
  * You must not call this function with disabled interrupts or
  * from a hardware interrupt handler or from a bottom half handler.
  */
_
Subject: Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch

