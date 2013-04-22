From: akpm@linux-foundation.org
Subject: [merged] timer_list-convert-timer-list-to-be-a-proper-seq_file.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:07:07 -0700
Message-ID: <20130422200707.8980131C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:43895 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3DVUHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:07:09 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so733259qee.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:07:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list: convert timer list to be a proper seq_file
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list: convert timer list to be a proper seq_file

When running with 4096 cores attemping to read /proc/timer_list will fail
with an ENOMEM condition.  On a sufficantly large systems the total amount
of data is more then 4mb, so it won't fit into a single buffer.  The
failure can also occur on smaller systems when memory fragmentation is
high as reported by Dave Jones.

Convert /proc/timer_list to a proper seq_file with its own iterator.  This
is a little more complex given that we have to make two passes with two
separate headers.

sysrq_timer_list_show also needed to be updated to reflect the fact that
now timer_list_show only does one cpu at at time.

[akpm@linux-foundation.org: whitespace fixlet]
[akpm@linux-foundation.org: fix up comment]
[akpm@linux-foundation.org: fix gcc warnings]
[akpm@linux-foundation.org: fix typo in comment]
[akpm@linux-foundation.org: fix comment typos, per Stephen]
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   99 ++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 12 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file
+++ a/kernel/time/timer_list.c
@@ -252,38 +252,113 @@ static int timer_list_show(struct seq_fi
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.7\n");
-	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
-	SEQ_printf(m, "\n");
-
-	for_each_online_cpu(cpu)
+	if (v == (void *)1) {
+		SEQ_printf(m, "Timer List Version: v0.7\n");
+		SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n",
+			   HRTIMER_MAX_CLOCK_BASES);
+		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+		SEQ_printf(m, "\n");
+	} else if (v < (void *)(unsigned long)(nr_cpu_ids + 2)) {
+		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
-
+	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	timer_list_show_tickdevices_header(m);
-	for_each_online_cpu(cpu)
+	else if (v == (void *)(unsigned long)nr_cpu_ids + 2) {
+		timer_list_show_tickdevices_header(m);
+	} else {
+		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
 		print_tickdevice(m, tick_get_device(cpu), cpu);
+	}
 #endif
-
 	return 0;
 }
 
+/*
+ * This iterator really needs some explanation since it is offset and has
+ * two passes, one of which is controlled by a config option.
+ * In hotpluggable systems some cpus, including cpu 0 and the last cpu, may
+ * be missing so we have to use cpumask_* to iterate over the cpus.
+ * For the first pass:
+ * It returns 1 for the header position.
+ * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
+ * On the second pass:
+ * It returns nr_cpu_ids + 1 for the second header position.
+ * For cpu 0 it returns nr_cpu_ids + 2
+ * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
+ * It is also important to remember that cpumask_next returns >= nr_cpu_ids if
+ * no further cpus set.
+ */
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	if (n < nr_cpu_ids + 1) {
+		n = cpumask_next(n - 2, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			n = nr_cpu_ids;
+		*offset = n + 1;
+		return (void *)(unsigned long)(n + 2);
+	}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	if (n == nr_cpu_ids + 1)
+		return (void *)(unsigned long)(nr_cpu_ids + 2);
+
+	if (n < nr_cpu_ids * 2 + 2) {
+		n -= (nr_cpu_ids + 2);
+		n = cpumask_next(n - 1, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			return NULL;
+		*offset = n + 2 + nr_cpu_ids;
+		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
+	}
+#endif
+
+	return NULL;
+}
+
+static void *timer_list_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return timer_list_start(file, offset);
+}
+
+static void timer_list_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations timer_list_sops = {
+	.start = timer_list_start,
+	.next = timer_list_next,
+	.stop = timer_list_stop,
+	.show = timer_list_show,
+};
+
 void sysrq_timer_list_show(void)
 {
 	timer_list_show(NULL, NULL);
 }
 
+static int timer_list_release(struct inode *inode, struct file *filep)
+{
+	seq_release(inode, filep);
+
+	return 0;
+}
+
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open(filp, &timer_list_sops);
 }
 
 static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= timer_list_release,
 };
 
 static int __init init_timer_list_procfs(void)
_

Patches currently in -mm which might be from nzimmer@sgi.com are

linux-next.patch

