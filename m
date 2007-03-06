From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-cleanup.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:41:26 -0800
Message-ID: <200703060141.l261fR3b008093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933808AbXCFBlm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:41:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: cleanup
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-cleanup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Linux Kernel Markers: cleanup
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

- Keep a positive CONFIG_MARKERS_ENABLE_OPTIMIZATION for Makefile.

- Have CONFIG_MARKERS_DISABLE_OPTIMIZATION depending on EMBEDDED shown
  in the menus.

- CONFIG_MARKERS_ENABLE_OPTIMIZATION depends on
       !CONFIG_MARKERS_DISABLE_OPTIMIZATION and defaults to y (hidden)
         (suggested by Martin Bligh)

- GEN_MARK is now declared in linux/marker.h

- asm-generic/marker.h is now only used as a fallback defining MARK as GEN_MARK

- New MARK_NO_TRAP defined for each architecture.
  asm-generic : defined as GEN_MARK
  asm-i386 : defined as GEN_MARK
  asm-powerpc : defined as MARK (because we don't need to use trap for XMC)

- Remove ugly ifdefs SOME_RANDOM_ARCH in architecture agnostic code

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/marker.c    |    4 -
 arch/powerpc/kernel/Makefile |    1 
 arch/powerpc/kernel/marker.c |   24 +++++++++
 include/asm-generic/marker.h |   39 +++++----------
 include/asm-i386/marker.h    |    7 ++
 include/asm-powerpc/marker.h |    7 ++
 include/linux/marker.h       |   82 +++++++++++++++------------------
 kernel/Kconfig.marker        |   12 +++-
 kernel/module.c              |   23 ---------
 9 files changed, 98 insertions(+), 101 deletions(-)

diff -puN arch/i386/kernel/marker.c~linux-kernel-markers-cleanup arch/i386/kernel/marker.c
--- a/arch/i386/kernel/marker.c~linux-kernel-markers-cleanup
+++ a/arch/i386/kernel/marker.c
@@ -56,7 +56,7 @@ static struct notifier_block mark_notify
 	.priority = 0x7fffffff,	/* we need to be notified first */
 };
 
-int arch_marker_set_ins_enable(void *address, char enable)
+int marker_set_ins_enable(void *address, char enable)
 {
 	char saved_byte;
 	int ret;
@@ -91,4 +91,4 @@ int arch_marker_set_ins_enable(void *add
 	flush_icache_range(address, size);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(arch_marker_set_ins_enable);
+EXPORT_SYMBOL_GPL(marker_set_ins_enable);
diff -puN arch/powerpc/kernel/Makefile~linux-kernel-markers-cleanup arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~linux-kernel-markers-cleanup
+++ a/arch/powerpc/kernel/Makefile
@@ -98,3 +98,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
diff -puN /dev/null arch/powerpc/kernel/marker.c
--- /dev/null
+++ a/arch/powerpc/kernel/marker.c
@@ -0,0 +1,24 @@
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
+int marker_set_ins_enable(void *address, char enable)
+{
+	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_set_ins_enable);
diff -puN include/asm-generic/marker.h~linux-kernel-markers-cleanup include/asm-generic/marker.h
--- a/include/asm-generic/marker.h~linux-kernel-markers-cleanup
+++ a/include/asm-generic/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
 /*
  * marker.h
  *
@@ -10,31 +13,17 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#ifdef CONFIG_MARKERS
-
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
+#include <linux/errno.h>
 
+#define MARK				GEN_MARK
+#define MARK_NO_TRAP			GEN_MARK
+#define MARK_ENABLE_TYPE		GEN_MARK_ENABLE_TYPE
+#define MARK_ENABLE_IMMEDIATE_OFFSET	GEN_MARK_ENABLE_IMMEDIATE_OFFSET
+#define MARK_ENABLE			GEN_MARK_ENABLE
 
-#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
-#define GEN_MARK_ENABLE_TYPE char
+static inline int marker_set_ins_enable(void *address, char enable)
+{
+	return -ENOSYS;
+}
 
-#endif
+#endif /* _ASM_GENERIC_MARKER_H */
diff -puN include/asm-i386/marker.h~linux-kernel-markers-cleanup include/asm-i386/marker.h
--- a/include/asm-i386/marker.h~linux-kernel-markers-cleanup
+++ a/include/asm-i386/marker.h
@@ -36,12 +36,15 @@
 		} \
 	} while (0)
 
+#define MARK_NO_TRAP GEN_MARK
 /* Offset of the immediate value from the start of the movb instruction, in
  * bytes. */
 #define MARK_ENABLE_IMMEDIATE_OFFSET 1
 #define MARK_ENABLE_TYPE char
-#define MARK_POLYMORPHIC
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_ENABLE(a) \
+	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
 
-extern int arch_marker_set_ins_enable(void *address, char enable);
+extern int marker_set_ins_enable(void *address, char enable);
 
 #endif
diff -puN include/asm-powerpc/marker.h~linux-kernel-markers-cleanup include/asm-powerpc/marker.h
--- a/include/asm-powerpc/marker.h~linux-kernel-markers-cleanup
+++ a/include/asm-powerpc/marker.h
@@ -40,10 +40,15 @@
 	} while (0)
 
 
+#define MARK_NO_TRAP MARK
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
 #define MARK_ENABLE_IMMEDIATE_OFFSET 2
 #define MARK_ENABLE_TYPE short
-#define MARK_POLYMORPHIC
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_ENABLE(a) \
+	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_set_ins_enable(void *address, char enable);
 
 #endif
diff -puN include/linux/marker.h~linux-kernel-markers-cleanup include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-cleanup
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
@@ -36,7 +14,7 @@
  * See the file COPYING for more details.
  */
 
-#ifndef __ASSEMBLY__
+#ifdef __KERNEL__
 
 typedef void marker_probe_func(const char *fmt, ...);
 
@@ -54,32 +32,48 @@ struct __mark_marker {
 	void *enable;
 } __attribute__((packed));
 
-#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
-#include <asm/marker.h>
-#endif
-
-#include <asm-generic/marker.h>
+/* Generic marker flavor always available */
+#ifdef CONFIG_MARKERS
+#define GEN_MARK(name, format, args...) \
+	do { \
+		static marker_probe_func *__mark_call_##name = \
+					__mark_empty_function; \
+		static char __marker_enable_##name = 0; \
+		static const struct __mark_marker_c __mark_c_##name \
+			__attribute__((section(".markers.c"))) = \
+			{ #name, &__mark_call_##name, format, \
+			MARKER_GENERIC } ; \
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
+#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
+#define GEN_MARK_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define GEN_MARK_ENABLE(a) \
+	*(GEN_MARK_ENABLE_TYPE*)((char*)a+GEN_MARK_ENABLE_IMMEDIATE_OFFSET)
 
-#ifndef CONFIG_MARKERS
+#else /* !CONFIG_MARKERS */
 #define GEN_MARK(name, format, args...) \
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
@@ -93,5 +87,5 @@ extern int marker_set_probe(const char *
 extern int marker_remove_probe(marker_probe_func *probe);
 extern int marker_list_probe(marker_probe_func *probe);
 
-#endif
+#endif /* __KERNEL__ */
 #endif
diff -puN kernel/Kconfig.marker~linux-kernel-markers-cleanup kernel/Kconfig.marker
--- a/kernel/Kconfig.marker~linux-kernel-markers-cleanup
+++ a/kernel/Kconfig.marker
@@ -7,10 +7,14 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
-config MARKERS_ENABLE_OPTIMIZATION
-	bool "Enable marker optimization"
-	depends on MARKERS
-	default y
+config MARKERS_DISABLE_OPTIMIZATION
+	bool "Disable marker optimization"
+	depends on MARKERS && EMBEDDED
+	default n
 	help
 	  Disable code replacement jump optimisations. Especially useful if your
 	  code is in a read-only rom/flash.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on MARKERS && !MARKERS_DISABLE_OPTIMIZATION
diff -puN kernel/module.c~linux-kernel-markers-cleanup kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-cleanup
+++ a/kernel/module.c
@@ -307,29 +307,6 @@ void __mark_empty_function(const char *f
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
-#ifdef MARK_POLYMORPHIC
-static int marker_set_ins_enable(void *address, char enable)
-{
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
 static int marker_set_gen_enable(void *address, char enable)
 {
 	GEN_MARK_ENABLE(address) = enable;
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
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
