From: akpm@linux-foundation.org
Subject: - m32r-kernel-cleanups.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:36 -0700
Message-ID: <200810012150.m91LoaRo005855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbYJAVu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r/kernel/: cleanups
has been removed from the -mm tree.  Its filename was
     m32r-kernel-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r/kernel/: cleanups
From: Adrian Bunk <bunk@kernel.org>

This patch contains the following cleanups:
- make the following needlessly global code static:
  - entry.S: resume_userspace
  - process.c: pm_idle
  - process.c: default_idle()
  - smp.c: send_IPI_allbutself()
  - time.c: timer_interrupt()
  - time.c: struct irq0
  - traps.c: set_eit_vector_entries()
  - traps.c: kstack_depth_to_print
  - traps.c: show_trace()
  - traps.c: die_lock
- remove the following unused code:
  - head.S: startup_32
  - process.c: hlt_counter
  - process.c: disable_hlt()
  - process.c: enable_hlt()
  - process.c: dump_task_regs()
- remove the following variables and their usages since they were
  always 0:
  - irq.c: irq_err_count
  - irq.c: irq_mis_count

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/entry.S   |    2 +-
 arch/m32r/kernel/head.S    |    1 -
 arch/m32r/kernel/irq.c     |    6 ------
 arch/m32r/kernel/process.c |   30 ++----------------------------
 arch/m32r/kernel/smp.c     |    4 ++--
 arch/m32r/kernel/time.c    |    5 ++---
 arch/m32r/kernel/traps.c   |    8 ++++----
 7 files changed, 11 insertions(+), 45 deletions(-)

diff -puN arch/m32r/kernel/entry.S~m32r-kernel-cleanups arch/m32r/kernel/entry.S
--- a/arch/m32r/kernel/entry.S~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/entry.S
@@ -143,7 +143,7 @@ ret_from_intr:
 	and3	r4, r4, #0x8000		; check BSM bit
 #endif
 	beqz	r4, resume_kernel
-ENTRY(resume_userspace)
+resume_userspace:
 	DISABLE_INTERRUPTS(r4)		; make sure we don't miss an interrupt
 					; setting need_resched or sigpending
 					; between sampling and the iret
diff -puN arch/m32r/kernel/head.S~m32r-kernel-cleanups arch/m32r/kernel/head.S
--- a/arch/m32r/kernel/head.S~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/head.S
@@ -29,7 +29,6 @@ __INITDATA
 	.global _end
 ENTRY(stext)
 ENTRY(_stext)
-ENTRY(startup_32)
 	/* Setup up the stack pointer */
 	LDIMM	(r0, spi_stack_top)
 	LDIMM	(r1, spu_stack_top)
diff -puN arch/m32r/kernel/irq.c~m32r-kernel-cleanups arch/m32r/kernel/irq.c
--- a/arch/m32r/kernel/irq.c~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/irq.c
@@ -22,9 +22,6 @@
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
-atomic_t irq_err_count;
-atomic_t irq_mis_count;
-
 /*
  * Generic, controller-independent functions:
  */
@@ -63,9 +60,6 @@ int show_interrupts(struct seq_file *p, 
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
-		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
 	}
 	return 0;
 }
diff -puN arch/m32r/kernel/process.c~m32r-kernel-cleanups arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/process.c
@@ -35,8 +35,6 @@
 
 #include <linux/err.h>
 
-static int hlt_counter=0;
-
 /*
  * Return saved PC of a blocked thread.
  */
@@ -48,31 +46,16 @@ unsigned long thread_saved_pc(struct tas
 /*
  * Powermanagement idle function, if any..
  */
-void (*pm_idle)(void) = NULL;
-EXPORT_SYMBOL(pm_idle);
+static void (*pm_idle)(void) = NULL;
 
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-
-EXPORT_SYMBOL(enable_hlt);
-
 /*
  * We use this is we don't have any better
  * idle routine..
  */
-void default_idle(void)
+static void default_idle(void)
 {
 	/* M32R_FIXME: Please use "cpu_sleep" mode.  */
 	cpu_relax();
@@ -260,15 +243,6 @@ int copy_thread(int nr, unsigned long cl
 	return 0;
 }
 
-/*
- * Capture the user space registers if the task is not running (in user space)
- */
-int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
-{
-	/* M32R_FIXME */
-	return 1;
-}
-
 asmlinkage int sys_fork(unsigned long r0, unsigned long r1, unsigned long r2,
 	unsigned long r3, unsigned long r4, unsigned long r5, unsigned long r6,
 	struct pt_regs regs)
diff -puN arch/m32r/kernel/smp.c~m32r-kernel-cleanups arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/smp.c
@@ -84,7 +84,7 @@ void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
-void send_IPI_allbutself(int, int);
+static void send_IPI_allbutself(int, int);
 static void send_IPI_mask(cpumask_t, int, int);
 unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
@@ -722,7 +722,7 @@ void smp_local_timer_interrupt(void)
  * ---------- --- --------------------------------------------------------
  *
  *==========================================================================*/
-void send_IPI_allbutself(int ipi_num, int try)
+static void send_IPI_allbutself(int ipi_num, int try)
 {
 	cpumask_t cpumask;
 
diff -puN arch/m32r/kernel/time.c~m32r-kernel-cleanups arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/time.c
@@ -34,7 +34,6 @@
 #include <asm/hw_irq.h>
 
 #ifdef CONFIG_SMP
-extern void send_IPI_allbutself(int, int);
 extern void smp_local_timer_interrupt(void);
 #endif
 
@@ -188,7 +187,7 @@ static long last_rtc_update = 0;
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
@@ -228,7 +227,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-struct irqaction irq0 = {
+static struct irqaction irq0 = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
 	.mask = CPU_MASK_NONE,
diff -puN arch/m32r/kernel/traps.c~m32r-kernel-cleanups arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~m32r-kernel-cleanups
+++ a/arch/m32r/kernel/traps.c
@@ -61,7 +61,7 @@ extern unsigned long	eit_vector[];
 	((unsigned long)func - (unsigned long)eit_vector - entry*4)/4 \
 	+ 0xff000000UL
 
-void	set_eit_vector_entries(void)
+static void set_eit_vector_entries(void)
 {
 	extern void default_eit_handler(void);
 	extern void system_call(void);
@@ -121,9 +121,9 @@ void __init trap_init(void)
 	cpu_init();
 }
 
-int kstack_depth_to_print = 24;
+static int kstack_depth_to_print = 24;
 
-void show_trace(struct task_struct *task, unsigned long *stack)
+static void show_trace(struct task_struct *task, unsigned long *stack)
 {
 	unsigned long addr;
 
@@ -224,7 +224,7 @@ bad:
 	printk("\n");
 }
 
-DEFINE_SPINLOCK(die_lock);
+static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-xtensa.patch
git-v4l-dvb.patch
git-net.patch
git-crypto.patch
git-drm.patch
git-security-testing.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
misdn-dsp_cmxc-fix-size-checks.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

