From: akpm@linux-foundation.org
Subject: + expand-proc-interrupts-to-include-missing-vectors-v3.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:45:43 -0700
Message-ID: <200707311845.l6VIjhfg016707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765970AbXGaSqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, ak@suse.de


The patch titled
     x86: expand /proc/interrupts to include missing vectors
has been added to the -mm tree.  Its filename is
     expand-proc-interrupts-to-include-missing-vectors-v3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: expand /proc/interrupts to include missing vectors
From: Joe Korty <joe.korty@ccur.com>

added documentation
merged some #ifdef CONFIG_SMP's

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   32 ++++++++++++++++++++++++++-
 arch/i386/kernel/irq.c             |    4 ---
 arch/x86_64/kernel/irq.c           |    4 ---
 3 files changed, 31 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/proc.txt~expand-proc-interrupts-to-include-missing-vectors-v3 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~expand-proc-interrupts-to-include-missing-vectors-v3
+++ a/Documentation/filesystems/proc.txt
@@ -347,7 +347,37 @@ connects the CPUs in a SMP system. This 
 the IO-APIC automatically retry the transmission, so it should not be a big
 problem, but you should read the SMP-FAQ.
 
-In this context it could be interesting to note the new irq directory in 2.4.
+In 2.6.2* /proc/interrupts was expanded again.  This time the goal was for
+/proc/interrupts to display every IRQ vector in use by the system, not
+just those considered 'most important'.  The new vectors are:
+
+  THR -- a threshold interrupt occurs when ECC memory correction is
+  occuring at too high a frequency.  Threshold interrupt machinery is
+  often put into the ECC logic, as occasional ECC memory failures are
+  part of normal memory operation, but sequences of ECC failures over
+  some short interval usually indicate a memory chip that is about to fail.
+
+  TRM -- a thermal event interrupt occurs when a temperature threshold
+  has been exceeded for some CPU chip.  This interrupt may also be generated
+  when the temperature drops back to normal.
+
+  SPU -- a spurious interrupt is some interrupt that was raised then lowered
+  by some IO device before it could be fully processed by the APIC.  Hence
+  the APIC sees the interrupt but does not know what device it came from.
+  For this case the APIC will generate the interrupt with a IRQ vector
+  of 0xff.
+
+  RES, CAL, TLB -- rescheduling, call and tlb flush interrupts are
+  sent from one CPU to another per the needs of the OS.  Typically,
+  their statistics are used by kernel developers and interested users to
+  determine the occurance of interrupt floods of the given type.
+
+The above IRQ vectors are displayed only when relevent.  For example,
+the threshold vector does not exist on x86_64 platforms.  Others are
+suppressed when the system is a uniprocessor.  As of this writing, only
+i386 and x86_64 platforms support the new IRQ vector displays.
+
+Of some interest is the introduction of the /proc/irq directory to 2.4.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
 irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
diff -puN arch/i386/kernel/irq.c~expand-proc-interrupts-to-include-missing-vectors-v3 arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~expand-proc-interrupts-to-include-missing-vectors-v3
+++ a/arch/i386/kernel/irq.c
@@ -298,15 +298,11 @@ skip:
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).irq_resched_counts);
 		seq_printf(p, "  Rescheduling interrupts\n");
-#endif
-#ifdef CONFIG_SMP
 		seq_printf(p, "CAL: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).irq_call_counts);
 		seq_printf(p, "  function call interrupts\n");
-#endif
-#ifdef CONFIG_SMP
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
diff -puN arch/x86_64/kernel/irq.c~expand-proc-interrupts-to-include-missing-vectors-v3 arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~expand-proc-interrupts-to-include-missing-vectors-v3
+++ a/arch/x86_64/kernel/irq.c
@@ -98,14 +98,10 @@ skip:
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_resched_counts);
 		seq_printf(p, "  Rescheduling interrupts\n");
-#endif
-#ifdef CONFIG_SMP
 		seq_printf(p, "CAL: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_counts);
 		seq_printf(p, "  function call interrupts\n");
-#endif
-#ifdef CONFIG_SMP
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_counts);
_

Patches currently in -mm which might be from joe.korty@ccur.com are

x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch
expand-proc-interrupts-to-include-missing-vectors-v3.patch
x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix.patch
