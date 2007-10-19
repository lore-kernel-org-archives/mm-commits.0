From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-coding-style-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:35:24 -0700
Message-ID: <200710190435.l9J4ZOBu015382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbXJSEfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers - Coding Style Fixes
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-coding-style-fixes.patch

This patch was dropped because it was folded into linux-kernel-markers.patch

------------------------------------------------------
Subject: Linux Kernel Markers - Coding Style Fixes
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

- Use struct marker instead of struct __mark_marker.
- Change a "private_data" parameter name for "private".
- DEFINE_MUTEX(markers_mutex) is made static.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |   18 +++++++++---------
 include/linux/module.h |    2 +-
 kernel/marker.c        |   22 ++++++++++------------
 3 files changed, 20 insertions(+), 22 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-coding-style-fixes include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-coding-style-fixes
+++ a/include/linux/marker.h
@@ -15,11 +15,11 @@
 #include <linux/types.h>
 
 struct module;
-struct __mark_marker;
+struct marker;
 
 /**
  * marker_probe_func - Type of a marker probe function
- * @mdata: pointer of type struct __mark_marker
+ * @mdata: pointer of type struct marker
  * @private_data: caller site private data
  * @fmt: format string
  * @...: variable argument list
@@ -27,10 +27,10 @@ struct __mark_marker;
  * Type of marker probe functions. They receive the mdata and need to parse the
  * format string to recover the variable argument list.
  */
-typedef void marker_probe_func(const struct __mark_marker *mdata,
+typedef void marker_probe_func(const struct marker *mdata,
 	void *private_data, const char *fmt, ...);
 
-struct __mark_marker {
+struct marker {
 	const char *name;	/* Marker name */
 	const char *format;	/* Marker format string, describing the
 				 * variable argument list.
@@ -57,7 +57,7 @@ struct __mark_marker {
 		static const char __mstrtab_format_##name[]		\
 		__attribute__((section("__markers_strings")))		\
 		= format;						\
-		static struct __mark_marker __mark_##name		\
+		static struct marker __mark_##name			\
 		__attribute__((section("__markers"))) =			\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
@@ -72,13 +72,13 @@ struct __mark_marker {
 		}							\
 	} while (0)
 
-extern void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module, int *refcount);
+extern void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount);
 #else /* !CONFIG_MARKERS */
 #define __trace_mark(name, call_data, format, args...) \
 		__mark_check_format(format, ## args)
-static inline void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module, int *refcount)
+static inline void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount)
 { }
 #endif /* CONFIG_MARKERS */
 
diff -puN include/linux/module.h~linux-kernel-markers-coding-style-fixes include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers-coding-style-fixes
+++ a/include/linux/module.h
@@ -356,7 +356,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_MARKERS
-	struct __mark_marker *markers;
+	struct marker *markers;
 	unsigned int num_markers;
 #endif
 };
diff -puN kernel/marker.c~linux-kernel-markers-coding-style-fixes kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-coding-style-fixes
+++ a/kernel/marker.c
@@ -24,14 +24,14 @@
 #include <linux/marker.h>
 #include <linux/err.h>
 
-extern struct __mark_marker __start___markers[];
-extern struct __mark_marker __stop___markers[];
+extern struct marker __start___markers[];
+extern struct marker __stop___markers[];
 
 /*
  * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
  * and module markers, the hash table and deferred_sync.
  */
-DEFINE_MUTEX(markers_mutex);
+static DEFINE_MUTEX(markers_mutex);
 
 /*
  * Marker deferred synchronization.
@@ -63,7 +63,7 @@ static struct hlist_head marker_table[MA
 
 /**
  * __mark_empty_function - Empty probe callback
- * @mdata: pointer of type const struct __mark_marker
+ * @mdata: pointer of type const struct marker
  * @fmt: format string
  * @...: variable argument list
  *
@@ -72,8 +72,7 @@ static struct hlist_head marker_table[MA
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-void __mark_empty_function(const struct __mark_marker *mdata,
-	void *private_data,
+void __mark_empty_function(const struct marker *mdata, void *private,
 	const char *fmt, ...)
 {
 }
@@ -207,8 +206,7 @@ static int marker_set_format(struct mark
 /*
  * Sets the probe callback corresponding to one marker.
  */
-static int set_marker(struct marker_entry **entry,
-			struct __mark_marker *elem)
+static int set_marker(struct marker_entry **entry, struct marker *elem)
 {
 	int ret;
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
@@ -240,7 +238,7 @@ static int set_marker(struct marker_entr
  * empty function insures that the original callback is not used anymore. This
  * insured by preemption disabling around the call site.
  */
-static void disable_marker(struct __mark_marker *elem)
+static void disable_marker(struct marker *elem)
 {
 	elem->state = 0;
 	elem->call = __mark_empty_function;
@@ -261,11 +259,11 @@ static void disable_marker(struct __mark
  * Updates the probe callback corresponding to a range of markers.
  * Must be called with markers_mutex held.
  */
-void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module,
+void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module,
 	int *refcount)
 {
-	struct __mark_marker *iter;
+	struct marker *iter;
 	struct marker_entry *mark_entry;
 
 	for (iter = begin; iter < end; iter++) {
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
