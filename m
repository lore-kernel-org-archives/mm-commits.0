From: akpm@linux-foundation.org
Subject: +
 arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch added to -mm tree
Date: Wed, 09 Mar 2016 12:23:29 -0800
Message-ID: <56e08641.Gfc6erdCIstsFSvP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934137AbcCIUXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 15:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch, ftrace: for KASAN put hard/soft IRQ entries into separate sections
has been added to the -mm tree.  Its filename is
     arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: arch, ftrace: for KASAN put hard/soft IRQ entries into separate sections

KASAN needs to know whether the allocation happens in an IRQ handler. 
This lets us strip everything below the IRQ entry point to reduce the
number of unique stack traces needed to be stored.

Move the definition of __irq_entry to <linux/interrupt.h> so that the
users don't need to pull in <linux/ftrace.h>.  Also introduce the
__softirq_entry macro which is similar to __irq_entry, but puts the
corresponding functions to the .softirqentry.text section.

Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/exception.h     |    2 +-
 arch/arm/kernel/vmlinux.lds.S        |    1 +
 arch/arm64/include/asm/exception.h   |    2 +-
 arch/arm64/kernel/vmlinux.lds.S      |    1 +
 arch/blackfin/kernel/vmlinux.lds.S   |    1 +
 arch/c6x/kernel/vmlinux.lds.S        |    1 +
 arch/metag/kernel/vmlinux.lds.S      |    1 +
 arch/microblaze/kernel/vmlinux.lds.S |    1 +
 arch/mips/kernel/vmlinux.lds.S       |    1 +
 arch/nios2/kernel/vmlinux.lds.S      |    1 +
 arch/openrisc/kernel/vmlinux.lds.S   |    1 +
 arch/parisc/kernel/vmlinux.lds.S     |    1 +
 arch/powerpc/kernel/vmlinux.lds.S    |    1 +
 arch/s390/kernel/vmlinux.lds.S       |    1 +
 arch/sh/kernel/vmlinux.lds.S         |    1 +
 arch/sparc/kernel/vmlinux.lds.S      |    1 +
 arch/tile/kernel/vmlinux.lds.S       |    1 +
 arch/x86/kernel/vmlinux.lds.S        |    1 +
 include/asm-generic/vmlinux.lds.h    |   12 +++++++++++-
 include/linux/ftrace.h               |   11 -----------
 include/linux/interrupt.h            |   20 ++++++++++++++++++++
 kernel/softirq.c                     |    2 +-
 kernel/trace/trace_functions_graph.c |    1 +
 23 files changed, 51 insertions(+), 15 deletions(-)

diff -puN arch/arm/include/asm/exception.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/arm/include/asm/exception.h
--- a/arch/arm/include/asm/exception.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/arm/include/asm/exception.h
@@ -7,7 +7,7 @@
 #ifndef __ASM_ARM_EXCEPTION_H
 #define __ASM_ARM_EXCEPTION_H
 
-#include <linux/ftrace.h>
+#include <linux/interrupt.h>
 
 #define __exception	__attribute__((section(".exception.text")))
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff -puN arch/arm/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -105,6 +105,7 @@ SECTIONS
 			*(.exception.text)
 			__exception_text_end = .;
 			IRQENTRY_TEXT
+			SOFTIRQENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
diff -puN arch/arm64/include/asm/exception.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/arm64/include/asm/exception.h
--- a/arch/arm64/include/asm/exception.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/arm64/include/asm/exception.h
@@ -18,7 +18,7 @@
 #ifndef __ASM_EXCEPTION_H
 #define __ASM_EXCEPTION_H
 
-#include <linux/ftrace.h>
+#include <linux/interrupt.h>
 
 #define __exception	__attribute__((section(".exception.text")))
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff -puN arch/arm64/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/arm64/kernel/vmlinux.lds.S
--- a/arch/arm64/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/arm64/kernel/vmlinux.lds.S
@@ -102,6 +102,7 @@ SECTIONS
 			*(.exception.text)
 			__exception_text_end = .;
 			IRQENTRY_TEXT
+			SOFTIRQENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
diff -puN arch/blackfin/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/blackfin/kernel/vmlinux.lds.S
--- a/arch/blackfin/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/blackfin/kernel/vmlinux.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 #endif
 		LOCK_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		KPROBES_TEXT
 #ifdef CONFIG_ROMKERNEL
 		__sinittext = .;
diff -puN arch/c6x/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/c6x/kernel/vmlinux.lds.S
--- a/arch/c6x/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/c6x/kernel/vmlinux.lds.S
@@ -72,6 +72,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		KPROBES_TEXT
 		*(.fixup)
 		*(.gnu.warning)
diff -puN arch/metag/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/metag/kernel/vmlinux.lds.S
--- a/arch/metag/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/metag/kernel/vmlinux.lds.S
@@ -24,6 +24,7 @@ SECTIONS
 	LOCK_TEXT
 	KPROBES_TEXT
 	IRQENTRY_TEXT
+	SOFTIRQENTRY_TEXT
 	*(.text.*)
 	*(.gnu.warning)
 	}
diff -puN arch/microblaze/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/microblaze/kernel/vmlinux.lds.S
--- a/arch/microblaze/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/microblaze/kernel/vmlinux.lds.S
@@ -36,6 +36,7 @@ SECTIONS {
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		. = ALIGN (4) ;
 		_etext = . ;
 	}
diff -puN arch/mips/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -58,6 +58,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.text.*)
 		*(.fixup)
 		*(.gnu.warning)
diff -puN arch/nios2/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/nios2/kernel/vmlinux.lds.S
--- a/arch/nios2/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/nios2/kernel/vmlinux.lds.S
@@ -39,6 +39,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		KPROBES_TEXT
 	} =0
 	_etext = .;
diff -puN arch/openrisc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/openrisc/kernel/vmlinux.lds.S
--- a/arch/openrisc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/openrisc/kernel/vmlinux.lds.S
@@ -50,6 +50,7 @@ SECTIONS
 	  LOCK_TEXT
 	  KPROBES_TEXT
 	  IRQENTRY_TEXT
+	  SOFTIRQENTRY_TEXT
 	  *(.fixup)
 	  *(.text.__*)
 	  _etext = .;
diff -puN arch/parisc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -72,6 +72,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.text.do_softirq)
 		*(.text.sys_exit)
 		*(.text.do_sigaltstack)
diff -puN arch/powerpc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -55,6 +55,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 
 #ifdef CONFIG_PPC32
 		*(.got1)
diff -puN arch/s390/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -28,6 +28,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 	} :text = 0x0700
diff -puN arch/sh/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -39,6 +39,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 		_etext = .;		/* End of text section */
diff -puN arch/sparc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -48,6 +48,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.gnu.warning)
 	} = 0
 	_etext = .;
diff -puN arch/tile/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/tile/kernel/vmlinux.lds.S
--- a/arch/tile/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/tile/kernel/vmlinux.lds.S
@@ -45,6 +45,7 @@ SECTIONS
     LOCK_TEXT
     KPROBES_TEXT
     IRQENTRY_TEXT
+    SOFTIRQENTRY_TEXT
     __fix_text_end = .;   /* tile-cpack won't rearrange before this */
     ALIGN_FUNCTION();
     *(.hottext*)
diff -puN arch/x86/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections arch/x86/kernel/vmlinux.lds.S
--- a/arch/x86/kernel/vmlinux.lds.S~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -102,6 +102,7 @@ SECTIONS
 		KPROBES_TEXT
 		ENTRY_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 		/* End of text section */
diff -puN include/asm-generic/vmlinux.lds.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/include/asm-generic/vmlinux.lds.h
@@ -456,7 +456,7 @@
 		*(.entry.text)						\
 		VMLINUX_SYMBOL(__entry_text_end) = .;
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#if defined(CONFIG_FUNCTION_GRAPH_TRACER) || defined(CONFIG_KASAN)
 #define IRQENTRY_TEXT							\
 		ALIGN_FUNCTION();					\
 		VMLINUX_SYMBOL(__irqentry_text_start) = .;		\
@@ -466,6 +466,16 @@
 #define IRQENTRY_TEXT
 #endif
 
+#if defined(CONFIG_FUNCTION_GRAPH_TRACER) || defined(CONFIG_KASAN)
+#define SOFTIRQENTRY_TEXT						\
+		ALIGN_FUNCTION();					\
+		VMLINUX_SYMBOL(__softirqentry_text_start) = .;		\
+		*(.softirqentry.text)					\
+		VMLINUX_SYMBOL(__softirqentry_text_end) = .;
+#else
+#define SOFTIRQENTRY_TEXT
+#endif
+
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(.head.text)
 
diff -puN include/linux/ftrace.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections include/linux/ftrace.h
--- a/include/linux/ftrace.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/include/linux/ftrace.h
@@ -799,16 +799,6 @@ ftrace_push_return_trace(unsigned long r
  */
 #define __notrace_funcgraph		notrace
 
-/*
- * We want to which function is an entrypoint of a hardirq.
- * That will help us to put a signal on output.
- */
-#define __irq_entry		 __attribute__((__section__(".irqentry.text")))
-
-/* Limits of hardirq entrypoints */
-extern char __irqentry_text_start[];
-extern char __irqentry_text_end[];
-
 #define FTRACE_NOTRACE_DEPTH 65536
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
@@ -845,7 +835,6 @@ static inline void unpause_graph_tracing
 #else /* !CONFIG_FUNCTION_GRAPH_TRACER */
 
 #define __notrace_funcgraph
-#define __irq_entry
 #define INIT_FTRACE_GRAPH
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
diff -puN include/linux/interrupt.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections include/linux/interrupt.h
--- a/include/linux/interrupt.h~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/include/linux/interrupt.h
@@ -673,4 +673,24 @@ extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
 
+#if defined(CONFIG_FUNCTION_GRAPH_TRACER) || defined(CONFIG_KASAN)
+/*
+ * We want to know which function is an entrypoint of a hardirq or a softirq.
+ */
+#define __irq_entry		 __attribute__((__section__(".irqentry.text")))
+#define __softirq_entry  \
+	__attribute__((__section__(".softirqentry.text")))
+
+/* Limits of hardirq entrypoints */
+extern char __irqentry_text_start[];
+extern char __irqentry_text_end[];
+/* Limits of softirq entrypoints */
+extern char __softirqentry_text_start[];
+extern char __softirqentry_text_end[];
+
+#else
+#define __irq_entry
+#define __softirq_entry
+#endif
+
 #endif
diff -puN kernel/softirq.c~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections kernel/softirq.c
--- a/kernel/softirq.c~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/kernel/softirq.c
@@ -227,7 +227,7 @@ static inline bool lockdep_softirq_start
 static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
-asmlinkage __visible void __do_softirq(void)
+asmlinkage __visible void __softirq_entry __do_softirq(void)
 {
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	unsigned long old_flags = current->flags;
diff -puN kernel/trace/trace_functions_graph.c~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections kernel/trace/trace_functions_graph.c
--- a/kernel/trace/trace_functions_graph.c~arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections
+++ a/kernel/trace/trace_functions_graph.c
@@ -8,6 +8,7 @@
  */
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 
_

Patches currently in -mm which might be from glider@google.com are

kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch
mm-kasan-slab-support.patch
mm-kasan-added-gfp-flags-to-kasan-api.patch
arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
mm-kasan-initial-memory-quarantine-implementation.patch

