From: akpm@linux-foundation.org
Subject: + softirq-reduce-latencies.patch added to -mm tree
Date: Tue, 08 Jan 2013 12:36:27 -0800
Message-ID: <20130108203628.095C6200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:40722 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3AHUgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:36:31 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so66204wey.4
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:36:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edumazet@google.com, bhutchings@solarflare.com, davem@davemloft.net, eric.dumazet@gmail.com, joe@perches.com, mingo@elte.hu, tglx@linutronix.de, therbert@google.com


The patch titled
     From: Eric Dumazet <eric.dumazet@gmail.com>
has been added to the -mm tree.  Its filename is
     softirq-reduce-latencies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>

In various network workloads, __do_softirq() latencies can be up
to 20 ms if HZ=1000, and 200 ms if HZ=100.

This is because we iterate 10 times in the softirq dispatcher,
and some actions can consume a lot of cycles.

This patch changes the fallback to ksoftirqd condition to :

- A time limit of 2 ms.
- need_resched() being set on current task

When one of this condition is met, we wakeup ksoftirqd for further
softirq processing if we still have pending softirqs.

Using need_resched() as the only condition can trigger RCU stalls,
as we can keep BH disabled for too long.

I ran several benchmarks and got no significant difference in
throughput, but a very significant reduction of latencies (one order
of magnitude) :

In following bench, 200 antagonist "netperf -t TCP_RR" are started in
background, using all available cpus.

Then we start one "netperf -t TCP_RR", bound to the cpu handling the NIC
IRQ (hard+soft)

Before patch :

# netperf -H 7.7.7.84 -t TCP_RR -T2,2 -- -k
RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
RT_LATENCY=550110.424
MIN_LATENCY=146858
MAX_LATENCY=997109
P50_LATENCY=305000
P90_LATENCY=550000
P99_LATENCY=710000
MEAN_LATENCY=376989.12
STDDEV_LATENCY=184046.92

After patch :

# netperf -H 7.7.7.84 -t TCP_RR -T2,2 -- -k
RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET
to 7.7.7.84 () port 0 AF_INET : first burst 0 : cpu bind
RT_LATENCY=40545.492
MIN_LATENCY=9834
MAX_LATENCY=78366
P50_LATENCY=33583
P90_LATENCY=59000
P99_LATENCY=69000
MEAN_LATENCY=38364.67
STDDEV_LATENCY=12865.26

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: Tom Herbert <therbert@google.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/softirq.c~softirq-reduce-latencies kernel/softirq.c
--- a/kernel/softirq.c~softirq-reduce-latencies
+++ a/kernel/softirq.c
@@ -195,21 +195,21 @@ void local_bh_enable_ip(unsigned long ip
 EXPORT_SYMBOL(local_bh_enable_ip);
 
 /*
- * We restart softirq processing MAX_SOFTIRQ_RESTART times,
- * and we fall back to softirqd after that.
+ * We restart softirq processing for at most 2 ms,
+ * and if need_resched() is not set.
  *
- * This number has been established via experimentation.
+ * These limits have been established via experimentation.
  * The two things to balance is latency against fairness -
  * we want to handle softirqs as soon as possible, but they
  * should not be able to lock up the box.
  */
-#define MAX_SOFTIRQ_RESTART 10
+#define MAX_SOFTIRQ_TIME  max(1, (2*HZ/1000))
 
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
 	__u32 pending;
-	int max_restart = MAX_SOFTIRQ_RESTART;
+	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
 	unsigned long old_flags = current->flags;
 
@@ -264,11 +264,12 @@ restart:
 	local_irq_disable();
 
 	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+	if (pending) {
+		if (time_before(jiffies, end) && !need_resched())
+			goto restart;
 
-	if (pending)
 		wakeup_softirqd();
+	}
 
 	lockdep_softirq_exit();
 
_

Patches currently in -mm which might be from edumazet@google.com are

origin.patch
linux-next.patch
lib-cpu_rmap-avoid-flushing-all-workqueues.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
softirq-reduce-latencies.patch

