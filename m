From: akpm@linux-foundation.org
Subject: + avoid-too-many-remote-cpu-references-due-to-proc-stat.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:01:08 -0700
Message-ID: <200707130501.l6D5187Q029268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXGMFBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, alok.kataria@calsoftinc.com


The patch titled
     Avoid too many remote cpu references due to /proc/stat
has been added to the -mm tree.  Its filename is
     avoid-too-many-remote-cpu-references-due-to-proc-stat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid too many remote cpu references due to /proc/stat
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Optimize show_stat to collect per-irq information just once.

On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
On every call to kstat_irqs, the process brings in per-cpu data from all
online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
Considering the fact that we already compute this value per-cpu, we can
save on the remote references as below.

Signed-off-by: Alok N Kataria <alok.kataria@calsoftinc.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/proc/proc_misc.c~avoid-too-many-remote-cpu-references-due-to-proc-stat fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~avoid-too-many-remote-cpu-references-due-to-proc-stat
+++ a/fs/proc/proc_misc.c
@@ -460,6 +460,11 @@ static int show_stat(struct seq_file *p,
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 sum = 0;
 	struct timespec boottime;
+	unsigned int *per_irq_sum;
+
+	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	if (!per_irq_sum)
+		return -ENOMEM;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -477,8 +482,11 @@ static int show_stat(struct seq_file *p,
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		for (j = 0 ; j < NR_IRQS ; j++)
-			sum += kstat_cpu(i).irqs[j];
+		for (j = 0; j < NR_IRQS; j++) {
+			unsigned int temp = kstat_cpu(i).irqs[j];
+			sum += temp;
+			per_irq_sum[j] += temp;
+		}
 	}
 
 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu\n",
@@ -516,7 +524,7 @@ static int show_stat(struct seq_file *p,
 
 #if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64)
 	for (i = 0; i < NR_IRQS; i++)
-		seq_printf(p, " %u", kstat_irqs(i));
+		seq_printf(p, " %u", per_irq_sum[i]);
 #endif
 
 	seq_printf(p,
@@ -531,6 +539,7 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
+	kfree(per_irq_sum);
 	return 0;
 }
 
_

Patches currently in -mm which might be from kiran@scalex86.org are

avoid-too-many-remote-cpu-references-due-to-proc-stat.patch
slab-leaks3-default-y.patch
