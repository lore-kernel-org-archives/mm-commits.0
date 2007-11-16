From: akpm@linux-foundation.org
Subject: - kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch removed from -mm tree
Date: Thu, 15 Nov 2007 18:16:43 -0800
Message-ID: <200711160216.lAG2GhOg027469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757347AbXKPCRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 21:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
has been removed from the -mm tree.  Its filename was
     kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch

This patch was dropped because Mathieu destroyed it

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
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-x86/kprobes_32.h  |    1 -
 include/asm-x86/kprobes_64.h  |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    6 +++---
 12 files changed, 31 insertions(+), 11 deletions(-)

diff -puN arch/avr32/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/avr32/Kconfig
@@ -71,6 +71,11 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_HAS_KRETPROBES
+	bool
+	depends on ARCH_HAS_KPROBES
+	default n
+
 source "init/Kconfig"
 
 menu "System Type and features"
diff -puN arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/ia64/Kconfig
@@ -104,6 +104,11 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool n
 
+config ARCH_HAS_KRETPROBES
+	bool
+	depends on ARCH_HAS_KPROBES
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff -puN arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/powerpc/Kconfig
@@ -165,6 +165,11 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config ARCH_HAS_KRETPROBES
+	bool
+	depends on ARCH_HAS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
diff -puN arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/s390/Kconfig
@@ -57,6 +57,11 @@ config S390
 	select ARCH_HAS_OPROFILE
 	select ARCH_HAS_KPROBES
 
+config ARCH_HAS_KRETPROBES
+	bool
+	depends on ARCH_HAS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Base setup"
diff -puN arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/arch/sparc64/Kconfig
@@ -81,6 +81,11 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_HAS_KRETPROBES
+	bool
+	depends on ARCH_HAS_KPROBES
+	default n
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff -puN arch/x86/Kconfig~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig arch/x86/Kconfig
diff -puN include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_HAS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
diff -puN include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_HAS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
diff -puN include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_HAS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
diff -puN include/asm-x86/kprobes_32.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-x86/kprobes_32.h
--- a/include/asm-x86/kprobes_32.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-x86/kprobes_32.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_HAS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
diff -puN include/asm-x86/kprobes_64.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/asm-x86/kprobes_64.h
--- a/include/asm-x86/kprobes_64.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/asm-x86/kprobes_64.h
@@ -41,7 +41,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_HAS_KRETPROBES
 extern const int kretprobe_blacklist_size;
 
 void kretprobe_trampoline(void);
diff -puN include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_HAS_KRETPROBES
+#ifdef CONFIG_ARCH_HAS_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_HAS_KRETPROBES */
+#else /* CONFIG_ARCH_HAS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_HAS_KRETPROBES */
+#endif /* CONFIG_ARCH_HAS_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
diff -puN kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-indicate-kretprobe-support-in-arch-arch-kconfig
+++ a/kernel/kprobes.c
@@ -678,7 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_HAS_KRETPROBES
+#ifdef CONFIG_ARCH_HAS_KRETPROBES
 
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
@@ -762,7 +762,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_HAS_KRETPROBES */
+#else /* CONFIG_ARCH_HAS_KRETPROBES */
 
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
@@ -775,7 +775,7 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }
 
-#endif /* ARCH_HAS_KRETPROBES */
+#endif /* CONFIG_ARCH_HAS_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
_

Patches currently in -mm which might be from ananth@in.ibm.com are

move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
kprobes-indicate-kretprobe-support-in-arch-arch-kconfig.patch
kprobes-build-kretprobe-samples-only-if-arch-supports-kretprobes.patch
