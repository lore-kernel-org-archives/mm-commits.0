Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D2AC001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjHDRvc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjHDRvb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83924C0A
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61491620D6
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29B2C433C7;
        Fri,  4 Aug 2023 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691171487;
        bh=EdFuh+9j/Uw9XLgQikI58L7EseL8g6poPT45IjWkxQg=;
        h=Date:To:From:Subject:From;
        b=bnRvGVG6zyCsJrRB5Shq42OFmYdEFw22B+ex7k88jh9a3gBW9TUzQsjk9jVYXwaGV
         b20Hi2w5MKHIf7Avt7mKGqIHiDRSopyb6BiGLykDYQzDMMbNk/Aeg2+IZIvssQ3ntM
         T9GtDEQsEYaHHEH15dCdMH7Jmhp/qAtWP5DjrHx8=
Date:   Fri, 04 Aug 2023 10:51:26 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, mhocko@suse.com,
        lkp@intel.com, lecopzer.chen@mediatek.com, kernelfans@gmail.com,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20230804175127.B29B2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nmi_backtrace: allow excluding an arbitrary CPU
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: nmi_backtrace: allow excluding an arbitrary CPU
Date: Fri, 4 Aug 2023 07:00:42 -0700

The APIs that allow backtracing across CPUs have always had a way to
exclude the current CPU.  This convenience means callers didn't need to
find a place to allocate a CPU mask just to handle the common case.

Let's extend the API to take a CPU ID to exclude instead of just a
boolean.  This isn't any more complex for the API to handle and allows the
hardlockup detector to exclude a different CPU (the one it already did a
trace for) without needing to find space for a CPU mask.

Arguably, this new API also encourages safer behavior.  Specifically if
the caller wants to avoid tracing the current CPU (maybe because they
already traced the current CPU) this makes it more obvious to the caller
that they need to make sure that the current CPU ID can't change.

Link: https://lkml.kernel.org/r/20230804065935.v4.1.Ia35521b91fc781368945161d7b28538f9996c182@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/irq.h       |    2 +-
 arch/arm/kernel/smp.c            |    4 ++--
 arch/loongarch/include/asm/irq.h |    2 +-
 arch/loongarch/kernel/process.c  |    4 ++--
 arch/mips/include/asm/irq.h      |    2 +-
 arch/mips/kernel/process.c       |    4 ++--
 arch/powerpc/include/asm/irq.h   |    2 +-
 arch/powerpc/kernel/stacktrace.c |    4 ++--
 arch/powerpc/kernel/watchdog.c   |    4 ++--
 arch/sparc/include/asm/irq_64.h  |    2 +-
 arch/sparc/kernel/process_64.c   |    6 +++---
 arch/x86/include/asm/irq.h       |    2 +-
 arch/x86/kernel/apic/hw_nmi.c    |    4 ++--
 include/linux/nmi.h              |   14 +++++++-------
 kernel/watchdog.c                |    2 +-
 lib/nmi_backtrace.c              |    6 +++---
 16 files changed, 32 insertions(+), 32 deletions(-)

--- a/arch/arm/include/asm/irq.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/arm/include/asm/irq.h
@@ -32,7 +32,7 @@ void handle_IRQ(unsigned int, struct pt_
 #include <linux/cpumask.h>
 
 extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
-					   bool exclude_self);
+					   int exclude_cpu);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 #endif
 
--- a/arch/arm/kernel/smp.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/arm/kernel/smp.c
@@ -846,7 +846,7 @@ static void raise_nmi(cpumask_t *mask)
 	__ipi_send_mask(ipi_desc[IPI_CPU_BACKTRACE], mask);
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
-	nmi_trigger_cpumask_backtrace(mask, exclude_self, raise_nmi);
+	nmi_trigger_cpumask_backtrace(mask, exclude_cpu, raise_nmi);
 }
--- a/arch/loongarch/include/asm/irq.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/loongarch/include/asm/irq.h
@@ -40,7 +40,7 @@ void spurious_interrupt(void);
 #define NR_IRQS_LEGACY 16
 
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
-void arch_trigger_cpumask_backtrace(const struct cpumask *mask, bool exclude_self);
+void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int exclude_cpu);
 
 #define MAX_IO_PICS 2
 #define NR_IRQS	(64 + (256 * MAX_IO_PICS))
--- a/arch/loongarch/kernel/process.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/loongarch/kernel/process.c
@@ -345,9 +345,9 @@ static void raise_backtrace(cpumask_t *m
 	}
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
-	nmi_trigger_cpumask_backtrace(mask, exclude_self, raise_backtrace);
+	nmi_trigger_cpumask_backtrace(mask, exclude_cpu, raise_backtrace);
 }
 
 #ifdef CONFIG_64BIT
--- a/arch/mips/include/asm/irq.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/mips/include/asm/irq.h
@@ -77,7 +77,7 @@ extern int cp0_fdc_irq;
 extern int get_c0_fdc_int(void);
 
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask,
-				    bool exclude_self);
+				    int exclude_cpu);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 
 #endif /* _ASM_IRQ_H */
--- a/arch/mips/kernel/process.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/mips/kernel/process.c
@@ -750,9 +750,9 @@ static void raise_backtrace(cpumask_t *m
 	}
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
-	nmi_trigger_cpumask_backtrace(mask, exclude_self, raise_backtrace);
+	nmi_trigger_cpumask_backtrace(mask, exclude_cpu, raise_backtrace);
 }
 
 int mips_get_process_fp_mode(struct task_struct *task)
--- a/arch/powerpc/include/asm/irq.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/powerpc/include/asm/irq.h
@@ -55,7 +55,7 @@ int irq_choose_cpu(const struct cpumask
 
 #if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_NMI_IPI)
 extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
-					   bool exclude_self);
+					   int exclude_cpu);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 #endif
 
--- a/arch/powerpc/kernel/stacktrace.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/powerpc/kernel/stacktrace.c
@@ -221,8 +221,8 @@ static void raise_backtrace_ipi(cpumask_
 	}
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
-	nmi_trigger_cpumask_backtrace(mask, exclude_self, raise_backtrace_ipi);
+	nmi_trigger_cpumask_backtrace(mask, exclude_cpu, raise_backtrace_ipi);
 }
 #endif /* defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_NMI_IPI) */
--- a/arch/powerpc/kernel/watchdog.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/powerpc/kernel/watchdog.c
@@ -245,7 +245,7 @@ static void watchdog_smp_panic(int cpu)
 			__cpumask_clear_cpu(c, &wd_smp_cpus_ipi);
 		}
 	} else {
-		trigger_allbutself_cpu_backtrace();
+		trigger_allbutcpu_cpu_backtrace(cpu);
 		cpumask_clear(&wd_smp_cpus_ipi);
 	}
 
@@ -416,7 +416,7 @@ DEFINE_INTERRUPT_HANDLER_NMI(soft_nmi_in
 		xchg(&__wd_nmi_output, 1); // see wd_lockup_ipi
 
 		if (sysctl_hardlockup_all_cpu_backtrace)
-			trigger_allbutself_cpu_backtrace();
+			trigger_allbutcpu_cpu_backtrace(cpu);
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
--- a/arch/sparc/include/asm/irq_64.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/sparc/include/asm/irq_64.h
@@ -87,7 +87,7 @@ static inline unsigned long get_softint(
 }
 
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask,
-				    bool exclude_self);
+				    int exclude_cpu);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
--- a/arch/sparc/kernel/process_64.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/sparc/kernel/process_64.c
@@ -236,7 +236,7 @@ static void __global_reg_poll(struct glo
 	}
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -252,7 +252,7 @@ void arch_trigger_cpumask_backtrace(cons
 
 	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
 
-	if (cpumask_test_cpu(this_cpu, mask) && !exclude_self)
+	if (cpumask_test_cpu(this_cpu, mask) && this_cpu != exclude_cpu)
 		__global_reg_self(tp, regs, this_cpu);
 
 	smp_fetch_global_regs();
@@ -260,7 +260,7 @@ void arch_trigger_cpumask_backtrace(cons
 	for_each_cpu(cpu, mask) {
 		struct global_reg_snapshot *gp;
 
-		if (exclude_self && cpu == this_cpu)
+		if (cpu == exclude_cpu)
 			continue;
 
 		gp = &global_cpu_snapshot[cpu].reg;
--- a/arch/x86/include/asm/irq.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/x86/include/asm/irq.h
@@ -42,7 +42,7 @@ extern void init_ISA_irqs(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask,
-				    bool exclude_self);
+				    int exclude_cpu);
 
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 #endif
--- a/arch/x86/kernel/apic/hw_nmi.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -34,9 +34,9 @@ static void nmi_raise_cpu_backtrace(cpum
 	apic->send_IPI_mask(mask, NMI_VECTOR);
 }
 
-void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
 {
-	nmi_trigger_cpumask_backtrace(mask, exclude_self,
+	nmi_trigger_cpumask_backtrace(mask, exclude_cpu,
 				      nmi_raise_cpu_backtrace);
 }
 
--- a/include/linux/nmi.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/include/linux/nmi.h
@@ -157,31 +157,31 @@ static inline void touch_nmi_watchdog(vo
 #ifdef arch_trigger_cpumask_backtrace
 static inline bool trigger_all_cpu_backtrace(void)
 {
-	arch_trigger_cpumask_backtrace(cpu_online_mask, false);
+	arch_trigger_cpumask_backtrace(cpu_online_mask, -1);
 	return true;
 }
 
-static inline bool trigger_allbutself_cpu_backtrace(void)
+static inline bool trigger_allbutcpu_cpu_backtrace(int exclude_cpu)
 {
-	arch_trigger_cpumask_backtrace(cpu_online_mask, true);
+	arch_trigger_cpumask_backtrace(cpu_online_mask, exclude_cpu);
 	return true;
 }
 
 static inline bool trigger_cpumask_backtrace(struct cpumask *mask)
 {
-	arch_trigger_cpumask_backtrace(mask, false);
+	arch_trigger_cpumask_backtrace(mask, -1);
 	return true;
 }
 
 static inline bool trigger_single_cpu_backtrace(int cpu)
 {
-	arch_trigger_cpumask_backtrace(cpumask_of(cpu), false);
+	arch_trigger_cpumask_backtrace(cpumask_of(cpu), -1);
 	return true;
 }
 
 /* generic implementation */
 void nmi_trigger_cpumask_backtrace(const cpumask_t *mask,
-				   bool exclude_self,
+				   int exclude_cpu,
 				   void (*raise)(cpumask_t *mask));
 bool nmi_cpu_backtrace(struct pt_regs *regs);
 
@@ -190,7 +190,7 @@ static inline bool trigger_all_cpu_backt
 {
 	return false;
 }
-static inline bool trigger_allbutself_cpu_backtrace(void)
+static inline bool trigger_allbutcpu_cpu_backtrace(void)
 {
 	return false;
 }
--- a/kernel/watchdog.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/kernel/watchdog.c
@@ -523,7 +523,7 @@ static enum hrtimer_restart watchdog_tim
 			dump_stack();
 
 		if (softlockup_all_cpu_backtrace) {
-			trigger_allbutself_cpu_backtrace();
+			trigger_allbutcpu_cpu_backtrace(smp_processor_id());
 			clear_bit_unlock(0, &soft_lockup_nmi_warn);
 		}
 
--- a/lib/nmi_backtrace.c~nmi_backtrace-allow-excluding-an-arbitrary-cpu
+++ a/lib/nmi_backtrace.c
@@ -34,7 +34,7 @@ static unsigned long backtrace_flag;
  * they are passed being updated as a side effect of this call.
  */
 void nmi_trigger_cpumask_backtrace(const cpumask_t *mask,
-				   bool exclude_self,
+				   int exclude_cpu,
 				   void (*raise)(cpumask_t *mask))
 {
 	int i, this_cpu = get_cpu();
@@ -49,8 +49,8 @@ void nmi_trigger_cpumask_backtrace(const
 	}
 
 	cpumask_copy(to_cpumask(backtrace_mask), mask);
-	if (exclude_self)
-		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
+	if (exclude_cpu != -1)
+		cpumask_clear_cpu(exclude_cpu, to_cpumask(backtrace_mask));
 
 	/*
 	 * Don't try to send an NMI to this cpu; it may work on some
_

Patches currently in -mm which might be from dianders@chromium.org are

nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch
watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch

