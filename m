From: akpm@linux-foundation.org
Subject: - x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2007 14:15:52 -0700
Message-ID: <200707312115.l6VLFqIg022900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbXGaVQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 17:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.korty@ccur.com, ak@suse.de, hpa@zytor.com, mingo@elte.hu, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     x86-expand-proc-interrupts-to-include-missing-vectors-v2 fix
has been removed from the -mm tree.  Its filename was
     x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86-expand-proc-interrupts-to-include-missing-vectors-v2 fix
From: Joe Korty <joe.korty@ccur.com>

spurs are what cowboys wear.

Cc: Joe Korty <joe.korty@ccur.com>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c    |    2 +-
 arch/i386/kernel/irq.c     |    2 +-
 arch/x86_64/kernel/apic.c  |    2 +-
 arch/x86_64/kernel/irq.c   |    2 +-
 include/asm-i386/hardirq.h |    2 +-
 include/asm-x86_64/pda.h   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/arch/i386/kernel/apic.c
@@ -1280,7 +1280,7 @@ void smp_spurious_interrupt(struct pt_re
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	irq_exit();
-	__get_cpu_var(irq_stat).irq_spur_counts++;
+	__get_cpu_var(irq_stat).irq_spurious_counts++;
 }
 
 /*
diff -puN arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/arch/i386/kernel/irq.c
@@ -317,7 +317,7 @@ skip:
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
-				per_cpu(irq_stat,j).irq_spur_counts);
+				per_cpu(irq_stat,j).irq_spurious_counts);
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
diff -puN arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/arch/x86_64/kernel/apic.c
@@ -1154,7 +1154,7 @@ asmlinkage void smp_spurious_interrupt(v
 		ack_APIC_irq();
 
 	irq_exit();
-	add_pda(irq_spur_counts, 1);
+	add_pda(irq_spurious_counts, 1);
 }
 
 /*
diff -puN arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/arch/x86_64/kernel/irq.c
@@ -117,7 +117,7 @@ skip:
 		seq_printf(p, "  Threshold APIC interrupts\n");
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_spur_counts);
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_counts);
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
diff -puN include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix include/asm-i386/hardirq.h
--- a/include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/include/asm-i386/hardirq.h
@@ -13,7 +13,7 @@ typedef struct {
 	unsigned int irq_call_counts;
 	unsigned int irq_tlb_counts;
 	unsigned int irq_thermal_counts;
-	unsigned int irq_spur_counts;
+	unsigned int irq_spurious_counts;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
diff -puN include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix include/asm-x86_64/pda.h
--- a/include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix
+++ a/include/asm-x86_64/pda.h
@@ -34,7 +34,7 @@ struct x8664_pda {
 	unsigned irq_tlb_counts;
 	unsigned irq_thermal_counts;
 	unsigned irq_threshold_counts;
-	unsigned irq_spur_counts;
+	unsigned irq_spurious_counts;
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
_

Patches currently in -mm which might be from joe.korty@ccur.com are

x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch
expand-proc-interrupts-to-include-missing-vectors-v3.patch
x86-expand-proc-interrupts-to-include-missing-vectors.patch
x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix.patch
