From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-i386-optimization-update.patch added to -mm tree
Date: Wed, 09 May 2007 20:44:35 -0700
Message-ID: <200705100344.l4A3iZux011249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbXEJDom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-i386-optimization update
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-i386-optimization-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-i386-optimization update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/marker.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN include/asm-i386/marker.h~linux-kernel-markers-i386-optimization-update include/asm-i386/marker.h
--- a/include/asm-i386/marker.h~linux-kernel-markers-i386-optimization-update
+++ a/include/asm-i386/marker.h
@@ -18,7 +18,7 @@
 #define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
 
 /* Optimized version of the markers */
-#define MARK_OPTIMIZED(flags, name, format, args...) \
+#define trace_mark_optimized(flags, name, format, args...) \
 	do { \
 		static const char __mstrtab_name_##name[] \
 		__attribute__((section("__markers_strings"))) \
@@ -26,9 +26,13 @@
 		static const char __mstrtab_format_##name[] \
 		__attribute__((section("__markers_strings"))) \
 		= format; \
+		static const char __mstrtab_args_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #args; \
 		static struct __mark_marker_data __mark_data_##name \
 		__attribute__((section("__markers_data"))) = \
 		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		__mstrtab_args_##name, \
 		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		char condition; \
 		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
@@ -40,7 +44,8 @@
 				: "=r" (condition) \
 				: "m" (__mark_data_##name)); \
 		__mark_check_format(format, ## args); \
-		if (unlikely(condition)) { \
+		if (likely(!condition)) { \
+		} else { \
 			preempt_disable(); \
 			(*__mark_data_##name.call)(&__mark_data_##name, \
 						format, ## args); \
@@ -53,9 +58,9 @@
 #define _trace_mark(flags, format, args...) \
 do { \
 	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
-		MARK_OPTIMIZED(flags, format, ## args); \
+		trace_mark_optimized(flags, format, ## args); \
 	else \
-		MARK_GENERIC(flags, format, ## args); \
+		trace_mark_generic(flags, format, ## args); \
 } while (0)
 
 /* Marker with default behavior */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
