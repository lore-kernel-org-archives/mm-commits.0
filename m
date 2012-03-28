From: akpm@linux-foundation.org
Subject: [folded] smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:30:50 -0700
Message-ID: <20120328213050.A772CA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53955 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:30:52 -0400
Received: by faaa19 with SMTP id a19so92539faa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:30:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update
has been removed from the -mm tree.  Its filename was
     smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch

This patch was dropped because it was folded into smp-add-func-to-ipi-cpus-based-on-parameter-func.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Acked-by: Michal Nazarewicz <mina86@mina86.org>
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
@@ -752,6 +752,8 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * The function might sleep if the GFP flags indicates a non
  * atomic allocation is allowed.
  *
+ * Preemption is disabled to protect against a hotplug event.
+ *
  * You must not call this function with disabled interrupts or
  * from a hardware interrupt handler or from a bottom half handler.
  */
_

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

