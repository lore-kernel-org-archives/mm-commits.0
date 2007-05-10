From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-architecture-independant-code-update.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:08 -0700
Message-ID: <200705102232.l4AMW8Zr032592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231AbXEJWcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-architecture-independant-code update
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-architecture-independant-code-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: linux-kernel-markers-architecture-independant-code update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-architecture-independant-code-update include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-architecture-independant-code-update
+++ a/include/linux/marker.h
@@ -24,6 +24,7 @@ typedef void marker_probe_func(const str
 struct __mark_marker_data {
 	const char *name;
 	const char *format;
+	const char *args;
 	int flags;
 	marker_probe_func *call;
 	void *pdata;
@@ -44,10 +45,8 @@ struct __mark_marker {
 #define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
 #define _MF_NR		3		/* Number of marker flags */
 
-#define DECLARE_MARKER_DATA(flags, name, format) \
-
 /* Generic marker flavor always available */
-#define MARK_GENERIC(flags, name, format, args...) \
+#define trace_mark_generic(flags, name, format, args...) \
 	do { \
 		static const char __mstrtab_name_##name[] \
 		__attribute__((section("__markers_strings"))) \
@@ -55,9 +54,13 @@ struct __mark_marker {
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
 		(flags) & ~MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		static char __marker_enable_##name = 0; \
 		static const struct __mark_marker __mark_##name \
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-architecture-independant-code-update.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization.patch
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
