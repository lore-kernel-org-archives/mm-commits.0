From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-powerpc-optimization-flags.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:39:53 -0800
Message-ID: <200703060139.l261drll008033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45814 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXCFBkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:40:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-powerpc-optimization-flags
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-powerpc-optimization-flags.patch

This patch was dropped because it was folded into linux-kernel-markers-powerpc-optimization.patch

------------------------------------------------------
Subject: linux-kernel-markers-powerpc-optimization-flags
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-powerpc-optimization-flags

Add flag support to powerpc optimization
Fix the .section .markers, \"a\", @progbits;\n\t inline assembly :
adding the @progbits seems to remove a warning from the linker (forces
the section to DATA, which is the same a what the MARK_GENERIC version
does).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    1 +
 arch/powerpc/kernel/marker.c |   25 +++++++++++++++++++++++++
 include/asm-powerpc/marker.h |   28 ++++++++++++++++++++++------
 3 files changed, 48 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kernel/Makefile~linux-kernel-markers-powerpc-optimization-flags arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~linux-kernel-markers-powerpc-optimization-flags
+++ a/arch/powerpc/kernel/Makefile
@@ -98,3 +98,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
diff -puN /dev/null arch/powerpc/kernel/marker.c
--- /dev/null
+++ a/arch/powerpc/kernel/marker.c
@@ -0,0 +1,25 @@
+/* marker.c
+ *
+ * Powerpc optimized marker enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char newi[MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(MARK_OPTIMIZED_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
diff -puN include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-flags include/asm-powerpc/marker.h
--- a/include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-flags
+++ a/include/asm-powerpc/marker.h
@@ -14,16 +14,18 @@
 
 #ifdef CONFIG_MARKERS
 
-#define MARK(name, format, args...) \
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
 					PPC_LONG "%1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 4\n\t" \
@@ -39,11 +41,25 @@
 		} \
 	} while (0)
 
+#define _MARK(flags, format, args...) \
+do { \
+	if ((flags) & _MF_OPTIMIZED) \
+		MARK_OPTIMIZED(flags, format, ## args); \
+	else \
+		MARK_GENERIC(flags, format, ## args); \
+} while (0)
+
+#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
 
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
-#define MARK_ENABLE_IMMEDIATE_OFFSET 2
-#define MARK_ENABLE_TYPE short
-#define MARK_POLYMORPHIC
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define MARK_OPTIMIZED_ENABLE_TYPE short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
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
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
