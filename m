From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:02:14 -0700
Message-ID: <200704110502.l3B52Evv028903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59172 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161195AbXDKFCa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     markers: changes to the powerpc marker header 
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: changes to the powerpc marker header 
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new MF_* bitmask, use the __markers, __markers_data and
__markers_strings sections, add documentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/marker.h |   40 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff -puN include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header include/asm-powerpc/marker.h
--- a/include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header
+++ a/include/asm-powerpc/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_POWERPC_MARKER_H
+#define _ASM_POWERPC_MARKER_H
+
 /*
  * marker.h
  *
@@ -14,42 +17,54 @@
 
 #ifdef CONFIG_MARKERS
 
-#define _MF_DEFAULT (_MF_OPTIMIZED | _MF_LOCKDEP | _MF_PRINTK)
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
 
+/* Optimized version of the markers */
 #define MARK_OPTIMIZED(flags, name, format, args...) \
 	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			(flags) | _MF_OPTIMIZED } ; \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		char condition; \
-		asm volatile(	".section .markers, \"a\", @progbits;\n\t" \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
 					PPC_LONG "%1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 4\n\t" \
 					"0:\n\t" \
 					"li %0,0;\n\t" \
 				: "=r" (condition) \
-				: "i" (&__mark_c_##name)); \
+				: "i" (&__mark_data_##name)); \
 		__mark_check_format(format, ## args); \
 		if (unlikely(condition)) { \
 			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
 			preempt_enable(); \
 		} \
 	} while (0)
 
+/* Marker macro selecting the generic or optimized version of marker, depending
+ * on the flags specified. */
 #define _MARK(flags, format, args...) \
 do { \
-	if ((flags) & _MF_OPTIMIZED) \
+	if ((flags) & MF_OPTIMIZED) \
 		MARK_OPTIMIZED(flags, format, ## args); \
 	else \
 		MARK_GENERIC(flags, format, ## args); \
 } while (0)
 
-#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
+/* Marker with default behavior */
+#define MARK(format, args...) _MARK(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
 
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
@@ -63,3 +78,4 @@ do { \
 extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
+#endif //_ASM_POWERPC_MARKER_H
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

avr32-remove-unneeded-cast-in-atomich.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
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
linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
markers-update-documentation.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
markers-add-documentation-to-the-modulec-marker-functions.patch
