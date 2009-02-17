From: akpm@linux-foundation.org
Subject: [merged] latencytop-incorporate-review-feedback-from-andrew-morton.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:09:13 -0800
Message-ID: <200902172009.n1HK9DiM001758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbZBQUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     latencytop: incorporate review feedback from Andrew Morton
has been removed from the -mm tree.  Its filename was
     latencytop-incorporate-review-feedback-from-andrew-morton.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: latencytop: incorporate review feedback from Andrew Morton
From: Arjan van de Ven <arjan@infradead.org>

Andrew had some suggestions for the latencytop file; this patch takes care
of most of these:

* Add documentation
* Turn account_scheduler_latency into an inline function
* Don't report negative values to userspace
* Make the file operations struct const
* Fix a few checkpatch.pl warnings

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/latencytop.h |   10 +++-
 kernel/latencytop.c        |   83 +++++++++++++++++++++++++++++------
 2 files changed, 80 insertions(+), 13 deletions(-)

diff -puN include/linux/latencytop.h~latencytop-incorporate-review-feedback-from-andrew-morton include/linux/latencytop.h
--- a/include/linux/latencytop.h~latencytop-incorporate-review-feedback-from-andrew-morton
+++ a/include/linux/latencytop.h
@@ -9,6 +9,7 @@
 #ifndef _INCLUDE_GUARD_LATENCYTOP_H_
 #define _INCLUDE_GUARD_LATENCYTOP_H_
 
+#include <linux/compiler.h>
 #ifdef CONFIG_LATENCYTOP
 
 #define LT_SAVECOUNT		32
@@ -24,7 +25,14 @@ struct latency_record {
 
 struct task_struct;
 
-void account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+extern int latencytop_enabled;
+void __account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+static inline void
+account_scheduler_latency(struct task_struct *task, int usecs, int inter)
+{
+	if (unlikely(latencytop_enabled))
+		__account_scheduler_latency(task, usecs, inter);
+}
 
 void clear_all_latency_tracing(struct task_struct *p);
 
diff -puN kernel/latencytop.c~latencytop-incorporate-review-feedback-from-andrew-morton kernel/latencytop.c
--- a/kernel/latencytop.c~latencytop-incorporate-review-feedback-from-andrew-morton
+++ a/kernel/latencytop.c
@@ -9,6 +9,44 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+
+/*
+ * CONFIG_LATENCYTOP enables a kernel latency tracking infrastructure that is
+ * used by the "latencytop" userspace tool. The latency that is tracked is not
+ * the 'traditional' interrupt latency (which is primarily caused by something
+ * else consuming CPU), but instead, it is the latency an application encounters
+ * because the kernel sleeps on its behalf for various reasons.
+ *
+ * This code tracks 2 levels of statistics:
+ * 1) System level latency
+ * 2) Per process latency
+ *
+ * The latency is stored in fixed sized data structures in an accumulated form;
+ * if the "same" latency cause is hit twice, this will be tracked as one entry
+ * in the data structure. Both the count, total accumulated latency and maximum
+ * latency are tracked in this data structure. When the fixed size structure is
+ * full, no new causes are tracked until the buffer is flushed by writing to
+ * the /proc file; the userspace tool does this on a regular basis.
+ *
+ * A latency cause is identified by a stringified backtrace at the point that
+ * the scheduler gets invoked. The userland tool will use this string to
+ * identify the cause of the latency in human readable form.
+ *
+ * The information is exported via /proc/latency_stats and /proc/<pid>/latency.
+ * These files look like this:
+ *
+ * Latency Top version : v0.1
+ * 70 59433 4897 i915_irq_wait drm_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl
+ * |    |    |    |
+ * |    |    |    +----> the stringified backtrace
+ * |    |    +---------> The maximum latency for this entry in microseconds
+ * |    +--------------> The accumulated latency for this entry (microseconds)
+ * +-------------------> The number of times this entry is hit
+ *
+ * (note: the average latency is the accumulated latency divided by the number
+ * of times)
+ */
+
 #include <linux/latencytop.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
@@ -72,7 +110,7 @@ account_global_scheduler_latency(struct 
 				firstnonnull = i;
 			continue;
 		}
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat->backtrace[q];
 
 			if (latency_record[i].backtrace[q] != record) {
@@ -101,31 +139,52 @@ account_global_scheduler_latency(struct 
 	memcpy(&latency_record[i], lat, sizeof(struct latency_record));
 }
 
-static inline void store_stacktrace(struct task_struct *tsk, struct latency_record *lat)
+/*
+ * Iterator to store a backtrace into a latency record entry
+ */
+static inline void store_stacktrace(struct task_struct *tsk,
+					struct latency_record *lat)
 {
 	struct stack_trace trace;
 
 	memset(&trace, 0, sizeof(trace));
 	trace.max_entries = LT_BACKTRACEDEPTH;
 	trace.entries = &lat->backtrace[0];
-	trace.skip = 0;
 	save_stack_trace_tsk(tsk, &trace);
 }
 
+/**
+ * __account_scheduler_latency - record an occured latency
+ * @tsk - the task struct of the task hitting the latency
+ * @usecs - the duration of the latency in microseconds
+ * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
+ *
+ * This function is the main entry point for recording latency entries
+ * as called by the scheduler.
+ *
+ * This function has a few special cases to deal with normal 'non-latency'
+ * sleeps: specifically, interruptible sleep longer than 5 msec is skipped
+ * since this usually is caused by waiting for events via select() and co.
+ *
+ * Negative latencies (caused by time going backwards) are also explicitly
+ * skipped.
+ */
 void __sched
-account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
+__account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 {
 	unsigned long flags;
 	int i, q;
 	struct latency_record lat;
 
-	if (!latencytop_enabled)
-		return;
-
 	/* Long interruptible waits are generally user requested... */
 	if (inter && usecs > 5000)
 		return;
 
+	/* Negative sleeps are time going backwards */
+	/* Zero-time sleeps are non-interesting */
+	if (usecs <= 0)
+		return;
+
 	memset(&lat, 0, sizeof(lat));
 	lat.count = 1;
 	lat.time = usecs;
@@ -143,12 +202,12 @@ account_scheduler_latency(struct task_st
 	if (tsk->latency_record_count >= LT_SAVECOUNT)
 		goto out_unlock;
 
-	for (i = 0; i < LT_SAVECOUNT ; i++) {
+	for (i = 0; i < LT_SAVECOUNT; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
 		mylat = &tsk->latency_record[i];
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat.backtrace[q];
 
 			if (mylat->backtrace[q] != record) {
@@ -186,7 +245,7 @@ static int lstats_show(struct seq_file *
 	for (i = 0; i < MAXLR; i++) {
 		if (latency_record[i].backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %li %li ",
+			seq_printf(m, "%i %lu %lu ",
 				latency_record[i].count,
 				latency_record[i].time,
 				latency_record[i].max);
@@ -223,7 +282,7 @@ static int lstats_open(struct inode *ino
 	return single_open(filp, lstats_show, NULL);
 }
 
-static struct file_operations lstats_fops = {
+static const struct file_operations lstats_fops = {
 	.open		= lstats_open,
 	.read		= seq_read,
 	.write		= lstats_write,
@@ -236,4 +295,4 @@ static int __init init_lstats_procfs(voi
 	proc_create("latency_stats", 0644, NULL, &lstats_fops);
 	return 0;
 }
-__initcall(init_lstats_procfs);
+device_initcall(init_lstats_procfs);
_

Patches currently in -mm which might be from arjan@infradead.org are

linux-next.patch
fs-superc-add-lockdep-annotation-to-s_umount.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch
synchronize-device-shutdown.patch
serios-async-shutdown.patch
sd-async-shutdown.patch

