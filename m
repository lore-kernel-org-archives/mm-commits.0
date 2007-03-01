From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-i386-optimization-flags.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:15:41 -0800
Message-ID: <200703012315.l21NFfGJ025584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161248AbXCAXPt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-i386-optimization-flags
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-i386-optimization-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-i386-optimization-flags
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-i386-optimization-flags

i386 marker optimization flags support.
Also fixes the @progbits assembly section declaration.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/marker.c |    4 ++--
 include/asm-i386/marker.h |   30 +++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimization-flags arch/i386/kernel/marker.c
--- a/arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimization-flags
+++ a/arch/i386/kernel/marker.c
@@ -56,7 +56,7 @@ static struct notifier_block mark_notify
 	.priority = 0x7fffffff,	/* we need to be notified first */
 };
 
-int arch_marker_set_ins_enable(void *address, char enable)
+int marker_optimized_set_enable(void *address, char enable)
 {
 	char saved_byte;
 	int ret;
@@ -91,4 +91,4 @@ int arch_marker_set_ins_enable(void *add
 	flush_icache_range(address, size);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(arch_marker_set_ins_enable);
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
diff -puN include/asm-i386/marker.h~linux-kernel-markers-i386-optimization-flags include/asm-i386/marker.h
--- a/include/asm-i386/marker.h~linux-kernel-markers-i386-optimization-flags
+++ a/include/asm-i386/marker.h
@@ -11,16 +11,19 @@
 
 
 #ifdef CONFIG_MARKERS
-#define MARK(name, format, args...) \
+
+#define _MF_DEFAULT (_MF_OPTIMIZED | _MF_LOCKDEP | _MF_PRINTK)
+
+#define MARK_OPTIMIZED(flags, name, format, args...) \
 	do { \
 		static marker_probe_func *__mark_call_##name = \
 					__mark_empty_function; \
 		static const struct __mark_marker_c __mark_c_##name \
 			__attribute__((section(".markers.c"))) = \
 			{ #name, &__mark_call_##name, format, \
-			MARKER_OPTIMIZED } ; \
+			(flags) | _MF_OPTIMIZED } ; \
 		char condition; \
-		asm volatile(	".section .markers, \"a\";\n\t" \
+		asm volatile(	".section .markers, \"a\", @progbits;\n\t" \
 					".long %1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 2\n\t" \
@@ -36,12 +39,25 @@
 		} \
 	} while (0)
 
+#define _MARK(flags, format, args...) \
+do { \
+	if (((flags) & _MF_LOCKDEP) && ((flags) & _MF_OPTIMIZED)) \
+		MARK_OPTIMIZED(flags, format, ## args); \
+	else \
+		MARK_GENERIC(flags, format, ## args); \
+} while (0)
+
+#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
+
 /* Offset of the immediate value from the start of the movb instruction, in
  * bytes. */
-#define MARK_ENABLE_IMMEDIATE_OFFSET 1
-#define MARK_ENABLE_TYPE char
-#define MARK_POLYMORPHIC
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_OPTIMIZED_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
 
-extern int arch_marker_set_ins_enable(void *address, char enable);
+extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-powerpc-extension-fix-build-fix.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
linux-kernel-markers-kconfig-menus-fix-5.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-architecture-independant-code-flags.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
