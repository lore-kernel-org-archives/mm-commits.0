From: akpm@linux-foundation.org
Subject: [merged] sched-proc-sched_stat-fails-on-very-very-large-machines.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:51:05 -0800
Message-ID: <20130227205105.BACE531C233@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35823 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3B0UvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:07 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so112191yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, fengguang.wu@intel.com, mingo@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: /proc/sched_stat fails on very very large machines
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_stat-fails-on-very-very-large-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: sched: /proc/sched_stat fails on very very large machines

On systems with 4096 cores doing a cat /proc/sched_stat fails.  We are
trying to push all the data into a single kmalloc buffer.  The issue is on
these very large machines all the data will not fit in 4mb.

A better solution is to not use the single_open() mechanism but to provide
our own seq_operations.

The output should be identical to previous version and thus not need the
version number.

[akpm@linux-foundation.org: fix memleak]
[akpm@linux-foundation.org: fix spello in comment]
[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |   79 ++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 20 deletions(-)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines
+++ a/kernel/sched/stats.c
@@ -21,14 +21,17 @@ static int show_schedstat(struct seq_fil
 	if (mask_str == NULL)
 		return -ENOMEM;
 
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
-		struct rq *rq = cpu_rq(cpu);
+	if (v == (void *)1) {
+		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+		seq_printf(seq, "timestamp %lu\n", jiffies);
+	} else {
+		struct rq *rq;
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
 		int dcount = 0;
 #endif
+		cpu = (unsigned long)(v - 2);
+		rq = cpu_rq(cpu);
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
@@ -77,30 +80,66 @@ static int show_schedstat(struct seq_fil
 	return 0;
 }
 
-static int schedstat_open(struct inode *inode, struct file *file)
+/*
+ * This itererator needs some explanation.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
+static void *schedstat_start(struct seq_file *file, loff_t *offset)
 {
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
-	struct seq_file *m;
-	int res;
+	unsigned long n = *offset;
 
-	if (!buf)
-		return -ENOMEM;
-	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
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
+static void *schedstat_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return schedstat_start(file, offset);
+}
+
+static void schedstat_stop(struct seq_file *file, void *data)
+{
 }
 
+static const struct seq_operations schedstat_sops = {
+	.start = schedstat_start,
+	.next  = schedstat_next,
+	.stop  = schedstat_stop,
+	.show  = show_schedstat,
+};
+
+static int schedstat_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &schedstat_sops);
+}
+
+static int schedstat_release(struct inode *inode, struct file *file)
+{
+	return 0;
+};
+
 static const struct file_operations proc_schedstat_operations = {
 	.open    = schedstat_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = single_release,
+	.release = schedstat_release,
 };
 
 static int __init proc_schedstat_init(void)
_

Patches currently in -mm which might be from nzimmer@sgi.com are

origin.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
procfs-improve-scaling-in-proc.patch

