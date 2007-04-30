From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:26:38 -0700
Message-ID: <200704302026.l3UKQcas014169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946775AbXD3U0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: document the linux/marker.h header
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch

This patch was dropped because it was folded into linux-kernel-markers-architecture-independant-code.patch

------------------------------------------------------
Subject: markers: document the linux/marker.h header
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix a bitwise flag manipulation mistake in the MARK_GENERIC macro.

Use the __marker (ro), new __marker_strings (ro) and __marker_data (rw)
sections.  It depends on the linker modification which defines this last
section.

It allows the use of a probe "private" data : upon probe connexion, it can
provide a pointer to its own data structure which will be available at the
probe call site as the pdata field of the mdata structure.

With the new __marker_data section, much less data has to be defined in the
kernel .data segment : only the enable flag, in non-optimized markers, is left
in .data because it is used very often.

The marker flags now only define MF_* which are bitmasks.  There is no way to
use the bitmask shift value, so it is less error prone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |   65 +++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header
+++ a/include/linux/marker.h
@@ -16,48 +16,59 @@
 
 #ifdef __KERNEL__
 
-typedef void marker_probe_func(const char *fmt, ...);
+struct __mark_marker_data;
 
-struct __mark_marker_c {
+typedef void marker_probe_func(const struct __mark_marker_data *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker_data {
 	const char *name;
-	marker_probe_func **call;
 	const char *format;
 	int flags;
+	marker_probe_func *call;
+	void *pdata;
 } __attribute__((packed));
 
 struct __mark_marker {
-	const struct __mark_marker_c *cmark;
+	struct __mark_marker_data *mdata;
 	void *enable;
 } __attribute__((packed));
 
-/* Generic marker flavor always available */
 #ifdef CONFIG_MARKERS
 
-#define MF_OPTIMIZED 1	/* Use optimized markers */
-#define MF_LOCKDEP 2	/* Can call lockdep */
-#define MF_PRINTK 3	/* vprintk can be called in the probe */
-
-#define _MF_OPTIMIZED (1 << MF_OPTIMIZED)
-#define _MF_LOCKDEP (1 << MF_LOCKDEP)
-#define _MF_PRINTK (1 << MF_PRINTK)
+/* Marker flags : selects the mechanism used to connect the probes to the
+ * markers and what can be executed within the probes. This is primarily
+ * used at reentrancy-unfriendly sites. */
+#define MF_OPTIMIZED	(1 << 0)	/* Use optimized markers */
+#define MF_LOCKDEP	(1 << 1)	/* Can call lockdep */
+#define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
+#define _MF_NR		3		/* Number of marker flags */
 
+#define DECLARE_MARKER_DATA(flags, name, format) \
+
+/* Generic marker flavor always available */
 #define MARK_GENERIC(flags, name, format, args...) \
 	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) & ~MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		static char __marker_enable_##name = 0; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			(flags) | ~_MF_OPTIMIZED } ; \
 		static const struct __mark_marker __mark_##name \
-			__attribute__((section(".markers"))) = \
-			{ &__mark_c_##name, &__marker_enable_##name } ; \
+			__attribute__((section("__markers"))) = \
+			{ &__mark_data_##name, &__marker_enable_##name } ; \
 		asm volatile ( "" : : "i" (&__mark_##name)); \
 		__mark_check_format(format, ## args); \
 		if (unlikely(__marker_enable_##name)) { \
 			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
 			preempt_enable(); \
 		} \
 	} while (0)
@@ -87,21 +98,23 @@ static inline int marker_generic_set_ena
 #endif
 
 #define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
 #define MARK_NOARGS " "
 
-static inline __attribute__ ((format (printf, 1, 2)))
+/* To be used for string format validity checking with sparse */
+static inline
 void __mark_check_format(const char *fmt, ...)
 { }
 
 extern marker_probe_func __mark_empty_function;
 
 extern int _marker_set_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe);
+				marker_probe_func *probe, void *pdata);
 
-#define marker_set_probe(name, format, probe) \
-	_marker_set_probe(_MF_DEFAULT, name, format, probe)
+#define marker_set_probe(name, format, probe, pdata) \
+	_marker_set_probe(MF_DEFAULT, name, format, probe, pdata)
 
-extern int marker_remove_probe(marker_probe_func *probe);
+extern int marker_remove_probe(const char *name);
 extern int marker_list_probe(marker_probe_func *probe);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
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
linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-markers-update-documentation.patch
linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
