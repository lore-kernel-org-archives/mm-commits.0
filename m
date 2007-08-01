From: akpm@linux-foundation.org
Subject: + optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch added to -mm tree
Date: Wed, 01 Aug 2007 14:00:37 -0700
Message-ID: <200708012100.l71L0bJm016939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXHAVBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 17:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, ak@suse.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, linux-arch@vger.kernel.org, prasanna@in.ibm.com


The patch titled
     x86: optimize page faults like all other achitectures and kill notifier cruft
has been added to the -mm tree.  Its filename is
     optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: optimize page faults like all other achitectures and kill notifier cruft
From: Christoph Hellwig <hch@lst.de>

x86(-64) are the last architectures still using the page fault notifier
cruft for the kprobes page fault hook.  This patch converts them to the
proper direct calls, and removes the now unused pagefault notifier bits
aswell as the cruft in kprobes.c that was related to this mess.

I know Andi didn't really like this, but all other architecture maintainers
agreed the direct calls are much better and besides the obvious cruft
removal a common way of dealing with kprobes across architectures is
important aswell.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <ak@suse.de>
Cc: <linux-arch@vger.kernel.org>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/kprobes.c    |    3 --
 arch/i386/mm/fault.c          |   43 +++++++++++++------------------
 arch/x86_64/kernel/kprobes.c  |    1 
 arch/x86_64/mm/fault.c        |   44 +++++++++++++-------------------
 include/asm-avr32/kdebug.h    |   16 -----------
 include/asm-avr32/kprobes.h   |    2 -
 include/asm-i386/kdebug.h     |    6 ----
 include/asm-i386/kprobes.h    |    2 -
 include/asm-ia64/kdebug.h     |   15 ----------
 include/asm-ia64/kprobes.h    |    1 
 include/asm-powerpc/kdebug.h  |   19 -------------
 include/asm-powerpc/kprobes.h |    1 
 include/asm-s390/kdebug.h     |   15 ----------
 include/asm-s390/kprobes.h    |    1 
 include/asm-sh/kdebug.h       |    2 -
 include/asm-sparc64/kdebug.h  |   20 --------------
 include/asm-sparc64/kprobes.h |    1 
 include/asm-x86_64/kdebug.h   |    6 ----
 include/asm-x86_64/kprobes.h  |    1 
 kernel/kprobes.c              |   39 ++--------------------------
 20 files changed, 43 insertions(+), 195 deletions(-)

diff -puN arch/i386/kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/arch/i386/kernel/kprobes.c
@@ -579,7 +579,7 @@ out:
 	return 1;
 }
 
-static int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -661,7 +661,6 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
-	case DIE_PAGE_FAULT:
 		/* kprobe_running() needs smp_processor_id() */
 		preempt_disable();
 		if (kprobe_running() &&
diff -puN arch/i386/mm/fault.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/arch/i386/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -32,33 +33,27 @@
 
 extern void die(const char *,struct pt_regs *,long);
 
-static ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
-
-int register_page_fault_notifier(struct notifier_block *nb)
+#ifdef CONFIG_KPROBES
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	vmalloc_sync_all();
-	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_page_fault_notifier);
+	int ret = 0;
 
-int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
+	/* kprobe_running() needs smp_processor_id() */
+	if (!user_mode_vm(regs)) {
+		preempt_disable();
+		if (kprobe_running() && kprobe_fault_handler(regs, 14))
+			ret = 1;
+		preempt_enable();
+	}
 
-static inline int notify_page_fault(struct pt_regs *regs, long err)
+	return ret;
+}
+#else
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	struct die_args args = {
-		.regs = regs,
-		.str = "page fault",
-		.err = err,
-		.trapnr = 14,
-		.signr = SIGSEGV
-	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain,
-	                                  DIE_PAGE_FAULT, &args);
+	return 0;
 }
+#endif
 
 /*
  * Return EIP plus the CS segment base.  The segment limit is also
@@ -328,7 +323,7 @@ fastcall void __kprobes do_page_fault(st
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+		if (notify_page_fault(regs))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -337,7 +332,7 @@ fastcall void __kprobes do_page_fault(st
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+	if (notify_page_fault(regs))
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff -puN arch/x86_64/kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/arch/x86_64/kernel/kprobes.c
@@ -652,7 +652,6 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
-	case DIE_PAGE_FAULT:
 		/* kprobe_running() needs smp_processor_id() */
 		preempt_disable();
 		if (kprobe_running() &&
diff -puN arch/x86_64/mm/fault.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/arch/x86_64/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/pgalloc.h>
@@ -40,34 +41,27 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-static ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
-
-/* Hook to register for page fault notifications */
-int register_page_fault_notifier(struct notifier_block *nb)
+#ifdef CONFIG_KPROBES
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	vmalloc_sync_all();
-	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_page_fault_notifier);
+	int ret = 0;
 
-int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
+	/* kprobe_running() needs smp_processor_id() */
+	if (!user_mode(regs)) {
+		preempt_disable();
+		if (kprobe_running() && kprobe_fault_handler(regs, 14))
+			ret = 1;
+		preempt_enable();
+	}
 
-static inline int notify_page_fault(struct pt_regs *regs, long err)
+	return ret;
+}
+#else
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	struct die_args args = {
-		.regs = regs,
-		.str = "page fault",
-		.err = err,
-		.trapnr = 14,
-		.signr = SIGSEGV
-	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain,
-	                                  DIE_PAGE_FAULT, &args);
+	return 0;
 }
+#endif
 
 /* Sometimes the CPU reports invalid exceptions on prefetch.
    Check that here and ignore.
@@ -355,7 +349,7 @@ asmlinkage void __kprobes do_page_fault(
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+		if (notify_page_fault(regs))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -364,7 +358,7 @@ asmlinkage void __kprobes do_page_fault(
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+	if (notify_page_fault(regs))
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
diff -puN include/asm-avr32/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-avr32/kdebug.h
--- a/include/asm-avr32/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-avr32/kdebug.h
@@ -1,26 +1,10 @@
 #ifndef __ASM_AVR32_KDEBUG_H
 #define __ASM_AVR32_KDEBUG_H
 
-#include <linux/notifier.h>
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_BREAKPOINT,
 	DIE_SSTEP,
 };
 
-/*
- * These are only here because kprobes.c wants them to implement a
- * blatant layering violation.  Will hopefully go away soon once all
- * architectures are updated.
- */
-static inline int register_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
 #endif /* __ASM_AVR32_KDEBUG_H */
diff -puN include/asm-avr32/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-avr32/kprobes.h
--- a/include/asm-avr32/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-avr32/kprobes.h
@@ -17,8 +17,6 @@ typedef u16	kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xd673	/* breakpoint */
 #define MAX_INSN_SIZE		2
 
-#define ARCH_INACTIVE_KPROBE_COUNT 1
-
 #define arch_remove_kprobe(p)	do { } while (0)
 
 /* Architecture specific copy of original instruction */
diff -puN include/asm-i386/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-i386/kdebug.h
--- a/include/asm-i386/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-i386/kdebug.h
@@ -5,14 +5,9 @@
  * Aug-05 2004 Ported by Prasanna S Panchamukhi <prasanna@in.ibm.com>
  * from x86_64 architecture.
  */
-#include <linux/notifier.h>
 
 struct pt_regs;
 
-extern int register_page_fault_notifier(struct notifier_block *);
-extern int unregister_page_fault_notifier(struct notifier_block *);
-
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_OOPS = 1,
@@ -27,7 +22,6 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
-	DIE_PAGE_FAULT,
 };
 
 #endif
diff -puN include/asm-i386/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-i386/kprobes.h
--- a/include/asm-i386/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-i386/kprobes.h
@@ -43,7 +43,6 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
-#define  ARCH_INACTIVE_KPROBE_COUNT 0
 #define flush_insn_slot(p)	do { } while (0)
 
 void arch_remove_kprobe(struct kprobe *p);
@@ -89,4 +88,5 @@ static inline void restore_interrupts(st
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 #endif				/* _ASM_KPROBES_H */
diff -puN include/asm-ia64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-ia64/kdebug.h
--- a/include/asm-ia64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-ia64/kdebug.h
@@ -26,21 +26,6 @@
  * 2005-Oct	Keith Owens <kaos@sgi.com>.  Expand notify_die to cover more
  *		events.
  */
-#include <linux/notifier.h>
-
-/*
- * These are only here because kprobes.c wants them to implement a
- * blatant layering violation.  Will hopefully go away soon once all
- * architectures are updated.
- */
-static inline int register_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
 
 enum die_val {
 	DIE_BREAK = 1,
diff -puN include/asm-ia64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-ia64/kprobes.h
@@ -83,7 +83,6 @@ struct kprobe_ctlblk {
 };
 
 #define ARCH_SUPPORTS_KRETPROBES
-#define  ARCH_INACTIVE_KPROBE_COUNT 1
 
 #define SLOT0_OPCODE_SHIFT	(37)
 #define SLOT1_p1_OPCODE_SHIFT	(37 - (64-46))
diff -puN include/asm-powerpc/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-powerpc/kdebug.h
--- a/include/asm-powerpc/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-powerpc/kdebug.h
@@ -2,25 +2,6 @@
 #define _ASM_POWERPC_KDEBUG_H
 #ifdef __KERNEL__
 
-/* nearly identical to x86_64/i386 code */
-
-#include <linux/notifier.h>
-
-/*
- * These are only here because kprobes.c wants them to implement a
- * blatant layering violation.  Will hopefully go away soon once all
- * architectures are updated.
- */
-static inline int register_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-extern struct atomic_notifier_head powerpc_die_chain;
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_OOPS = 1,
diff -puN include/asm-powerpc/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-powerpc/kprobes.h
@@ -81,7 +81,6 @@ typedef unsigned int kprobe_opcode_t;
 #endif
 
 #define ARCH_SUPPORTS_KRETPROBES
-#define  ARCH_INACTIVE_KPROBE_COUNT 1
 #define flush_insn_slot(p)	do { } while (0)
 
 void kretprobe_trampoline(void);
diff -puN include/asm-s390/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-s390/kdebug.h
--- a/include/asm-s390/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-s390/kdebug.h
@@ -4,24 +4,9 @@
 /*
  * Feb 2006 Ported to s390 <grundym@us.ibm.com>
  */
-#include <linux/notifier.h>
 
 struct pt_regs;
 
-/*
- * These are only here because kprobes.c wants them to implement a
- * blatant layering violation. Will hopefully go away soon once all
- * architectures are updated.
- */
-static inline int register_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
 enum die_val {
 	DIE_OOPS = 1,
 	DIE_BPT,
diff -puN include/asm-s390/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-s390/kprobes.h
@@ -47,7 +47,6 @@ typedef u16 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
-#define ARCH_INACTIVE_KPROBE_COUNT 0
 
 #define KPROBE_SWAP_INST	0x10
 
diff -puN include/asm-sh/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-sh/kdebug.h
--- a/include/asm-sh/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-sh/kdebug.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SH_KDEBUG_H
 #define __ASM_SH_KDEBUG_H
 
-#include <linux/notifier.h>
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_TRAP,
diff -puN include/asm-sparc64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-sparc64/kdebug.h
--- a/include/asm-sparc64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-sparc64/kdebug.h
@@ -1,26 +1,6 @@
 #ifndef _SPARC64_KDEBUG_H
 #define _SPARC64_KDEBUG_H
 
-/* Nearly identical to x86_64/i386 code. */
-
-#include <linux/notifier.h>
-
-struct pt_regs;
-
-/*
- * These are only here because kprobes.c wants them to implement a
- * blatant layering violation.  Will hopefully go away soon once all
- * architectures are updated.
- */
-static inline int register_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
 extern void bad_trap(struct pt_regs *, long);
 
 /* Grossly misnamed. */
diff -puN include/asm-sparc64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-sparc64/kprobes.h
--- a/include/asm-sparc64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-sparc64/kprobes.h
@@ -11,7 +11,6 @@ typedef u32 kprobe_opcode_t;
 #define MAX_INSN_SIZE 2
 
 #define arch_remove_kprobe(p)	do {} while (0)
-#define  ARCH_INACTIVE_KPROBE_COUNT 0
 
 #define flush_insn_slot(p)		\
 do { 	flushi(&(p)->ainsn.insn[0]);	\
diff -puN include/asm-x86_64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-x86_64/kdebug.h
--- a/include/asm-x86_64/kdebug.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-x86_64/kdebug.h
@@ -1,13 +1,8 @@
 #ifndef _X86_64_KDEBUG_H
 #define _X86_64_KDEBUG_H 1
 
-#include <linux/notifier.h>
-
 struct pt_regs;
 
-extern int register_page_fault_notifier(struct notifier_block *);
-extern int unregister_page_fault_notifier(struct notifier_block *);
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_OOPS = 1,
@@ -22,7 +17,6 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
-	DIE_PAGE_FAULT,
 };
 
 extern void printk_address(unsigned long address);
diff -puN include/asm-x86_64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft include/asm-x86_64/kprobes.h
--- a/include/asm-x86_64/kprobes.h~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/include/asm-x86_64/kprobes.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
-#define  ARCH_INACTIVE_KPROBE_COUNT 1
 
 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
diff -puN kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft kernel/kprobes.c
--- a/kernel/kprobes.c~optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft
+++ a/kernel/kprobes.c
@@ -64,7 +64,6 @@
 
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
-static atomic_t kprobe_count;
 
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobe_enabled;
@@ -73,11 +72,6 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 
-static struct notifier_block kprobe_page_fault_nb = {
-	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7fffffff /* we need to notified first */
-};
-
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -556,8 +550,6 @@ static int __kprobes __register_kprobe(s
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
 		ret = register_aggr_kprobe(old_p, p);
-		if (!ret)
-			atomic_inc(&kprobe_count);
 		goto out;
 	}
 
@@ -569,13 +561,9 @@ static int __kprobes __register_kprobe(s
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (kprobe_enabled) {
-		if (atomic_add_return(1, &kprobe_count) == \
-				(ARCH_INACTIVE_KPROBE_COUNT + 1))
-			register_page_fault_notifier(&kprobe_page_fault_nb);
-
+	if (kprobe_enabled)
 		arch_arm_kprobe(p);
-	}
+
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -658,16 +646,6 @@ valid_p:
 		}
 		mutex_unlock(&kprobe_mutex);
 	}
-
-	/* Call unregister_page_fault_notifier()
-	 * if no probes are active
-	 */
-	mutex_lock(&kprobe_mutex);
-	if (atomic_add_return(-1, &kprobe_count) == \
-				ARCH_INACTIVE_KPROBE_COUNT)
-		unregister_page_fault_notifier(&kprobe_page_fault_nb);
-	mutex_unlock(&kprobe_mutex);
-	return;
 }
 
 static struct notifier_block kprobe_exceptions_nb = {
@@ -815,7 +793,6 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
-	atomic_set(&kprobe_count, 0);
 
 	/* By default, kprobes are enabled */
 	kprobe_enabled = true;
@@ -921,13 +898,6 @@ static void __kprobes enable_all_kprobes
 	if (kprobe_enabled)
 		goto already_enabled;
 
-	/*
-	 * Re-register the page fault notifier only if there are any
-	 * active probes at the time of enabling kprobes globally
-	 */
-	if (atomic_read(&kprobe_count) > ARCH_INACTIVE_KPROBE_COUNT)
-		register_page_fault_notifier(&kprobe_page_fault_nb);
-
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
@@ -968,10 +938,7 @@ static void __kprobes disable_all_kprobe
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();
-
-	mutex_lock(&kprobe_mutex);
-	/* Unconditionally unregister the page_fault notifier */
-	unregister_page_fault_notifier(&kprobe_page_fault_nb);
+	return;
 
 already_disabled:
 	mutex_unlock(&kprobe_mutex);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-scsi-misc.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
git-unionfs-fixup.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
