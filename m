From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-non-optimized-architures-fallback-flags.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:28:33 -0800
Message-ID: <200703012328.l21NSXrB025781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXCAX2l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-non-optimized-architures-fallback-flags
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-non-optimized-architures-fallback-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-non-optimized-architures-fallback-flags
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-non-optimized-architures-fallback-flags

- asm-generic/marker.h is now only used as a fallback defining _MARK as
  MARK_GENERIC.
- flags support

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/marker.h |   38 ++++++++++++---------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff -puN include/asm-generic/marker.h~linux-kernel-markers-non-optimized-architures-fallback-flags include/asm-generic/marker.h
--- a/include/asm-generic/marker.h~linux-kernel-markers-non-optimized-architures-fallback-flags
+++ a/include/asm-generic/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
 /*
  * marker.h
  *
@@ -10,31 +13,18 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#ifdef CONFIG_MARKERS
+#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
 
-#define GEN_MARK(name, format, args...) \
-	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
-		static char __marker_enable_##name = 0; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			MARKER_GENERIC } ; \
-		static const struct __mark_marker __mark_##name \
-			__attribute__((section(".markers"))) = \
-			{ &__mark_c_##name, &__marker_enable_##name } ; \
-		asm volatile ( "" : : "i" (&__mark_##name)); \
-		__mark_check_format(format, ## args); \
-		if (unlikely(__marker_enable_##name)) { \
-			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
-			preempt_enable(); \
-		} \
-	} while (0)
+#define MARK_OPTIMIZED			MARK_GENERIC
+#define _MARK				MARK_GENERIC
+#define MARK(format, args...)		_MARK(_MF_DEFAULT, format, ## args)
 
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
+		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
+#define MARK_OPTIMIZED_ENABLE_TYPE	MARK_GENERIC_ENABLE_TYPE
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE		MARK_GENERIC_ENABLE
 
-#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
-#define GEN_MARK_ENABLE_TYPE char
+#define marker_optimized_set_enable marker_generic_set_enable
 
-#endif
+#endif /* _ASM_GENERIC_MARKER_H */
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
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
