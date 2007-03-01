From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-architecture-independant-code-flags.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:14:34 -0800
Message-ID: <200703012314.l21NEYa2025531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161235AbXCAXOn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-architecture-independant-code-flags
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-architecture-independant-code-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-architecture-independant-code-flags
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-architecture-independant-code-flags

- GEN_MARK changed for MARK_GENERIC is now declared in linux/marker.h
- Adds the MF_* flags than can be used by the _MARK macro
  MF_OPTIMIZED (Use optimized markers)
  MF_LOCKDEP (Can call lockdep)
  MF_PRINTK (vprintk can be called in the probe)
- The MARK marcro calls _MARK with a default set of flags (_MF_DEFAULT)
- Verification of flag compatibility at probe connexion

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |  107 +++++++++++++++++++++------------------
 kernel/module.c        |   77 +++++++++++-----------------
 2 files changed, 91 insertions(+), 93 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-architecture-independant-code-flags include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-architecture-independant-code-flags
+++ a/include/linux/marker.h
@@ -6,29 +6,7 @@
  *
  * Code markup for dynamic and static tracing.
  *
- * Example :
- *
- * MARK(subsystem_event, "%d %s %p[struct task_struct]",
- *   someint, somestring, current);
- * Where :
- * - Subsystem is the name of your subsystem.
- * - event is the name of the event to mark.
- * - "%d %s %p[struct task_struct]" is the formatted string for printk.
- * - someint is an integer.
- * - somestring is a char pointer.
- * - current is a pointer to a struct task_struct.
- *
- * - Dynamically overridable function call based on marker mechanism
- *   from Frank Ch. Eigler <fche@redhat.com>.
- * - Thanks to Jeremy Fitzhardinge <jeremy@goop.org> for his constructive
- *   criticism about gcc optimization related issues.
- *
- * The marker mechanism supports multiple instances of the same marker.
- * Markers can be put in inline functions, inlined static functions and
- * unrolled loops.
- *
- * Note : It is safe to put markers within preempt-safe code : preempt_enable()
- * will not call the scheduler due to the tests in preempt_schedule().
+ * See Documentation/marker.txt.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -36,17 +14,15 @@
  * See the file COPYING for more details.
  */
 
-#ifndef __ASSEMBLY__
+#ifdef __KERNEL__
 
 typedef void marker_probe_func(const char *fmt, ...);
 
-enum marker_type { MARKER_GENERIC, MARKER_OPTIMIZED };
-
 struct __mark_marker_c {
 	const char *name;
 	marker_probe_func **call;
 	const char *format;
-	enum marker_type type;
+	int flags;
 } __attribute__((packed));
 
 struct __mark_marker {
@@ -54,32 +30,64 @@ struct __mark_marker {
 	void *enable;
 } __attribute__((packed));
 
-#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
-#include <asm/marker.h>
-#endif
+/* Generic marker flavor always available */
+#ifdef CONFIG_MARKERS
 
-#include <asm-generic/marker.h>
+#define MF_OPTIMIZED 1	/* Use optimized markers */
+#define MF_LOCKDEP 2	/* Can call lockdep */
+#define MF_PRINTK 3	/* vprintk can be called in the probe */
+
+#define _MF_OPTIMIZED (1 << MF_OPTIMIZED)
+#define _MF_LOCKDEP (1 << MF_LOCKDEP)
+#define _MF_PRINTK (1 << MF_PRINTK)
+
+#define MARK_GENERIC(flags, name, format, args...) \
+	do { \
+		static marker_probe_func *__mark_call_##name = \
+					__mark_empty_function; \
+		static char __marker_enable_##name = 0; \
+		static const struct __mark_marker_c __mark_c_##name \
+			__attribute__((section(".markers.c"))) = \
+			{ #name, &__mark_call_##name, format, \
+			(flags) | ~_MF_OPTIMIZED } ; \
+		static const struct __mark_marker __mark_##name \
+			__attribute__((section(".markers"))) = \
+			{ &__mark_c_##name, &__marker_enable_##name } ; \
+		asm volatile ( "" : : "i" (&__mark_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(__marker_enable_##name)) { \
+			preempt_disable(); \
+			(*__mark_call_##name)(format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
 
-#define MARK_NOARGS " "
-#define MARK_MAX_FORMAT_LEN	1024
+#define MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET 0
+#define MARK_GENERIC_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_GENERIC_ENABLE(a) \
+	*(MARK_GENERIC_ENABLE_TYPE*) \
+		((char*)a+MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET)
+
+static inline int marker_generic_set_enable(void *address, char enable)
+{
+	MARK_GENERIC_ENABLE(address) = enable;
+	return 0;
+}
 
-#ifndef CONFIG_MARKERS
-#define GEN_MARK(name, format, args...) \
+#else /* !CONFIG_MARKERS */
+#define MARK_GENERIC(flags, name, format, args...) \
 		__mark_check_format(format, ## args)
-#endif
+#endif /* CONFIG_MARKERS */
 
-#ifndef MARK
-#define MARK GEN_MARK
-#define MARK_ENABLE_TYPE GEN_MARK_ENABLE_TYPE
-#define MARK_ENABLE_IMMEDIATE_OFFSET GEN_MARK_ENABLE_IMMEDIATE_OFFSET
+#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
+#include <asm/marker.h>			/* optimized marker flavor */
+#else
+#include <asm-generic/marker.h>		/* fallback on generic markers */
 #endif
 
-/* Dereference enable as lvalue from a pointer to its instruction */
-#define MARK_ENABLE(a) \
-	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
-
-#define GEN_MARK_ENABLE(a) \
-	*(GEN_MARK_ENABLE_TYPE*)((char*)a+GEN_MARK_ENABLE_IMMEDIATE_OFFSET)
+#define MARK_MAX_FORMAT_LEN	1024
+#define MARK_NOARGS " "
 
 static inline __attribute__ ((format (printf, 1, 2)))
 void __mark_check_format(const char *fmt, ...)
@@ -87,11 +95,14 @@ void __mark_check_format(const char *fmt
 
 extern marker_probe_func __mark_empty_function;
 
-extern int marker_set_probe(const char *name, const char *format,
+extern int _marker_set_probe(int flags, const char *name, const char *format,
 				marker_probe_func *probe);
 
+#define marker_set_probe(name, format, probe) \
+	_marker_set_probe(_MF_DEFAULT, name, format, probe)
+
 extern int marker_remove_probe(marker_probe_func *probe);
 extern int marker_list_probe(marker_probe_func *probe);
 
-#endif
+#endif /* __KERNEL__ */
 #endif
diff -puN kernel/module.c~linux-kernel-markers-architecture-independant-code-flags kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independant-code-flags
+++ a/kernel/module.c
@@ -307,46 +307,17 @@ void __mark_empty_function(const char *f
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
-#ifdef MARK_POLYMORPHIC
-static int marker_set_ins_enable(void *address, char enable)
+static int marker_set_enable(void *address, char enable, int flags)
 {
-#ifdef CONFIG_X86_32
-	return arch_marker_set_ins_enable(address, enable);
-#else
-	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
-	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
-
-	memcpy(newi, address, size);
-	MARK_ENABLE(&newi[0]) = enable;
-	memcpy(address, newi, size);
-	flush_icache_range((unsigned long)address, size);
-	return 0;
-#endif //CONFIG_X86_32
-}
-#else
-static int marker_set_ins_enable(void *address, char enable)
-{
-	return -EPERM;
-}
-#endif //MARK_POLYMORPHIC
-
-static int marker_set_gen_enable(void *address, char enable)
-{
-	GEN_MARK_ENABLE(address) = enable;
-	return 0;
-}
-
-static int marker_set_enable(void *address, char enable, enum marker_type type)
-{
-	if (type == MARKER_OPTIMIZED)
-		return marker_set_ins_enable(address, enable);
+	if (flags & _MF_OPTIMIZED)
+		return marker_optimized_set_enable(address, enable);
 	else
-		return marker_set_gen_enable(address, enable);
+		return marker_generic_set_enable(address, enable);
 }
 
 /* enable and function address are set out of order, and it's ok :
  * the state is always coherent. */
-static int marker_set_probe_range(const char *name,
+static int _marker_set_probe_range(int flags, const char *name,
 	const char *format,
 	marker_probe_func *probe,
 	const struct __mark_marker *begin,
@@ -367,6 +338,22 @@ static int marker_set_probe_range(const 
 					iter->cmark->format);
 				continue;
 			}
+			if (flags & _MF_LOCKDEP
+				&& !(iter->cmark->flags & _MF_LOCKDEP)) {
+					printk(KERN_NOTICE
+					"Incompatible lockdep flags for "
+					"probe %s\n",
+					name);
+					continue;
+			}
+			if (flags & _MF_PRINTK
+				&& !(iter->cmark->flags & _MF_PRINTK)) {
+					printk(KERN_NOTICE
+					"Incompatible printk flags for "
+					"probe %s\n",
+					name);
+					continue;
+			}
 			if (probe == __mark_empty_function) {
 				if (*iter->cmark->call
 					!= __mark_empty_function) {
@@ -374,7 +361,7 @@ static int marker_set_probe_range(const 
 						__mark_empty_function;
 				}
 				marker_set_enable(iter->enable, 0,
-					iter->cmark->type);
+					iter->cmark->flags);
 			} else {
 				if (*iter->cmark->call
 					!= __mark_empty_function) {
@@ -393,7 +380,7 @@ static int marker_set_probe_range(const 
 				}
 				/* Can have many enables for one function */
 				marker_set_enable(iter->enable, 1,
-					iter->cmark->type);
+					iter->cmark->flags);
 			}
 			found++;
 		}
@@ -411,7 +398,7 @@ static int marker_remove_probe_range(mar
 	for (iter = begin; iter < end; iter++) {
 		if (*iter->cmark->call == probe) {
 			marker_set_enable(iter->enable, 0,
-				iter->cmark->type);
+				iter->cmark->flags);
 			*iter->cmark->call = __mark_empty_function;
 			found++;
 		}
@@ -430,12 +417,12 @@ static int marker_list_probe_range(marke
 		if (probe)
 			if (probe != *iter->cmark->call) continue;
 		printk("name %s \n", iter->cmark->name);
-		if (iter->cmark->type == MARKER_OPTIMIZED)
+		if (iter->cmark->flags & _MF_OPTIMIZED)
 			printk("  enable %u optimized ",
-				MARK_ENABLE(iter->enable));
+				MARK_OPTIMIZED_ENABLE(iter->enable));
 		else
 			printk("  enable %u generic ",
-				GEN_MARK_ENABLE(iter->enable));
+				MARK_GENERIC_ENABLE(iter->enable));
 		printk("  func 0x%p format \"%s\"\n",
 			*iter->cmark->call, iter->cmark->format);
 		found++;
@@ -443,7 +430,7 @@ static int marker_list_probe_range(marke
 	return found;
 }
 /* markers use the modlist_lock to to synchronise */
-int marker_set_probe(const char *name, const char *format,
+int _marker_set_probe(int flags, const char *name, const char *format,
 				marker_probe_func *probe)
 {
 	struct module *mod;
@@ -451,18 +438,18 @@ int marker_set_probe(const char *name, c
 
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
-	found += marker_set_probe_range(name, format, probe,
+	found += _marker_set_probe_range(flags, name, format, probe,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
-			found += marker_set_probe_range(name, format, probe,
-				mod->markers, mod->markers+mod->num_markers);
+			found += _marker_set_probe_range(flags, name, format,
+			probe, mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL_GPL(marker_set_probe);
+EXPORT_SYMBOL_GPL(_marker_set_probe);
 
 int marker_remove_probe(marker_probe_func *probe)
 {
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
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
