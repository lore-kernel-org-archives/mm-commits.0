From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-architecture-independant-code.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:22:06 -0800
Message-ID: <200702150722.l1F7M6Te022847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964961AbXBOHWP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers: architecture independent code
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-architecture-independant-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: architecture independent code
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Linux Kernel Markers, architecture independent code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   13 +
 include/linux/marker.h            |   97 +++++++++++
 include/linux/module.h            |    4 
 kernel/module.c                   |  244 ++++++++++++++++++++++++++++
 4 files changed, 358 insertions(+)

diff -puN include/asm-generic/vmlinux.lds.h~linux-kernel-markers-architecture-independant-code include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~linux-kernel-markers-architecture-independant-code
+++ a/include/asm-generic/vmlinux.lds.h
@@ -121,6 +121,19 @@
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
 	}								\
+	/* Kernel markers : pointers */					\
+	.markers : AT(ADDR(.markers) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start___markers) = .;			\
+		*(.markers)						\
+		VMLINUX_SYMBOL(__stop___markers) = .;			\
+	}								\
+	.markers.c : AT(ADDR(.markers.c) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___markers_c) = .;		\
+		*(.markers.c)						\
+		VMLINUX_SYMBOL(__stop___markers_c) = .;			\
+	}								\
+	__end_rodata = .;						\
+	. = ALIGN(4096);						\
 									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
diff -puN /dev/null include/linux/marker.h
--- /dev/null
+++ a/include/linux/marker.h
@@ -0,0 +1,97 @@
+#ifndef _LINUX_MARKER_H
+#define _LINUX_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing.
+ *
+ * Example :
+ *
+ * MARK(subsystem_event, "%d %s %p[struct task_struct]",
+ *   someint, somestring, current);
+ * Where :
+ * - Subsystem is the name of your subsystem.
+ * - event is the name of the event to mark.
+ * - "%d %s %p[struct task_struct]" is the formatted string for printk.
+ * - someint is an integer.
+ * - somestring is a char pointer.
+ * - current is a pointer to a struct task_struct.
+ *
+ * - Dynamically overridable function call based on marker mechanism
+ *   from Frank Ch. Eigler <fche@redhat.com>.
+ * - Thanks to Jeremy Fitzhardinge <jeremy@goop.org> for his constructive
+ *   criticism about gcc optimization related issues.
+ *
+ * The marker mechanism supports multiple instances of the same marker.
+ * Markers can be put in inline functions, inlined static functions and
+ * unrolled loops.
+ *
+ * Note : It is safe to put markers within preempt-safe code : preempt_enable()
+ * will not call the scheduler due to the tests in preempt_schedule().
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef __ASSEMBLY__
+
+typedef void marker_probe_func(const char *fmt, ...);
+
+enum marker_type { MARKER_GENERIC, MARKER_OPTIMIZED };
+
+struct __mark_marker_c {
+	const char *name;
+	marker_probe_func **call;
+	const char *format;
+	enum marker_type type;
+} __attribute__((packed));
+
+struct __mark_marker {
+	const struct __mark_marker_c *cmark;
+	void *enable;
+} __attribute__((packed));
+
+#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
+#include <asm/marker.h>
+#endif
+
+#include <asm-generic/marker.h>
+
+#define MARK_NOARGS " "
+#define MARK_MAX_FORMAT_LEN	1024
+
+#ifndef CONFIG_MARKERS
+#define GEN_MARK(name, format, args...) \
+		__mark_check_format(format, ## args)
+#endif
+
+#ifndef MARK
+#define MARK GEN_MARK
+#define MARK_ENABLE_TYPE GEN_MARK_ENABLE_TYPE
+#define MARK_ENABLE_IMMEDIATE_OFFSET GEN_MARK_ENABLE_IMMEDIATE_OFFSET
+#endif
+
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_ENABLE(a) \
+	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
+
+#define GEN_MARK_ENABLE(a) \
+	*(GEN_MARK_ENABLE_TYPE*)((char*)a+GEN_MARK_ENABLE_IMMEDIATE_OFFSET)
+
+static inline __attribute__ ((format (printf, 1, 2)))
+void __mark_check_format(const char *fmt, ...)
+{ }
+
+extern marker_probe_func __mark_empty_function;
+
+extern int marker_set_probe(const char *name, const char *format,
+				marker_probe_func *probe);
+
+extern int marker_remove_probe(marker_probe_func *probe);
+extern int marker_list_probe(marker_probe_func *probe);
+
+#endif
+#endif
diff -puN include/linux/module.h~linux-kernel-markers-architecture-independant-code include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers-architecture-independant-code
+++ a/include/linux/module.h
@@ -355,6 +355,9 @@ struct module
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+
+	const struct __mark_marker *markers;
+	unsigned int num_markers;
 };
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
@@ -464,6 +467,7 @@ int register_module_notifier(struct noti
 int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
+extern void list_modules(void);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
diff -puN kernel/module.c~linux-kernel-markers-architecture-independant-code kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independant-code
+++ a/kernel/module.c
@@ -138,6 +138,8 @@ extern const unsigned long __start___kcr
 extern const unsigned long __start___kcrctab_gpl_future[];
 extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
+extern const struct __mark_marker __start___markers[];
+extern const struct __mark_marker __stop___markers[];
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -298,6 +300,214 @@ static struct module *find_module(const 
 	return NULL;
 }
 
+#ifdef CONFIG_MARKERS
+void __mark_empty_function(const char *fmt, ...)
+{
+}
+EXPORT_SYMBOL(__mark_empty_function);
+
+#ifdef MARK_POLYMORPHIC
+static int marker_set_ins_enable(void *address, char enable)
+{
+#ifdef CONFIG_X86_32
+	return arch_marker_set_ins_enable(address, enable);
+#else
+	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+#endif //CONFIG_X86_32
+}
+#else
+static int marker_set_ins_enable(void *address, char enable)
+{
+	return -EPERM;
+}
+#endif //MARK_POLYMORPHIC
+
+static int marker_set_gen_enable(void *address, char enable)
+{
+	GEN_MARK_ENABLE(address) = enable;
+	return 0;
+}
+
+static int marker_set_enable(void *address, char enable, enum marker_type type)
+{
+	if (type == MARKER_OPTIMIZED)
+		return marker_set_ins_enable(address, enable);
+	else
+		return marker_set_gen_enable(address, enable);
+}
+
+/* enable and function address are set out of order, and it's ok :
+ * the state is always coherent. */
+static int marker_set_probe_range(const char *name,
+	const char *format,
+	marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->cmark->name) == 0) {
+			if (format
+				&& strcmp(format, iter->cmark->format) != 0) {
+				printk(KERN_NOTICE
+					"Format mismatch for probe %s "
+					"(%s), marker (%s)\n",
+					name,
+					format,
+					iter->cmark->format);
+				continue;
+			}
+			if (probe == __mark_empty_function) {
+				if (*iter->cmark->call
+					!= __mark_empty_function) {
+					*iter->cmark->call =
+						__mark_empty_function;
+				}
+				marker_set_enable(iter->enable, 0,
+					iter->cmark->type);
+			} else {
+				if (*iter->cmark->call
+					!= __mark_empty_function) {
+					if (*iter->cmark->call != probe) {
+						printk(KERN_NOTICE
+							"Marker %s busy, "
+							"probe %p already "
+							"installed\n",
+							name,
+							*iter->cmark->call);
+						continue;
+					}
+				} else {
+					found++;
+					*iter->cmark->call = probe;
+				}
+				/* Can have many enables for one function */
+				marker_set_enable(iter->enable, 1,
+					iter->cmark->type);
+			}
+			found++;
+		}
+	}
+	return found;
+}
+
+static int marker_remove_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (*iter->cmark->call == probe) {
+			marker_set_enable(iter->enable, 0,
+				iter->cmark->type);
+			*iter->cmark->call = __mark_empty_function;
+			found++;
+		}
+	}
+	return found;
+}
+
+static int marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != *iter->cmark->call) continue;
+		printk("name %s \n", iter->cmark->name);
+		if (iter->cmark->type == MARKER_OPTIMIZED)
+			printk("  enable %u optimized ",
+				MARK_ENABLE(iter->enable));
+		else
+			printk("  enable %u generic ",
+				GEN_MARK_ENABLE(iter->enable));
+		printk("  func 0x%p format \"%s\"\n",
+			*iter->cmark->call, iter->cmark->format);
+		found++;
+	}
+	return found;
+}
+/* markers use the modlist_lock to to synchronise */
+int marker_set_probe(const char *name, const char *format,
+				marker_probe_func *probe)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	found += marker_set_probe_range(name, format, probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += marker_set_probe_range(name, format, probe,
+				mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL(marker_set_probe);
+
+int marker_remove_probe(marker_probe_func *probe)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	found += marker_remove_probe_range(probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += marker_remove_probe_range(probe,
+				mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL(marker_remove_probe);
+
+int marker_list_probe(marker_probe_func *probe)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	printk("Listing kernel markers\n");
+	found += marker_list_probe_range(probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	printk("Listing module markers\n");
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing markers for module %s\n", mod->name);
+			found += marker_list_probe_range(probe,
+				mod->markers, mod->markers+mod->num_markers);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL(marker_list_probe);
+#endif
+
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -1585,6 +1795,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int markersindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1681,6 +1892,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	markersindex = find_sec(hdr, sechdrs, secstrings, ".markers");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1691,6 +1903,13 @@ static struct module *load_module(void _
 #endif
 	if (unwindex)
 		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
+#ifdef CONFIG_MARKERS
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+#else
+	if (markersindex)
+		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -1831,6 +2050,11 @@ static struct module *load_module(void _
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+	if (markersindex) {
+		mod->markers = (void *)sechdrs[markersindex].sh_addr;
+		mod->num_markers =
+			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+	}
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -2271,6 +2495,26 @@ const struct seq_operations modules_op =
 	.show	= m_show
 };
 
+void list_modules(void)
+{
+	/* Enumerate loaded modules */
+	struct list_head	*i;
+	struct module		*mod;
+	unsigned long refcount = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each(i, &modules) {
+		mod = list_entry(i, struct module, list);
+#ifdef CONFIG_MODULE_UNLOAD
+		refcount = local_read(&mod->ref[0].count);
+#endif //CONFIG_MODULE_UNLOAD
+		MARK(list_modules, "%s %d[enum module_state] %lu",
+				mod->name, mod->state, refcount);
+	}
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL(list_modules);
+
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
