From: akpm@osdl.org
Subject: - paravirt-smp-boot-hook-for-paravirt.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:02 -0800
Message-ID: <200701102303.l0AN32r6010784@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXAJXDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     paravirt: sMP boot hook for paravirt
has been removed from the -mm tree.  Its filename was
     paravirt-smp-boot-hook-for-paravirt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt: sMP boot hook for paravirt
From: Zachary Amsden <zach@vmware.com>

Add VMI SMP boot hook.  We emulate a regular boot sequence and use the same
APIC IPI initiation, we just poke magic values to load into the CPU state when
the startup IPI is received, rather than having to jump through a real mode
trampoline.

This is all that was needed to get SMP to work.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/paravirt.c |    2 ++
 arch/i386/kernel/smpboot.c  |    7 +++++++
 include/asm-i386/paravirt.h |    9 +++++++++
 include/asm-i386/smp.h      |    5 +++++
 4 files changed, 23 insertions(+)

diff -puN arch/i386/kernel/paravirt.c~paravirt-smp-boot-hook-for-paravirt arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt-smp-boot-hook-for-paravirt
+++ a/arch/i386/kernel/paravirt.c
@@ -572,5 +572,7 @@ struct paravirt_ops paravirt_ops = {
 
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
+
+	.startup_ipi_hook = (void *)native_nop,
 };
 EXPORT_SYMBOL(paravirt_ops);
diff -puN arch/i386/kernel/smpboot.c~paravirt-smp-boot-hook-for-paravirt arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~paravirt-smp-boot-hook-for-paravirt
+++ a/arch/i386/kernel/smpboot.c
@@ -828,6 +828,13 @@ wakeup_secondary_cpu(int phys_apicid, un
 		num_starts = 0;
 
 	/*
+	 * Paravirt / VMI wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
+		         (unsigned long) stack_start.esp);
+
+	/*
 	 * Run STARTUP IPI loop.
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
diff -puN include/asm-i386/paravirt.h~paravirt-smp-boot-hook-for-paravirt include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt-smp-boot-hook-for-paravirt
+++ a/include/asm-i386/paravirt.h
@@ -151,6 +151,8 @@ struct paravirt_ops
 	/* These two are jmp to, not actually called. */
 	void (fastcall *irq_enable_sysexit)(void);
 	void (fastcall *iret)(void);
+
+	void (fastcall *startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
 /* Mark a paravirt probe function. */
@@ -323,6 +325,13 @@ static inline unsigned long apic_read(un
 }
 #endif
 
+#ifdef CONFIG_SMP
+static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
+				    unsigned long start_esp)
+{
+	return paravirt_ops.startup_ipi_hook(phys_apicid, start_eip, start_esp);
+}
+#endif
 
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
diff -puN include/asm-i386/smp.h~paravirt-smp-boot-hook-for-paravirt include/asm-i386/smp.h
--- a/include/asm-i386/smp.h~paravirt-smp-boot-hook-for-paravirt
+++ a/include/asm-i386/smp.h
@@ -52,6 +52,11 @@ extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
+#ifndef CONFIG_PARAVIRT
+#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
+do { } while (0)
+#endif
+
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
