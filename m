From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-powerpc-optimization-update.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:16 -0700
Message-ID: <200705102232.l4AMWGdx032604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708AbXEJWcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-powerpc-optimization update
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-powerpc-optimization-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: linux-kernel-markers-powerpc-optimization update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/marker.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-update include/asm-powerpc/marker.h
--- a/include/asm-powerpc/marker.h~linux-kernel-markers-powerpc-optimization-update
+++ a/include/asm-powerpc/marker.h
@@ -20,7 +20,7 @@
 #define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
 
 /* Optimized version of the markers */
-#define MARK_OPTIMIZED(flags, name, format, args...) \
+#define trace_mark_optimized(flags, name, format, args...) \
 	do { \
 		static const char __mstrtab_name_##name[] \
 		__attribute__((section("__markers_strings"))) \
@@ -28,9 +28,13 @@
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
@@ -55,9 +59,9 @@
 #define _trace_mark(flags, format, args...) \
 do { \
 	if ((flags) & MF_OPTIMIZED) \
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
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
