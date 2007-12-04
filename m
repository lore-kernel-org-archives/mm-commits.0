From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-support-multiple-probes.patch added to -mm tree
Date: Tue, 04 Dec 2007 11:07:04 -0800
Message-ID: <200712041907.lB4J756K032702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbXLDTIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 14:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, dipankar@in.ibm.com, dsmith@redhat.com, hch@infradead.org, mmlnx@us.ibm.com, paulmck@us.ibm.com


The patch titled
     Linux Kernel Markers: support multiple probes
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-support-multiple-probes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: support multiple probes
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

RCU style multiple probes support for the Linux Kernel Markers.  Common case
(one probe) is still fast and does not require dynamic allocation or a
supplementary pointer dereference on the fast path.

- Move preempt disable from the marker site to the callback.

Since we now have an internal callback, move the preempt disable/enable to the
callback instead of the marker site.

Since the callback change is done asynchronously (passing from a handler that
supports arguments to a handler that does not setup the arguments is no
arguments are passed), we can safely update it even if it is outside the
preempt disable section.

- Move probe arm to probe connection. Now, a connected probe is automatically
  armed.

Remove MARK_MAX_FORMAT_LEN, unused.

This patch modifies the Linux Kernel Markers API : it removes the probe
"arm/disarm" and changes the probe function prototype : it now expects a
va_list * instead of a "...".

If we want to have more than one probe connected to a marker at a given
time (LTTng, or blktrace, ssytemtap) then we need this patch. Without it,
connecting a second probe handler to a marker will fail.

It allow us, for instance, to do interesting combinations :

Do standard tracing with LTTng and, eventually, to compute statistics
with SystemTAP, or to have a special trigger on an event that would call
a systemtap script which would stop flight recorder tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Mason <mmlnx@us.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: David Smith <dsmith@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h          |   59 +-
 include/linux/module.h          |    2 
 kernel/marker.c                 |  671 ++++++++++++++++++++++--------
 kernel/module.c                 |    7 
 samples/markers/probe-example.c |   25 -
 5 files changed, 548 insertions(+), 216 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-support-multiple-probes include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-support-multiple-probes
+++ a/include/linux/marker.h
@@ -19,16 +19,23 @@ struct marker;
 
 /**
  * marker_probe_func - Type of a marker probe function
- * @mdata: pointer of type struct marker
- * @private_data: caller site private data
+ * @probe_private: probe private data
+ * @call_private: call site private data
  * @fmt: format string
- * @...: variable argument list
+ * @args: variable argument list pointer. Use a pointer to overcome C's
+ *        inability to pass this around as a pointer in a portable manner in
+ *        the callee otherwise.
  *
  * Type of marker probe functions. They receive the mdata and need to parse the
  * format string to recover the variable argument list.
  */
-typedef void marker_probe_func(const struct marker *mdata,
-	void *private_data, const char *fmt, ...);
+typedef void marker_probe_func(void *probe_private, void *call_private,
+		const char *fmt, va_list *args);
+
+struct marker_probe_closure {
+	marker_probe_func *func;	/* Callback */
+	void *probe_private;		/* Private probe data */
+};
 
 struct marker {
 	const char *name;	/* Marker name */
@@ -36,8 +43,11 @@ struct marker {
 				 * variable argument list.
 				 */
 	char state;		/* Marker state. */
-	marker_probe_func *call;/* Probe handler function pointer */
-	void *private;		/* Private probe data */
+	char ptype;		/* probe type : 0 : single, 1 : multi */
+	void (*call)(const struct marker *mdata,	/* Probe wrapper */
+		void *call_private, const char *fmt, ...);
+	struct marker_probe_closure single;
+	struct marker_probe_closure *multi;
 } __attribute__((aligned(8)));
 
 #ifdef CONFIG_MARKERS
@@ -49,7 +59,7 @@ struct marker {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __trace_mark(name, call_data, format, args...)			\
+#define __trace_mark(name, call_private, format, args...)		\
 	do {								\
 		static const char __mstrtab_name_##name[]		\
 		__attribute__((section("__markers_strings")))		\
@@ -60,24 +70,23 @@ struct marker {
 		static struct marker __mark_##name			\
 		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
-		0, __mark_empty_function, NULL };			\
+		0, 0, marker_probe_cb,					\
+		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
-			preempt_disable();				\
 			(*__mark_##name.call)				\
-				(&__mark_##name, call_data,		\
+				(&__mark_##name, call_private,		\
 				format, ## args);			\
-			preempt_enable();				\
 		}							\
 	} while (0)
 
 extern void marker_update_probe_range(struct marker *begin,
-	struct marker *end, struct module *probe_module, int *refcount);
+	struct marker *end);
 #else /* !CONFIG_MARKERS */
-#define __trace_mark(name, call_data, format, args...) \
+#define __trace_mark(name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
 static inline void marker_update_probe_range(struct marker *begin,
-	struct marker *end, struct module *probe_module, int *refcount)
+	struct marker *end)
 { }
 #endif /* CONFIG_MARKERS */
 
@@ -92,8 +101,6 @@ static inline void marker_update_probe_r
 #define trace_mark(name, format, args...) \
 	__trace_mark(name, NULL, format, ## args)
 
-#define MARK_MAX_FORMAT_LEN	1024
-
 /**
  * MARK_NOARGS - Format string for a marker with no argument.
  */
@@ -106,24 +113,30 @@ static inline void __printf(1, 2) __mark
 
 extern marker_probe_func __mark_empty_function;
 
+extern void marker_probe_cb(const struct marker *mdata,
+	void *call_private, const char *fmt, ...);
+extern void marker_probe_cb_noarg(const struct marker *mdata,
+	void *call_private, const char *fmt, ...);
+
 /*
  * Connect a probe to a marker.
  * private data pointer must be a valid allocated memory address, or NULL.
  */
 extern int marker_probe_register(const char *name, const char *format,
-				marker_probe_func *probe, void *private);
+				marker_probe_func *probe, void *probe_private);
 
 /*
  * Returns the private data given to marker_probe_register.
  */
-extern void *marker_probe_unregister(const char *name);
+extern int marker_probe_unregister(const char *name,
+	marker_probe_func *probe, void *probe_private);
 /*
  * Unregister a marker by providing the registered private data.
  */
-extern void *marker_probe_unregister_private_data(void *private);
+extern int marker_probe_unregister_private_data(marker_probe_func *probe,
+	void *probe_private);
 
-extern int marker_arm(const char *name);
-extern int marker_disarm(const char *name);
-extern void *marker_get_private_data(const char *name);
+extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
+	int num);
 
 #endif
diff -puN include/linux/module.h~linux-kernel-markers-support-multiple-probes include/linux/module.h
--- a/include/linux/module.h~linux-kernel-markers-support-multiple-probes
+++ a/include/linux/module.h
@@ -462,7 +462,7 @@ int unregister_module_notifier(struct no
 
 extern void print_modules(void);
 
-extern void module_update_markers(struct module *probe_module, int *refcount);
+extern void module_update_markers(void);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
diff -puN kernel/marker.c~linux-kernel-markers-support-multiple-probes kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-support-multiple-probes
+++ a/kernel/marker.c
@@ -27,35 +27,41 @@
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
 
+/* Set to 1 to enable marker debug output */
+const int marker_debug;
+
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
- * and module markers, the hash table and deferred_sync.
+ * and module markers and the hash table.
  */
 static DEFINE_MUTEX(markers_mutex);
 
 /*
- * Marker deferred synchronization.
- * Upon marker probe_unregister, we delay call to synchronize_sched() to
- * accelerate mass unregistration (only when there is no more reference to a
- * given module do we call synchronize_sched()). However, we need to make sure
- * every critical region has ended before we re-arm a marker that has been
- * unregistered and then registered back with a different probe data.
- */
-static int deferred_sync;
-
-/*
  * Marker hash table, containing the active markers.
  * Protected by module_mutex.
  */
 #define MARKER_HASH_BITS 6
 #define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
 
+/*
+ * Note about RCU :
+ * It is used to make sure every handler has finished using its private data
+ * between two consecutive operation (add or remove) on a given marker.  It is
+ * also used to delay the free of multiple probes array until a quiescent state
+ * is reached.
+ */
 struct marker_entry {
 	struct hlist_node hlist;
 	char *format;
-	marker_probe_func *probe;
-	void *private;
+	void (*call)(const struct marker *mdata,	/* Probe wrapper */
+		void *call_private, const char *fmt, ...);
+	struct marker_probe_closure single;
+	struct marker_probe_closure *multi;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
+	struct rcu_head rcu;
+	void *oldptr;
+	char rcu_pending:1;
+	char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
 
@@ -63,7 +69,8 @@ static struct hlist_head marker_table[MA
 
 /**
  * __mark_empty_function - Empty probe callback
- * @mdata: pointer of type const struct marker
+ * @probe_private: probe private data
+ * @call_private: call site private data
  * @fmt: format string
  * @...: variable argument list
  *
@@ -72,13 +79,262 @@ static struct hlist_head marker_table[MA
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-void __mark_empty_function(const struct marker *mdata, void *private,
-	const char *fmt, ...)
+void __mark_empty_function(void *probe_private, void *call_private,
+	const char *fmt, va_list *args)
 {
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
 /*
+ * marker_probe_cb Callback that prepares the variable argument list for probes.
+ * @mdata: pointer of type struct marker
+ * @call_private: caller site private data
+ * @fmt: format string
+ * @...:  Variable argument list.
+ *
+ * Since we do not use "typical" pointer based RCU in the 1 argument case, we
+ * need to put a full smp_rmb() in this branch. This is why we do not use
+ * rcu_dereference() for the pointer read.
+ */
+void marker_probe_cb(const struct marker *mdata, void *call_private,
+	const char *fmt, ...)
+{
+	va_list args;
+	char ptype;
+
+	preempt_disable();
+	ptype = ACCESS_ONCE(mdata->ptype);
+	if (likely(!ptype)) {
+		marker_probe_func *func;
+		/* Must read the ptype before ptr. They are not data dependant,
+		 * so we put an explicit smp_rmb() here. */
+		smp_rmb();
+		func = ACCESS_ONCE(mdata->single.func);
+		/* Must read the ptr before private data. They are not data
+		 * dependant, so we put an explicit smp_rmb() here. */
+		smp_rmb();
+		va_start(args, fmt);
+		func(mdata->single.probe_private, call_private, fmt, &args);
+		va_end(args);
+	} else {
+		struct marker_probe_closure *multi;
+		int i;
+		/*
+		 * multi points to an array, therefore accessing the array
+		 * depends on reading multi. However, even in this case,
+		 * we must insure that the pointer is read _before_ the array
+		 * data. Same as rcu_dereference, but we need a full smp_rmb()
+		 * in the fast path, so put the explicit barrier here.
+		 */
+		smp_read_barrier_depends();
+		multi = ACCESS_ONCE(mdata->multi);
+		for (i = 0; multi[i].func; i++) {
+			va_start(args, fmt);
+			multi[i].func(multi[i].probe_private, call_private, fmt,
+				&args);
+			va_end(args);
+		}
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(marker_probe_cb);
+
+/*
+ * marker_probe_cb Callback that does not prepare the variable argument list.
+ * @mdata: pointer of type struct marker
+ * @call_private: caller site private data
+ * @fmt: format string
+ * @...:  Variable argument list.
+ *
+ * Should be connected to markers "MARK_NOARGS".
+ */
+void marker_probe_cb_noarg(const struct marker *mdata,
+	void *call_private, const char *fmt, ...)
+{
+	va_list args;	/* not initialized */
+	char ptype;
+
+	preempt_disable();
+	ptype = ACCESS_ONCE(mdata->ptype);
+	if (likely(!ptype)) {
+		marker_probe_func *func;
+		/* Must read the ptype before ptr. They are not data dependant,
+		 * so we put an explicit smp_rmb() here. */
+		smp_rmb();
+		func = ACCESS_ONCE(mdata->single.func);
+		/* Must read the ptr before private data. They are not data
+		 * dependant, so we put an explicit smp_rmb() here. */
+		smp_rmb();
+		func(mdata->single.probe_private, call_private, fmt, &args);
+	} else {
+		struct marker_probe_closure *multi;
+		int i;
+		/*
+		 * multi points to an array, therefore accessing the array
+		 * depends on reading multi. However, even in this case,
+		 * we must insure that the pointer is read _before_ the array
+		 * data. Same as rcu_dereference, but we need a full smp_rmb()
+		 * in the fast path, so put the explicit barrier here.
+		 */
+		smp_read_barrier_depends();
+		multi = ACCESS_ONCE(mdata->multi);
+		for (i = 0; multi[i].func; i++)
+			multi[i].func(multi[i].probe_private, call_private, fmt,
+				&args);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
+
+static void free_old_closure(struct rcu_head *head)
+{
+	struct marker_entry *entry = container_of(head,
+		struct marker_entry, rcu);
+	kfree(entry->oldptr);
+	/* Make sure we free the data before setting the pending flag to 0 */
+	smp_wmb();
+	entry->rcu_pending = 0;
+}
+
+static inline void debug_print_probes(struct marker_entry *entry)
+{
+	int i;
+
+	if (!marker_debug)
+		return;
+
+	if (!entry->ptype) {
+		printk(KERN_DEBUG "Single probe : %p %p\n",
+			entry->single.func,
+			entry->single.probe_private);
+	} else {
+		for (i = 0; entry->multi[i].func; i++)
+			printk(KERN_DEBUG "Multi probe %d : %p %p\n", i,
+				entry->multi[i].func,
+				entry->multi[i].probe_private);
+	}
+}
+
+static struct marker_probe_closure *
+marker_entry_add_probe(struct marker_entry *entry,
+		marker_probe_func *probe, void *probe_private)
+{
+	int nr_probes = 0;
+	struct marker_probe_closure *old, *new;
+
+	WARN_ON(!probe);
+
+	debug_print_probes(entry);
+	old = entry->multi;
+	if (!entry->ptype) {
+		if (entry->single.func == probe &&
+				entry->single.probe_private == probe_private)
+			return ERR_PTR(-EBUSY);
+		if (entry->single.func == __mark_empty_function) {
+			/* 0 -> 1 probes */
+			entry->single.func = probe;
+			entry->single.probe_private = probe_private;
+			entry->refcount = 1;
+			entry->ptype = 0;
+			debug_print_probes(entry);
+			return NULL;
+		} else {
+			/* 1 -> 2 probes */
+			nr_probes = 1;
+			old = NULL;
+		}
+	} else {
+		/* (N -> N+1), (N != 0, 1) probes */
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
+			if (old[nr_probes].func == probe
+					&& old[nr_probes].probe_private
+						== probe_private)
+				return ERR_PTR(-EBUSY);
+	}
+	/* + 2 : one for new probe, one for NULL func */
+	new = kzalloc((nr_probes + 2) * sizeof(struct marker_probe_closure),
+			GFP_KERNEL);
+	if (new == NULL)
+		return ERR_PTR(-ENOMEM);
+	if (!old)
+		new[0] = entry->single;
+	else
+		memcpy(new, old,
+			nr_probes * sizeof(struct marker_probe_closure));
+	new[nr_probes].func = probe;
+	new[nr_probes].probe_private = probe_private;
+	entry->refcount = nr_probes + 1;
+	entry->multi = new;
+	entry->ptype = 1;
+	debug_print_probes(entry);
+	return old;
+}
+
+static struct marker_probe_closure *
+marker_entry_remove_probe(struct marker_entry *entry,
+		marker_probe_func *probe, void *probe_private)
+{
+	int nr_probes = 0, nr_del = 0, i;
+	struct marker_probe_closure *old, *new;
+
+	old = entry->multi;
+
+	debug_print_probes(entry);
+	if (!entry->ptype) {
+		/* 0 -> N is an error */
+		WARN_ON(entry->single.func == __mark_empty_function);
+		/* 1 -> 0 probes */
+		WARN_ON(probe && entry->single.func != probe);
+		WARN_ON(entry->single.probe_private != probe_private);
+		entry->single.func = __mark_empty_function;
+		entry->refcount = 0;
+		entry->ptype = 0;
+		debug_print_probes(entry);
+		return NULL;
+	} else {
+		/* (N -> M), (N > 1, M >= 0) probes */
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+			if ((!probe || old[nr_probes].func == probe)
+					&& old[nr_probes].probe_private
+						== probe_private)
+				nr_del++;
+		}
+	}
+
+	if (nr_probes - nr_del == 0) {
+		/* N -> 0, (N > 1) */
+		entry->single.func = __mark_empty_function;
+		entry->refcount = 0;
+		entry->ptype = 0;
+	} else if (nr_probes - nr_del == 1) {
+		/* N -> 1, (N > 1) */
+		for (i = 0; old[i].func; i++)
+			if ((probe && old[i].func != probe) ||
+					old[i].probe_private != probe_private)
+				entry->single = old[i];
+		entry->refcount = 1;
+		entry->ptype = 0;
+	} else {
+		int j = 0;
+		/* N -> M, (N > 1, M > 1) */
+		/* + 1 for NULL */
+		new = kzalloc((nr_probes - nr_del + 1)
+			* sizeof(struct marker_probe_closure), GFP_KERNEL);
+		if (new == NULL)
+			return ERR_PTR(-ENOMEM);
+		for (i = 0; old[i].func; i++)
+			if ((probe && old[i].func != probe) ||
+					old[i].probe_private != probe_private)
+				new[j++] = old[i];
+		entry->refcount = nr_probes - nr_del;
+		entry->ptype = 1;
+		entry->multi = new;
+	}
+	debug_print_probes(entry);
+	return old;
+}
+
+/*
  * Get marker if the marker is present in the marker hash table.
  * Must be called with markers_mutex held.
  * Returns NULL if not present.
@@ -102,8 +358,7 @@ static struct marker_entry *get_marker(c
  * Add the marker to the marker hash table. Must be called with markers_mutex
  * held.
  */
-static int add_marker(const char *name, const char *format,
-	marker_probe_func *probe, void *private)
+static struct marker_entry *add_marker(const char *name, const char *format)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -118,9 +373,8 @@ static int add_marker(const char *name, 
 	hlist_for_each_entry(e, node, head, hlist) {
 		if (!strcmp(name, e->name)) {
 			printk(KERN_NOTICE
-				"Marker %s busy, probe %p already installed\n",
-				name, e->probe);
-			return -EBUSY;	/* Already there */
+				"Marker %s busy\n", name);
+			return ERR_PTR(-EBUSY);	/* Already there */
 		}
 	}
 	/*
@@ -130,34 +384,42 @@ static int add_marker(const char *name, 
 	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
 			GFP_KERNEL);
 	if (!e)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	memcpy(&e->name[0], name, name_len);
 	if (format) {
 		e->format = &e->name[name_len];
 		memcpy(e->format, format, format_len);
+		if (strcmp(e->format, MARK_NOARGS) == 0)
+			e->call = marker_probe_cb_noarg;
+		else
+			e->call = marker_probe_cb;
 		trace_mark(core_marker_format, "name %s format %s",
 				e->name, e->format);
-	} else
+	} else {
 		e->format = NULL;
-	e->probe = probe;
-	e->private = private;
+		e->call = marker_probe_cb;
+	}
+	e->single.func = __mark_empty_function;
+	e->single.probe_private = NULL;
+	e->multi = NULL;
+	e->ptype = 0;
 	e->refcount = 0;
+	e->rcu_pending = 0;
 	hlist_add_head(&e->hlist, head);
-	return 0;
+	return e;
 }
 
 /*
  * Remove the marker from the marker hash table. Must be called with mutex_lock
  * held.
  */
-static void *remove_marker(const char *name)
+static int remove_marker(const char *name)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
 	struct marker_entry *e;
 	int found = 0;
 	size_t len = strlen(name) + 1;
-	void *private = NULL;
 	u32 hash = jhash(name, len-1, 0);
 
 	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
@@ -167,12 +429,16 @@ static void *remove_marker(const char *n
 			break;
 		}
 	}
-	if (found) {
-		private = e->private;
-		hlist_del(&e->hlist);
-		kfree(e);
-	}
-	return private;
+	if (!found)
+		return -ENOENT;
+	if (e->single.func != __mark_empty_function)
+		return -EBUSY;
+	hlist_del(&e->hlist);
+	/* Make sure the call_rcu has been executed */
+	if (e->rcu_pending)
+		rcu_barrier();
+	kfree(e);
+	return 0;
 }
 
 /*
@@ -184,6 +450,7 @@ static int marker_set_format(struct mark
 	size_t name_len = strlen((*entry)->name) + 1;
 	size_t format_len = strlen(format) + 1;
 
+
 	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
 			GFP_KERNEL);
 	if (!e)
@@ -191,11 +458,20 @@ static int marker_set_format(struct mark
 	memcpy(&e->name[0], (*entry)->name, name_len);
 	e->format = &e->name[name_len];
 	memcpy(e->format, format, format_len);
-	e->probe = (*entry)->probe;
-	e->private = (*entry)->private;
+	if (strcmp(e->format, MARK_NOARGS) == 0)
+		e->call = marker_probe_cb_noarg;
+	else
+		e->call = marker_probe_cb;
+	e->single = (*entry)->single;
+	e->multi = (*entry)->multi;
+	e->ptype = (*entry)->ptype;
 	e->refcount = (*entry)->refcount;
+	e->rcu_pending = 0;
 	hlist_add_before(&e->hlist, &(*entry)->hlist);
 	hlist_del(&(*entry)->hlist);
+	/* Make sure the call_rcu has been executed */
+	if ((*entry)->rcu_pending)
+		rcu_barrier();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -206,7 +482,8 @@ static int marker_set_format(struct mark
 /*
  * Sets the probe callback corresponding to one marker.
  */
-static int set_marker(struct marker_entry **entry, struct marker *elem)
+static int set_marker(struct marker_entry **entry, struct marker *elem,
+		int active)
 {
 	int ret;
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
@@ -226,9 +503,43 @@ static int set_marker(struct marker_entr
 		if (ret)
 			return ret;
 	}
-	elem->call = (*entry)->probe;
-	elem->private = (*entry)->private;
-	elem->state = 1;
+
+	/*
+	 * probe_cb setup (statically known) is done here. It is
+	 * asynchronous with the rest of execution, therefore we only
+	 * pass from a "safe" callback (with argument) to an "unsafe"
+	 * callback (does not set arguments).
+	 */
+	elem->call = (*entry)->call;
+	/*
+	 * Sanity check :
+	 * We only update the single probe private data when the ptr is
+	 * set to a _non_ single probe! (0 -> 1 and N -> 1, N != 1)
+	 */
+	WARN_ON(elem->single.func != __mark_empty_function
+		&& elem->single.probe_private
+		!= (*entry)->single.probe_private &&
+		!elem->ptype);
+	elem->single.probe_private = (*entry)->single.probe_private;
+	/*
+	 * Make sure the private data is valid when we update the
+	 * single probe ptr.
+	 */
+	smp_wmb();
+	elem->single.func = (*entry)->single.func;
+	/*
+	 * We also make sure that the new probe callbacks array is consistent
+	 * before setting a pointer to it.
+	 */
+	rcu_assign_pointer(elem->multi, (*entry)->multi);
+	/*
+	 * Update the function or multi probe array pointer before setting the
+	 * ptype.
+	 */
+	smp_wmb();
+	elem->ptype = (*entry)->ptype;
+	elem->state = active;
+
 	return 0;
 }
 
@@ -240,8 +551,12 @@ static int set_marker(struct marker_entr
  */
 static void disable_marker(struct marker *elem)
 {
+	/* leave "call" as is. It is known statically. */
 	elem->state = 0;
-	elem->call = __mark_empty_function;
+	elem->single.func = __mark_empty_function;
+	/* Update the function before setting the ptype */
+	smp_wmb();
+	elem->ptype = 0;	/* single probe */
 	/*
 	 * Leave the private data and id there, because removal is racy and
 	 * should be done only after a synchronize_sched(). These are never used
@@ -253,14 +568,11 @@ static void disable_marker(struct marker
  * marker_update_probe_range - Update a probe range
  * @begin: beginning of the range
  * @end: end of the range
- * @probe_module: module address of the probe being updated
- * @refcount: number of references left to the given probe_module (out)
  *
  * Updates the probe callback corresponding to a range of markers.
  */
 void marker_update_probe_range(struct marker *begin,
-	struct marker *end, struct module *probe_module,
-	int *refcount)
+	struct marker *end)
 {
 	struct marker *iter;
 	struct marker_entry *mark_entry;
@@ -268,15 +580,12 @@ void marker_update_probe_range(struct ma
 	mutex_lock(&markers_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_marker(iter->name);
-		if (mark_entry && mark_entry->refcount) {
-			set_marker(&mark_entry, iter);
+		if (mark_entry) {
+			set_marker(&mark_entry, iter,
+					!!mark_entry->refcount);
 			/*
 			 * ignore error, continue
 			 */
-			if (probe_module)
-				if (probe_module ==
-			__module_text_address((unsigned long)mark_entry->probe))
-					(*refcount)++;
 		} else {
 			disable_marker(iter);
 		}
@@ -289,20 +598,27 @@ void marker_update_probe_range(struct ma
  * Issues a synchronize_sched() when no reference to the module passed
  * as parameter is found in the probes so the probe module can be
  * safely unloaded from now on.
+ *
+ * Internal callback only changed before the first probe is connected to it.
+ * Single probe private data can only be changed on 0 -> 1 and 2 -> 1
+ * transitions.  All other transitions will leave the old private data valid.
+ * This makes the non-atomicity of the callback/private data updates valid.
+ *
+ * "special case" updates :
+ * 0 -> 1 callback
+ * 1 -> 0 callback
+ * 1 -> 2 callbacks
+ * 2 -> 1 callbacks
+ * Other updates all behave the same, just like the 2 -> 3 or 3 -> 2 updates.
+ * Site effect : marker_set_format may delete the marker entry (creating a
+ * replacement).
  */
-static void marker_update_probes(struct module *probe_module)
+static void marker_update_probes(void)
 {
-	int refcount = 0;
-
 	/* Core kernel markers */
-	marker_update_probe_range(__start___markers,
-			__stop___markers, probe_module, &refcount);
+	marker_update_probe_range(__start___markers, __stop___markers);
 	/* Markers in modules. */
-	module_update_markers(probe_module, &refcount);
-	if (probe_module && refcount == 0) {
-		synchronize_sched();
-		deferred_sync = 0;
-	}
+	module_update_markers();
 }
 
 /**
@@ -310,33 +626,49 @@ static void marker_update_probes(struct 
  * @name: marker name
  * @format: format string
  * @probe: probe handler
- * @private: probe private data
+ * @probe_private: probe private data
  *
  * private data must be a valid allocated memory address, or NULL.
  * Returns 0 if ok, error value on error.
+ * The probe address must at least be aligned on the architecture pointer size.
  */
 int marker_probe_register(const char *name, const char *format,
-			marker_probe_func *probe, void *private)
+			marker_probe_func *probe, void *probe_private)
 {
 	struct marker_entry *entry;
 	int ret = 0;
+	struct marker_probe_closure *old;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
-	if (entry && entry->refcount) {
-		ret = -EBUSY;
-		goto end;
-	}
-	if (deferred_sync) {
-		synchronize_sched();
-		deferred_sync = 0;
+	if (!entry) {
+		entry = add_marker(name, format);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto end;
+		}
 	}
-	ret = add_marker(name, format, probe, private);
-	if (ret)
+	/*
+	 * If we detect that a call_rcu is pending for this marker,
+	 * make sure it's executed now.
+	 */
+	if (entry->rcu_pending)
+		rcu_barrier();
+	old = marker_entry_add_probe(entry, probe, probe_private);
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
 		goto end;
+	}
 	mutex_unlock(&markers_mutex);
-	marker_update_probes(NULL);
-	return ret;
+	marker_update_probes();		/* may update entry */
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	WARN_ON(!entry);
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -346,171 +678,166 @@ EXPORT_SYMBOL_GPL(marker_probe_register)
 /**
  * marker_probe_unregister -  Disconnect a probe from a marker
  * @name: marker name
+ * @probe: probe function pointer
+ * @probe_private: probe private data
  *
  * Returns the private data given to marker_probe_register, or an ERR_PTR().
+ * We do not need to call a synchronize_sched to make sure the probes have
+ * finished running before doing a module unload, because the module unload
+ * itself uses stop_machine(), which insures that every preempt disabled section
+ * have finished.
  */
-void *marker_probe_unregister(const char *name)
+int marker_probe_unregister(const char *name,
+	marker_probe_func *probe, void *probe_private)
 {
-	struct module *probe_module;
 	struct marker_entry *entry;
-	void *private;
+	struct marker_probe_closure *old;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry) {
-		private = ERR_PTR(-ENOENT);
+		ret = -ENOENT;
 		goto end;
 	}
-	entry->refcount = 0;
-	/* In what module is the probe handler ? */
-	probe_module = __module_text_address((unsigned long)entry->probe);
-	private = remove_marker(name);
-	deferred_sync = 1;
+	if (entry->rcu_pending)
+		rcu_barrier();
+	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
-	marker_update_probes(probe_module);
-	return private;
+	marker_update_probes();		/* may update entry */
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu(&entry->rcu, free_old_closure);
+	remove_marker(name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);
-	return private;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister);
 
-/**
- * marker_probe_unregister_private_data -  Disconnect a probe from a marker
- * @private: probe private data
- *
- * Unregister a marker by providing the registered private data.
- * Returns the private data given to marker_probe_register, or an ERR_PTR().
- */
-void *marker_probe_unregister_private_data(void *private)
+static struct marker_entry *
+get_marker_from_private_data(marker_probe_func *probe, void *probe_private)
 {
-	struct module *probe_module;
-	struct hlist_head *head;
-	struct hlist_node *node;
 	struct marker_entry *entry;
-	int found = 0;
 	unsigned int i;
+	struct hlist_head *head;
+	struct hlist_node *node;
 
-	mutex_lock(&markers_mutex);
 	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
 		head = &marker_table[i];
 		hlist_for_each_entry(entry, node, head, hlist) {
-			if (entry->private == private) {
-				found = 1;
-				goto iter_end;
+			if (!entry->ptype) {
+				if (entry->single.func == probe
+						&& entry->single.probe_private
+						== probe_private)
+					return entry;
+			} else {
+				struct marker_probe_closure *closure;
+				closure = entry->multi;
+				for (i = 0; closure[i].func; i++) {
+					if (closure[i].func == probe &&
+							closure[i].probe_private
+							== probe_private)
+						return entry;
+				}
 			}
 		}
 	}
-iter_end:
-	if (!found) {
-		private = ERR_PTR(-ENOENT);
-		goto end;
-	}
-	entry->refcount = 0;
-	/* In what module is the probe handler ? */
-	probe_module = __module_text_address((unsigned long)entry->probe);
-	private = remove_marker(entry->name);
-	deferred_sync = 1;
-	mutex_unlock(&markers_mutex);
-	marker_update_probes(probe_module);
-	return private;
-end:
-	mutex_unlock(&markers_mutex);
-	return private;
+	return NULL;
 }
-EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
 
 /**
- * marker_arm - Arm a marker
- * @name: marker name
+ * marker_probe_unregister_private_data -  Disconnect a probe from a marker
+ * @probe: probe function
+ * @probe_private: probe private data
  *
- * Activate a marker. It keeps a reference count of the number of
- * arming/disarming done.
- * Returns 0 if ok, error value on error.
+ * Unregister a probe by providing the registered private data.
+ * Only removes the first marker found in hash table.
+ * Return 0 on success or error value.
+ * We do not need to call a synchronize_sched to make sure the probes have
+ * finished running before doing a module unload, because the module unload
+ * itself uses stop_machine(), which insures that every preempt disabled section
+ * have finished.
  */
-int marker_arm(const char *name)
+int marker_probe_unregister_private_data(marker_probe_func *probe,
+		void *probe_private)
 {
 	struct marker_entry *entry;
 	int ret = 0;
+	struct marker_probe_closure *old;
 
 	mutex_lock(&markers_mutex);
-	entry = get_marker(name);
+	entry = get_marker_from_private_data(probe, probe_private);
 	if (!entry) {
 		ret = -ENOENT;
 		goto end;
 	}
-	/*
-	 * Only need to update probes when refcount passes from 0 to 1.
-	 */
-	if (entry->refcount++)
-		goto end;
-end:
+	if (entry->rcu_pending)
+		rcu_barrier();
+	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
-	marker_update_probes(NULL);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(marker_arm);
-
-/**
- * marker_disarm - Disarm a marker
- * @name: marker name
- *
- * Disarm a marker. It keeps a reference count of the number of arming/disarming
- * done.
- * Returns 0 if ok, error value on error.
- */
-int marker_disarm(const char *name)
-{
-	struct marker_entry *entry;
-	int ret = 0;
-
+	marker_update_probes();		/* may update entry */
 	mutex_lock(&markers_mutex);
-	entry = get_marker(name);
-	if (!entry) {
-		ret = -ENOENT;
-		goto end;
-	}
-	/*
-	 * Only permit decrement refcount if higher than 0.
-	 * Do probe update only on 1 -> 0 transition.
-	 */
-	if (entry->refcount) {
-		if (--entry->refcount)
-			goto end;
-	} else {
-		ret = -EPERM;
-		goto end;
-	}
+	entry = get_marker_from_private_data(probe, probe_private);
+	WARN_ON(!entry);
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu(&entry->rcu, free_old_closure);
+	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);
-	marker_update_probes(NULL);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(marker_disarm);
+EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
 
 /**
  * marker_get_private_data - Get a marker's probe private data
  * @name: marker name
+ * @probe: probe to match
+ * @num: get the nth matching probe's private data
  *
+ * Returns the nth private data pointer (starting from 0) matching, or an
+ * ERR_PTR.
  * Returns the private data pointer, or an ERR_PTR.
  * The private data pointer should _only_ be dereferenced if the caller is the
  * owner of the data, or its content could vanish. This is mostly used to
  * confirm that a caller is the owner of a registered probe.
  */
-void *marker_get_private_data(const char *name)
+void *marker_get_private_data(const char *name, marker_probe_func *probe,
+		int num)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
 	struct marker_entry *e;
 	size_t name_len = strlen(name) + 1;
 	u32 hash = jhash(name, name_len-1, 0);
-	int found = 0;
+	int i;
 
 	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
 	hlist_for_each_entry(e, node, head, hlist) {
 		if (!strcmp(name, e->name)) {
-			found = 1;
-			return e->private;
+			if (!e->ptype) {
+				if (num == 0 && e->single.func == probe)
+					return e->single.probe_private;
+				else
+					break;
+			} else {
+				struct marker_probe_closure *closure;
+				int match = 0;
+				closure = e->multi;
+				for (i = 0; closure[i].func; i++) {
+					if (closure[i].func != probe)
+						continue;
+					if (match++ == num)
+						return closure[i].probe_private;
+				}
+			}
 		}
 	}
 	return ERR_PTR(-ENOENT);
diff -puN kernel/module.c~linux-kernel-markers-support-multiple-probes kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-support-multiple-probes
+++ a/kernel/module.c
@@ -1994,7 +1994,7 @@ static struct module *load_module(void _
 #ifdef CONFIG_MARKERS
 	if (!mod->taints)
 		marker_update_probe_range(mod->markers,
-			mod->markers + mod->num_markers, NULL, NULL);
+			mod->markers + mod->num_markers);
 #endif
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
@@ -2589,7 +2589,7 @@ EXPORT_SYMBOL(struct_module);
 #endif
 
 #ifdef CONFIG_MARKERS
-void module_update_markers(struct module *probe_module, int *refcount)
+void module_update_markers(void)
 {
 	struct module *mod;
 
@@ -2597,8 +2597,7 @@ void module_update_markers(struct module
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
 			marker_update_probe_range(mod->markers,
-				mod->markers + mod->num_markers,
-				probe_module, refcount);
+				mod->markers + mod->num_markers);
 	mutex_unlock(&module_mutex);
 }
 #endif
diff -puN samples/markers/probe-example.c~linux-kernel-markers-support-multiple-probes samples/markers/probe-example.c
--- a/samples/markers/probe-example.c~linux-kernel-markers-support-multiple-probes
+++ a/samples/markers/probe-example.c
@@ -20,31 +20,27 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
-void probe_subsystem_event(const struct marker *mdata, void *private,
-	const char *format, ...)
+void probe_subsystem_event(void *probe_data, void *call_data,
+	const char *format, va_list *args)
 {
-	va_list ap;
 	/* Declare args */
 	unsigned int value;
 	const char *mystr;
 
 	/* Assign args */
-	va_start(ap, format);
-	value = va_arg(ap, typeof(value));
-	mystr = va_arg(ap, typeof(mystr));
+	value = va_arg(*args, typeof(value));
+	mystr = va_arg(*args, typeof(mystr));
 
 	/* Call printk */
-	printk(KERN_DEBUG "Value %u, string %s\n", value, mystr);
+	printk(KERN_INFO "Value %u, string %s\n", value, mystr);
 
 	/* or count, check rights, serialize data in a buffer */
-
-	va_end(ap);
 }
 
 atomic_t eventb_count = ATOMIC_INIT(0);
 
-void probe_subsystem_eventb(const struct marker *mdata, void *private,
-	const char *format, ...)
+void probe_subsystem_eventb(void *probe_data, void *call_data,
+	const char *format, va_list *args)
 {
 	/* Increment counter */
 	atomic_inc(&eventb_count);
@@ -72,10 +68,6 @@ static int __init probe_init(void)
 		if (result)
 			printk(KERN_INFO "Unable to register probe %s\n",
 				probe_array[i].name);
-		result = marker_arm(probe_array[i].name);
-		if (result)
-			printk(KERN_INFO "Unable to arm probe %s\n",
-				probe_array[i].name);
 	}
 	return 0;
 }
@@ -85,7 +77,8 @@ static void __exit probe_fini(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
-		marker_probe_unregister(probe_array[i].name);
+		marker_probe_unregister(probe_array[i].name,
+			probe_array[i].probe_func, &probe_array[i]);
 	printk(KERN_INFO "Number of event b : %u\n",
 			atomic_read(&eventb_count));
 }
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-create-modpost-file.patch
git-x86.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
modules-handle-symbols-that-have-a-zero-value.patch
