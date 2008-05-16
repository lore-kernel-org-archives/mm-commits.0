From: akpm@linux-foundation.org
Subject: + remove-argument-from-open_softirq-which-is-always-null.patch added to -mm tree
Date: Thu, 15 May 2008 20:12:45 -0700
Message-ID: <200805160312.m4G3Cjx0023891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYEPDOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 23:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crmafra2@gmail.com, crmafra@ift.unesp.br, davem@davemloft.net, jens.axboe@oracle.com, mingo@elte.hu, paulmck@us.ibm.com, tglx@linutronix.de, willy@linux.intel.com


The patch titled
     Remove argument from open_softirq which is always NULL
has been added to the -mm tree.  Its filename is
     remove-argument-from-open_softirq-which-is-always-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove argument from open_softirq which is always NULL
From: "Carlos R. Mafra" <crmafra2@gmail.com>

As git-grep shows, open_softirq() is always called with the last argument
being NULL

block/blk-core.c:       open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
kernel/hrtimer.c:       open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
kernel/rcuclassic.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
kernel/rcupreempt.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
kernel/sched.c: open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
kernel/softirq.c:       open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
kernel/softirq.c:       open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
kernel/timer.c: open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
net/core/dev.c: open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
net/core/dev.c: open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);

This observation has already been made by Matthew Wilcox in June 2002
(http://www.cs.helsinki.fi/linux/linux-kernel/2002-25/0687.html)

"I notice that none of the current softirq routines use the data element
passed to them."

and the situation hasn't changed since them. So it appears we can safely
remove that extra argument to save 128 (54) bytes of kernel data (text).

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c          |    2 +-
 include/linux/interrupt.h |    3 +--
 kernel/hrtimer.c          |    2 +-
 kernel/rcuclassic.c       |    2 +-
 kernel/rcupreempt.c       |    2 +-
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    7 +++----
 kernel/timer.c            |    2 +-
 net/core/dev.c            |    4 ++--
 9 files changed, 12 insertions(+), 14 deletions(-)

diff -puN block/blk-core.c~remove-argument-from-open_softirq-which-is-always-null block/blk-core.c
--- a/block/blk-core.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/block/blk-core.c
@@ -2042,7 +2042,7 @@ int __init blk_dev_init(void)
 	for_each_possible_cpu(i)
 		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
 
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
+	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq);
 	register_hotcpu_notifier(&blk_cpu_notifier);
 
 	return 0;
diff -puN include/linux/interrupt.h~remove-argument-from-open_softirq-which-is-always-null include/linux/interrupt.h
--- a/include/linux/interrupt.h~remove-argument-from-open_softirq-which-is-always-null
+++ a/include/linux/interrupt.h
@@ -285,12 +285,11 @@ enum
 struct softirq_action
 {
 	void	(*action)(struct softirq_action *);
-	void	*data;
 };
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
-extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
+extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
diff -puN kernel/hrtimer.c~remove-argument-from-open_softirq-which-is-always-null kernel/hrtimer.c
--- a/kernel/hrtimer.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/hrtimer.c
@@ -1669,7 +1669,7 @@ void __init hrtimers_init(void)
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
-	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
+	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif
 }
 
diff -puN kernel/rcuclassic.c~remove-argument-from-open_softirq-which-is-always-null kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/rcuclassic.c
@@ -529,7 +529,7 @@ static void __cpuinit rcu_online_cpu(int
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
diff -puN kernel/rcupreempt.c~remove-argument-from-open_softirq-which-is-always-null kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/rcupreempt.c
@@ -1124,7 +1124,7 @@ void __init __rcu_init(void)
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
 
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 /*
diff -puN kernel/sched.c~remove-argument-from-open_softirq-which-is-always-null kernel/sched.c
--- a/kernel/sched.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/sched.c
@@ -8210,7 +8210,7 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
diff -puN kernel/softirq.c~remove-argument-from-open_softirq-which-is-always-null kernel/softirq.c
--- a/kernel/softirq.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/softirq.c
@@ -347,9 +347,8 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
-void open_softirq(int nr, void (*action)(struct softirq_action*), void *data)
+void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
-	softirq_vec[nr].data = data;
 	softirq_vec[nr].action = action;
 }
 
@@ -503,8 +502,8 @@ void __init softirq_init(void)
 			&per_cpu(tasklet_hi_vec, cpu).head;
 	}
 
-	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
-	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
+	open_softirq(TASKLET_SOFTIRQ, tasklet_action);
+	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
 static int ksoftirqd(void * __bind_cpu)
diff -puN kernel/timer.c~remove-argument-from-open_softirq-which-is-always-null kernel/timer.c
--- a/kernel/timer.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/kernel/timer.c
@@ -1494,7 +1494,7 @@ void __init init_timers(void)
 
 	BUG_ON(err == NOTIFY_BAD);
 	register_cpu_notifier(&timers_nb);
-	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
+	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
 
 /**
diff -puN net/core/dev.c~remove-argument-from-open_softirq-which-is-always-null net/core/dev.c
--- a/net/core/dev.c~remove-argument-from-open_softirq-which-is-always-null
+++ a/net/core/dev.c
@@ -4559,8 +4559,8 @@ static int __init net_dev_init(void)
 
 	dev_boot_phase = 0;
 
-	open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
-	open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);
+	open_softirq(NET_TX_SOFTIRQ, net_tx_action);
+	open_softirq(NET_RX_SOFTIRQ, net_rx_action);
 
 	hotcpu_notifier(dev_cpu_callback, 0);
 	dst_init();
_

Patches currently in -mm which might be from crmafra2@gmail.com are

remove-argument-from-open_softirq-which-is-always-null.patch

