From: akpm@linux-foundation.org
Subject: + proc-export-statistics-for-softirq-to-proc.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:04:22 -0800
Message-ID: <200811242204.mAOM4Nk7013042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbYKXWE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:04:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, mingo@elte.hu


The patch titled
     proc: export statistics for softirq to /proc
has been added to the -mm tree.  Its filename is
     proc-export-statistics-for-softirq-to-proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: export statistics for softirq to /proc
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Export statistics for softirq in /proc/softirqs and /proc/stat.

1. /proc/softirqs
Implement /proc/softirqs which shows the number of softirq
for each CPU like /proc/interrupts.

2. /proc/stat
Add the "softirq" line to /proc/stat.
This line shows the number of softirq for all cpu.
The first column is the total of all softirqs and
each subsequent column is the total for particular softirq.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile   |    1 
 fs/proc/softirqs.c |   57 +++++++++++++++++++++++++++++++++++++++++++
 fs/proc/stat.c     |   17 ++++++++++++
 3 files changed, 75 insertions(+)

diff -puN fs/proc/Makefile~proc-export-statistics-for-softirq-to-proc fs/proc/Makefile
--- a/fs/proc/Makefile~proc-export-statistics-for-softirq-to-proc
+++ a/fs/proc/Makefile
@@ -19,6 +19,7 @@ proc-y	+= meminfo.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
+proc-y	+= softirqs.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff -puN /dev/null fs/proc/softirqs.c
--- /dev/null
+++ a/fs/proc/softirqs.c
@@ -0,0 +1,57 @@
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+static const char *desc_array[] = {
+	"HI",
+	"TIMER",
+	"NET_TX",
+	"NET_RX",
+	"BLOCK",
+	"TASKLET",
+	"SCHED",
+#ifdef CONFIG_HIGH_RES_TIMERS
+	"HRTIMER",
+#endif
+	"RCU"};
+
+/*
+ * /proc/softirqs  ... display the number of softirqs
+ */
+static int show_softirqs(struct seq_file *p, void *v)
+{
+	int i, j;
+
+	seq_printf(p, "                ");
+	for_each_possible_cpu(i)
+		seq_printf(p, "CPU%-8d", i);
+	seq_printf(p, "\n");
+
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		seq_printf(p, "%-9s", desc_array[i]);
+		for_each_possible_cpu(j)
+			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
+		seq_printf(p, "\n");
+	}
+	return 0;
+}
+
+static int softirqs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_softirqs, NULL);
+}
+
+static const struct file_operations proc_softirqs_operations = {
+	.open		= softirqs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_softirqs_init(void)
+{
+	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
+	return 0;
+}
+module_init(proc_softirqs_init);
diff -puN fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc fs/proc/stat.c
--- a/fs/proc/stat.c~proc-export-statistics-for-softirq-to-proc
+++ a/fs/proc/stat.c
@@ -25,6 +25,7 @@ static int show_stat(struct seq_file *p,
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
+	u64 sum_softirq = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
 
@@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p,
 			sum += kstat_irqs_cpu(j, i);
 
 		sum += arch_irq_stat_cpu(i);
+
+		for (j = 0; j < NR_SOFTIRQS; j++)
+			sum_softirq += kstat_softirqs_cpu(j, i);
+
 	}
 	sum += arch_irq_stat();
 
@@ -111,6 +116,18 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
+	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		per_irq_sum = 0;
+
+		for_each_possible_cpu(j)
+			per_irq_sum += kstat_softirqs_cpu(i, j);
+
+		seq_printf(p, " %u", per_irq_sum);
+	}
+	seq_printf(p, "\n");
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

