From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-architecture-independant-code.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:06 -0700
Message-ID: <200705102232.l4AMW6Em032589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756550AbXEJWcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: architecture independent code
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-architecture-independant-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Linux Kernel Markers: architecture independent code
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Linux Kernel Markers, architecture independent code.

[bunk@stusta.de: marker exports must be EXPORT_SYMBOL_GPL]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <>
---

 include/asm-generic/vmlinux.lds.h |   13 +
 include/linux/marker.h            |  121 ++++++++++++
 include/linux/module.h            |    4 
 kernel/module.c                   |  273 ++++++++++++++++++++++++++++
 4 files changed, 411 insertions(+)

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
 	EH_FRAME							\
 									\
diff -puN /dev/null include/linux/marker.h
--- /dev/null
+++ a/include/linux/marker.h
@@ -0,0 +1,121 @@
+#ifndef _LINUX_MARKER_H
+#define _LINUX_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing.
+ *
+ * See Documentation/marker.txt.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef __KERNEL__
+
+struct __mark_marker_data;
+
+typedef void marker_probe_func(const struct __mark_marker_data *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker_data {
+	const char *name;
+	const char *format;
+	int flags;
+	marker_probe_func *call;
+	void *pdata;
+} __attribute__((packed));
+
+struct __mark_marker {
+	struct __mark_marker_data *mdata;
+	void *enable;
+} __attribute__((packed));
+
+#ifdef CONFIG_MARKERS
+
+/* Marker flags : selects the mechanism used to connect the probes to the
+ * markers and what can be executed within the probes. This is primarily
+ * used at reentrancy-unfriendly sites. */
+#define MF_OPTIMIZED	(1 << 0)	/* Use optimized markers */
+#define MF_LOCKDEP	(1 << 1)	/* Can call lockdep */
+#define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
+#define _MF_NR		3		/* Number of marker flags */
+
+#define DECLARE_MARKER_DATA(flags, name, format) \
+
+/* Generic marker flavor always available */
+#define MARK_GENERIC(flags, name, format, args...) \
+	do { \
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
+		static char __marker_enable_##name = 0; \
+		static const struct __mark_marker __mark_##name \
+			__attribute__((section("__markers"))) = \
+			{ &__mark_data_##name, &__marker_enable_##name } ; \
+		asm volatile ( "" : : "i" (&__mark_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(__marker_enable_##name)) { \
+			preempt_disable(); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
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
+
+#else /* !CONFIG_MARKERS */
+#define MARK_GENERIC(flags, name, format, args...) \
+		__mark_check_format(format, ## args)
+#endif /* CONFIG_MARKERS */
+
+#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
+#include <asm/marker.h>			/* optimized marker flavor */
+#else
+#include <asm-generic/marker.h>		/* fallback on generic markers */
+#endif
+
+#define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with sparse */
+static inline
+void __mark_check_format(const char *fmt, ...)
+{ }
+
+extern marker_probe_func __mark_empty_function;
+
+extern int _marker_set_probe(int flags, const char *name, const char *format,
+				marker_probe_func *probe, void *pdata);
+
+#define marker_set_probe(name, format, probe, pdata) \
+	_marker_set_probe(MF_DEFAULT, name, format, probe, pdata)
+
+extern int marker_remove_probe(const char *name);
+extern int marker_list_probe(marker_probe_func *probe);
+
+#endif /* __KERNEL__ */
+#endif
diff -puN include/linux/module.h~linux-kernel-markers-architecture-independant-code include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers-architecture-independant-code
+++ a/include/linux/module.h
@@ -356,6 +356,9 @@ struct module
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+
+	const struct __mark_marker *markers;
+	unsigned int num_markers;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
@@ -470,6 +473,7 @@ int register_module_notifier(struct noti
 int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
+extern void list_modules(void);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
diff -puN kernel/module.c~linux-kernel-markers-architecture-independant-code kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independant-code
+++ a/kernel/module.c
@@ -142,6 +142,8 @@ extern const unsigned long __start___kcr
 extern const unsigned long __start___kcrctab_gpl_future[];
 extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
+extern const struct __mark_marker __start___markers[];
+extern const struct __mark_marker __stop___markers[];
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -302,6 +304,229 @@ static struct module *find_module(const 
 	return NULL;
 }
 
+#ifdef CONFIG_MARKERS
+
+/* Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code. */
+void __mark_empty_function(const struct __mark_marker_data *mdata,
+	const char *fmt, ...)
+{
+}
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/* Set the enable bit of the marker, choosing the generic or architecture
+ * specific functions depending on the marker's flags.
+ */
+static int marker_set_enable(void *address, char enable, int flags)
+{
+	if (flags & MF_OPTIMIZED)
+		return marker_optimized_set_enable(address, enable);
+	else
+		return marker_generic_set_enable(address, enable);
+}
+
+/* Sets the probe callback and enables the markers corresponding to a range of
+ * markers. The enable bit and function address are set out of order, and it's
+ * ok : the state is always coherent because of the empty callback we provide.
+ */
+static int _marker_set_probe_range(int flags, const char *name,
+	const char *format,
+	marker_probe_func *probe,
+	void *pdata,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->mdata->name) == 0) {
+			if (format
+				&& strcmp(format, iter->mdata->format) != 0) {
+				printk(KERN_NOTICE
+					"Format mismatch for probe %s "
+					"(%s), marker (%s)\n",
+					name,
+					format,
+					iter->mdata->format);
+				continue;
+			}
+			if (flags & MF_LOCKDEP
+				&& !(iter->mdata->flags & MF_LOCKDEP)) {
+					printk(KERN_NOTICE
+					"Incompatible lockdep flags for "
+					"probe %s\n",
+					name);
+					continue;
+			}
+			if (flags & MF_PRINTK
+				&& !(iter->mdata->flags & MF_PRINTK)) {
+					printk(KERN_NOTICE
+					"Incompatible printk flags for "
+					"probe %s\n",
+					name);
+					continue;
+			}
+			if (probe == __mark_empty_function) {
+				if (iter->mdata->call
+					!= __mark_empty_function) {
+					iter->mdata->call =
+						__mark_empty_function;
+				}
+				marker_set_enable(iter->enable, 0,
+					iter->mdata->flags);
+			} else {
+				if (iter->mdata->call
+					!= __mark_empty_function) {
+					if (iter->mdata->call != probe) {
+						printk(KERN_NOTICE
+							"Marker %s busy, "
+							"probe %p already "
+							"installed\n",
+							name,
+							iter->mdata->call);
+						continue;
+					}
+				} else {
+					found++;
+					iter->mdata->call = probe;
+				}
+				iter->mdata->pdata = pdata;
+				smp_wmb();
+				marker_set_enable(iter->enable, 1,
+					iter->mdata->flags);
+			}
+			found++;
+		}
+	}
+	return found;
+}
+
+/* Sets a range of markers to a disabled state : unset the enable bit and
+ * provide the empty callback. */
+static int marker_remove_probe_range(const char *name,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->mdata->name) == 0) {
+			marker_set_enable(iter->enable, 0,
+				iter->mdata->flags);
+			iter->mdata->call = __mark_empty_function;
+			found++;
+		}
+	}
+	return found;
+}
+
+/* Provides a listing of the markers present in the kernel with their type
+ * (optimized or generic), state (enabled or disabled), callback and format
+ * string. */
+static int marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != iter->mdata->call) continue;
+		printk("name %s \n", iter->mdata->name);
+		if (iter->mdata->flags & MF_OPTIMIZED)
+			printk("  enable %u optimized ",
+				MARK_OPTIMIZED_ENABLE(iter->enable));
+		else
+			printk("  enable %u generic ",
+				MARK_GENERIC_ENABLE(iter->enable));
+		printk("  func 0x%p format \"%s\"\n",
+			iter->mdata->call, iter->mdata->format);
+		found++;
+	}
+	return found;
+}
+
+/* Calls _marker_set_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
+int _marker_set_probe(int flags, const char *name, const char *format,
+				marker_probe_func *probe,
+				void *pdata)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	found += _marker_set_probe_range(flags, name, format, probe,
+			pdata,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += _marker_set_probe_range(flags, name, format,
+			probe, pdata,
+			mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(_marker_set_probe);
+
+/* Calls _marker_remove_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
+int marker_remove_probe(const char *name)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	found += marker_remove_probe_range(name,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += marker_remove_probe_range(name,
+				mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(marker_remove_probe);
+
+/* Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file. */
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
+EXPORT_SYMBOL_GPL(marker_list_probe);
+#endif
+
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -1659,6 +1884,9 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int markersindex;
+	unsigned int markersdataindex;
+	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1755,6 +1983,10 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+	markersdataindex = find_sec(hdr, sechdrs, secstrings, "__markers_data");
+	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
+				"__markers_strings");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1765,6 +1997,22 @@ static struct module *load_module(void _
 #endif
 	if (unwindex)
 		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
+#ifdef CONFIG_MARKERS
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
+#else
+	if (markersindex)
+		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags
+					&= ~(unsigned long)SHF_ALLOC;
+#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -1905,6 +2153,11 @@ static struct module *load_module(void _
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
@@ -2399,6 +2652,26 @@ const struct seq_operations modules_op =
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
+		trace_mark(list_module, "%s %d %lu",
+				mod->name, mod->state, refcount);
+	}
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL_GPL(list_modules);
+
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-architecture-independant-code.patch
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
