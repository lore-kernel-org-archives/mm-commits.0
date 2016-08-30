From: akpm@linux-foundation.org
Subject: +
 powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch added to -mm tree
Date: Tue, 30 Aug 2016 14:55:15 -0700
Message-ID: <57c600c3.FG4yPVqbRnWVx1g2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45279 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbcH3VzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 17:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: change places using CONFIG_KEXEC to use CONFIG_KEXEC_CORE instead
has been added to the -mm tree.  Its filename is
     powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: change places using CONFIG_KEXEC to use CONFIG_KEXEC_CORE instead

Commit 2965faa5e03d ("kexec: split kexec_load syscall from kexec core
code") introduced CONFIG_KEXEC_CORE so that CONFIG_KEXEC means whether the
kexec_load system call should be compiled-in and CONFIG_KEXEC_FILE means
whether the kexec_file_load system call should be compiled-in.  These
options can be set independently from each other.

Since until now powerpc only supported kexec_load, CONFIG_KEXEC and
CONFIG_KEXEC_CORE were synonyms.  That is not the case anymore, so we need
to make a distinction.  Almost all places where CONFIG_KEXEC was being
used should be using CONFIG_KEXEC_CORE instead, since kexec_file_load also
needs that code compiled in.

Link: http://lkml.kernel.org/r/1472579041-26033-5-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                          |    2 +-
 arch/powerpc/include/asm/debug.h              |    2 +-
 arch/powerpc/include/asm/kexec.h              |    6 +++---
 arch/powerpc/include/asm/machdep.h            |    4 ++--
 arch/powerpc/include/asm/smp.h                |    2 +-
 arch/powerpc/kernel/Makefile                  |    4 ++--
 arch/powerpc/kernel/head_64.S                 |    2 +-
 arch/powerpc/kernel/misc_32.S                 |    2 +-
 arch/powerpc/kernel/misc_64.S                 |    6 +++---
 arch/powerpc/kernel/prom.c                    |    2 +-
 arch/powerpc/kernel/setup_64.c                |    4 ++--
 arch/powerpc/kernel/smp.c                     |    6 +++---
 arch/powerpc/kernel/traps.c                   |    2 +-
 arch/powerpc/platforms/85xx/corenet_generic.c |    2 +-
 arch/powerpc/platforms/85xx/smp.c             |    8 ++++----
 arch/powerpc/platforms/cell/spu_base.c        |    2 +-
 arch/powerpc/platforms/powernv/setup.c        |    6 +++---
 arch/powerpc/platforms/ps3/setup.c            |    4 ++--
 arch/powerpc/platforms/pseries/Makefile       |    2 +-
 arch/powerpc/platforms/pseries/setup.c        |    4 ++--
 20 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/Kconfig
@@ -494,7 +494,7 @@ config CRASH_DUMP
 
 config FA_DUMP
 	bool "Firmware-assisted dump"
-	depends on PPC64 && PPC_RTAS && CRASH_DUMP && KEXEC
+	depends on PPC64 && PPC_RTAS && CRASH_DUMP && KEXEC_CORE
 	help
 	  A robust mechanism to get reliable kernel crash dump with
 	  assistance from firmware. This approach does not use kexec,
diff -puN arch/powerpc/include/asm/debug.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/include/asm/debug.h
--- a/arch/powerpc/include/asm/debug.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/include/asm/debug.h
@@ -10,7 +10,7 @@ struct pt_regs;
 
 extern struct dentry *powerpc_debugfs_root;
 
-#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC_CORE)
 
 extern int (*__debugger)(struct pt_regs *regs);
 extern int (*__debugger_ipi)(struct pt_regs *regs);
diff -puN arch/powerpc/include/asm/kexec.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/include/asm/kexec.h
@@ -53,7 +53,7 @@
 
 typedef void (*crash_shutdown_t)(void);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 
 /*
  * This function is responsible for capturing register states if coming
@@ -91,7 +91,7 @@ static inline bool kdump_in_progress(voi
 	return crashing_cpu >= 0;
 }
 
-#else /* !CONFIG_KEXEC */
+#else /* !CONFIG_KEXEC_CORE */
 static inline void crash_kexec_secondary(struct pt_regs *regs) { }
 
 static inline int overlaps_crashkernel(unsigned long start, unsigned long size)
@@ -116,7 +116,7 @@ static inline bool kdump_in_progress(voi
 	return false;
 }
 
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 #endif /* ! __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_KEXEC_H */
diff -puN arch/powerpc/include/asm/machdep.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/include/asm/machdep.h
--- a/arch/powerpc/include/asm/machdep.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/include/asm/machdep.h
@@ -183,7 +183,7 @@ struct machdep_calls {
 	 */
 	void (*machine_shutdown)(void);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	void (*kexec_cpu_down)(int crash_shutdown, int secondary);
 
 	/* Called to do what every setup is needed on image and the
@@ -198,7 +198,7 @@ struct machdep_calls {
 	 * no return.
 	 */
 	void (*machine_kexec)(struct kimage *image);
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_SUSPEND
 	/* These are called to disable and enable, respectively, IRQs when
diff -puN arch/powerpc/include/asm/smp.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/include/asm/smp.h
--- a/arch/powerpc/include/asm/smp.h~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/include/asm/smp.h
@@ -176,7 +176,7 @@ static inline void set_hard_smp_processo
 #endif /* !CONFIG_SMP */
 #endif /* !CONFIG_PPC64 */
 
-#if defined(CONFIG_PPC64) && (defined(CONFIG_SMP) || defined(CONFIG_KEXEC))
+#if defined(CONFIG_PPC64) && (defined(CONFIG_SMP) || defined(CONFIG_KEXEC_CORE))
 extern void smp_release_cpus(void);
 #else
 static inline void smp_release_cpus(void) { };
diff -puN arch/powerpc/kernel/Makefile~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/Makefile
@@ -107,7 +107,7 @@ pci64-$(CONFIG_PPC64)		+= pci_dn.o pci-h
 obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_SIZE).o $(pci64-y) \
 				   pci-common.o pci_of_scan.o
 obj-$(CONFIG_PCI_MSI)		+= msi.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o \
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o crash.o \
 				   machine_kexec_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
@@ -128,7 +128,7 @@ obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+=
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
 obj-$(CONFIG_PPC32)		+= $(obj32-y)
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC),)
+ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE),)
 obj-y				+= ppc_save_regs.o
 endif
 
diff -puN arch/powerpc/kernel/head_64.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/head_64.S
--- a/arch/powerpc/kernel/head_64.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/head_64.S
@@ -145,7 +145,7 @@ __secondary_hold:
 	cmpdi	0,r12,0
 	beq	100b
 
-#if defined(CONFIG_SMP) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_SMP) || defined(CONFIG_KEXEC_CORE)
 #ifdef CONFIG_PPC_BOOK3E
 	tovirt(r12,r12)
 #endif
diff -puN arch/powerpc/kernel/misc_32.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/misc_32.S
--- a/arch/powerpc/kernel/misc_32.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/misc_32.S
@@ -602,7 +602,7 @@ _GLOBAL(start_secondary_resume)
 _GLOBAL(__main)
 	blr
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	/*
 	 * Must be relocatable PIC code callable as a C function.
 	 */
diff -puN arch/powerpc/kernel/misc_64.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/misc_64.S
--- a/arch/powerpc/kernel/misc_64.S~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/misc_64.S
@@ -473,7 +473,7 @@ _GLOBAL(kexec_wait)
 	addi	r5,r5,kexec_flag-1b
 
 99:	HMT_LOW
-#ifdef CONFIG_KEXEC		/* use no memory without kexec */
+#ifdef CONFIG_KEXEC_CORE	/* use no memory without kexec */
 	lwz	r4,0(r5)
 	cmpwi	0,r4,0
 	beq	99b
@@ -498,7 +498,7 @@ kexec_flag:
 	.long	0
 
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 #ifdef CONFIG_PPC_BOOK3E
 /*
  * BOOK3E has no real MMU mode, so we have to setup the initial TLB
@@ -700,4 +700,4 @@ _GLOBAL(kexec_sequence)
 	mtlr	4
 	li	r5,0
 	blr	/* image->start(physid, image->start, 0); */
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
diff -puN arch/powerpc/kernel/prom.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/prom.c
@@ -427,7 +427,7 @@ static int __init early_init_dt_scan_cho
 		tce_alloc_end = *lprop;
 #endif
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	lprop = of_get_flat_dt_prop(node, "linux,crashkernel-base", NULL);
 	if (lprop)
 		crashk_res.start = *lprop;
diff -puN arch/powerpc/kernel/setup_64.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/setup_64.c
@@ -346,7 +346,7 @@ void early_setup_secondary(void)
 
 #endif /* CONFIG_SMP */
 
-#if defined(CONFIG_SMP) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_SMP) || defined(CONFIG_KEXEC_CORE)
 static bool use_spinloop(void)
 {
 	if (!IS_ENABLED(CONFIG_PPC_BOOK3E))
@@ -391,7 +391,7 @@ void smp_release_cpus(void)
 
 	DBG(" <- smp_release_cpus()\n");
 }
-#endif /* CONFIG_SMP || CONFIG_KEXEC */
+#endif /* CONFIG_SMP || CONFIG_KEXEC_CORE */
 
 /*
  * Initialize some remaining members of the ppc64_caches and systemcfg
diff -puN arch/powerpc/kernel/smp.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/smp.c
@@ -193,7 +193,7 @@ int smp_request_message_ipi(int virq, in
 	if (msg < 0 || msg > PPC_MSG_DEBUGGER_BREAK) {
 		return -EINVAL;
 	}
-#if !defined(CONFIG_DEBUGGER) && !defined(CONFIG_KEXEC)
+#if !defined(CONFIG_DEBUGGER) && !defined(CONFIG_KEXEC_CORE)
 	if (msg == PPC_MSG_DEBUGGER_BREAK) {
 		return 1;
 	}
@@ -325,7 +325,7 @@ void tick_broadcast(const struct cpumask
 }
 #endif
 
-#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC_CORE)
 void smp_send_debugger_break(void)
 {
 	int cpu;
@@ -340,7 +340,7 @@ void smp_send_debugger_break(void)
 }
 #endif
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 void crash_send_ipi(void (*crash_ipi_callback)(struct pt_regs *))
 {
 	crash_ipi_function_ptr = crash_ipi_callback;
diff -puN arch/powerpc/kernel/traps.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/kernel/traps.c
@@ -65,7 +65,7 @@
 #include <asm/hmi.h>
 #include <sysdev/fsl_pci.h>
 
-#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC_CORE)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
 int (*__debugger_ipi)(struct pt_regs *regs) __read_mostly;
 int (*__debugger_bpt)(struct pt_regs *regs) __read_mostly;
diff -puN arch/powerpc/platforms/85xx/corenet_generic.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/85xx/corenet_generic.c
--- a/arch/powerpc/platforms/85xx/corenet_generic.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -220,7 +220,7 @@ define_machine(corenet_generic) {
  *
  * Likewise, problems have been seen with kexec when coreint is enabled.
  */
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_KEXEC_CORE)
 	.get_irq		= mpic_get_irq,
 #else
 	.get_irq		= mpic_get_coreint_irq,
diff -puN arch/powerpc/platforms/85xx/smp.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/85xx/smp.c
--- a/arch/powerpc/platforms/85xx/smp.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/85xx/smp.c
@@ -349,13 +349,13 @@ struct smp_ops_t smp_85xx_ops = {
 	.cpu_disable	= generic_cpu_disable,
 	.cpu_die	= generic_cpu_die,
 #endif
-#if defined(CONFIG_KEXEC) && !defined(CONFIG_PPC64)
+#if defined(CONFIG_KEXEC_CORE) && !defined(CONFIG_PPC64)
 	.give_timebase	= smp_generic_give_timebase,
 	.take_timebase	= smp_generic_take_timebase,
 #endif
 };
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 #ifdef CONFIG_PPC32
 atomic_t kexec_down_cpus = ATOMIC_INIT(0);
 
@@ -458,7 +458,7 @@ static void mpc85xx_smp_machine_kexec(st
 
 	default_machine_kexec(image);
 }
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
 static void smp_85xx_basic_setup(int cpu_nr)
 {
@@ -512,7 +512,7 @@ void __init mpc85xx_smp_init(void)
 #endif
 	smp_ops = &smp_85xx_ops;
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	ppc_md.kexec_cpu_down = mpc85xx_smp_kexec_cpu_down;
 	ppc_md.machine_kexec = mpc85xx_smp_machine_kexec;
 #endif
diff -puN arch/powerpc/platforms/cell/spu_base.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -676,7 +676,7 @@ static ssize_t spu_stat_show(struct devi
 
 static DEVICE_ATTR(stat, 0444, spu_stat_show, NULL);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 
 struct crash_spu_info {
 	struct spu *spu;
diff -puN arch/powerpc/platforms/powernv/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/powernv/setup.c
--- a/arch/powerpc/platforms/powernv/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/powernv/setup.c
@@ -174,7 +174,7 @@ static void pnv_shutdown(void)
 	opal_shutdown();
 }
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 static void pnv_kexec_wait_secondaries_down(void)
 {
 	int my_cpu, i, notified = -1;
@@ -245,7 +245,7 @@ static void pnv_kexec_cpu_down(int crash
 		opal_reinit_cpus(OPAL_REINIT_CPUS_HILE_BE);
 	}
 }
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static unsigned long pnv_memory_block_size(void)
@@ -311,7 +311,7 @@ define_machine(powernv) {
 	.machine_shutdown	= pnv_shutdown,
 	.power_save             = NULL,
 	.calibrate_decr		= generic_calibrate_decr,
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_cpu_down		= pnv_kexec_cpu_down,
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
diff -puN arch/powerpc/platforms/ps3/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/ps3/setup.c
--- a/arch/powerpc/platforms/ps3/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/ps3/setup.c
@@ -250,7 +250,7 @@ static int __init ps3_probe(void)
 	return 1;
 }
 
-#if defined(CONFIG_KEXEC)
+#if defined(CONFIG_KEXEC_CORE)
 static void ps3_kexec_cpu_down(int crash_shutdown, int secondary)
 {
 	int cpu = smp_processor_id();
@@ -276,7 +276,7 @@ define_machine(ps3) {
 	.progress			= ps3_progress,
 	.restart			= ps3_restart,
 	.halt				= ps3_halt,
-#if defined(CONFIG_KEXEC)
+#if defined(CONFIG_KEXEC_CORE)
 	.kexec_cpu_down			= ps3_kexec_cpu_down,
 #endif
 };
diff -puN arch/powerpc/platforms/pseries/Makefile~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/pseries/Makefile
--- a/arch/powerpc/platforms/pseries/Makefile~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/pseries/Makefile
@@ -8,7 +8,7 @@ obj-y			:= lpar.o hvCall.o nvram.o recon
 			   pci.o pci_dlpar.o eeh_pseries.o msi.o
 obj-$(CONFIG_SMP)	+= smp.o
 obj-$(CONFIG_SCANLOG)	+= scanlog.o
-obj-$(CONFIG_KEXEC)	+= kexec.o
+obj-$(CONFIG_KEXEC_CORE)	+= kexec.o
 obj-$(CONFIG_PSERIES_ENERGY)	+= pseries_energy.o
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-cpu.o
diff -puN arch/powerpc/platforms/pseries/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead arch/powerpc/platforms/pseries/setup.c
--- a/arch/powerpc/platforms/pseries/setup.c~powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -367,7 +367,7 @@ void pseries_disable_reloc_on_exc(void)
 }
 EXPORT_SYMBOL(pseries_disable_reloc_on_exc);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 static void pSeries_machine_kexec(struct kimage *image)
 {
 	if (firmware_has_feature(FW_FEATURE_SET_MODE))
@@ -725,7 +725,7 @@ define_machine(pseries) {
 	.progress		= rtas_progress,
 	.system_reset_exception = pSeries_system_reset_exception,
 	.machine_check_exception = pSeries_machine_check_exception,
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.machine_kexec          = pSeries_machine_kexec,
 	.kexec_cpu_down         = pseries_kexec_cpu_down,
 #endif
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch
kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch

