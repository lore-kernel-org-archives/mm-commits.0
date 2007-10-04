From: akpm@linux-foundation.org
Subject: - x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch removed from -mm tree
Date: Thu, 04 Oct 2007 01:32:41 -0700
Message-ID: <200710040832.l948WfJ0031719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbXJDIdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 04:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbahi@novell.com, GHaskins@novell.com, ak@suse.de, jbeulich@novell.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: nmi_watchdog fix to be more like i386
has been removed from the -mm tree.  Its filename was
     x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: x86_64: nmi_watchdog fix to be more like i386
From: "David Bahi" <dbahi@novell.com>

Thanks to tglx and ghaskins for all the help in tracking down a very
early nmi_watchdog crash on certain x86_64 machines.

This modifies nmi_watchdog_tick behavior for x86_64 arch to consider both
timer and hpet IRQs just as the i386 arch does.

[akpm@linux-foundation.org: build fix]
Signed-off-by: David Bahi <dbahi@novell.com>
Cc: "Gregory Haskins" <GHaskins@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/nmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/nmi.c~x86_64-nmi_watchdog-fix-to-be-more-like-i386 arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-nmi_watchdog-fix-to-be-more-like-i386
+++ a/arch/x86_64/kernel/nmi.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/sysdev.h>
+#include <linux/kernel_stat.h>
 #include <linux/sysctl.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
@@ -330,7 +331,6 @@ int __kprobes nmi_watchdog_tick(struct p
 		touched = 1;
 	}
 
-	sum = read_pda(apic_timer_irqs);
 	if (smp_processor_id() == 0)
 		sum += kstat_cpu(cpu).irqs[0];
 
@@ -349,6 +349,12 @@ int __kprobes nmi_watchdog_tick(struct p
 		cpu_clear(cpu, backtrace_mask);
 	}
 
+	/*
+	 * Take the local apic timer and PIT/HPET into account. We don't
+	 * know which one is active, when we have highres/dyntick on
+	 */
+	sum = read_pda(apic_timer_irqs) + kstat_cpu(cpu).irqs[0];
+
 #ifdef CONFIG_X86_MCE
 	/* Could check oops_in_progress here too, but it's safer
 	   not too */
_

Patches currently in -mm which might be from dbahi@novell.com are

x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch
