From: akpm@linux-foundation.org
Subject: +
 kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch
 added to -mm tree
Date: Mon, 12 Aug 2013 15:16:38 -0700
Message-ID: <52095ec6.8W89tOkKk4yXD6o7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3HLWQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 18:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gilad@benyossef.com, cmetcalf@tilera.com, cl@linux.com, a.p.zijlstra@chello.nl, david.daney@cavium.com

Subject: + kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch added to -mm tree
To: david.daney@cavium.com,a.p.zijlstra@chello.nl,cl@linux.com,cmetcalf@tilera.com,gilad@benyossef.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 15:16:38 -0700


The patch titled
     Subject: kernel/smp.c: quit unconditionally enabling irqs in on_each_cpu_mask().
has been added to the -mm tree.  Its filename is
     kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: kernel/smp.c: quit unconditionally enabling irqs in on_each_cpu_mask().

As in f21afc25f9ed ("smp.h: Use local_irq_{save,restore}() in !SMP version
of on_each_cpu()"), we don't want to enable irqs if they are not already
enabled.

I don't know of any bugs currently caused by this unconditional
local_irq_enable(), but I want to use this function in MIPS/OCTEON early
boot (when we have early_boot_irqs_disabled).  This also makes this
function have similar semantics to on_each_cpu() which is good in itself.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/smp.c~kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask
+++ a/kernel/smp.c
@@ -575,8 +575,10 @@ EXPORT_SYMBOL(on_each_cpu);
  *
  * If @wait is true, then returns once @func has returned.
  *
- * You must not call this function with disabled interrupts or
- * from a hardware interrupt handler or from a bottom half handler.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.  The
+ * exception is that it may be used during early boot while
+ * early_boot_irqs_disabled is set.
  */
 void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
 			void *info, bool wait)
@@ -585,9 +587,10 @@ void on_each_cpu_mask(const struct cpuma
 
 	smp_call_function_many(mask, func, info, wait);
 	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
+		unsigned long flags;
+		local_irq_save(flags);
 		func(info);
-		local_irq_enable();
+		local_irq_restore(flags);
 	}
 	put_cpu();
 }
_

Patches currently in -mm which might be from david.daney@cavium.com are

linux-next.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch
upc-use-local_irq_saverestore-in-smp_call_function_single.patch
smph-move-smp-version-of-on_each_cpu-out-of-line.patch
extable-skip-sorting-if-the-table-is-empty.patch
kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch

