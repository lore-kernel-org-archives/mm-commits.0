From: akpm@linux-foundation.org
Subject: + ftrace-printk-formatting-infrastructure.patch added to -mm tree
Date: Mon, 04 Aug 2008 19:42:08 -0700
Message-ID: <200808050242.m752g8LL012848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347AbYHECnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 22:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com


The patch titled
     ftrace: printk formatting infrastructure
has been added to the -mm tree.  Its filename is
     ftrace-printk-formatting-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: printk formatting infrastructure
From: Steven Rostedt <rostedt@goodmis.org>

This patch adds a feature that can help kernel developers debug their
code using ftrace.

  int ftrace_printk(const char *fmt, ...);

This records into the ftrace buffer using printf formatting. The entry
size in the buffers are still a fixed length. A new type has been added
that allows for more entries to be used for a single recording.

The start of the print is still the same as the other entries.

It returns the number of characters written to the ftrace buffer.

For example:

Having a module with the following code:

static int __init ftrace_print_test(void)
{
        ftrace_printk("jiffies are %ld\n", jiffies);
        return 0;
}

Gives me:

  insmod-5441  3...1 7569us : ftrace_print_test: jiffies are 4296626666

for the latency_trace file and:

          insmod-5441  [03]  1959.370498: ftrace_print_test jiffies are 4296626666

for the trace file.

Note: Only the infrastructure should go into the kernel. It is to help
facilitate debugging for other kernel developers. Calls to ftrace_printk
is not intended to be left in the kernel, and should be frowned upon just
like scattering printks around in the code.

But having this easily at your fingertips helps the debugging go faster
and bugs be solved quicker.

Maybe later on, we can hook this with markers and have their printf format
be sucked into ftrace output.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h        |    9 +
 kernel/trace/trace.c          |  273 ++++++++++++++++++++++++++++----
 kernel/trace/trace.h          |   11 +
 kernel/trace/trace_selftest.c |   11 -
 4 files changed, 271 insertions(+), 33 deletions(-)

diff -puN include/linux/ftrace.h~ftrace-printk-formatting-infrastructure include/linux/ftrace.h
--- a/include/linux/ftrace.h~ftrace-printk-formatting-infrastructure
+++ a/include/linux/ftrace.h
@@ -136,9 +136,18 @@ static inline void tracer_disable(void)
 #ifdef CONFIG_TRACING
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
+# define ftrace_printk(x...) __ftrace_printk(_THIS_IP_, x)
+extern int
+__ftrace_printk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
+static inline int
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)))
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_FTRACE_H */
diff -puN kernel/trace/trace.c~ftrace-printk-formatting-infrastructure kernel/trace/trace.c
--- a/kernel/trace/trace.c~ftrace-printk-formatting-infrastructure
+++ a/kernel/trace/trace.c
@@ -197,12 +197,14 @@ unsigned long nsecs_to_usecs(unsigned lo
  *  NEED_RESCED - reschedule is requested
  *  HARDIRQ	- inside an interrupt handler
  *  SOFTIRQ	- inside a softirq handler
+ *  CONT	- multiple entries hold the trace item
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_NEED_RESCHED		= 0x02,
 	TRACE_FLAG_HARDIRQ		= 0x04,
 	TRACE_FLAG_SOFTIRQ		= 0x08,
+	TRACE_FLAG_CONT			= 0x10,
 };
 
 /*
@@ -1074,6 +1076,7 @@ enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
+/* Return the current entry.  */
 static struct trace_entry *
 trace_entry_idx(struct trace_array *tr, struct trace_array_cpu *data,
 		struct trace_iterator *iter, int cpu)
@@ -1104,8 +1107,58 @@ trace_entry_idx(struct trace_array *tr, 
 	return &array[iter->next_page_idx[cpu]];
 }
 
+/* Increment the index counter of an iterator by one */
+static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+{
+	iter->idx++;
+	iter->next_idx[cpu]++;
+	iter->next_page_idx[cpu]++;
+
+	if (iter->next_page_idx[cpu] >= ENTRIES_PER_PAGE) {
+		struct trace_array_cpu *data = iter->tr->data[cpu];
+
+		iter->next_page_idx[cpu] = 0;
+		iter->next_page[cpu] =
+			trace_next_list(data, iter->next_page[cpu]);
+	}
+}
+
 static struct trace_entry *
-find_next_entry(struct trace_iterator *iter, int *ent_cpu)
+trace_entry_next(struct trace_array *tr, struct trace_array_cpu *data,
+		 struct trace_iterator *iter, int cpu)
+{
+	struct list_head *next_page;
+	struct trace_entry *ent;
+	int idx, next_idx, next_page_idx;
+
+	ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+	if (likely(!ent || ent->type != TRACE_CONT))
+		return ent;
+
+	/* save the iterator details */
+	idx		= iter->idx;
+	next_idx	= iter->next_idx[cpu];
+	next_page_idx	= iter->next_page_idx[cpu];
+	next_page	= iter->next_page[cpu];
+
+	/* find a real entry */
+	do {
+		trace_iterator_increment(iter, cpu);
+		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+	} while (ent && ent->type != TRACE_CONT);
+
+	/* reset the iterator */
+	iter->idx			= idx;
+	iter->next_idx[cpu]		= next_idx;
+	iter->next_page_idx[cpu]	= next_page_idx;
+	iter->next_page[cpu]		= next_page;
+
+	return ent;
+}
+
+static struct trace_entry *
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu, int inc)
 {
 	struct trace_array *tr = iter->tr;
 	struct trace_entry *ent, *next = NULL;
@@ -1115,7 +1168,23 @@ find_next_entry(struct trace_iterator *i
 	for_each_tracing_cpu(cpu) {
 		if (!head_page(tr->data[cpu]))
 			continue;
+
 		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+		if (ent && ent->type == TRACE_CONT) {
+			struct trace_array_cpu *data = tr->data[cpu];
+
+			if (!inc)
+				ent = trace_entry_next(tr, data, iter, cpu);
+			else {
+				while (ent && ent->type == TRACE_CONT) {
+					trace_iterator_increment(iter, cpu);
+					ent = trace_entry_idx(tr, tr->data[cpu],
+							      iter, cpu);
+				}
+			}
+		}
+
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
@@ -1131,25 +1200,39 @@ find_next_entry(struct trace_iterator *i
 	return next;
 }
 
-static void trace_iterator_increment(struct trace_iterator *iter)
+/* Find the next real entry, without updating the iterator itself */
+static struct trace_entry *
+find_next_entry(struct trace_iterator *iter, int *ent_cpu)
 {
-	iter->idx++;
-	iter->next_idx[iter->cpu]++;
-	iter->next_page_idx[iter->cpu]++;
+	return __find_next_entry(iter, ent_cpu, 0);
+}
 
-	if (iter->next_page_idx[iter->cpu] >= ENTRIES_PER_PAGE) {
-		struct trace_array_cpu *data = iter->tr->data[iter->cpu];
+/* Find the next real entry, and increment the iterator to the next entry */
+static void *find_next_entry_inc(struct trace_iterator *iter)
+{
+	struct trace_entry *next;
+	int next_cpu = -1;
 
-		iter->next_page_idx[iter->cpu] = 0;
-		iter->next_page[iter->cpu] =
-			trace_next_list(data, iter->next_page[iter->cpu]);
-	}
+	next = __find_next_entry(iter, &next_cpu, 1);
+
+	iter->prev_ent = iter->ent;
+	iter->prev_cpu = iter->cpu;
+
+	iter->ent = next;
+	iter->cpu = next_cpu;
+
+	if (next)
+		trace_iterator_increment(iter, iter->cpu);
+
+	return next ? iter : NULL;
 }
 
 static void trace_consume(struct trace_iterator *iter)
 {
 	struct trace_array_cpu *data = iter->tr->data[iter->cpu];
+	struct trace_entry *ent;
 
+ again:
 	data->trace_tail_idx++;
 	if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
 		data->trace_tail = trace_next_page(data, data->trace_tail);
@@ -1160,25 +1243,11 @@ static void trace_consume(struct trace_i
 	if (data->trace_head == data->trace_tail &&
 	    data->trace_head_idx == data->trace_tail_idx)
 		data->trace_idx = 0;
-}
-
-static void *find_next_entry_inc(struct trace_iterator *iter)
-{
-	struct trace_entry *next;
-	int next_cpu = -1;
-
-	next = find_next_entry(iter, &next_cpu);
-
-	iter->prev_ent = iter->ent;
-	iter->prev_cpu = iter->cpu;
-
-	iter->ent = next;
-	iter->cpu = next_cpu;
 
-	if (next)
-		trace_iterator_increment(iter);
-
-	return next ? iter : NULL;
+	ent = trace_entry_idx(iter->tr, iter->tr->data[iter->cpu],
+			      iter, iter->cpu);
+	if (ent && ent->type == TRACE_CONT)
+		goto again;
 }
 
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1473,6 +1542,26 @@ lat_print_timestamp(struct trace_seq *s,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
+static void
+trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
+{
+	struct trace_array *tr = iter->tr;
+	struct trace_array_cpu *data = tr->data[iter->cpu];
+	struct trace_entry *ent;
+
+	ent = trace_entry_idx(tr, data, iter, iter->cpu);
+	if (!ent || ent->type != TRACE_CONT) {
+		trace_seq_putc(s, '\n');
+		return;
+	}
+
+	do {
+		trace_seq_printf(s, "%s", ent->cont.buf);
+		trace_iterator_increment(iter, iter->cpu);
+		ent = trace_entry_idx(tr, data, iter, iter->cpu);
+	} while (ent && ent->type == TRACE_CONT);
+}
+
 static int
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
@@ -1491,6 +1580,10 @@ print_lat_fmt(struct trace_iterator *ite
 
 	if (!next_entry)
 		next_entry = entry;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	rel_usecs = ns2usecs(next_entry->field.t - entry->field.t);
 	abs_usecs = ns2usecs(entry->field.t - iter->tr->time_start);
 
@@ -1550,6 +1643,12 @@ print_lat_fmt(struct trace_iterator *ite
 		}
 		trace_seq_puts(s, "\n");
 		break;
+	case TRACE_PRINT:
+		seq_print_ip_sym(s, field->print.ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->print.buf);
+		if (field->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1571,6 +1670,10 @@ static int print_trace_fmt(struct trace_
 	int i;
 
 	entry = iter->ent;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	field = &entry->field;
 
 	comm = trace_find_cmdline(iter->ent->field.pid);
@@ -1653,6 +1756,12 @@ static int print_trace_fmt(struct trace_
 		if (!ret)
 			return 0;
 		break;
+	case TRACE_PRINT:
+		seq_print_ip_sym(s, field->print.ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->print.buf);
+		if (field->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	}
 	return 1;
 }
@@ -1666,6 +1775,10 @@ static int print_raw_fmt(struct trace_it
 	int S, T;
 
 	entry = iter->ent;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	field = &entry->field;
 
 	ret = trace_seq_printf(s, "%d %d %llu ",
@@ -1708,6 +1821,12 @@ static int print_raw_fmt(struct trace_it
 		if (!ret)
 			return 0;
 		break;
+	case TRACE_PRINT:
+		trace_seq_printf(s, "# %lx %s",
+				 field->print.ip, field->print.buf);
+		if (field->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	}
 	return 1;
 }
@@ -1733,6 +1852,10 @@ static int print_hex_fmt(struct trace_it
 	int S, T;
 
 	entry = iter->ent;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	field = &entry->field;
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->pid);
@@ -1778,6 +1901,10 @@ static int print_bin_fmt(struct trace_it
 	struct trace_field *field;
 
 	entry = iter->ent;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	field = &entry->field;
 
 	SEQ_PUT_FIELD_RET(s, field->pid);
@@ -2943,6 +3070,94 @@ static __init void tracer_init_debugfs(v
 #endif
 }
 
+#define TRACE_BUF_SIZE 1024
+#define TRACE_PRINT_BUF_SIZE \
+	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
+#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
+
+/**
+ * ftrace_printk - printf formatting in the ftrace buffer
+ * @fmt - the printf format for printing.
+ *
+ * Note: __ftrace_printk is an internal function for ftrace_printk and
+ *       the @ip is passed in via the ftrace_printk macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please reframe from leaving ftrace_printks scattered around in
+ * your code.
+ */
+int __ftrace_printk(unsigned long ip, const char *fmt, ...)
+{
+	struct trace_array *tr = &global_trace;
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static char trace_buf[TRACE_BUF_SIZE];
+	struct trace_array_cpu *data;
+	struct trace_entry *entry;
+	unsigned long flags;
+	long disabled;
+	va_list ap;
+	int cpu, len = 0, write, written = 0;
+
+	if (likely(!ftrace_function_enabled))
+		return 0;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (unlikely(disabled != 1 || !ftrace_function_enabled))
+		goto out;
+
+	spin_lock(&trace_buf_lock);
+	va_start(ap, fmt);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
+	va_end(ap);
+
+	len = min(len, TRACE_BUF_SIZE-1);
+	trace_buf[len] = 0;
+
+	__raw_spin_lock(&data->lock);
+	entry				= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type			= TRACE_PRINT;
+	entry->field.print.ip		= ip;
+
+	write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
+
+	memcpy(&entry->field.print.buf, trace_buf, write);
+	entry->field.print.buf[write] = 0;
+	written = write;
+
+	if (written != len)
+		entry->field.flags |= TRACE_FLAG_CONT;
+
+	while (written != len) {
+		entry = tracing_get_trace_entry(tr, data);
+
+		entry->type = TRACE_CONT;
+		write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
+		memcpy(&entry->cont.buf, trace_buf+written, write);
+		entry->cont.buf[write] = 0;
+		written += write;
+	}
+	__raw_spin_unlock(&data->lock);
+
+	spin_unlock(&trace_buf_lock);
+
+ out:
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(__ftrace_printk);
+
 static int trace_alloc_page(void)
 {
 	struct trace_array_cpu *data;
diff -puN kernel/trace/trace.h~ftrace-printk-formatting-infrastructure kernel/trace/trace.h
--- a/kernel/trace/trace.h~ftrace-printk-formatting-infrastructure
+++ a/kernel/trace/trace.h
@@ -13,7 +13,9 @@ enum trace_type {
 	TRACE_FN,
 	TRACE_CTX,
 	TRACE_WAKE,
+	TRACE_CONT,
 	TRACE_STACK,
+	TRACE_PRINT,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
@@ -61,6 +63,14 @@ struct stack_entry {
 };
 
 /*
+ * ftrace_printk entry:
+ */
+struct print_entry {
+	unsigned long		ip;
+	char			buf[];
+};
+
+/*
  * The trace field - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
  *
@@ -77,6 +87,7 @@ struct trace_field {
 		struct ctx_switch_entry		ctx;
 		struct special_entry		special;
 		struct stack_entry		stack;
+		struct print_entry		print;
 		struct mmiotrace_rw		mmiorw;
 		struct mmiotrace_map		mmiomap;
 	};
diff -puN kernel/trace/trace_selftest.c~ftrace-printk-formatting-infrastructure kernel/trace/trace_selftest.c
--- a/kernel/trace/trace_selftest.c~ftrace-printk-formatting-infrastructure
+++ a/kernel/trace/trace_selftest.c
@@ -9,7 +9,9 @@ static inline int trace_valid_entry(stru
 	case TRACE_FN:
 	case TRACE_CTX:
 	case TRACE_WAKE:
+	case TRACE_CONT:
 	case TRACE_STACK:
+	case TRACE_PRINT:
 	case TRACE_SPECIAL:
 		return 1;
 	}
@@ -120,11 +122,11 @@ int trace_selftest_startup_dynamic_traci
 					   struct trace_array *tr,
 					   int (*func)(void))
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
 	char *func_name;
+	int ret;
 
 	/* The ftrace test PASSED */
 	printk(KERN_CONT "PASSED\n");
@@ -157,6 +159,7 @@ int trace_selftest_startup_dynamic_traci
 	/* enable tracing */
 	tr->ctrl = 1;
 	trace->init(tr);
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 
@@ -212,10 +215,10 @@ int trace_selftest_startup_dynamic_traci
 int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
+	int ret;
 
 	/* make sure msleep has been recorded */
 	msleep(1);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch

