From: akpm@linux-foundation.org
Subject: + sched-proc-sched_debug-fails-on-very-very-large-machines.patch added to -mm tree
Date: Wed, 16 Jan 2013 13:56:59 -0800
Message-ID: <20130116215700.4FC9431C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37354 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3APV5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 16:57:01 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so227029yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 13:57:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, mingo@redhat.com, peterz@infradead.org


The patch titled
     Subject: sched: /proc/sched_debug fails on very very large machines
has been added to the -mm tree.  Its filename is
     sched-proc-sched_debug-fails-on-very-very-large-machines.patch

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
Subject: sched: /proc/sched_debug fails on very very large machines

On systems with 4096 cores attemping to read /proc/sched_debug fails.  We
are trying to push all the data into a single kmalloc buffer.  The issue
is on these very large machines all the data will not fit in 4mb.

A better solution is to not us the single_open mechanism but to provide
our own seq_operations and treat each cpu as an individual record.

The output should be identical to previous version.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/debug.c |   84 +++++++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 11 deletions(-)

diff -puN kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines kernel/sched/debug.c
--- a/kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines
+++ a/kernel/sched/debug.c
@@ -269,11 +269,11 @@ static void print_cpu(struct seq_file *m
 	{
 		unsigned int freq = cpu_khz ? : 1;
 
-		SEQ_printf(m, "\ncpu#%d, %u.%03u MHz\n",
+		SEQ_printf(m, "cpu#%d, %u.%03u MHz\n",
 			   cpu, freq / 1000, (freq % 1000));
 	}
 #else
-	SEQ_printf(m, "\ncpu#%d\n", cpu);
+	SEQ_printf(m, "cpu#%d\n", cpu);
 #endif
 
 #define P(x)								\
@@ -330,6 +330,7 @@ do {									\
 	print_rq(m, rq, cpu);
 	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
+	SEQ_printf(m, "\n");
 }
 
 static const char *sched_tunable_scaling_names[] = {
@@ -338,11 +339,10 @@ static const char *sched_tunable_scaling
 	"linear"
 };
 
-static int sched_debug_show(struct seq_file *m, void *v)
+static void sched_debug_header(struct seq_file *m)
 {
 	u64 ktime, sched_clk, cpu_clk;
 	unsigned long flags;
-	int cpu;
 
 	local_irq_save(flags);
 	ktime = ktime_to_ns(ktime_get());
@@ -384,33 +384,95 @@ static int sched_debug_show(struct seq_f
 #undef PN
 #undef P
 
-	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
+	SEQ_printf(m, "  .%-40s: %d (%s)\n",
+		"sysctl_sched_tunable_scaling",
 		sysctl_sched_tunable_scaling,
 		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+	SEQ_printf(m, "\n");
+}
 
-	for_each_online_cpu(cpu)
-		print_cpu(m, cpu);
+static int sched_debug_show(struct seq_file *m, void *v)
+{
+	int cpu = (unsigned long)(v - 2);
 
-	SEQ_printf(m, "\n");
+	if (cpu != -1)
+		print_cpu(m, cpu);
+	else
+		sched_debug_header(m);
 
 	return 0;
 }
 
 void sysrq_sched_debug_show(void)
 {
-	sched_debug_show(NULL, NULL);
+	int cpu;
+
+	sched_debug_header(NULL);
+	for_each_online_cpu(cpu)
+		print_cpu(NULL, cpu);
+
+}
+
+static void *sched_debug_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	n--;
+
+	if (n > 0)
+		n = cpumask_next(n - 1, cpu_online_mask);
+	else
+		n = cpumask_first(cpu_online_mask);
+
+	*offset = n + 1;
+
+	if (n < nr_cpu_ids)
+		return (void *)(unsigned long)(n + 2);
+	return NULL;
+}
+
+static void *sched_debug_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return sched_debug_start(file, offset);
+}
+
+static void sched_debug_stop(struct seq_file *file, void *data)
+{
+}
+
+
+static const struct seq_operations sched_debug_sops = {
+	.start = sched_debug_start,
+	.next = sched_debug_next,
+	.stop = sched_debug_stop,
+	.show = sched_debug_show,
+};
+
+static int sched_debug_release(struct inode *inode, struct file *file)
+{
+	seq_release(inode, file);
+
+	return 0;
 }
 
 static int sched_debug_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, sched_debug_show, NULL);
+	int ret = 0;
+
+	ret = seq_open(filp, &sched_debug_sops);
+
+	return ret;
 }
 
 static const struct file_operations sched_debug_fops = {
 	.open		= sched_debug_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= sched_debug_release,
 };
 
 static int __init init_sched_debug_procfs(void)
_

Patches currently in -mm which might be from nzimmer@sgi.com are

sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

