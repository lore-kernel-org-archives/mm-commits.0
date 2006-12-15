From: akpm@osdl.org
Subject: + git-kgdb-fixup.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:16:36 -0800
Message-ID: <200612152216.kBFMGaqN002414@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030258AbWLOWaX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, piet@bluelane.com, trini@kernel.crashing.org


The patch titled
     git-kgdb-fixup
has been added to the -mm tree.  Its filename is
     git-kgdb-fixup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-kgdb-fixup
From: Andrew Morton <akpm@osdl.org>

Attempt to repair all the git rejects which arise from pulling crufty old git
tree into -mm.

This has basically zero chance of working.

Cc: Piet Delaney <piet@bluelane.com>
Cc: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/networking/ip-sysctl.txt  |    3 -
 arch/i386/kernel/Makefile               |    3 -
 arch/i386/kernel/entry.S                |   22 +++++------
 arch/i386/kernel/process.c              |    3 -
 arch/i386/kernel/setup.c                |    7 ---
 arch/ia64/kernel/smp.c                  |    8 ----
 arch/mips/kernel/irq.c                  |    3 -
 arch/mips/kernel/traps.c                |    6 ---
 arch/mips/sibyte/sb1250/irq.c           |    3 -
 arch/powerpc/Kconfig.debug              |    9 ----
 arch/powerpc/kernel/Makefile            |    3 -
 arch/powerpc/kernel/setup_32.c          |    3 -
 arch/sh/Kconfig.debug                   |    3 -
 arch/sh/boards/se/7751/setup.c          |    6 ---
 arch/sh/kernel/setup.c                  |    3 -
 arch/sh/kernel/time.c                   |    3 -
 arch/sh/kernel/traps.c                  |   13 ------
 arch/sh/mm/fault.c                      |    6 ---
 drivers/char/keyboard.c                 |    5 --
 drivers/serial/cpm_uart/cpm_uart_core.c |    3 -
 drivers/serial/serial_core.c            |    3 -
 drivers/serial/sh-sci.c                 |   44 ----------------------
 include/asm-sh/kgdb.h                   |    3 -
 include/asm-sh/system.h                 |    3 -
 include/linux/netpoll.h                 |    7 ---
 kernel/timer.c                          |    5 ++
 lib/Kconfig.debug                       |    8 ----
 27 files changed, 19 insertions(+), 169 deletions(-)

diff -puN arch/i386/kernel/entry.S~git-kgdb-fixup arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~git-kgdb-fixup
+++ a/arch/i386/kernel/entry.S
@@ -1040,30 +1040,30 @@ ENTRY(end_of_stack_stop_unwind_function)
 	.text
 
 	CFI_preamble(c1,_PC,1,1)
-	CFA_define_reference(_ESP,OLDESP)	/* Stack pointer */
+	CFA_define_reference(_ESP,PT_OLDESP)	/* Stack pointer */
 	CFA_expression(_EIP)
 	   CFA_exp_OP_dup			/* copy old esp */
- 	   CFA_exp_OP_consts(CS-OLDESP)		/* offset to CS address */
+ 	   CFA_exp_OP_consts(PT_CS-PT_OLDESP)		/* offset to CS address */
  	   CFA_exp_OP_plus			/* should be CS address */
 	   CFA_exp_OP_deref			/* get the CS */
 	   CFA_exp_OP_const4s(VM_MASK|3)	/* prepare to mask it */
 	   CFA_exp_OP_and			/* mask it, zero means kernel */
 	   CFA_exp_OP_bra(eip_user_rtn)		/* branch if user */
-	   CFA_exp_OP_const4s(EIP-OLDESP)	/* offset to return address */
+	   CFA_exp_OP_const4s(PT_EIP-PT_OLDESP)	/* offset to return address */
 	   CFA_exp_OP_plus			/* add that in */
 	   CFA_exp_OP_skip(eip_end)		/* done if kernel, skip out */
 eip_user_rtn:
 	   CFA_exp_OP_addr(end_of_stack_stop_unwind_function)/*dummy function */
 eip_end:
 	   CFA_expression_end
-	CFA_define_offset(_EBX,EBX-OLDESP)
-	CFA_define_offset(_ECX,ECX-OLDESP)
-	CFA_define_offset(_EDX,EDX-OLDESP)
-	CFA_define_offset(_ESI,ESI-OLDESP)
-	CFA_define_offset(_EDI,EDI-OLDESP)
-	CFA_define_offset(_EBP,EBP-OLDESP)
-	CFA_define_offset(_EAX,EAX-OLDESP)
-	CFA_define_offset(_EFLAGS,EFLAGS-OLDESP)
+	CFA_define_offset(_EBX,PT_EBX-PT_OLDESP)
+	CFA_define_offset(_ECX,PT_ECX-PT_OLDESP)
+	CFA_define_offset(_EDX,PT_EDX-PT_OLDESP)
+	CFA_define_offset(_ESI,PT_ESI-PT_OLDESP)
+	CFA_define_offset(_EDI,PT_EDI-PT_OLDESP)
+	CFA_define_offset(_EBP,PT_EBP-PT_OLDESP)
+	CFA_define_offset(_EAX,PT_EAX-PT_OLDESP)
+	CFA_define_offset(_EFLAGS,PT_EFLAGS-PT_OLDESP)
 	CFI_postamble()
 
 /*
diff -puN arch/i386/kernel/setup.c~git-kgdb-fixup arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~git-kgdb-fixup
+++ a/arch/i386/kernel/setup.c
@@ -124,11 +124,8 @@ EXPORT_SYMBOL(ist_info);
 #endif
 
 extern void early_cpu_init(void);
-<<<<<<< HEAD/arch/i386/kernel/setup.c
-=======
 extern void early_trap_init(void);
 extern void generic_apic_probe(char *);
->>>>>>> /arch/i386/kernel/setup.c
 extern int root_mountflags;
 
 unsigned long saved_videomode;
@@ -575,12 +572,8 @@ void __init setup_arch(char **cmdline_p)
 	data_resource.start = virt_to_phys(_etext);
 	data_resource.end = virt_to_phys(_edata)-1;
 
-<<<<<<< HEAD/arch/i386/kernel/setup.c
-	parse_early_param();
-=======
 	parse_cmdline_early(cmdline_p);
 	parse_early_param();
->>>>>>> /arch/i386/kernel/setup.c
 
 	if (user_defined_memmap) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
diff -puN kernel/timer.c~git-kgdb-fixup kernel/timer.c
--- a/kernel/timer.c~git-kgdb-fixup
+++ a/kernel/timer.c
@@ -1318,6 +1318,11 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+
+#ifdef CONFIG_KGDB
+	if (!atomic_read(&kgdb_sync_softlockup[raw_smp_processor_id()]))
+#endif
+	softlockup_tick();
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
diff -puN lib/Kconfig.debug~git-kgdb-fixup lib/Kconfig.debug
--- a/lib/Kconfig.debug~git-kgdb-fixup
+++ a/lib/Kconfig.debug
@@ -357,11 +357,7 @@ config DEBUG_LIST
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
-<<<<<<< HEAD/lib/Kconfig.debug
 	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH)
-=======
-	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || SUPERH)
->>>>>>> /lib/Kconfig.debug
 	default y if DEBUG_INFO && UML
 	help
 	  If you say Y here the resulting kernel image will be slightly larger
@@ -396,7 +392,6 @@ config RCU_TORTURE_TEST
 	  at boot time (you probably don't).
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
-<<<<<<< HEAD/lib/Kconfig.debug
 
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
@@ -445,7 +440,6 @@ config FAULT_INJECTION_DEBUG_FS
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
 	help
 	  Enable configuration of fault-injection capabilities via debugfs.
-=======
 
 config WANT_EXTRA_DEBUG_INFORMATION
 	bool
@@ -646,4 +640,4 @@ config KGDB_8250_CONF_STRING
 	  serial port on an i386 box located at 0x2f8 and 115200 baud
 	  on IRQ 3 at use:
 	  io,2f8,115200,3
->>>>>>> /lib/Kconfig.debug
+
diff -puN Documentation/networking/ip-sysctl.txt~git-kgdb-fixup Documentation/networking/ip-sysctl.txt
--- a/Documentation/networking/ip-sysctl.txt~git-kgdb-fixup
+++ a/Documentation/networking/ip-sysctl.txt
@@ -387,8 +387,6 @@ tcp_workaround_signed_windows - BOOLEAN
 	not receive a window scaling option from them.
 	Default: 0
 
-<<<<<<< HEAD/Documentation/networking/ip-sysctl.txt
-=======
 tcp_slow_start_after_idle - BOOLEAN
 	If set, provide RFC2861 behavior and time out the congestion
 	window after an idle period.  An idle period is defined at
@@ -402,7 +400,6 @@ tcp_dma_copybreak - INTEGER
 	and CONFIG_NET_DMA is enabled.
 	Default: 4096
 
->>>>>>> /Documentation/networking/ip-sysctl.txt
 CIPSOv4 Variables:
 
 cipso_cache_enable - BOOLEAN
diff -puN arch/i386/kernel/Makefile~git-kgdb-fixup arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~git-kgdb-fixup
+++ a/arch/i386/kernel/Makefile
@@ -38,14 +38,11 @@ obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
-<<<<<<< HEAD/arch/i386/kernel/Makefile
 
 # Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
-=======
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp.o
->>>>>>> /arch/i386/kernel/Makefile
 
 EXTRA_AFLAGS   := -traditional
 
diff -puN arch/i386/kernel/process.c~git-kgdb-fixup arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~git-kgdb-fixup
+++ a/arch/i386/kernel/process.c
@@ -322,8 +322,6 @@ void show_regs(struct pt_regs * regs)
  * the "args".
  */
 extern void kernel_thread_helper(void);
-<<<<<<< HEAD/arch/i386/kernel/process.c
-=======
 __asm__(".section .text\n"
 	".align 4\n"
 	"kernel_thread_helper:\n\t"
@@ -353,7 +351,6 @@ __asm__(
 		FDE_postamble()
 		));
 #endif
->>>>>>> /arch/i386/kernel/process.c
 
 /*
  * Create a kernel thread
diff -puN arch/ia64/kernel/smp.c~git-kgdb-fixup arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~git-kgdb-fixup
+++ a/arch/ia64/kernel/smp.c
@@ -68,13 +68,10 @@ static volatile struct call_data_struct 
 
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
-<<<<<<< HEAD/arch/ia64/kernel/smp.c
-#define IPI_KDUMP_CPU_STOP	3
-=======
 #ifdef	CONFIG_KGDB
 #define	IPI_KGDB_INTERRUPT	2
 #endif
->>>>>>> /arch/ia64/kernel/smp.c
+#define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
 static DEFINE_PER_CPU(u64, ipi_operation) ____cacheline_aligned;
@@ -164,20 +161,17 @@ handle_IPI (int irq, void *dev_id)
 			      case IPI_CPU_STOP:
 				stop_this_cpu();
 				break;
-<<<<<<< HEAD/arch/ia64/kernel/smp.c
 #ifdef CONFIG_KEXEC
 			      case IPI_KDUMP_CPU_STOP:
 				unw_init_running(kdump_cpu_freeze, NULL);
 				break;
 #endif
-=======
 #ifdef	CONFIG_KGDB
 			      case IPI_KGDB_INTERRUPT:
 				kgdb_wait_ipi(regs);
 				break;
 #endif
 
->>>>>>> /arch/ia64/kernel/smp.c
 			      default:
 				printk(KERN_CRIT "Unknown IPI on CPU %d: %lu\n", this_cpu, which);
 				break;
diff -puN arch/mips/kernel/irq.c~git-kgdb-fixup arch/mips/kernel/irq.c
--- a/arch/mips/kernel/irq.c~git-kgdb-fixup
+++ a/arch/mips/kernel/irq.c
@@ -144,8 +144,6 @@ asmlinkage void spurious_interrupt(void)
 
 void __init init_IRQ(void)
 {
-<<<<<<< HEAD/arch/mips/kernel/irq.c
-=======
 	int i;
 
 	if (kgdb_early_setup)
@@ -162,7 +160,6 @@ void __init init_IRQ(void)
 #endif /* CONFIG_MIPS_MT_SMTC */
 	}
 
->>>>>>> /arch/mips/kernel/irq.c
 	arch_init_irq();
 #ifdef CONFIG_KGDB
 	/*
diff -puN arch/mips/kernel/traps.c~git-kgdb-fixup arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~git-kgdb-fixup
+++ a/arch/mips/kernel/traps.c
@@ -22,11 +22,8 @@
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/bootmem.h>
-<<<<<<< HEAD/arch/mips/kernel/traps.c
 #include <linux/interrupt.h>
-=======
 #include <linux/kgdb.h>
->>>>>>> /arch/mips/kernel/traps.c
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -47,11 +44,8 @@
 #include <asm/mmu_context.h>
 #include <asm/watch.h>
 #include <asm/types.h>
-<<<<<<< HEAD/arch/mips/kernel/traps.c
 #include <asm/stacktrace.h>
-=======
 #include <asm/kdebug.h>
->>>>>>> /arch/mips/kernel/traps.c
 
 extern asmlinkage void handle_int(void);
 extern asmlinkage void handle_tlbm(void);
diff -puN arch/mips/sibyte/sb1250/irq.c~git-kgdb-fixup arch/mips/sibyte/sb1250/irq.c
--- a/arch/mips/sibyte/sb1250/irq.c~git-kgdb-fixup
+++ a/arch/mips/sibyte/sb1250/irq.c
@@ -361,7 +361,6 @@ void __init arch_init_irq(void)
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
 
-<<<<<<< HEAD/arch/mips/sibyte/sb1250/irq.c
 #ifdef CONFIG_KGDB
 	if (kgdb_flag) {
 		kgdb_irq = K_INT_UART_0 + kgdb_port;
@@ -408,7 +407,6 @@ static void sb1250_kgdb_interrupt(void)
 
 extern void sb1250_timer_interrupt(void);
 extern void sb1250_mailbox_interrupt(void);
-=======
 static inline int dclz(unsigned long long x)
 {
 	int lz;
@@ -427,7 +425,6 @@ static inline int dclz(unsigned long lon
 extern void sb1250_timer_interrupt(struct pt_regs *regs);
 extern void sb1250_mailbox_interrupt(struct pt_regs *regs);
 extern void sb1250_kgdb_interrupt(struct pt_regs *regs);
->>>>>>> /arch/mips/sibyte/sb1250/irq.c
 
 asmlinkage void plat_irq_dispatch(void)
 {
diff -puN arch/powerpc/Kconfig.debug~git-kgdb-fixup arch/powerpc/Kconfig.debug
--- a/arch/powerpc/Kconfig.debug~git-kgdb-fixup
+++ a/arch/powerpc/Kconfig.debug
@@ -18,7 +18,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-<<<<<<< HEAD/arch/powerpc/Kconfig.debug
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS
@@ -76,15 +75,10 @@ config KGDB_CONSOLE
 	  over the gdb stub.
 	  If unsure, say N.
 
-=======
->>>>>>> /arch/powerpc/Kconfig.debug
 config XMON
 	bool "Include xmon kernel debugger"
-<<<<<<< HEAD/arch/powerpc/Kconfig.debug
 	depends on DEBUGGER
-=======
 	depends on DEBUG_KERNEL && !PPC_ISERIES
->>>>>>> /arch/powerpc/Kconfig.debug
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.
@@ -105,7 +99,6 @@ config XMON_DEFAULT
 	  xmon is normally disabled unless booted with 'xmon=on'.
 	  Use 'xmon=off' to disable xmon init during runtime.
 
-<<<<<<< HEAD/arch/powerpc/Kconfig.debug
 config XMON_DISASSEMBLY
 	bool "Include disassembly support in xmon"
 	depends on XMON
@@ -115,13 +108,11 @@ config XMON_DISASSEMBLY
 	  to say Y here, unless you're building for a memory-constrained
 	  system.
 
-=======
 config DEBUGGER
 	bool
 	depends on KGDB || XMON
 	default y
 
->>>>>>> /arch/powerpc/Kconfig.debug
 config IRQSTACKS
 	bool "Use separate kernel stacks when processing interrupts"
 	depends on PPC64
diff -puN arch/powerpc/kernel/Makefile~git-kgdb-fixup arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~git-kgdb-fixup
+++ a/arch/powerpc/kernel/Makefile
@@ -58,11 +58,8 @@ obj-$(CONFIG_BOOTX_TEXT)	+= btext.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_PPC_UDBG_16550)	+= legacy_serial.o udbg_16550.o
-<<<<<<< HEAD/arch/powerpc/kernel/Makefile
 
-=======
 obj-$(CONFIG_KGDB)		+= kgdb.o
->>>>>>> /arch/powerpc/kernel/Makefile
 module-$(CONFIG_PPC64)		+= module_64.o
 obj-$(CONFIG_MODULES)		+= $(module-y)
 
diff -puN arch/powerpc/kernel/setup_32.c~git-kgdb-fixup arch/powerpc/kernel/setup_32.c
--- a/arch/powerpc/kernel/setup_32.c~git-kgdb-fixup
+++ a/arch/powerpc/kernel/setup_32.c
@@ -237,7 +237,6 @@ void __init setup_arch(char **cmdline_p)
 	/* Register early console */
 	register_early_udbg_console();
 
-<<<<<<< HEAD/arch/powerpc/kernel/setup_32.c
 	xmon_setup();
 
 #if defined(CONFIG_KGDB)
@@ -252,8 +251,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-=======
->>>>>>> /arch/powerpc/kernel/setup_32.c
 	/*
 	 * Set cache line size based on type of cpu as a default.
 	 * Systems with OF can look in the properties on the cpu node(s)
diff -puN arch/sh/Kconfig.debug~git-kgdb-fixup arch/sh/Kconfig.debug
--- a/arch/sh/Kconfig.debug~git-kgdb-fixup
+++ a/arch/sh/Kconfig.debug
@@ -45,7 +45,6 @@ config EARLY_PRINTK
 	  This option is only useful porting the kernel to a new machine,
 	  when the kernel may crash or hang before the serial console is
 	  initialised. If unsure, say N.
-<<<<<<< HEAD/arch/sh/Kconfig.debug
 
 	  On devices that are running SH-IPL and want to keep the port
 	  initialization consistent while not using the BIOS callbacks,
@@ -161,6 +160,4 @@ endchoice
 
 endmenu
 
-=======
->>>>>>> /arch/sh/Kconfig.debug
 endmenu
diff -puN arch/sh/boards/se/7751/setup.c~git-kgdb-fixup arch/sh/boards/se/7751/setup.c
--- a/arch/sh/boards/se/7751/setup.c~git-kgdb-fixup
+++ a/arch/sh/boards/se/7751/setup.c
@@ -16,7 +16,6 @@
 void heartbeat_7751se(void);
 void init_7751se_IRQ(void);
 
-<<<<<<< HEAD/arch/sh/boards/se/7751/setup.c
 #ifdef CONFIG_SH_KGDB
 #include <asm/kgdb.h>
 static int kgdb_uart_setup(void);
@@ -24,7 +23,6 @@ static struct kgdb_sermap kgdb_uart_serm
 { "ttyS", 0, kgdb_uart_setup, NULL };
 #endif
  
-=======
 /*
  * Configure the Super I/O chip
  */
@@ -86,7 +84,6 @@ const char *get_system_type(void)
 	return "7751 SolutionEngine";
 }
 
->>>>>>> /arch/sh/boards/se/7751/setup.c
 /*
  * Initialize the board
  */
@@ -95,7 +92,6 @@ static void __init sh7751se_setup(char *
 	/* Call init_smsc() replacement to set up SuperIO. */
 	/* XXX: RTC setting comes here */
 }
-<<<<<<< HEAD/arch/sh/boards/se/7751/setup.c
 #endif /* CONFIG_SH_KGDB */
 
 
@@ -131,5 +127,3 @@ struct sh_machine_vector mv_7751se __ini
 #endif
 };
 ALIAS_MV(7751se)
-=======
->>>>>>> /arch/sh/boards/se/7751/setup.c
diff -puN arch/sh/kernel/setup.c~git-kgdb-fixup arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~git-kgdb-fixup
+++ a/arch/sh/kernel/setup.c
@@ -494,7 +494,6 @@ struct seq_operations cpuinfo_op = {
 	.show	= show_cpuinfo,
 };
 #endif /* CONFIG_PROC_FS */
-<<<<<<< HEAD/arch/sh/kernel/setup.c
 
 #ifdef CONFIG_SH_KGDB
 /*
@@ -584,5 +583,3 @@ static int __init kgdb_parse_options(cha
 }
 __setup("kgdb=", kgdb_parse_options);
 #endif /* CONFIG_SH_KGDB */
-=======
->>>>>>> /arch/sh/kernel/setup.c
diff -puN arch/sh/kernel/time.c~git-kgdb-fixup arch/sh/kernel/time.c
--- a/arch/sh/kernel/time.c~git-kgdb-fixup
+++ a/arch/sh/kernel/time.c
@@ -323,7 +323,6 @@ void __init time_init(void)
 	 */
 	sys_timer = get_sys_timer();
 	printk(KERN_INFO "Using %s for system timer\n", sys_timer->name);
-<<<<<<< HEAD/arch/sh/kernel/time.c
 
 #ifdef CONFIG_NO_IDLE_HZ
 	if (sys_timer->dyn_tick)
@@ -337,6 +336,4 @@ void __init time_init(void)
 	 */
 	kgdb_init();
 #endif
-=======
->>>>>>> /arch/sh/kernel/time.c
 }
diff -puN arch/sh/kernel/traps.c~git-kgdb-fixup arch/sh/kernel/traps.c
--- a/arch/sh/kernel/traps.c~git-kgdb-fixup
+++ a/arch/sh/kernel/traps.c
@@ -17,18 +17,14 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
-<<<<<<< HEAD/arch/sh/kernel/traps.c
 #include <linux/io.h>
 #include <linux/debug_locks.h>
 #include <linux/limits.h>
-=======
 #include <linux/kgdb.h>
 
->>>>>>> /arch/sh/kernel/traps.c
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
-<<<<<<< HEAD/arch/sh/kernel/traps.c
 #ifdef CONFIG_SH_KGDB
 #include <asm/kgdb.h>
 #define CHK_REMOTE_DEBUG(regs)			\
@@ -38,14 +34,11 @@
 }
 #else
 #define CHK_REMOTE_DEBUG(regs)
-=======
+
 #ifndef CONFIG_KGDB
 #define kgdb_handle_exception(t, s, e, r)
->>>>>>> /arch/sh/kernel/traps.c
 #endif
 
-<<<<<<< HEAD/arch/sh/kernel/traps.c
-=======
 #define DO_ERROR(trapnr, signr, str, name, tsk)				\
 asmlinkage void do_##name(unsigned long r4, unsigned long r5,		\
 			  unsigned long r6, unsigned long r7,		\
@@ -69,7 +62,6 @@ asmlinkage void do_##name(unsigned long 
 	die_if_no_fixup(str,&regs,error_code);				\
 }
 
->>>>>>> /arch/sh/kernel/traps.c
 #ifdef CONFIG_CPU_SH2
 # define TRAP_RESERVED_INST	4
 # define TRAP_ILLEGAL_SLOT_INST	6
@@ -124,12 +116,9 @@ void die(const char * str, struct pt_reg
 	bust_spinlocks(1);
 
 	printk("%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
-<<<<<<< HEAD/arch/sh/kernel/traps.c
 
 	CHK_REMOTE_DEBUG(regs);
 	print_modules();
-=======
->>>>>>> /arch/sh/kernel/traps.c
 	show_regs(regs);
 
 	printk("Process: %s (pid: %d, stack limit = %p)\n",
diff -puN arch/sh/mm/fault.c~git-kgdb-fixup arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~git-kgdb-fixup
+++ a/arch/sh/mm/fault.c
@@ -17,11 +17,8 @@
 #include <linux/kprobes.h>
 #include <asm/system.h>
 #include <asm/mmu_context.h>
-<<<<<<< HEAD/arch/sh/mm/fault.c
 #include <asm/kgdb.h>
-=======
 #include <asm/cacheflush.h>
->>>>>>> /arch/sh/mm/fault.c
 
 extern void die(const char *,struct pt_regs *,long);
 
@@ -224,8 +221,6 @@ do_sigbus:
 	if (!user_mode(regs))
 		goto no_context;
 }
-<<<<<<< HEAD/arch/sh/mm/fault.c
-=======
 
 /*
  * Called with interrupt disabled.
@@ -413,4 +408,3 @@ void flush_tlb_all(void)
 	ctrl_outl(status, MMUCR);
 	local_irq_restore(flags);
 }
->>>>>>> /arch/sh/mm/fault.c
diff -puN drivers/char/keyboard.c~git-kgdb-fixup drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~git-kgdb-fixup
+++ a/drivers/char/keyboard.c
@@ -1176,12 +1176,7 @@ static void kbd_keycode(unsigned int key
 	if (sysrq_down && !down && keycode == sysrq_alt_use)
 		sysrq_down = 0;
 	if (sysrq_down && down && !rep) {
-<<<<<<< HEAD/drivers/char/keyboard.c
 		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
-=======
-		handle_sysrq(kbd_sysrq_xlate[keycode], regs, tty);
-		sysrq_down = 0;		/* In case we miss the 'up' event. */
->>>>>>> /drivers/char/keyboard.c
 		return;
 	}
 #endif
diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~git-kgdb-fixup drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~git-kgdb-fixup
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1177,7 +1177,6 @@ int cpm_uart_early_setup(int index, int 
 		cpm_uart_drv_get_platform_data(pdev, 1);
 	}
 
-<<<<<<< HEAD/drivers/serial/cpm_uart/cpm_uart_core.c
 	pinfo->flags |= FLAG_CONSOLE;
 
 	if (options) {
@@ -1187,8 +1186,6 @@ int cpm_uart_early_setup(int index, int 
 			baud = 9600;
 	}
 
-=======
->>>>>>> /drivers/serial/cpm_uart/cpm_uart_core.c
 	if (IS_SMC(pinfo)) {
 		pinfo->smcp->smc_smcm &= ~(SMCM_RX | SMCM_TX);
 		pinfo->smcp->smc_smcmr &= ~(SMCMR_REN | SMCMR_TEN);
diff -puN drivers/serial/serial_core.c~git-kgdb-fixup drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~git-kgdb-fixup
+++ a/drivers/serial/serial_core.c
@@ -66,9 +66,7 @@ static struct lock_class_key port_lock_k
 #define uart_console(port)	(0)
 #endif
 
-<<<<<<< HEAD/drivers/serial/serial_core.c
 static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
-=======
 #ifdef CONFIG_KGDB_CONSOLE
 #define uart_kgdb(port)		(port->cons && !strcmp(port->cons->name, "kgdb"))
 #else
@@ -76,7 +74,6 @@ static void uart_change_speed(struct uar
 #endif
 
 static void uart_change_speed(struct uart_state *state, struct termios *old_termios);
->>>>>>> /drivers/serial/serial_core.c
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
diff -puN drivers/serial/sh-sci.c~git-kgdb-fixup drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~git-kgdb-fixup
+++ a/drivers/serial/sh-sci.c
@@ -35,13 +35,10 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/console.h>
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #include <linux/platform_device.h>
-=======
 #include <linux/bitops.h>
 #include <linux/generic_serial.h>
 #include <linux/kgdb.h>
->>>>>>> /drivers/serial/sh-sci.c
 
 #ifdef CONFIG_CPU_FREQ
 #include <linux/notifier.h>
@@ -62,7 +59,6 @@
 
 #include "sh-sci.h"
 
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 struct sci_port {
 	struct uart_port	port;
 
@@ -90,7 +86,6 @@ struct sci_port {
 #ifdef CONFIG_SH_KGDB
 static struct sci_port *kgdb_sci_port;
 #endif
-=======
 #ifdef CONFIG_KGDB_SH_SCI
 /* Speed of the UART. */
 static int kgdbsci_baud = CONFIG_KGDB_BAUDRATE
@@ -101,7 +96,6 @@ static int kgdbsci_ttySC = CONFIG_KGDB_P
 /* Make life easier on us. */
 #define KGDBPORT	sci_ports[kgdbsci_ttySC]
 #endif /* CONFIG_KGDB_SH_SCI */
->>>>>>> /drivers/serial/sh-sci.c
 
 #ifdef CONFIG_SERIAL_SH_SCI_CONSOLE
 static struct sci_port *serial_console_port;
@@ -109,8 +103,6 @@ static struct sci_port *serial_console_p
 
 /* Function prototypes */
 static void sci_stop_tx(struct uart_port *port);
-<<<<<<< HEAD/drivers/serial/sh-sci.c
-=======
 static void sci_start_tx(struct uart_port *port);
 static void sci_start_rx(struct uart_port *port, unsigned int tty_start);
 static void sci_stop_rx(struct uart_port *port);
@@ -119,14 +111,12 @@ static void sci_free_irq(struct sci_port
 static void sci_set_termios(struct uart_port *port, struct termios *termios,
 			struct termios *old);
 static int kgdbsci_init(void);
->>>>>>> /drivers/serial/sh-sci.c
 
 #define SCI_NPORTS CONFIG_SERIAL_SH_SCI_NR_UARTS
 
 static struct sci_port sci_ports[SCI_NPORTS];
 static struct uart_driver sci_uart_driver;
 
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #if defined(CONFIG_SERIAL_SH_SCI_CONSOLE) && \
     defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
 static inline void handle_error(struct uart_port *port)
@@ -136,12 +126,10 @@ static inline void handle_error(struct u
 }
 
 static int get_char(struct uart_port *port)
-=======
 #define SCI_NPORTS sci_uart_driver.nr
 
 #if defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_KGDB_SH_SCI)
 static int get_char_for_gdb(struct uart_port *port)
->>>>>>> /drivers/serial/sh-sci.c
 {
 	unsigned long flags;
 	unsigned short status;
@@ -163,11 +151,7 @@ static int get_char_for_gdb(struct uart_
 
 	return c;
 }
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_SH_KGDB */
-=======
-#endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_KGDB_SH_SCI */
->>>>>>> /drivers/serial/sh-sci.c
 
 #if defined(CONFIG_SERIAL_SH_SCI_CONSOLE) || defined(CONFIG_SH_KGDB)
 static void put_char(struct uart_port *port, char c)
@@ -235,10 +219,8 @@ static void put_string(struct sci_port *
 }
 #endif /* CONFIG_SERIAL_SH_SCI_CONSOLE */
 
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #ifdef CONFIG_SH_KGDB
 static int kgdb_sci_getchar(void)
-=======
 
 #ifdef CONFIG_KGDB_SH_SCI
 static int kgdbsci_read_char(void)
@@ -287,16 +269,13 @@ static irqreturn_t kgdbsci_rx_interrupt(
 
 static irqreturn_t kgdbsci_mpxed_interrupt(int irq, void *ptr,
 		struct pt_regs *regs)
->>>>>>> /drivers/serial/sh-sci.c
 {
         unsigned short ssr_status, scr_status;
         struct uart_port *port = ptr;
 
-<<<<<<< HEAD/drivers/serial/sh-sci.c
         /* Keep trying to read a character, this could be neater */
         while ((c = get_char(kgdb_sci_port)) < 0)
 		cpu_relax();
-=======
         ssr_status = sci_in(port,SCxSR);
         scr_status = sci_in(port,SCSCR);
 
@@ -329,22 +308,9 @@ static void __init kgdbsci_lateinit(void
 }
 #endif
 
-/*
- * We use the normal init routine to setup the port, so we can't be
- * in here too early.
- */
-static int kgdbsci_init(void)
-{
-	struct termios termios;
->>>>>>> /drivers/serial/sh-sci.c
-
-	memset(&termios, 0, sizeof(struct termios));
-
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 static inline void kgdb_sci_putchar(int c)
 {
         put_char(kgdb_sci_port, c);
-=======
 	termios.c_cflag = CREAD | HUPCL | CLOCAL | CS8;
 	switch (kgdbsci_baud) {
 	case 9600:
@@ -366,11 +332,8 @@ static inline void kgdb_sci_putchar(int 
 	sci_set_termios(&KGDBPORT.port, &termios, NULL);
 
 	return 0;
->>>>>>> /drivers/serial/sh-sci.c
 }
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #endif /* CONFIG_SH_KGDB */
-=======
 
 struct kgdb_io kgdb_io_ops = {
 	.read_char = kgdbsci_read_char,
@@ -1517,7 +1480,6 @@ int __init kgdb_console_setup(struct con
 #endif /* CONFIG_SH_KGDB */
 #endif /* 0 */
 
-<<<<<<< HEAD/drivers/serial/sh-sci.c
 #ifdef CONFIG_SH_KGDB_CONSOLE
 static struct console kgdb_console = {
         .name		= "ttySC",
@@ -1541,9 +1503,7 @@ console_initcall(kgdb_console_init);
 #if defined(CONFIG_SH_KGDB_CONSOLE)
 #define SCI_CONSOLE	&kgdb_console
 #elif defined(CONFIG_SERIAL_SH_SCI_CONSOLE)
-=======
 #ifdef CONFIG_SERIAL_SH_SCI_CONSOLE
->>>>>>> /drivers/serial/sh-sci.c
 #define SCI_CONSOLE	&serial_console
 #else
 #define SCI_CONSOLE	0
@@ -1685,8 +1645,4 @@ static void __exit sci_exit(void)
 
 module_init(sci_init);
 module_exit(sci_exit);
-<<<<<<< HEAD/drivers/serial/sh-sci.c
-
 MODULE_LICENSE("GPL");
-=======
->>>>>>> /drivers/serial/sh-sci.c
diff -puN include/asm-sh/kgdb.h~git-kgdb-fixup include/asm-sh/kgdb.h
--- a/include/asm-sh/kgdb.h~git-kgdb-fixup
+++ a/include/asm-sh/kgdb.h
@@ -47,7 +47,6 @@ struct kgdb_regs {
 #else
 #define kgdb_flush_icache_range(start, end)	do { } while (0)
 #endif
-<<<<<<< HEAD/include/asm-sh/kgdb.h
 
 /* Kernel assert macros */
 #ifdef CONFIG_KGDB_KERNEL_ASSERTS
@@ -89,7 +88,5 @@ static inline char lowhex(const int x)
 	return hexchars[x & 0xf];
 }
 
-=======
 #endif				/* !__ASSEMBLY__ */
->>>>>>> /include/asm-sh/kgdb.h
 #endif
diff -puN include/asm-sh/system.h~git-kgdb-fixup include/asm-sh/system.h
--- a/include/asm-sh/system.h~git-kgdb-fixup
+++ a/include/asm-sh/system.h
@@ -6,12 +6,9 @@
  * Copyright (C) 2002 Paul Mundt
  */
 
-<<<<<<< HEAD/include/asm-sh/system.h
 #include <linux/irqflags.h>
 #include <asm/types.h>
-=======
 #include <asm/types.h>
->>>>>>> /include/asm-sh/system.h
 
 /*
  *	switch_to() should switch tasks to task nr n, first
diff -puN include/linux/netpoll.h~git-kgdb-fixup include/linux/netpoll.h
--- a/include/linux/netpoll.h~git-kgdb-fixup
+++ a/include/linux/netpoll.h
@@ -14,16 +14,9 @@
 
 struct netpoll {
 	struct net_device *dev;
-<<<<<<< HEAD/include/linux/netpoll.h
-	char dev_name[IFNAMSIZ];
-	const char *name;
-	void (*rx_hook)(struct netpoll *, int, char *, int);
-
-=======
 	char dev_name[16], *name;
 	void (*rx_hook)(struct netpoll *, int, char *, int, struct sk_buff *);
 	void (*drop)(struct sk_buff *skb);
->>>>>>> /include/linux/netpoll.h
 	u32 local_ip, remote_ip;
 	u16 local_port, remote_port;
  	u8 local_mac[ETH_ALEN], remote_mac[ETH_ALEN];
_

Patches currently in -mm which might be from akpm@osdl.org are

deadlock-in-mincore-tidy.patch
deadlock-in-mincore-speedup.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-cpufreq-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
infiniband-fix-for-gregkh-depredations.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-fix.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
kgdb-fix-rejects.patch
git-kgdb-fixup.patch
git-kgdb-vs-define-struct-pspace.patch
kgdb-default-to-ttys0.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

