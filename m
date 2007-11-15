From: akpm@linux-foundation.org
Subject: + kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:28:40 -0800
Message-ID: <200711152228.lAFMSeLE019164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932318AbXKOW2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:28:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com


The patch titled
     Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
has been added to the -mm tree.  Its filename is
     kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch adds CONFIG_ARCH_SUPPORTS_KRETPROBES to the arch/<arch>/Kconfig
file for relevant architectures with kprobes support.  This facilitates easy
handling of in-kernel modules (like samples/kprobes/kretprobe_example.c) that
depend on kretprobes being present in the kernel.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig            |    5 +++++
 arch/ia64/Kconfig             |    5 +++++
 arch/powerpc/Kconfig          |    5 +++++
 arch/s390/Kconfig             |    5 +++++
 arch/sparc64/Kconfig          |    5 +++++
 arch/x86/Kconfig              |    5 +++++
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-x86/kprobes_32.h  |    1 -
 include/asm-x86/kprobes_64.h  |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    6 +++---
 13 files changed, 36 insertions(+), 11 deletions(-)

diff -puN arch/avr32/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/avr32/Kconfig
@@ -70,6 +70,11 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default n
+
 source "init/Kconfig"
 
 menu "System Type and features"
diff -puN arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/ia64/Kconfig
@@ -105,6 +105,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff -puN arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/powerpc/Kconfig
@@ -169,6 +169,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
diff -puN arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/s390/Kconfig
@@ -58,6 +58,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Base setup"
diff -puN arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/sparc64/Kconfig
@@ -82,6 +82,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default n
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff -puN arch/x86/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/x86/Kconfig
@@ -178,6 +178,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
diff -puN include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
diff -puN include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
diff -puN include/asm-x86/kprobes_32.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-x86/kprobes_32.h
--- a/include/asm-x86/kprobes_32.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-x86/kprobes_32.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
diff -puN include/asm-x86/kprobes_64.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-x86/kprobes_64.h
--- a/include/asm-x86/kprobes_64.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-x86/kprobes_64.h
@@ -41,7 +41,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 extern const int kretprobe_blacklist_size;
 
 void kretprobe_trampoline(void);
diff -puN include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_ARCH_SUPPORTS_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
diff -puN kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/kernel/kprobes.c
@@ -678,7 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_ARCH_SUPPORTS_KRETPROBES
 
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
@@ -762,7 +762,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
@@ -775,7 +775,7 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }
 
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
_

Patches currently in -mm which might be from ananth@in.ibm.com are

move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch
kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch
