From: akpm@linux-foundation.org
Subject: + timer_list-convert-timer-list-to-be-a-proper-seq_file.patch added to -mm tree
Date: Wed, 16 Jan 2013 14:12:52 -0800
Message-ID: <20130116221253.40972100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59357 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3APWMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 17:12:54 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so228911qch.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 14:12:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     Subject: timer_list: convert timer list to be a proper seq_file
has been added to the -mm tree.  Its filename is
     timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   88 +++++++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 12 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file
+++ a/kernel/time/timer_list.c
@@ -253,38 +253,102 @@ static int timer_list_show(struct seq_fi
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
+	} else if (v < (void *)(nr_cpu_ids + 2)) {
+		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
-
+	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	timer_list_show_tickdevices_header(m);
-	for_each_online_cpu(cpu)
+	else if (v == (void *)nr_cpu_ids + 2) {
+		timer_list_show_tickdevices_header(m);
+	} else {
+		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
 		print_tickdevice(m, tick_get_device(cpu), cpu);
+	}
 #endif
-
 	return 0;
 }
 
+
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	if (n < nr_cpu_ids + 1) {
+		n--;
+		if (n > 0)
+			n = cpumask_next(n - 1, cpu_online_mask);
+		else
+			n = cpumask_first(cpu_online_mask);
+		*offset = n + 1;
+		return (void *)(unsigned long)(n + 2);
+	}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	if (n == nr_cpu_ids + 1)
+		return (void *) (nr_cpu_ids + 2);
+
+	if (n < nr_cpu_ids * 2 + 2) {
+		n -= (nr_cpu_ids + 2);
+		if (n > 0)
+			n = cpumask_next(n - 1, cpu_online_mask);
+		else
+			n = cpumask_first(cpu_online_mask);
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

timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch

