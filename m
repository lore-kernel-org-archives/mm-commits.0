From: akpm@linux-foundation.org
Subject: [patch 081/162] printk/nmi: generic solution for safe printk in
 NMI
Date: Fri, 20 May 2016 17:00:33 -0700
Message-ID: <573fa521.C7HtYXnFkcFNsiuf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcEUAAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, benh@kernel.crashing.org, daniel.thompson@linaro.org, davem@davemloft.net, jack@suse.cz, jkosina@suse.com, mingo@redhat.com, peterz@infradead.org, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, schwidefsky@de.ibm.com, tglx@linutronix.de

From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: generic solution for safe printk in NMI

printk() takes some locks and could not be used a safe way in NMI context.

The chance of a deadlock is real especially when printing stacks from all
CPUs.  This particular problem has been addressed on x86 by the commit
a9edc8809328 ("x86/nmi: Perform a safe NMI stack trace on all CPUs").

The patchset brings two big advantages.  First, it makes the NMI
backtraces safe on all architectures for free.  Second, it makes all NMI
messages almost safe on all architectures (the temporary buffer is
limited.  We still should keep the number of messages in NMI context at
minimum).

Note that there already are several messages printed in NMI context:
WARN_ON(in_nmi()), BUG_ON(in_nmi()), anything being printed out from MCE
handlers.  These are not easy to avoid.

This patch reuses most of the code and makes it generic.  It is useful for
all messages and architectures that support NMI.

The alternative printk_func is set when entering and is reseted when
leaving NMI context.  It queues IRQ work to copy the messages into the
main ring buffer in a safe context.

__printk_nmi_flush() copies all available messages and reset the buffer.
Then we could use a simple cmpxchg operations to get synchronized with
writers.  There is also used a spinlock to get synchronized with other
flushers.

We do not longer use seq_buf because it depends on external lock.  It
would be hard to make all supported operations safe for a lockless use.
It would be confusing and error prone to make only some operations safe.

The code is put into separate printk/nmi.c as suggested by Steven Rostedt.
It needs a per-CPU buffer and is compiled only on architectures that call
nmi_enter().  This is achieved by the new HAVE_NMI Kconfig flag.

The are MN10300 and Xtensa architectures.  We need to clean up NMI
handling there first.  Let's do it separately.

The patch is heavily based on the draft from Peter Zijlstra, see
https://lkml.org/lkml/2015/6/10/327

[arnd@arndb.de: printk-nmi: use %zu format string for size_t]
[akpm@linux-foundation.org: min_t->min - all types are size_t here]
Signed-off-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>	[arm part]
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jiri Kosina <jkosina@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                  |    4 
 arch/arm/Kconfig              |    1 
 arch/arm/kernel/smp.c         |    2 
 arch/avr32/Kconfig            |    1 
 arch/blackfin/Kconfig         |    1 
 arch/cris/Kconfig             |    1 
 arch/mips/Kconfig             |    1 
 arch/powerpc/Kconfig          |    1 
 arch/s390/Kconfig             |    1 
 arch/sh/Kconfig               |    1 
 arch/sparc/Kconfig            |    1 
 arch/tile/Kconfig             |    1 
 arch/x86/Kconfig              |    1 
 arch/x86/kernel/apic/hw_nmi.c |    1 
 include/linux/hardirq.h       |    2 
 include/linux/percpu.h        |    3 
 include/linux/printk.h        |   12 +
 init/Kconfig                  |    5 
 init/main.c                   |    1 
 kernel/printk/Makefile        |    1 
 kernel/printk/internal.h      |   44 ++++++
 kernel/printk/nmi.c           |  219 ++++++++++++++++++++++++++++++++
 kernel/printk/printk.c        |   19 --
 lib/nmi_backtrace.c           |   89 -------------
 24 files changed, 306 insertions(+), 107 deletions(-)

diff -puN arch/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/Kconfig
--- a/arch/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/Kconfig
@@ -187,7 +187,11 @@ config HAVE_OPTPROBES
 config HAVE_KPROBES_ON_FTRACE
 	bool
 
+config HAVE_NMI
+	bool
+
 config HAVE_NMI_WATCHDOG
+	depends on HAVE_NMI
 	bool
 #
 # An arch should select this if it provides all these things:
diff -puN arch/arm/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/arm/Kconfig
--- a/arch/arm/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/arm/Kconfig
@@ -67,6 +67,7 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_MEMBLOCK
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_NMI
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_OPTPROBES if !THUMB2_KERNEL
 	select HAVE_PERF_EVENTS
diff -puN arch/arm/kernel/smp.c~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/arm/kernel/smp.c
@@ -644,9 +644,11 @@ void handle_IPI(int ipinr, struct pt_reg
 		break;
 
 	case IPI_CPU_BACKTRACE:
+		printk_nmi_enter();
 		irq_enter();
 		nmi_cpu_backtrace(regs);
 		irq_exit();
+		printk_nmi_exit();
 		break;
 
 	default:
diff -puN arch/avr32/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/avr32/Kconfig
@@ -18,6 +18,7 @@ config AVR32
 	select GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_NMI
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff -puN arch/blackfin/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/blackfin/Kconfig
@@ -40,6 +40,7 @@ config BLACKFIN
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_NMI
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/cris/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/cris/Kconfig
--- a/arch/cris/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/cris/Kconfig
@@ -70,6 +70,7 @@ config CRIS
 	select GENERIC_CLOCKEVENTS if ETRAX_ARCH_V32
 	select GENERIC_SCHED_CLOCK if ETRAX_ARCH_V32
 	select HAVE_DEBUG_BUGVERBOSE if ETRAX_ARCH_V32
+	select HAVE_NMI
 
 config HZ
 	int
diff -puN arch/mips/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/mips/Kconfig
--- a/arch/mips/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/mips/Kconfig
@@ -48,6 +48,7 @@ config MIPS
 	select GENERIC_SCHED_CLOCK if !CAVIUM_OCTEON_SOC
 	select GENERIC_CMOS_UPDATE
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_NMI
 	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
diff -puN arch/powerpc/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/powerpc/Kconfig
@@ -155,6 +155,7 @@ config PPC
 	select NO_BOOTMEM
 	select HAVE_GENERIC_RCU_GUP
 	select HAVE_PERF_EVENTS_NMI if PPC64
+	select HAVE_NMI if PERF_EVENTS
 	select EDAC_SUPPORT
 	select EDAC_ATOMIC_SCRUB
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
diff -puN arch/s390/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/s390/Kconfig
--- a/arch/s390/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/s390/Kconfig
@@ -166,6 +166,7 @@ config S390
 	select TTY
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
+	select HAVE_NMI
 
 
 config SCHED_OMIT_FRAME_POINTER
diff -puN arch/sh/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/sh/Kconfig
--- a/arch/sh/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/sh/Kconfig
@@ -44,6 +44,7 @@ config SUPERH
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_NMI
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff -puN arch/sparc/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/sparc/Kconfig
@@ -79,6 +79,7 @@ config SPARC64
 	select NO_BOOTMEM
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select HAVE_NMI
 
 config ARCH_DEFCONFIG
 	string
diff -puN arch/tile/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/tile/Kconfig
--- a/arch/tile/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/tile/Kconfig
@@ -30,6 +30,7 @@ config TILE
 	select HAVE_DEBUG_STACKOVERFLOW
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_NMI if USE_PMC
 	select EDAC_SUPPORT
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff -puN arch/x86/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/x86/Kconfig
--- a/arch/x86/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MIXED_BREAKPOINTS_REGS
+	select HAVE_NMI
 	select HAVE_OPROFILE
 	select HAVE_OPTPROBES
 	select HAVE_PCSPKR_PLATFORM
diff -puN arch/x86/kernel/apic/hw_nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -18,7 +18,6 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/seq_buf.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(int watchdog_thresh)
diff -puN include/linux/hardirq.h~printk-nmi-generic-solution-for-safe-printk-in-nmi include/linux/hardirq.h
--- a/include/linux/hardirq.h~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/include/linux/hardirq.h
@@ -61,6 +61,7 @@ extern void irq_exit(void);
 
 #define nmi_enter()						\
 	do {							\
+		printk_nmi_enter();				\
 		lockdep_off();					\
 		ftrace_nmi_enter();				\
 		BUG_ON(in_nmi());				\
@@ -77,6 +78,7 @@ extern void irq_exit(void);
 		preempt_count_sub(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		ftrace_nmi_exit();				\
 		lockdep_on();					\
+		printk_nmi_exit();				\
 	} while (0)
 
 #endif /* LINUX_HARDIRQ_H */
diff -puN include/linux/percpu.h~printk-nmi-generic-solution-for-safe-printk-in-nmi include/linux/percpu.h
--- a/include/linux/percpu.h~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/include/linux/percpu.h
@@ -129,7 +129,4 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
 						__alignof__(type))
 
-/* To avoid include hell, as printk can not declare this, we declare it here */
-DECLARE_PER_CPU(printk_func_t, printk_func);
-
 #endif /* __LINUX_PERCPU_H */
diff -puN include/linux/printk.h~printk-nmi-generic-solution-for-safe-printk-in-nmi include/linux/printk.h
--- a/include/linux/printk.h~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/include/linux/printk.h
@@ -122,7 +122,17 @@ static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
 #endif
 
-typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
+#ifdef CONFIG_PRINTK_NMI
+extern void printk_nmi_init(void);
+extern void printk_nmi_enter(void);
+extern void printk_nmi_exit(void);
+extern void printk_nmi_flush(void);
+#else
+static inline void printk_nmi_init(void) { }
+static inline void printk_nmi_enter(void) { }
+static inline void printk_nmi_exit(void) { }
+static inline void printk_nmi_flush(void) { }
+#endif /* PRINTK_NMI */
 
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
diff -puN init/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi init/Kconfig
--- a/init/Kconfig~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/init/Kconfig
@@ -1454,6 +1454,11 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PRINTK_NMI
+	def_bool y
+	depends on PRINTK
+	depends on HAVE_NMI
+
 config BUG
 	bool "BUG() support" if EXPERT
 	default y
diff -puN init/main.c~printk-nmi-generic-solution-for-safe-printk-in-nmi init/main.c
--- a/init/main.c~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/init/main.c
@@ -569,6 +569,7 @@ asmlinkage __visible void __init start_k
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
+	printk_nmi_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();
diff -puN kernel/printk/Makefile~printk-nmi-generic-solution-for-safe-printk-in-nmi kernel/printk/Makefile
--- a/kernel/printk/Makefile~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/kernel/printk/Makefile
@@ -1,2 +1,3 @@
 obj-y	= printk.o
+obj-$(CONFIG_PRINTK_NMI)		+= nmi.o
 obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
diff -puN /dev/null kernel/printk/internal.h
--- /dev/null
+++ a/kernel/printk/internal.h
@@ -0,0 +1,44 @@
+/*
+ * internal.h - printk internal definitions
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/percpu.h>
+
+typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
+
+int __printf(1, 0) vprintk_default(const char *fmt, va_list args);
+
+#ifdef CONFIG_PRINTK_NMI
+
+/*
+ * printk() could not take logbuf_lock in NMI context. Instead,
+ * it temporary stores the strings into a per-CPU buffer.
+ * The alternative implementation is chosen transparently
+ * via per-CPU variable.
+ */
+DECLARE_PER_CPU(printk_func_t, printk_func);
+static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+{
+	return this_cpu_read(printk_func)(fmt, args);
+}
+
+#else /* CONFIG_PRINTK_NMI */
+
+static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+{
+	return vprintk_default(fmt, args);
+}
+
+#endif /* CONFIG_PRINTK_NMI */
diff -puN /dev/null kernel/printk/nmi.c
--- /dev/null
+++ a/kernel/printk/nmi.c
@@ -0,0 +1,219 @@
+/*
+ * nmi.c - Safe printk in NMI context
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/preempt.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/cpumask.h>
+#include <linux/irq_work.h>
+#include <linux/printk.h>
+
+#include "internal.h"
+
+/*
+ * printk() could not take logbuf_lock in NMI context. Instead,
+ * it uses an alternative implementation that temporary stores
+ * the strings into a per-CPU buffer. The content of the buffer
+ * is later flushed into the main ring buffer via IRQ work.
+ *
+ * The alternative implementation is chosen transparently
+ * via @printk_func per-CPU variable.
+ *
+ * The implementation allows to flush the strings also from another CPU.
+ * There are situations when we want to make sure that all buffers
+ * were handled or when IRQs are blocked.
+ */
+DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
+static int printk_nmi_irq_ready;
+
+#define NMI_LOG_BUF_LEN (4096 - sizeof(atomic_t) - sizeof(struct irq_work))
+
+struct nmi_seq_buf {
+	atomic_t		len;	/* length of written data */
+	struct irq_work		work;	/* IRQ work that flushes the buffer */
+	unsigned char		buffer[NMI_LOG_BUF_LEN];
+};
+static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
+
+/*
+ * Safe printk() for NMI context. It uses a per-CPU buffer to
+ * store the message. NMIs are not nested, so there is always only
+ * one writer running. But the buffer might get flushed from another
+ * CPU, so we need to be careful.
+ */
+static int vprintk_nmi(const char *fmt, va_list args)
+{
+	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
+	int add = 0;
+	size_t len;
+
+again:
+	len = atomic_read(&s->len);
+
+	if (len >= sizeof(s->buffer))
+		return 0;
+
+	/*
+	 * Make sure that all old data have been read before the buffer was
+	 * reseted. This is not needed when we just append data.
+	 */
+	if (!len)
+		smp_rmb();
+
+	add = vsnprintf(s->buffer + len, sizeof(s->buffer) - len, fmt, args);
+
+	/*
+	 * Do it once again if the buffer has been flushed in the meantime.
+	 * Note that atomic_cmpxchg() is an implicit memory barrier that
+	 * makes sure that the data were written before updating s->len.
+	 */
+	if (atomic_cmpxchg(&s->len, len, len + add) != len)
+		goto again;
+
+	/* Get flushed in a more safe context. */
+	if (add && printk_nmi_irq_ready) {
+		/* Make sure that IRQ work is really initialized. */
+		smp_rmb();
+		irq_work_queue(&s->work);
+	}
+
+	return add;
+}
+
+/*
+ * printk one line from the temporary buffer from @start index until
+ * and including the @end index.
+ */
+static void print_nmi_seq_line(struct nmi_seq_buf *s, int start, int end)
+{
+	const char *buf = s->buffer + start;
+
+	printk("%.*s", (end - start) + 1, buf);
+}
+
+/*
+ * Flush data from the associated per_CPU buffer. The function
+ * can be called either via IRQ work or independently.
+ */
+static void __printk_nmi_flush(struct irq_work *work)
+{
+	static raw_spinlock_t read_lock =
+		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
+	struct nmi_seq_buf *s = container_of(work, struct nmi_seq_buf, work);
+	unsigned long flags;
+	size_t len, size;
+	int i, last_i;
+
+	/*
+	 * The lock has two functions. First, one reader has to flush all
+	 * available message to make the lockless synchronization with
+	 * writers easier. Second, we do not want to mix messages from
+	 * different CPUs. This is especially important when printing
+	 * a backtrace.
+	 */
+	raw_spin_lock_irqsave(&read_lock, flags);
+
+	i = 0;
+more:
+	len = atomic_read(&s->len);
+
+	/*
+	 * This is just a paranoid check that nobody has manipulated
+	 * the buffer an unexpected way. If we printed something then
+	 * @len must only increase.
+	 */
+	if (i && i >= len)
+		pr_err("printk_nmi_flush: internal error: i=%d >= len=%zu\n",
+		       i, len);
+
+	if (!len)
+		goto out; /* Someone else has already flushed the buffer. */
+
+	/* Make sure that data has been written up to the @len */
+	smp_rmb();
+
+	size = min(len, sizeof(s->buffer));
+	last_i = i;
+
+	/* Print line by line. */
+	for (; i < size; i++) {
+		if (s->buffer[i] == '\n') {
+			print_nmi_seq_line(s, last_i, i);
+			last_i = i + 1;
+		}
+	}
+	/* Check if there was a partial line. */
+	if (last_i < size) {
+		print_nmi_seq_line(s, last_i, size - 1);
+		pr_cont("\n");
+	}
+
+	/*
+	 * Check that nothing has got added in the meantime and truncate
+	 * the buffer. Note that atomic_cmpxchg() is an implicit memory
+	 * barrier that makes sure that the data were copied before
+	 * updating s->len.
+	 */
+	if (atomic_cmpxchg(&s->len, len, 0) != len)
+		goto more;
+
+out:
+	raw_spin_unlock_irqrestore(&read_lock, flags);
+}
+
+/**
+ * printk_nmi_flush - flush all per-cpu nmi buffers.
+ *
+ * The buffers are flushed automatically via IRQ work. This function
+ * is useful only when someone wants to be sure that all buffers have
+ * been flushed at some point.
+ */
+void printk_nmi_flush(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		__printk_nmi_flush(&per_cpu(nmi_print_seq, cpu).work);
+}
+
+void __init printk_nmi_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct nmi_seq_buf *s = &per_cpu(nmi_print_seq, cpu);
+
+		init_irq_work(&s->work, __printk_nmi_flush);
+	}
+
+	/* Make sure that IRQ works are initialized before enabling. */
+	smp_wmb();
+	printk_nmi_irq_ready = 1;
+
+	/* Flush pending messages that did not have scheduled IRQ works. */
+	printk_nmi_flush();
+}
+
+void printk_nmi_enter(void)
+{
+	this_cpu_write(printk_func, vprintk_nmi);
+}
+
+void printk_nmi_exit(void)
+{
+	this_cpu_write(printk_func, vprintk_default);
+}
diff -puN kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/kernel/printk/printk.c
@@ -55,6 +55,7 @@
 
 #include "console_cmdline.h"
 #include "braille.h"
+#include "internal.h"
 
 int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* console_loglevel */
@@ -1807,14 +1808,6 @@ int vprintk_default(const char *fmt, va_
 }
 EXPORT_SYMBOL_GPL(vprintk_default);
 
-/*
- * This allows printk to be diverted to another function per cpu.
- * This is useful for calling printk functions from within NMI
- * without worrying about race conditions that can lock up the
- * box.
- */
-DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
-
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -1838,21 +1831,11 @@ DEFINE_PER_CPU(printk_func_t, printk_fun
  */
 asmlinkage __visible int printk(const char *fmt, ...)
 {
-	printk_func_t vprintk_func;
 	va_list args;
 	int r;
 
 	va_start(args, fmt);
-
-	/*
-	 * If a caller overrides the per_cpu printk_func, then it needs
-	 * to disable preemption when calling printk(). Otherwise
-	 * the printk_func should be set to the default. No need to
-	 * disable preemption here.
-	 */
-	vprintk_func = this_cpu_read(printk_func);
 	r = vprintk_func(fmt, args);
-
 	va_end(args);
 
 	return r;
diff -puN lib/nmi_backtrace.c~printk-nmi-generic-solution-for-safe-printk-in-nmi lib/nmi_backtrace.c
--- a/lib/nmi_backtrace.c~printk-nmi-generic-solution-for-safe-printk-in-nmi
+++ a/lib/nmi_backtrace.c
@@ -16,33 +16,14 @@
 #include <linux/delay.h>
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
-#include <linux/seq_buf.h>
 
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-static cpumask_t printtrace_mask;
-
-#define NMI_BUF_SIZE		4096
-
-struct nmi_seq_buf {
-	unsigned char		buffer[NMI_BUF_SIZE];
-	struct seq_buf		seq;
-};
-
-/* Safe printing in NMI context */
-static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
 
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
-static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
-{
-	const char *buf = s->buffer + start;
-
-	printk("%.*s", (end - start) + 1, buf);
-}
-
 /*
  * When raise() is called it will be is passed a pointer to the
  * backtrace_mask. Architectures that call nmi_cpu_backtrace()
@@ -52,8 +33,7 @@ static void print_seq_line(struct nmi_se
 void nmi_trigger_all_cpu_backtrace(bool include_self,
 				   void (*raise)(cpumask_t *mask))
 {
-	struct nmi_seq_buf *s;
-	int i, cpu, this_cpu = get_cpu();
+	int i, this_cpu = get_cpu();
 
 	if (test_and_set_bit(0, &backtrace_flag)) {
 		/*
@@ -68,17 +48,6 @@ void nmi_trigger_all_cpu_backtrace(bool
 	if (!include_self)
 		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
 
-	cpumask_copy(&printtrace_mask, to_cpumask(backtrace_mask));
-
-	/*
-	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
-	 * CPUs will write to.
-	 */
-	for_each_cpu(cpu, to_cpumask(backtrace_mask)) {
-		s = &per_cpu(nmi_print_seq, cpu);
-		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
-	}
-
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
 		pr_info("Sending NMI to %s CPUs:\n",
 			(include_self ? "all" : "other"));
@@ -94,73 +63,25 @@ void nmi_trigger_all_cpu_backtrace(bool
 	}
 
 	/*
-	 * Now that all the NMIs have triggered, we can dump out their
-	 * back traces safely to the console.
+	 * Force flush any remote buffers that might be stuck in IRQ context
+	 * and therefore could not run their irq_work.
 	 */
-	for_each_cpu(cpu, &printtrace_mask) {
-		int len, last_i = 0;
-
-		s = &per_cpu(nmi_print_seq, cpu);
-		len = seq_buf_used(&s->seq);
-		if (!len)
-			continue;
-
-		/* Print line by line. */
-		for (i = 0; i < len; i++) {
-			if (s->buffer[i] == '\n') {
-				print_seq_line(s, last_i, i);
-				last_i = i + 1;
-			}
-		}
-		/* Check if there was a partial line. */
-		if (last_i < len) {
-			print_seq_line(s, last_i, len - 1);
-			pr_cont("\n");
-		}
-	}
+	printk_nmi_flush();
 
-	clear_bit(0, &backtrace_flag);
-	smp_mb__after_atomic();
+	clear_bit_unlock(0, &backtrace_flag);
 	put_cpu();
 }
 
-/*
- * It is not safe to call printk() directly from NMI handlers.
- * It may be fine if the NMI detected a lock up and we have no choice
- * but to do so, but doing a NMI on all other CPUs to get a back trace
- * can be done with a sysrq-l. We don't want that to lock up, which
- * can happen if the NMI interrupts a printk in progress.
- *
- * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
- * the content into a per cpu seq_buf buffer. Then when the NMIs are
- * all done, we can safely dump the contents of the seq_buf to a printk()
- * from a non NMI context.
- */
-static int nmi_vprintk(const char *fmt, va_list args)
-{
-	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
-	unsigned int len = seq_buf_used(&s->seq);
-
-	seq_buf_vprintf(&s->seq, fmt, args);
-	return seq_buf_used(&s->seq) - len;
-}
-
 bool nmi_cpu_backtrace(struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		printk_func_t printk_func_save = this_cpu_read(printk_func);
-
-		/* Replace printk to write into the NMI seq */
-		this_cpu_write(printk_func, nmi_vprintk);
 		pr_warn("NMI backtrace for cpu %d\n", cpu);
 		if (regs)
 			show_regs(regs);
 		else
 			dump_stack();
-		this_cpu_write(printk_func, printk_func_save);
