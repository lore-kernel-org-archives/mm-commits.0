From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:01:21 -0700
Message-ID: <200704110501.l3B51LAR028894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186AbXDKFBd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     markers: document the i386 marker header
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-i386-optimization-markers-document-the-i386-m=
arker-header.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: markers: document the i386 marker header
=46rom: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Document the i386 marker header, change it to use the __marker, __marke=
r_data
and __marker_strings sections.  Change the flag usage to use MF_* direc=
tly
(which is now a bitmask).  In marker.c, for the i386 optimized marker
enabling, check the a simple test is the value will be changed.  If not=
,
simply return : we would set it to the same value anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/marker.c |    8 +++++--
 include/asm-i386/marker.h |   40 +++++++++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimizat=
ion-markers-document-the-i386-marker-header arch/i386/kernel/marker.c
--- a/arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimization-=
markers-document-the-i386-marker-header
+++ a/arch/i386/kernel/marker.c
@@ -4,7 +4,9 @@
  *
  * Permits marker activation by XMC with correct serialization.
  *
- * Reentrant for NMI and trap handler instrumentation.=C2=A0:-)
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to =
a
+ * location that has preemption enabled because it involves no tempora=
ry or
+ * reused data structure.
  *
  * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  */
@@ -63,8 +65,10 @@ int marker_optimized_set_enable(void *ad
 	int ret;
 	char *dest =3D address;
=20
+	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute *=
/
+		return 0;
+
 	mutex_lock(&mark_mutex);
-	BUG_ON(!(enable ^ dest[1]));	/* Must be a state change 0<->1 */
 	target_eip =3D (long)address + BREAKPOINT_INS_LEN;
 	/* register_die_notifier has memory barriers */
 	register_die_notifier(&mark_notify);
diff -puN include/asm-i386/marker.h~linux-kernel-markers-i386-optimizat=
ion-markers-document-the-i386-marker-header include/asm-i386/marker.h
--- a/include/asm-i386/marker.h~linux-kernel-markers-i386-optimization-=
markers-document-the-i386-marker-header
+++ a/include/asm-i386/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_I386_MARKER_H
+#define _ASM_I386_MARKER_H
+
 /*
  * marker.h
  *
@@ -12,42 +15,54 @@
=20
 #ifdef CONFIG_MARKERS
=20
-#define _MF_DEFAULT (_MF_OPTIMIZED | _MF_LOCKDEP | _MF_PRINTK)
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
=20
+/* Optimized version of the markers */
 #define MARK_OPTIMIZED(flags, name, format, args...) \
 	do { \
-		static marker_probe_func *__mark_call_##name =3D \
-					__mark_empty_function; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) =3D \
-			{ #name, &__mark_call_##name, format, \
-			(flags) | _MF_OPTIMIZED } ; \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		=3D #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		=3D format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) =3D \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		char condition; \
-		asm volatile(	".section .markers, \"a\", @progbits;\n\t" \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
 					".long %1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 2\n\t" \
 					"0:\n\t" \
 					"movb $0,%0;\n\t" \
 				: "=3Dr" (condition) \
-				: "m" (__mark_c_##name)); \
+				: "m" (__mark_data_##name)); \
 		__mark_check_format(format, ## args); \
 		if (unlikely(condition)) { \
 			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
 			preempt_enable(); \
 		} \
 	} while (0)
=20
+/* Marker macro selecting the generic or optimized version of marker, =
depending
+ * on the flags specified. */
 #define _MARK(flags, format, args...) \
 do { \
-	if (((flags) & _MF_LOCKDEP) && ((flags) & _MF_OPTIMIZED)) \
+	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
 		MARK_OPTIMIZED(flags, format, ## args); \
 	else \
 		MARK_GENERIC(flags, format, ## args); \
 } while (0)
=20
-#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
+/* Marker with default behavior */
+#define MARK(format, args...) _MARK(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for mark=
er
+ * activation. */
=20
 /* Offset of the immediate value from the start of the movb instructio=
n, in
  * bytes. */
@@ -61,3 +76,4 @@ do { \
 extern int marker_optimized_set_enable(void *address, char enable);
=20
 #endif
+#endif //_ASM_I386_MARKER_H
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.=
ca are

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
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dep=
endency.patch
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
linux-kernel-markers-architecture-independant-code-markers-document-the=
-linux-markerh-header.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker=
-header.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
markers-changes-to-the-powerpc-marker-header.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patc=
h
markers-update-documentation.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
markers-add-documentation-to-the-modulec-marker-functions.patch
