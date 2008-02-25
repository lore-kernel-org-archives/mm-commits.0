From: akpm@linux-foundation.org
Subject: + kprobes-indicate-kretprobe-support-in-kconfig.patch added to -mm tree
Date: Sun, 24 Feb 2008 23:20:39 -0800
Message-ID: <200802250720.m1P7Kd38019674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbYBYHVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 02:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, mathieu.desnoyers@polymtl.ca


The patch titled
     Kprobes: indicate kretprobe support in Kconfig
has been added to the -mm tree.  Its filename is
     kprobes-indicate-kretprobe-support-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kprobes: indicate kretprobe support in Kconfig
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Add CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file for relevant
architectures with kprobes support.  This facilitates easy handling of
in-kernel modules (like samples/kprobes/kretprobe_example.c) that depend on
kretprobes being present in the kernel.

Thanks to Sam Ravnborg for helping make the patch more lean.

Per Mathieu's suggestion, added CONFIG_KRETPROBES and fixed up dependencies.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                  |    7 +++++++
 arch/arm/Kconfig              |    1 +
 arch/ia64/Kconfig             |    1 +
 arch/powerpc/Kconfig          |    1 +
 arch/s390/Kconfig             |    1 +
 arch/sparc64/Kconfig          |    1 +
 arch/x86/Kconfig              |    1 +
 include/asm-arm/kprobes.h     |    1 -
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-sparc64/kprobes.h |    2 --
 include/asm-x86/kprobes.h     |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    9 +++------
 15 files changed, 19 insertions(+), 16 deletions(-)

diff -puN arch/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/Kconfig
--- a/arch/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/Kconfig
@@ -27,5 +27,12 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KRETPROBES
+	def_bool y
+	depends on KPROBES && HAVE_KRETPROBES
+
 config HAVE_KPROBES
 	def_bool n
+
+config HAVE_KRETPROBES
+	def_bool n
diff -puN arch/arm/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/arm/Kconfig
@@ -12,6 +12,7 @@ config ARM
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
+	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/ia64/Kconfig
@@ -18,6 +18,7 @@ config IA64
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/powerpc/Kconfig
@@ -90,6 +90,7 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config EARLY_PRINTK
 	bool
diff -puN arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/s390/Kconfig
@@ -61,6 +61,7 @@ config S390
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 source "init/Kconfig"
 
diff -puN arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/sparc64/Kconfig
@@ -10,6 +10,7 @@ config SPARC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config SPARC64
 	bool
diff -puN arch/x86/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/arch/x86/Kconfig
@@ -22,6 +22,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	select HAVE_KVM
 
 
diff -puN include/asm-arm/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-arm/kprobes.h
--- a/include/asm-arm/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-arm/kprobes.h
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE			2
 #define MAX_STACK_SIZE			64	/* 32 would probably be OK */
diff -puN include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
diff -puN include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
diff -puN include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
diff -puN include/asm-sparc64/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-sparc64/kprobes.h
--- a/include/asm-sparc64/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-sparc64/kprobes.h
@@ -14,8 +14,6 @@ typedef u32 kprobe_opcode_t;
 
 #define arch_remove_kprobe(p)	do {} while (0)
 
-#define ARCH_SUPPORTS_KRETPROBES
-
 #define flush_insn_slot(p)		\
 do { 	flushi(&(p)->ainsn.insn[0]);	\
 	flushi(&(p)->ainsn.insn[1]);	\
diff -puN include/asm-x86/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/asm-x86/kprobes.h
--- a/include/asm-x86/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/asm-x86/kprobes.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
 	   - (unsigned long)(ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
diff -puN include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
diff -puN kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-kconfig kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-kconfig
+++ a/kernel/kprobes.c
@@ -678,8 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
-
+#ifdef CONFIG_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -769,8 +768,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
-
+#else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
@@ -781,8 +779,7 @@ static int __kprobes pre_handler_kretpro
 {
 	return 0;
 }
-
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-indicate-kretprobe-support-in-kconfig.patch
kprobes-move-kprobe-examples-to-samples.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
