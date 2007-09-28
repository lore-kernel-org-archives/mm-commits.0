From: akpm@linux-foundation.org
Subject: + x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:09:06 -0700
Message-ID: <200709280609.l8S696o2013954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbXI1GJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbahi@novell.com, GHaskins@novell.com, ak@suse.de, jbeulich@novell.com, tglx@linutronix.de


The patch titled
     x86_64: nmi_watchdog fix to be more like i386
has been added to the -mm tree.  Its filename is
     x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: nmi_watchdog fix to be more like i386
From: "David Bahi" <dbahi@novell.com>

Thanks to tglx and ghaskins for all the help in tracking down a very
early nmi_watchdog crash on certain x86_64 machines.

This modifies nmi_watchdog_tick behavior for x86_64 arch to consider both
timer and hpet IRQs just as the i386 arch does.

Signed-off-by: David Bahi <dbahi@novell.com>
Cc: "Gregory Haskins" <GHaskins@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/nmi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/nmi.c~x86_64-nmi_watchdog-fix-to-be-more-like-i386 arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-nmi_watchdog-fix-to-be-more-like-i386
+++ a/arch/x86_64/kernel/nmi.c
@@ -329,7 +329,6 @@ int __kprobes nmi_watchdog_tick(struct p
 		touched = 1;
 	}
 
-	sum = read_pda(apic_timer_irqs);
 	if (__get_cpu_var(nmi_touch)) {
 		__get_cpu_var(nmi_touch) = 0;
 		touched = 1;
@@ -345,6 +344,12 @@ int __kprobes nmi_watchdog_tick(struct p
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
