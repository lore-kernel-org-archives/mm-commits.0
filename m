From: akpm@linux-foundation.org
Subject: + alpha-add-performance-monitor-interrupt-counter.patch added to -mm tree
Date: Mon, 03 May 2010 15:13:15 -0700
Message-ID: <201005032213.o43MDFRu024616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422Ab0ECWON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 18:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcree@orcon.net.nz, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, mattst88@gmail.com, mingo@elte.hu, peterz@infradead.org, rth@twiddle.net, tglx@linutronix.de


The patch titled
     alpha: add performance monitor interrupt counter
has been added to the -mm tree.  Its filename is
     alpha-add-performance-monitor-interrupt-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: add performance monitor interrupt counter
From: Michael Cree <mcree@orcon.net.nz>

The following patches implement hardware performance events for the Alpha
EV67 and later CPUs.  I have had this running on a Compaq XP1000 (EV67,
single CPU) for a few days now.  Pretty cool -- discovered that the glibc
exp2() library routine uses on average 985 cycles to execute 777 CPU
instructions whereas Compaq's CPML library version of exp2() uses on
average 32 cycles to execute 47 CPU instructions to achieve the same
thing!


This patch:

Add performance monitor interrupt counternd and export the count to user
space via /proc/interrupts.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/hw_irq.h |    1 +
 arch/alpha/kernel/irq.c         |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/hw_irq.h~alpha-add-performance-monitor-interrupt-counter arch/alpha/include/asm/hw_irq.h
--- a/arch/alpha/include/asm/hw_irq.h~alpha-add-performance-monitor-interrupt-counter
+++ a/arch/alpha/include/asm/hw_irq.h
@@ -3,6 +3,7 @@
 
 
 extern volatile unsigned long irq_err_count;
+DECLARE_PER_CPU(unsigned long, irq_pmi_count);
 
 #ifdef CONFIG_ALPHA_GENERIC
 #define ACTUAL_NR_IRQS	alpha_mv.nr_irqs
diff -puN arch/alpha/kernel/irq.c~alpha-add-performance-monitor-interrupt-counter arch/alpha/kernel/irq.c
--- a/arch/alpha/kernel/irq.c~alpha-add-performance-monitor-interrupt-counter
+++ a/arch/alpha/kernel/irq.c
@@ -31,6 +31,7 @@
 #include <asm/uaccess.h>
 
 volatile unsigned long irq_err_count;
+DEFINE_PER_CPU(unsigned long, irq_pmi_count);
 
 void ack_bad_irq(unsigned int irq)
 {
@@ -63,9 +64,7 @@ int irq_select_affinity(unsigned int irq
 int
 show_interrupts(struct seq_file *p, void *v)
 {
-#ifdef CONFIG_SMP
 	int j;
-#endif
 	int irq = *(loff_t *) v;
 	struct irqaction * action;
 	unsigned long flags;
@@ -112,6 +111,10 @@ unlock:
 			seq_printf(p, "%10lu ", cpu_data[j].ipi_count);
 		seq_putc(p, '\n');
 #endif
+		seq_puts(p, "PMI: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10lu ", per_cpu(irq_pmi_count, j));
+		seq_puts(p, "          Performance Monitoring\n");
 		seq_printf(p, "ERR: %10lu\n", irq_err_count);
 	}
 	return 0;
_

Patches currently in -mm which might be from mcree@orcon.net.nz are

alpha-add-performance-monitor-interrupt-counter.patch
alpha-add-wrperfmonh-header-file-to-aid-use-of-wrperfmon-palcall.patch
alpha-implement-hw-performance-events-on-the-ev67-and-later-cpus.patch

