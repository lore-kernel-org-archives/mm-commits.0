From: akpm@linux-foundation.org
Subject: [merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-v5.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:07:10 -0700
Message-ID: <20130422200710.7B5925A4265@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:49512 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3DVUHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:07:12 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so733261vbb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:07:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v5
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v5

v5: Use seq_open_private and supply a proper iterator rather then a big mess.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |  130 +++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 70 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v5 kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v5
+++ a/kernel/time/timer_list.c
@@ -20,6 +20,13 @@
 
 #include <asm/uaccess.h>
 
+
+struct timer_list_iter {
+	int cpu;
+	bool second_pass;
+	u64 now;
+};
+
 typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
 
 DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
@@ -247,86 +254,80 @@ static void timer_list_show_tickdevices_
 }
 #endif
 
+static inline void timer_list_header(struct seq_file *m, u64 now)
+{
+	SEQ_printf(m, "Timer List Version: v0.7\n");
+	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
+	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "\n");
+}
+
 static int timer_list_show(struct seq_file *m, void *v)
 {
+	struct timer_list_iter *iter = v;
 	u64 now = ktime_to_ns(ktime_get());
-	int cpu;
 
-	if (v == (void *)1) {
-		SEQ_printf(m, "Timer List Version: v0.7\n");
-		SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n",
-			   HRTIMER_MAX_CLOCK_BASES);
-		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
-		SEQ_printf(m, "\n");
-	} else if (v < (void *)(unsigned long)(nr_cpu_ids + 2)) {
-		cpu = (unsigned long)(v - 2);
-		print_cpu(m, cpu, now);
-	}
+	if (iter->cpu == -1 && !iter->second_pass)
+		timer_list_header(m, now);
+	else if (!iter->second_pass)
+		print_cpu(m, iter->cpu, iter->now);
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	else if (v == (void *)(unsigned long)nr_cpu_ids + 2) {
+	else if (iter->cpu == -1 && iter->second_pass)
 		timer_list_show_tickdevices_header(m);
-	} else {
-		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
-		print_tickdevice(m, tick_get_device(cpu), cpu);
-	}
+	else
+		print_tickdevice(m, tick_get_device(iter->cpu), iter->cpu);
 #endif
 	return 0;
 }
 
-/*
- * This iterator really needs some explanation since it is offset and has
- * two passes, one of which is controlled by a config option.
- * In hotpluggable systems some cpus, including cpu 0 and the last cpu, may
- * be missing so we have to use cpumask_* to iterate over the cpus.
- * For the first pass:
- * It returns 1 for the header position.
- * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
- * On the second pass:
- * It returns nr_cpu_ids + 1 for the second header position.
- * For cpu 0 it returns nr_cpu_ids + 2
- * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
- * It is also important to remember that cpumask_next returns >= nr_cpu_ids if
- * no further cpus set.
- */
-static void *timer_list_start(struct seq_file *file, loff_t *offset)
+void sysrq_timer_list_show(void)
 {
-	unsigned long n = *offset;
+	u64 now = ktime_to_ns(ktime_get());
+	int cpu;
 
-	if (n == 0)
-		return (void *) 1;
+	timer_list_header(NULL, now);
 
-	if (n < nr_cpu_ids + 1) {
-		n = cpumask_next(n - 2, cpu_online_mask);
-		if (n >= nr_cpu_ids)
-			n = nr_cpu_ids;
-		*offset = n + 1;
-		return (void *)(unsigned long)(n + 2);
-	}
+	for_each_online_cpu(cpu)
+		print_cpu(NULL, cpu, now);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	if (n == nr_cpu_ids + 1)
-		return (void *)(unsigned long)(nr_cpu_ids + 2);
+	timer_list_show_tickdevices_header(NULL);
+	for_each_online_cpu(cpu)
+		print_tickdevice(NULL, tick_get_device(cpu), cpu);
+#endif
+	return;
+}
+
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
 
-	if (n < nr_cpu_ids * 2 + 2) {
-		n -= (nr_cpu_ids + 2);
-		n = cpumask_next(n - 1, cpu_online_mask);
-		if (n >= nr_cpu_ids)
+	if (!*offset) {
+		iter->cpu = -1;
+		iter->now = ktime_to_ns(ktime_get());
+	} else if (iter->cpu >= nr_cpu_ids) {
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+		if (!iter->second_pass) {
+			iter->cpu = -1;
+			iter->second_pass = true;
+		} else
 			return NULL;
-		*offset = n + 2 + nr_cpu_ids;
-		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
-	}
+#else
+		return NULL;
 #endif
-
-	return NULL;
+	}
+	return iter;
 }
 
-static void *timer_list_next(struct seq_file *file, void *data, loff_t *offset)
+static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
 {
-	(*offset)++;
+	struct timer_list_iter *iter = file->private;
+	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
+	++*offset;
 	return timer_list_start(file, offset);
 }
 
-static void timer_list_stop(struct seq_file *file, void *data)
+static void timer_list_stop(struct seq_file *seq, void *v)
 {
 }
 
@@ -337,28 +338,17 @@ static const struct seq_operations timer
 	.show = timer_list_show,
 };
 
-void sysrq_timer_list_show(void)
-{
-	timer_list_show(NULL, NULL);
-}
-
-static int timer_list_release(struct inode *inode, struct file *filep)
-{
-	seq_release(inode, filep);
-
-	return 0;
-}
