From: akpm@linux-foundation.org
Subject: - linux-kernel-markers.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:23 -0700
Message-ID: <200710192254.l9JMsNGE024523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764645AbXJSXHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, fche@redhat.com, hch@infradead.org, mmlnx@us.ibm.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Linux Kernel Markers
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The marker activation functions sits in kernel/marker.c.  A hash table is used
to keep track of the registered probes and armed markers, so the markers
within a newly loaded module that should be active can be activated at module
load time.

marker_query has been removed. marker_get_first, marker_get_next and
marker_release should be used as iterators on the markers.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Mason <mmlnx@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    7 
 include/linux/marker.h            |  130 ++++++
 include/linux/module.h            |   12 
 kernel/Kconfig.instrumentation    |    6 
 kernel/Makefile                   |    1 
 kernel/marker.c                   |  525 ++++++++++++++++++++++++++++
 kernel/module.c                   |   30 +
 7 files changed, 710 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~linux-kernel-markers include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~linux-kernel-markers
+++ a/include/asm-generic/vmlinux.lds.h
@@ -12,7 +12,11 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)
+	*(.data.init.refok)						\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___markers) = .;				\
+	*(__markers)							\
+	VMLINUX_SYMBOL(__stop___markers) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -20,6 +24,7 @@
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
+		*(__markers_strings)	/* Markers: strings */		\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
diff -puN /dev/null include/linux/marker.h
--- /dev/null
+++ a/include/linux/marker.h
@@ -0,0 +1,130 @@
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
+#include <linux/types.h>
+
+struct module;
+struct marker;
+
+/**
+ * marker_probe_func - Type of a marker probe function
+ * @mdata: pointer of type struct marker
+ * @private_data: caller site private data
+ * @fmt: format string
+ * @...: variable argument list
+ *
+ * Type of marker probe functions. They receive the mdata and need to parse the
+ * format string to recover the variable argument list.
+ */
+typedef void marker_probe_func(const struct marker *mdata,
+	void *private_data, const char *fmt, ...);
+
+struct marker {
+	const char *name;	/* Marker name */
+	const char *format;	/* Marker format string, describing the
+				 * variable argument list.
+				 */
+	char state;		/* Marker state. */
+	marker_probe_func *call;/* Probe handler function pointer */
+	void *private;		/* Private probe data */
+} __attribute__((aligned(8)));
+
+#ifdef CONFIG_MARKERS
+
+/*
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ * Make sure the alignment of the structure in the __markers section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+#define __trace_mark(name, call_data, format, args...)			\
+	do {								\
+		static const char __mstrtab_name_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= #name;						\
+		static const char __mstrtab_format_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= format;						\
+		static struct marker __mark_##name			\
+		__attribute__((section("__markers"), aligned(8))) =	\
+		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		0, __mark_empty_function, NULL };			\
+		asm volatile("" : : "i" (&__mark_##name));		\
+		__mark_check_format(format, ## args);			\
+		if (unlikely(__mark_##name.state)) {			\
+			preempt_disable();				\
+			(*__mark_##name.call)				\
+				(&__mark_##name, call_data,		\
+				format, ## args);			\
+			preempt_enable();				\
+		}							\
+	} while (0)
+
+extern void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount);
+#else /* !CONFIG_MARKERS */
+#define __trace_mark(name, call_data, format, args...) \
+		__mark_check_format(format, ## args)
+static inline void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount)
+{ }
+#endif /* CONFIG_MARKERS */
+
+/**
+ * trace_mark - Marker
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker.
+ */
+#define trace_mark(name, format, args...) \
+	__trace_mark(name, NULL, format, ## args)
+
+#define MARK_MAX_FORMAT_LEN	1024
+
+/**
+ * MARK_NOARGS - Format string for a marker with no argument.
+ */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with gcc */
+static inline void __printf(1, 2) __mark_check_format(const char *fmt, ...)
+{
+}
+
+extern marker_probe_func __mark_empty_function;
+
+/*
+ * Connect a probe to a marker.
+ * private data pointer must be a valid allocated memory address, or NULL.
+ */
+extern int marker_probe_register(const char *name, const char *format,
+				marker_probe_func *probe, void *private);
+
+/*
+ * Returns the private data given to marker_probe_register.
+ */
+extern void *marker_probe_unregister(const char *name);
+/*
+ * Unregister a marker by providing the registered private data.
+ */
+extern void *marker_probe_unregister_private_data(void *private);
+
+extern int marker_arm(const char *name);
+extern int marker_disarm(const char *name);
+extern void *marker_get_private_data(const char *name);
+
+#endif
diff -puN include/linux/module.h~linux-kernel-markers include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers
+++ a/include/linux/module.h
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -354,6 +355,10 @@ struct module
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+#ifdef CONFIG_MARKERS
+	struct marker *markers;
+	unsigned int num_markers;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
@@ -457,6 +462,8 @@ int unregister_module_notifier(struct no
 
 extern void print_modules(void);
 
+extern void module_update_markers(struct module *probe_module, int *refcount);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -556,6 +563,11 @@ static inline void print_modules(void)
 {
 }
 
+static inline void module_update_markers(struct module *probe_module,
+		int *refcount)
+{
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
diff -puN kernel/Kconfig.instrumentation~linux-kernel-markers kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~linux-kernel-markers
+++ a/kernel/Kconfig.instrumentation
@@ -40,4 +40,10 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
 endif # INSTRUMENTATION
diff -puN kernel/Makefile~linux-kernel-markers kernel/Makefile
--- a/kernel/Makefile~linux-kernel-markers
+++ a/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff -puN /dev/null kernel/marker.c
--- /dev/null
+++ a/kernel/marker.c
@@ -0,0 +1,525 @@
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
+extern struct marker __start___markers[];
+extern struct marker __stop___markers[];
+
+/*
+ * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * and module markers, the hash table and deferred_sync.
+ */
+static DEFINE_MUTEX(markers_mutex);
+
+/*
+ * Marker deferred synchronization.
+ * Upon marker probe_unregister, we delay call to synchronize_sched() to
+ * accelerate mass unregistration (only when there is no more reference to a
+ * given module do we call synchronize_sched()). However, we need to make sure
+ * every critical region has ended before we re-arm a marker that has been
+ * unregistered and then registered back with a different probe data.
+ */
+static int deferred_sync;
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
+	char *format;
+	marker_probe_func *probe;
+	void *private;
+	int refcount;	/* Number of times armed. 0 if disarmed. */
+	char name[0];	/* Contains name'\0'format'\0' */
+};
+
+static struct hlist_head marker_table[MARKER_TABLE_SIZE];
+
+/**
+ * __mark_empty_function - Empty probe callback
+ * @mdata: pointer of type const struct marker
+ * @fmt: format string
+ * @...: variable argument list
+ *
+ * Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we make sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code.
+ */
+void __mark_empty_function(const struct marker *mdata, void *private,
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
+static struct marker_entry *get_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name))
+			return e;
+	}
+	return NULL;
+}
+
+/*
+ * Add the marker to the marker hash table. Must be called with markers_mutex
+ * held.
+ */
+static int add_marker(const char *name, const char *format,
+	marker_probe_func *probe, void *private)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name) + 1;
+	size_t format_len = 0;
+	u32 hash = jhash(name, name_len-1, 0);
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
+		trace_mark(core_marker_format, "name %s format %s",
+				e->name, e->format);
+	} else
+		e->format = NULL;
+	e->probe = probe;
+	e->private = private;
+	e->refcount = 0;
+	hlist_add_head(&e->hlist, head);
+	return 0;
+}
+
+/*
+ * Remove the marker from the marker hash table. Must be called with mutex_lock
+ * held.
+ */
+static void *remove_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	int found = 0;
+	size_t len = strlen(name) + 1;
+	void *private = NULL;
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
+		private = e->private;
+		hlist_del(&e->hlist);
+		kfree(e);
+	}
+	return private;
+}
+
+/*
+ * Set the mark_entry format to the format found in the element.
+ */
+static int marker_set_format(struct marker_entry **entry, const char *format)
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
+	e->probe = (*entry)->probe;
+	e->private = (*entry)->private;
+	e->refcount = (*entry)->refcount;
+	hlist_add_before(&e->hlist, &(*entry)->hlist);
+	hlist_del(&(*entry)->hlist);
+	kfree(*entry);
+	*entry = e;
+	trace_mark(core_marker_format, "name %s format %s",
+			e->name, e->format);
+	return 0;
+}
+
+/*
+ * Sets the probe callback corresponding to one marker.
+ */
+static int set_marker(struct marker_entry **entry, struct marker *elem)
+{
+	int ret;
+	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
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
+		ret = marker_set_format(entry, elem->format);
+		if (ret)
+			return ret;
+	}
+	elem->call = (*entry)->probe;
+	elem->private = (*entry)->private;
+	elem->state = 1;
+	return 0;
+}
+
+/*
+ * Disable a marker and its probe callback.
+ * Note: only after a synchronize_sched() issued after setting elem->call to the
+ * empty function insures that the original callback is not used anymore. This
+ * insured by preemption disabling around the call site.
+ */
+static void disable_marker(struct marker *elem)
+{
+	elem->state = 0;
+	elem->call = __mark_empty_function;
+	/*
+	 * Leave the private data and id there, because removal is racy and
+	 * should be done only after a synchronize_sched(). These are never used
+	 * until the next initialization anyway.
+	 */
+}
+
+/**
+ * marker_update_probe_range - Update a probe range
+ * @begin: beginning of the range
+ * @end: end of the range
+ * @probe_module: module address of the probe being updated
+ * @refcount: number of references left to the given probe_module (out)
+ *
+ * Updates the probe callback corresponding to a range of markers.
+ * Must be called with markers_mutex held.
+ */
+void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module,
+	int *refcount)
+{
+	struct marker *iter;
+	struct marker_entry *mark_entry;
+
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = get_marker(iter->name);
+		if (mark_entry && mark_entry->refcount) {
+			set_marker(&mark_entry, iter);
+			/*
+			 * ignore error, continue
+			 */
+			if (probe_module)
+				if (probe_module ==
+			__module_text_address((unsigned long)mark_entry->probe))
+					(*refcount)++;
+		} else {
+			disable_marker(iter);
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
+static void marker_update_probes(struct module *probe_module)
+{
+	int refcount = 0;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount);
+	/* Markers in modules. */
+	module_update_markers(probe_module, &refcount);
+	if (probe_module && refcount == 0) {
+		synchronize_sched();
+		deferred_sync = 0;
+	}
+	mutex_unlock(&markers_mutex);
+}
+
+/**
+ * marker_probe_register -  Connect a probe to a marker
+ * @name: marker name
+ * @format: format string
+ * @probe: probe handler
+ * @private: probe private data
+ *
+ * private data must be a valid allocated memory address, or NULL.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_probe_register(const char *name, const char *format,
+			marker_probe_func *probe, void *private)
+{
+	struct marker_entry *entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (entry && entry->refcount) {
+		ret = -EBUSY;
+		goto end;
+	}
+	if (deferred_sync) {
+		synchronize_sched();
+		deferred_sync = 0;
+	}
+	ret = add_marker(name, format, probe, private);
+	if (ret)
+		goto end;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_probe_register);
+
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @name: marker name
+ *
+ * Returns the private data given to marker_probe_register, or an ERR_PTR().
+ */
+void *marker_probe_unregister(const char *name)
+{
+	struct module *probe_module;
+	struct marker_entry *entry;
+	void *private;
+	int need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (!entry) {
+		private = ERR_PTR(-ENOENT);
+		goto end;
+	}
+	entry->refcount = 0;
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	private = remove_marker(name);
+	deferred_sync = 1;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(probe_module);
+	return private;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister);
+
+/**
+ * marker_probe_unregister_private_data -  Disconnect a probe from a marker
+ * @private: probe private data
+ *
+ * Unregister a marker by providing the registered private data.
+ * Returns the private data given to marker_probe_register, or an ERR_PTR().
+ */
+void *marker_probe_unregister_private_data(void *private)
+{
+	struct module *probe_module;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *entry;
+	int found = 0;
+	unsigned int i;
+	int need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
+		head = &marker_table[i];
+		hlist_for_each_entry(entry, node, head, hlist) {
+			if (entry->private == private) {
+				found = 1;
+				goto iter_end;
+			}
+		}
+	}
+iter_end:
+	if (!found) {
+		private = ERR_PTR(-ENOENT);
+		goto end;
+	}
+	entry->refcount = 0;
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	private = remove_marker(entry->name);
+	deferred_sync = 1;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(probe_module);
+	return private;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
+
+/**
+ * marker_arm - Arm a marker
+ * @name: marker name
+ *
+ * Activate a marker. It keeps a reference count of the number of
+ * arming/disarming done.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_arm(const char *name)
+{
+	struct marker_entry *entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * Only need to update probes when refcount passes from 0 to 1.
+	 */
+	if (entry->refcount++)
+		goto end;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_arm);
+
+/**
+ * marker_disarm - Disarm a marker
+ * @name: marker name
+ *
+ * Disarm a marker. It keeps a reference count of the number of arming/disarming
+ * done.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_disarm(const char *name)
+{
+	struct marker_entry *entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * Only permit decrement refcount if higher than 0.
+	 * Do probe update only on 1 -> 0 transition.
+	 */
+	if (entry->refcount) {
+		if (--entry->refcount)
+			goto end;
+	} else {
+		ret = -EPERM;
+		goto end;
+	}
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_disarm);
+
+/**
+ * marker_get_private_data - Get a marker's probe private data
+ * @name: marker name
+ *
+ * Returns the private data pointer, or an ERR_PTR.
+ * The private data pointer should _only_ be dereferenced if the caller is the
+ * owner of the data, or its content could vanish. This is mostly used to
+ * confirm that a caller is the owner of a registered probe.
+ */
+void *marker_get_private_data(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name) + 1;
+	u32 hash = jhash(name, name_len-1, 0);
+	int found = 0;
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			return e->private;
+		}
+	}
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(marker_get_private_data);
diff -puN kernel/module.c~linux-kernel-markers kernel/module.c
--- a/kernel/module.c~linux-kernel-markers
+++ a/kernel/module.c
@@ -1673,6 +1673,8 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int markersindex;
+	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1939,6 +1941,9 @@ static struct module *load_module(void _
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 	}
 #endif
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__markers_strings");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -1961,6 +1966,11 @@ static struct module *load_module(void _
 		if (err < 0)
 			goto cleanup;
 	}
+#ifdef CONFIG_MARKERS
+	mod->markers = (void *)sechdrs[markersindex].sh_addr;
+	mod->num_markers =
+		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -1979,6 +1989,11 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+#ifdef CONFIG_MARKERS
+	if (!mod->taints)
+		marker_update_probe_range(mod->markers,
+			mod->markers + mod->num_markers, NULL, NULL);
+#endif
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2570,3 +2585,18 @@ EXPORT_SYMBOL(module_remove_driver);
 void struct_module(struct module *mod) { return; }
 EXPORT_SYMBOL(struct_module);
 #endif
+
+#ifdef CONFIG_MARKERS
+void module_update_markers(struct module *probe_module, int *refcount)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list)
+		if (!mod->taints)
+			marker_update_probe_range(mod->markers,
+				mod->markers + mod->num_markers,
+				probe_module, refcount);
+	mutex_unlock(&module_mutex);
+}
+#endif
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
