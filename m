From: akpm@linux-foundation.org
Subject: [merged] softirq-introduce-statistics-for-softirq.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:44 -0700
Message-ID: <200906182243.n5IMhii9002773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153AbZFRWoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softirq: introduce statistics for softirq
has been removed from the -mm tree.  Its filename was
     softirq-introduce-statistics-for-softirq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softirq: introduce statistics for softirq
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Statistics for softirq doesn't exist.
It will be helpful like statistics for interrupts.
This patch introduces counting the number of softirq,
which will be exported in /proc/softirqs.

When softirq handler consumes much CPU time,
/proc/stat is like the following.

$ while :; do  cat /proc/stat | head -n1 ; sleep 10 ; done
cpu  88 0 408 739665 583 28 2 0 0
cpu  450 0 1090 740970 594 28 1294 0 0
                              ^^^^
                             softirq

In such a situation,
/proc/softirqs shows us which softirq handler is invoked.
We can see the increase rate of softirqs.

<before>
$ cat /proc/softirqs
                CPU0       CPU1       CPU2       CPU3
HI                 0          0          0          0
TIMER         462850     462805     462782     462718
NET_TX             0          0          0        365
NET_RX          2472          2          2         40
BLOCK              0          0        381       1164
TASKLET            0          0          0        224
SCHED         462654     462689     462698     462427
RCU             3046       2423       3367       3173

<after>
$ cat /proc/softirqs
                CPU0       CPU1       CPU2       CPU3
HI                 0          0          0          0
TIMER         463361     465077     465056     464991
NET_TX            53          0          1        365
NET_RX          3757          2          2         40
BLOCK              0          0        398       1170
TASKLET            0          0          0        224
SCHED         463074     464318     464612     463330
RCU             3505       2948       3947       3673

When CPU TIME of softirq is high,
the rates of increase is the following.
  TIMER  : 220/sec     : CPU1-3
  NET_TX : 5/sec       : CPU0
  NET_RX : 120/sec     : CPU0
  SCHED  : 40-200/sec  : all CPU
  RCU    : 45-58/sec   : all CPU

The rates of increase in an idle mode is the following.
  TIMER  : 250/sec
  SCHED  : 250/sec
  RCU    : 2/sec

It seems many softirqs for receiving packets and rcu are invoked.  This
gives us help for checking system.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel_stat.h |   12 ++++++++++++
 kernel/softirq.c            |    1 +
 2 files changed, 13 insertions(+)

diff -puN include/linux/kernel_stat.h~softirq-introduce-statistics-for-softirq include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~softirq-introduce-statistics-for-softirq
+++ a/include/linux/kernel_stat.h
@@ -5,6 +5,7 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
+#include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -31,6 +32,7 @@ struct kernel_stat {
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
+	unsigned int softirqs[NR_SOFTIRQS];
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -67,6 +69,16 @@ extern unsigned int kstat_irqs_cpu(unsig
 
 #endif
 
+static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
+{
+	kstat_this_cpu.softirqs[irq]++;
+}
+
+static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
+{
+       return kstat_cpu(cpu).softirqs[irq];
+}
+
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
diff -puN kernel/softirq.c~softirq-introduce-statistics-for-softirq kernel/softirq.c
--- a/kernel/softirq.c~softirq-introduce-statistics-for-softirq
+++ a/kernel/softirq.c
@@ -213,6 +213,7 @@ restart:
 	do {
 		if (pending & 1) {
 			int prev_count = preempt_count();
+			kstat_incr_softirqs_this_cpu(h - softirq_vec);
 
 			trace_softirq_entry(h, softirq_vec);
 			h->action(h);
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

origin.patch

