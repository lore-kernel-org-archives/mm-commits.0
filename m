From: akpm@linux-foundation.org
Subject: [merged] proc-export-statistics-for-softirq-to-proc.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:47 -0700
Message-ID: <200906182243.n5IMhl6h002790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153AbZFRWoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proc: export statistics for softirq to /proc
has been removed from the -mm tree.  Its filename was
     proc-export-statistics-for-softirq-to-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[kosaki.motohiro@jp.fujitsu.com: remove redundunt for_each_possible_cpu() loop]
Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   26 +++++++++++++++
 fs/proc/Makefile                   |    1 
 fs/proc/softirqs.c                 |   44 +++++++++++++++++++++++++++
 fs/proc/stat.c                     |   15 +++++++++
 4 files changed, 86 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-export-statistics-for-softirq-to-proc Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-export-statistics-for-softirq-to-proc
+++ a/Documentation/filesystems/proc.txt
@@ -283,6 +283,7 @@ Table 1-4: Kernel info in /proc
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
  slabinfo    Slab pool info                                    
+ softirqs    softirq usage
  stat        Overall statistics                                
  swaps       Swap space utilization                            
  sys         See chapter 2                                     
@@ -597,6 +598,25 @@ on the kind of area :
 0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 ...
    pages=10 vmalloc N0=10
 
+..............................................................................
+
+softirqs:
+
+Provides counts of softirq handlers serviced since boot time, for each cpu.
+
+> cat /proc/softirqs
+                CPU0       CPU1       CPU2       CPU3
+      HI:          0          0          0          0
+   TIMER:      27166      27120      27097      27034
+  NET_TX:          0          0          0         17
+  NET_RX:         42          0          0         39
+   BLOCK:          0          0        107       1121
+ TASKLET:          0          0          0        290
+   SCHED:      27035      26983      26971      26746
+ HRTIMER:          0          0          0          0
+     RCU:       1678       1769       2178       2250
+
+
 1.3 IDE devices in /proc/ide
 ----------------------------
 
@@ -883,6 +903,7 @@ since the system first booted.  For a qu
   processes 2915
   procs_running 1
   procs_blocked 0
+  softirq 183433 0 21755 12 39 1137 231 21459 2263
 
 The very first  "cpu" line aggregates the  numbers in all  of the other "cpuN"
 lines.  These numbers identify the amount of time the CPU has spent performing
@@ -918,6 +939,11 @@ CPUs.
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.
 
+The "softirq" line gives counts of softirqs serviced since boot time, for each
+of the possible system softirqs. The first column is the total of all
+softirqs serviced; each subsequent column is the total for that particular
+softirq.
+
 
 1.9 Ext4 file system parameters
 ------------------------------
diff -puN fs/proc/Makefile~proc-export-statistics-for-softirq-to-proc fs/proc/Makefile
--- a/fs/proc/Makefile~proc-export-statistics-for-softirq-to-proc
+++ a/fs/proc/Makefile
@@ -18,6 +18,7 @@ proc-y	+= meminfo.o
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
@@ -0,0 +1,44 @@
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
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
+		seq_printf(p, "%8s:", softirq_to_name[i]);
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
@@ -29,6 +29,8 @@ static int show_stat(struct seq_file *p,
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
+	u64 sum_softirq = 0;
+	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 	unsigned int per_irq_sum;
 
@@ -53,6 +55,13 @@ static int show_stat(struct seq_file *p,
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
+
+		for (j = 0; j < NR_SOFTIRQS; j++) {
+			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
+
+			per_softirq_sums[j] += softirq_stat;
+			sum_softirq += softirq_stat;
+		}
 	}
 	sum += arch_irq_stat();
 
@@ -115,6 +124,12 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
+	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+
+	for (i = 0; i < NR_SOFTIRQS; i++)
+		seq_printf(p, " %u", per_softirq_sums[i]);
+	seq_printf(p, "\n");
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

origin.patch

