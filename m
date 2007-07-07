From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-architecture-independent-code.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:32:23 -0700
Message-ID: <200707070036.l670aZMU030017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbXGGAgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: architecture independent code
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-architecture-independent-code.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Linux Kernel Markers: architecture independent code
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The marker activation functions sits in kernel/marker.c.  A hash table is used
to keep track of the armed/disarmed markers, so they can be activated at
module load time.

The marker IDs will be used as unique identifiers for markers.  They are
assigned by the marker infrastructure and are used to identify a marker in a
compact representation either in a probe handler and especially in a trace.

Marker group is a parameter given by the probe provider.  It can be used, for
instance, to tell which set of buffers the information must be send to when
recording a trace.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   11 
 include/linux/marker.h            |  159 +++++
 include/linux/module.h            |    5 
 kernel/Makefile                   |    1 
 kernel/marker.c                   |  801 ++++++++++++++++++++++++++++
 kernel/module.c                   |   17 
 6 files changed, 993 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~linux-kernel-markers-architecture-independent-code include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~linux-kernel-markers-architecture-independent-code
+++ a/include/asm-generic/vmlinux.lds.h
@@ -12,7 +12,11 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)
+	*(.data.init.refok)						\
+	. = ALIGN(32);							\
+	VMLINUX_SYMBOL(__start___markers) = .;				\
+	*(__markers)							\
+	VMLINUX_SYMBOL(__stop___markers) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -129,6 +133,11 @@
 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
 	}								\
 									\
+	/* Markers: strings */						\
+        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
+		*(__markers_strings)					\
+ 	}								\
+									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
diff -puN /dev/null include/linux/marker.h
--- /dev/null
+++ a/include/linux/marker.h
@@ -0,0 +1,159 @@
+#ifndef _LINUX_MARKER_H
+#define _LINUX_MARKER_H
+
+/*
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
+#include <linux/immediate.h>
+#include <linux/types.h>
+
+struct module;
+struct __mark_marker;
+
+/*
+ * Unique ID assigned to each registered probe.
+ */
+enum marker_id {
+	MARKER_ID_LOAD_MARKER = 0,	/* Static IDs available (range 0-7) */
+	MARKER_ID_HEARTBEAT_32,
+	MARKER_ID_HEARTBEAT_64,
+	MARKER_ID_COMPACT,		/* Compact IDs (range: 8-127)	    */
+	MARKER_ID_DYNAMIC,		/* Dynamic IDs (range: 128-65535)   */
+};
+
+/* static ids 0-7 reserved for internal use. */
+#define MARKER_CORE_IDS		8
+/* dynamic ids 8-127 reserved for compact events. */
+#define MARKER_COMPACT_IDS	128
+static inline enum marker_id marker_id_type(uint16_t id)
+{
+	if (id < MARKER_CORE_IDS)
+		return (enum marker_id)id;
+	else if (id < MARKER_COMPACT_IDS)
+		return MARKER_ID_COMPACT;
+	else
+		return MARKER_ID_DYNAMIC;
+}
+
+typedef void marker_probe_func(const struct __mark_marker *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker {
+	const char *name;	/* Marker name */
+	const char *format;	/* Marker format string, describing the
+				 * variable argument list.
+				 */
+	const char *args;	/* List of arguments litteraly transformed
+				 * into a string: "arg1, arg2, arg3".
+				 */
+	immediate_t state;	/* Immediate value state. */
+	int flags;		/* Flags controlling the markers flavor.
+				 * Passed to the contidional call declaration
+				 * and used to check that the probe matches the
+				 * markers restrictions at connexion time. */
+	marker_probe_func *call;/* Probe handler function pointer */
+	void *pdata;		/* Private probe data */
+	uint16_t id;		/* Unique marker numeric ID */
+	uint16_t group;		/*
+				 * Per probe information to select to which
+				 * group the marker belongs.
+				 */
+};
+
+#ifdef CONFIG_MARKERS
+
+/*
+ * Generic marker flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ * Make sure the alignment of the structure in the __markers section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ * Use the natual alignment for a 32 bytes structure (32 bytes).
+ */
+#define _trace_mark(flags, name, format, args...)			\
+	do {								\
+		static const char __mstrtab_name_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= #name;						\
+		static const char __mstrtab_format_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= format;						\
+		static const char __mstrtab_args_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= #args;						\
+		static struct __mark_marker __mark_##name		\
+		__attribute__((section("__markers"), aligned(32))) = 	\
+		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		__mstrtab_args_##name, { 0 }, (flags),			\
+		__mark_empty_function, NULL, 0 };			\
+		asm volatile ( "" : : "i" (&__mark_##name));		\
+		__mark_check_format(format, ## args);			\
+		if (unlikely(_immediate((flags), __mark_##name.state))) { \
+			preempt_disable();				\
+			(*__mark_##name.call)(&__mark_##name, format, ## args);\
+			preempt_enable();				\
+		}							\
+	} while (0)
+
+extern void module_marker_update(struct module *mod);
+#else /* !CONFIG_MARKERS */
+#define _trace_mark(flags, name, format, args...) \
+		__mark_check_format(format, ## args)
+static inline void module_marker_update(struct module *mod) { }
+#endif /* CONFIG_MARKERS */
+
+/* Marker with default behavior */
+#define trace_mark(name, format, args...) \
+	_trace_mark(IF_DEFAULT, name, format, ## args)
+
+#define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with gcc (TODO) */
+static inline
+void __mark_check_format(const char *fmt, ...)
+#ifdef GCC_SUPPORTS_MARKER_CHECK
+	__attribute__((format (trace_mark, 1, 2)))
+#endif
+{ }
+
+extern marker_probe_func __mark_empty_function;
+
+extern int _marker_probe_register(int flags, const char *name,
+				const char *format, marker_probe_func *probe,
+				void *pdata, enum marker_id id,
+				uint16_t group);
+extern int marker_set_group(const char *name, uint16_t group);
+extern int marker_set_id(const char *name, enum marker_id id);
+
+/*
+ * Returns the pdata given to marker_probe_register.
+ */
+extern void *marker_probe_unregister(const char *name);
+
+#define marker_probe_register(name, format, probe, pdata, group)	\
+	_marker_probe_register(IF_DEFAULT, name, format, probe, pdata, \
+				MARKER_ID_DYNAMIC, group)
+
+extern int marker_arm(const char *name);
+extern int marker_disarm(const char *name);
+extern int marker_query_probe(const char *name, marker_probe_func **probe,
+				void **pdata, uint16_t *id, uint16_t *group);
+extern int marker_list_probe(marker_probe_func *probe);
+extern const struct __mark_marker *marker_query(const char *name, int instance);
+extern void marker_probe_clean_pdata(void *pdata);
+
+#endif /* __KERNEL__ */
+#endif
diff -puN include/linux/module.h~linux-kernel-markers-architecture-independent-code include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers-architecture-independent-code
+++ a/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/immediate.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -380,6 +381,10 @@ struct module
 	const struct __immediate *immediates;
 	unsigned int num_immediates;
 #endif
+#ifdef CONFIG_MARKERS
+	struct __mark_marker *markers;
+	unsigned int num_markers;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff -puN kernel/Makefile~linux-kernel-markers-architecture-independent-code kernel/Makefile
--- a/kernel/Makefile~linux-kernel-markers-architecture-independent-code
+++ a/kernel/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_IMMEDIATE) += immediate.o
+obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff -puN /dev/null kernel/marker.c
--- /dev/null
+++ a/kernel/marker.c
@@ -0,0 +1,801 @@
+/*
+ * Copyright (C) 2007 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/marker.h>
+#include <linux/err.h>
+
+static uint8_t mark_next_compact_id = MARKER_CORE_IDS;
+/* Next available ID. Dynamic range : 128-65535 */
+static uint16_t mark_next_id = MARKER_COMPACT_IDS;
+
+extern struct __mark_marker __start___markers[];
+extern struct __mark_marker __stop___markers[];
+
+/*
+ * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * and module markers, and the hash table.
+ */
+DEFINE_MUTEX(markers_mutex);
+
+/*
+ * Marker hash table, containing the active markers.
+ * Protected by module_mutex.
+ */
+#define MARKER_HASH_BITS 6
+#define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
+
+struct marker_entry {
+	struct hlist_node hlist;
+	int flags;
+	char *format;
+	marker_probe_func *probe;
+	void *pdata;
+	uint16_t id;	/* 16 bits unique numeric ID */
+	uint16_t group;
+	int state;	/* Armed or disarmed */
+	char name[0];	/* Contains name'\0'format'\0' */
+};
+
+static struct hlist_head marker_table[MARKER_TABLE_SIZE];
+
+/*
+ * Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code.
+ */
+void __mark_empty_function(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+}
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/*
+ * Get marker if the marker is present in the marker hash table.
+ * Must be called with markers_mutex held.
+ * Returns NULL if not present.
+ */
+static struct marker_entry *_get_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t len = strlen(name) + 1;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name))
+			return e;
+	return NULL;
+}
+
+/*
+ * Add the marker to the marker hash table. Must be called with markers_mutex
+ * held.
+ */
+static int _add_marker(int flags, const char *name,
+	const char *format, marker_probe_func *probe, void *pdata,
+	enum marker_id id, uint16_t group)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name) + 1;
+	size_t format_len = 0;
+	u32 hash = jhash(name, name_len-1, 0);
+
+	/* First check if there are still IDs available */
+	switch (id) {
+		case MARKER_ID_DYNAMIC:
+			if (mark_next_id == 0)
+				return -ENOSPC;
+			break;
+		case MARKER_ID_COMPACT:
+			if (mark_next_compact_id == 0)
+				return -ENOSPC;
+			break;
+		default:
+			/* Only allow 0-7 range for core IDs */
+			if ((uint16_t)id >= MARKER_CORE_IDS)
+				return -EPERM;
+	}
+
+	if (format)
+		format_len = strlen(format) + 1;
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			printk(KERN_NOTICE
+				"Marker %s busy, probe %p already installed\n",
+				name, e->probe);
+			return -EBUSY;	/* Already there */
+		}
+	}
+	/*
+	 * Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused.
+	 */
+	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
+			GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], name, name_len);
+	if (format) {
+		e->format = &e->name[name_len];
+		memcpy(e->format, format, format_len);
+	} else
+		e->format = NULL;
+	e->flags = flags;
+	e->probe = probe;
+	e->pdata = pdata;
+	e->group = group;
+	switch (id) {
+		case MARKER_ID_COMPACT:
+			e->id = mark_next_compact_id++;
+			break;
+		case MARKER_ID_DYNAMIC:
+			e->id = mark_next_id++;
+			break;
+		default:
+			e->id = (uint16_t)id;
+	}
+	e->state = 0;
+	hlist_add_head(&e->hlist, head);
+	return 0;
+}
+
+/*
+ * Remove the marker from the marker hash table. Must be called with mutex_lock
+ * held.
+ */
+static void *_remove_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	int found = 0;
+	size_t len = strlen(name) + 1;
+	void *pdata = NULL;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (found) {
+		pdata = e->pdata;
+		hlist_del(&e->hlist);
+		kfree(e);
+	}
+	return pdata;
+}
+
+/*
+ * Set the mark_entry format to the format found in the element.
+ */
+static int _marker_set_format(struct marker_entry **entry, const char *format)
+{
+	struct marker_entry *e;
+	size_t name_len = strlen((*entry)->name) + 1;
+	size_t format_len = strlen(format) + 1;
+
+	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
+			GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], (*entry)->name, name_len);
+	e->format = &e->name[name_len];
+	memcpy(e->format, format, format_len);
+	e->flags = (*entry)->flags;
+	e->probe = (*entry)->probe;
+	e->pdata = (*entry)->pdata;
+	e->state = (*entry)->state;
+	e->id = (*entry)->id;
+	e->group = (*entry)->group;
+	hlist_add_before(&e->hlist, &(*entry)->hlist);
+	hlist_del(&(*entry)->hlist);
+	kfree(*entry);
+	*entry = e;
+	trace_mark(marker_load, "name %s format %s id %hu",
+			e->name, e->format, e->id);
+	return 0;
+}
+
+/* Sets the probe callback corresponding to one marker. */
+static int _set_marker(struct marker_entry **entry,
+			struct __mark_marker *elem)
+{
+	int ret;
+	BUG_ON(strcmp((*entry)->name, elem->name) != 0);
+
+	if ((*entry)->format) {
+		if (strcmp((*entry)->format, elem->format) != 0) {
+			printk(KERN_NOTICE
+				"Format mismatch for probe %s "
+				"(%s), marker (%s)\n",
+				(*entry)->name,
+				(*entry)->format,
+				elem->format);
+			return -EPERM;
+		}
+	} else {
+		ret = _marker_set_format(entry, elem->format);
+		if (ret)
+			return ret;
+	}
+	if ((*entry)->flags & IF_LOCKDEP
+		&& !(elem->flags & IF_LOCKDEP)) {
+		printk(KERN_NOTICE
+			"Incompatible lockdep flags for "
+			"probe %s\n",
+			(*entry)->name);
+		return -EPERM;
+	}
+	elem->call = (*entry)->probe;
+	elem->pdata = (*entry)->pdata;
+	elem->id = (*entry)->id;
+	elem->group = (*entry)->group;
+	__immediate_update(&elem->state, 1);
+	return 0;
+}
+
+static void _disable_marker(struct __mark_marker *elem)
+{
+	__immediate_update(&elem->state, 0);
+	elem->call = __mark_empty_function;
+	/*
+	 * Leave the pdata and id there, because removal is racy and should be
+	 * done only after a synchronize_sched(). There are never used until
+	 * the next initialization anyway.
+	 */
+}
+
+/*
+ * Updates the probe callback corresponding to a range of markers.
+ * Must be called with markers_mutex held.
+ */
+static void _marker_update_probe_range(
+	struct __mark_marker *begin,
+	struct __mark_marker *end,
+	struct module *probe_module,
+	int *refcount, int *nr_armed)
+{
+	struct __mark_marker *iter;
+	struct marker_entry *mark_entry;
+
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = _get_marker(iter->name);
+		if (mark_entry && mark_entry->state) {
+			_set_marker(&mark_entry, iter);
+			/*
+			 * ignore error, continue
+			 */
+			if (probe_module)
+				if (probe_module ==
+			__module_text_address((unsigned long)mark_entry->probe))
+					(*refcount)++;
+			(*nr_armed)++;
+		} else {
+			_disable_marker(iter);
+		}
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Update module probes.
+ * Must be called with markers_mutex held.
+ */
+static inline void __marker_update_probes_modules(struct module *probe_module,
+	int *refcount, int *nr_armed)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			_marker_update_probe_range(mod->markers,
+				mod->markers+mod->num_markers,
+				probe_module, refcount, nr_armed);
+		}
+	}
+}
+#else
+static inline void __marker_update_probes_modules(struct module *probe_module,
+	int *refcount, *nr_armed)
+{
+}
+#endif
+
+/*
+ * Defragment the markers IDs. Should only be called when the IDs are not used
+ * by anyone, typically when all probes are disarmed. Clients of the markers
+ * rely on having their code markers armed during a "session" to make sure there
+ * will be no ID compaction. (for instance, a marker ID is never reused during a
+ * trace).
+ * There is no need to synchronize the hash table entries with the section
+ * elements because none is armed.
+ */
+void _marker_id_defrag(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	unsigned int i;
+
+	mark_next_compact_id = MARKER_CORE_IDS;
+	mark_next_id = MARKER_COMPACT_IDS;
+
+	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
+		head = &marker_table[i];
+		hlist_for_each_entry(e, node, head, hlist) {
+			switch (marker_id_type(e->id)) {
+				case MARKER_ID_COMPACT:
+					e->id = mark_next_compact_id++;
+					break;
+				case MARKER_ID_DYNAMIC:
+					e->id = mark_next_id++;
+					break;
+				default:
+					/* default is to keep the static ID */
+					break;
+			}
+		}
+	}
+}
+
+/*
+ * Update probes, removing the faulty probes.
+ * Issues a synchronize_sched() when no reference to the module passed
+ * as parameter is found in the probes so the probe module can be
+ * safely unloaded from now on.
+ */
+static inline void __marker_update_probes(struct module *probe_module)
+{
+	int refcount = 0, nr_armed = 0;
+
+	/* Core kernel markers */
+	_marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount, &nr_armed);
+	/* Markers in modules. */
+	__marker_update_probes_modules(probe_module, &refcount,
+			&nr_armed);
+	if (probe_module && refcount == 0)
+		synchronize_sched();
+	if (!nr_armed)
+		_marker_id_defrag();
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Setup the marker according to the data present in the marker hash table
+ * upon module load. If an error occur during the set probe range,
+ * refuse to load the module. Must be called with module_mutex held.
+ */
+void module_marker_update(struct module *mod)
+{
+	int nr_armed = 0;
+	if (!mod->taints)
+		_marker_update_probe_range(mod->markers,
+			mod->markers+mod->num_markers, NULL, NULL, &nr_armed);
+}
+
+/*
+ * Update the system wide probes, with modules. */
+static inline void _marker_update_probes(struct module *probe_module)
+{
+	mutex_lock(&module_mutex);
+	__marker_update_probes(probe_module);
+	mutex_unlock(&module_mutex);
+}
+#else
+/* Update the system wide probes, without modules. */
+static inline void _marker_update_probes(struct module *probe_module)
+{
+	__marker_update_probes(probe_module);
+}
+#endif
+
+/*
+ * Register a probe : set the callback for each marker.
+ * Markers must be disarmed to be registered.
+ */
+int _marker_probe_register(int flags, const char *name, const char *format,
+			marker_probe_func *probe, void *pdata,
+			enum marker_id id, uint16_t group)
+{
+	struct marker_entry *entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (entry && entry->state) {
+		ret = -EBUSY;
+		goto end;
+	}
+	ret = _add_marker(flags, name, format, probe, pdata, id, group);
+	if (ret)
+		goto end;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(_marker_probe_register);
+
+/*
+ * Set the group of a marker.
+ */
+int marker_set_group(const char *name, uint16_t group)
+{
+	struct marker_entry *entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	} else if (entry->state) {
+		ret = -EBUSY;
+		goto end;
+	}
+
+	entry->group = group;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_set_group);
+
+/*
+ * Set the ID of a marker.
+ */
+int marker_set_id(const char *name, enum marker_id id)
+{
+	struct marker_entry *entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	} else if (entry->state) {
+		ret = -EBUSY;
+		goto end;
+	}
+
+	if (id == marker_id_type(entry->id)) {
+		ret = 0;
+		goto end;
+	}
+	switch (id) {
+		case MARKER_ID_COMPACT:
+			entry->id = mark_next_compact_id++;
+			break;
+		case MARKER_ID_DYNAMIC:
+			entry->id = mark_next_id++;
+			break;
+		default:
+			entry->id = (uint16_t)id;
+	}
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_set_id);
+
+/*
+ * Unregister a probe : unset the callback for each marker.
+ * Markers must be disarmed to be unregistered.
+ * returns the pdata if ok.
+ * else, returns a ERR_PTR().
+ */
+void *marker_probe_unregister(const char *name)
+{
+	struct module *probe_module;
+	struct marker_entry *entry;
+	void *pdata;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		pdata = ERR_PTR(-ENOENT);
+		goto end;
+	} else if (entry->state) {
+		pdata = ERR_PTR(-EBUSY);
+		goto end;
+	}
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	pdata = _remove_marker(name);
+	_marker_update_probes(probe_module);
+end:
+	mutex_unlock(&markers_mutex);
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister);
+
+/*
+ * Disarm and remove every marker referencing pdata.
+ */
+void marker_probe_clean_pdata(void *pdata)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	unsigned int i;
+
+	mutex_lock(&markers_mutex);
+	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
+		head = &marker_table[i];
+		hlist_for_each_entry(e, node, head, hlist) {
+			if (e->pdata == pdata) {
+				e->state = 0;
+			}
+		}
+	}
+	_marker_update_probes(NULL);
+	synchronize_sched();
+
+	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
+		head = &marker_table[i];
+		hlist_for_each_entry(e, node, head, hlist) {
+			if (e->pdata == pdata) {
+				hlist_del(&e->hlist);
+				kfree(e);
+			}
+		}
+	}
+	_marker_update_probes(NULL);
+	mutex_unlock(&markers_mutex);
+}
+EXPORT_SYMBOL_GPL(marker_probe_clean_pdata);
+
+/*
+ * Arm the probe : arm the immediate values.
+ * A probe must have been previously registered.
+ */
+int marker_arm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * The marker is known to the marker_load callback only once it provides
+	 * a format string, which can come later from the marker section,
+	 * through _marker_set_format().
+	 */
+	if (entry->format)
+		trace_mark(marker_load, "name %s format %s id %hu",
+			name, entry->format, entry->id);
+	entry->state = 1;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_arm);
+
+/*
+ * Disarm the probe : disarm the immediate and set the empty callback for each
+ * marker.
+ */
+int marker_disarm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	entry->state = 0;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_disarm);
+
+/*
+ * Get the callback, pdata and ID assigned to a marker.
+ * Can be used to verify if the caller module is the owner of the probe. Data
+ * returned should not be touched if the module is not owner, because no locking
+ * prevents modification of these structure by the owner.
+ * returns -ENOENT if the probe is not registered.
+ * returns 0 if ok.
+ */
+int marker_query_probe(const char *name, marker_probe_func **probe,
+				void **pdata, uint16_t *id, uint16_t *group)
+{
+	struct marker_entry * entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	*probe = entry->probe;
+	*pdata = entry->pdata;
+	*id = entry->id;
+	*group = entry->group;
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_query_probe);
+
+/*
+ * Looks up a marker by its name and instance number within the specificed
+ * range and returns the associated data structure.
+ */
+static const struct __mark_marker *_marker_query_range(const char *name,
+	int instance,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->name) != 0)
+			continue;
+		if (found++ == instance)
+			return iter;
+	}
+	return NULL;
+}
+
+/* Query the markers in the modules */
+#ifdef CONFIG_MODULES
+static inline const struct __mark_marker *marker_query_modules(const char *name,
+			int instance)
+{
+	struct module *mod;
+	const struct __mark_marker *mdata = NULL;
+
+	mutex_lock(&module_mutex);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			mdata = _marker_query_range(name, instance,
+				mod->markers,
+				mod->markers+mod->num_markers);
+			if (mdata)
+				break;
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return mdata;
+}
+#else
+static inline const struct __mark_marker *marker_query_modules(const char *name,
+			int instance)
+{
+	return NULL;
+}
+#endif
+
+/*
+ * Looks up a marker by its name and instance number and returns the
+ * associated data structure.
+ */
+const struct __mark_marker *marker_query(const char *name, int instance)
+{
+	const struct __mark_marker *mdata;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	mdata = _marker_query_range(name, instance,
+			__start___markers, __stop___markers);
+	if (!mdata)
+		mdata = marker_query_modules(name, instance);
+	mutex_unlock(&markers_mutex);
+	return mdata;
+}
+EXPORT_SYMBOL_GPL(marker_query);
+
+/*
+ * Provides a listing of the markers present in the kernel along with their
+ * callback and format string.
+ */
+static int _marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != iter->call) continue;
+		printk("name %s func 0x%p format \"%s\"\n",
+			iter->name,
+			iter->call, iter->format);
+		found++;
+	}
+	return found;
+}
+
+#ifdef CONFIG_MODULES
+static inline int marker_list_probe_modules(marker_probe_func *probe)
+{
+	int found = 0;
+	struct module *mod;
+
+	printk("Listing module markers\n");
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing markers for module %s\n", mod->name);
+			found += _marker_list_probe_range(probe,
+				mod->markers, mod->markers+mod->num_markers);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+#else
+static inline int marker_list_probe_modules(marker_probe_func *probe)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file.
+ */
+int marker_list_probe(marker_probe_func *probe)
+{
+	int found = 0;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	printk("Listing kernel markers\n");
+	found += _marker_list_probe_range(probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	found += marker_list_probe_modules(probe);
+	mutex_unlock(&markers_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(marker_list_probe);
diff -puN kernel/module.c~linux-kernel-markers-architecture-independent-code kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independent-code
+++ a/kernel/module.c
@@ -1723,6 +1723,10 @@ static struct module *load_module(void _
 #ifdef CONFIG_IMMEDIATE
 	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
 #endif
+#ifdef CONFIG_MARKERS
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings, "__markers_strings");
+#endif
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1882,6 +1886,10 @@ static struct module *load_module(void _
 			sechdrs[immediateindex].sh_size / sizeof(*mod->immediates);
 	}
 #endif
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -1923,6 +1931,13 @@ static struct module *load_module(void _
 		if (err < 0)
 			goto cleanup;
 	}
+#ifdef CONFIG_MARKERS
+	if (markersindex) {
+		mod->markers = (void *)sechdrs[markersindex].sh_addr;
+		mod->num_markers =
+			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+	}
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -1947,6 +1962,8 @@ static struct module *load_module(void _
         }
 #endif
 
+	module_marker_update(mod);
+
 	module_immediate_setup(mod);
 
 	err = module_finalize(hdr, sechdrs, mod);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
