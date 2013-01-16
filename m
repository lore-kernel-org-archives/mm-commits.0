From: akpm@linux-foundation.org
Subject: + sched-proc-sched_stat-fails-on-very-very-large-machines.patch added to -mm tree
Date: Wed, 16 Jan 2013 13:56:54 -0800
Message-ID: <20130116215655.2C60331C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47936 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab3APV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 16:56:56 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so133700vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 13:56:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, mingo@redhat.com, peterz@infradead.org


The patch titled
     Subject: sched: /proc/sched_stat fails on very very large machines
has been added to the -mm tree.  Its filename is
     sched-proc-sched_stat-fails-on-very-very-large-machines.patch

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
Subject: sched: /proc/sched_stat fails on very very large machines

On systems with 4096 cores doing a cat /proc/sched_stat fails.  We are
trying to push all the data into a single kmalloc buffer.  The issue is on
these very large machines all the data will not fit in 4mb.

A better solution is to not use the single_open() mechanism but to provide
our own seq_operations.

The output should be identical to previous version and thus not need the
version number.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |   73 +++++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 20 deletions(-)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines
+++ a/kernel/sched/stats.c
@@ -21,9 +21,13 @@ static int show_schedstat(struct seq_fil
 	if (mask_str == NULL)
 		return -ENOMEM;
 
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
+	if (v == (void *)1) {
+		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+		seq_printf(seq, "timestamp %lu\n", jiffies);
+	} else {
+
+		cpu = (unsigned long)(v - 2);
+
 		struct rq *rq = cpu_rq(cpu);
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
@@ -72,35 +76,64 @@ static int show_schedstat(struct seq_fil
 		}
 		rcu_read_unlock();
 #endif
+		kfree(mask_str);
 	}
-	kfree(mask_str);
 	return 0;
 }
 
-static int schedstat_open(struct inode *inode, struct file *file)
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
+}
+
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
 }
 
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

sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

