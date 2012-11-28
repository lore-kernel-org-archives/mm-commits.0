From: akpm@linux-foundation.org
Subject: [failures] tasklet-ignore-disabled-tasklet-in-tasklet_action.patch removed from -mm tree
Date: Wed, 28 Nov 2012 14:23:31 -0800
Message-ID: <20121128222333.001A7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55890 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2K1WXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 17:23:35 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so1158514vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 14:23:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xtfeng@gmail.com, dannyfeng@tencent.com, eric.dumazet@gmail.com, mingo@elte.hu, peter@hurleysoftware.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: tasklet: ignore disabled tasklet in tasklet_action()
has been removed from the -mm tree.  Its filename was
     tasklet-ignore-disabled-tasklet-in-tasklet_action.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: tasklet: ignore disabled tasklet in tasklet_action()

We met a ksoftirqd 100% issue, the perf top shows kernel is busy with
tasklet_action(), but no actual action is shown.  From dumped kernel,
there's only one disabled tasklet on the tasklet_vec.

tasklet_action might be handled after tasklet is disabled, this will make
disabled tasklet stayed on tasklet_vec.  tasklet_action will not handle
disabled tasklet, but place it on the tail of tasklet_vec, still raise
softirq for this tasklet.  Things will become worse if device driver uses
tasklet_disable on its device remove/close code.  The disabled tasklet
will stay on the vec, frequently __raise_softirq_off() and make ksoftirqd
wakeup even if no tasklets need to be handled.

This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
in tasklet_action(), simply ignore the disabled tasklet and don't raise
the softirq nr.  In my previous patch, I remove tasklet_hi_enable() since
it is the same as tasklet_enable().  So only tasklet_enable() needs to be
modified, if tasklet state is changed from disable to enable, use
__tasklet_schedule() to put it on the right vec.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/jme.c |   12 ++++++------
 include/linux/interrupt.h  |   18 ++++++++++--------
 kernel/softirq.c           |    9 +++++----
 3 files changed, 21 insertions(+), 18 deletions(-)

diff -puN drivers/net/ethernet/jme.c~tasklet-ignore-disabled-tasklet-in-tasklet_action drivers/net/ethernet/jme.c
--- a/drivers/net/ethernet/jme.c~tasklet-ignore-disabled-tasklet-in-tasklet_action
+++ a/drivers/net/ethernet/jme.c
@@ -1364,8 +1364,8 @@ err_out_free_rx_resources:
 	jme_free_rx_resources(jme);
 out_enable_tasklet:
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 out:
 	atomic_inc(&jme->link_changing);
 }
@@ -2379,8 +2379,8 @@ static inline void jme_resume_rx(struct 
 	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
 		JME_NAPI_ENABLE(jme);
 	} else {
-		tasklet_hi_enable(&jme->rxclean_task);
-		tasklet_hi_enable(&jme->rxempty_task);
+		tasklet_enable(&jme->rxclean_task);
+		tasklet_enable(&jme->rxempty_task);
 	}
 	dpi->cur		= PCC_P1;
 	dpi->attempt		= PCC_P1;
@@ -3264,8 +3264,8 @@ jme_suspend(struct device *dev)
 	}
 
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 
 	jme_powersave_phy(jme);
 
diff -puN include/linux/interrupt.h~tasklet-ignore-disabled-tasklet-in-tasklet_action include/linux/interrupt.h
--- a/include/linux/interrupt.h~tasklet-ignore-disabled-tasklet-in-tasklet_action
+++ a/include/linux/interrupt.h
@@ -521,7 +521,8 @@ struct tasklet_struct name = { NULL, 0, 
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_HI	/* Tasklet is HI_SOFTIRQ */
 };
 
 #ifdef CONFIG_SMP
@@ -593,13 +594,14 @@ static inline void tasklet_disable(struc
 static inline void tasklet_enable(struct tasklet_struct *t)
 {
 	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
+	if (atomic_dec_and_test(&t->count)) {
+		if (!test_bit(TASKLET_STATE_SCHED, &t->state))
+			return;
+		if (test_bit(TASKLET_STATE_HI, &t->state))
+			__tasklet_hi_schedule(t);
+		else
+			__tasklet_schedule(t);
+	}
 }
 
 extern void tasklet_kill(struct tasklet_struct *t);
diff -puN kernel/softirq.c~tasklet-ignore-disabled-tasklet-in-tasklet_action kernel/softirq.c
--- a/kernel/softirq.c~tasklet-ignore-disabled-tasklet-in-tasklet_action
+++ a/kernel/softirq.c
@@ -417,6 +417,7 @@ void __tasklet_schedule(struct tasklet_s
 	*__this_cpu_read(tasklet_vec.tail) = t;
 	__this_cpu_write(tasklet_vec.tail, &(t->next));
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	clear_bit(TASKLET_STATE_HI, &t->state);
 	local_irq_restore(flags);
 }
 
@@ -431,6 +432,7 @@ void __tasklet_hi_schedule(struct taskle
 	*__this_cpu_read(tasklet_hi_vec.tail) = t;
 	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
 	raise_softirq_irqoff(HI_SOFTIRQ);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	local_irq_restore(flags);
 }
 
@@ -442,6 +444,7 @@ void __tasklet_hi_schedule_first(struct 
 
 	t->next = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, t);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
 
@@ -467,10 +470,9 @@ static void tasklet_action(struct softir
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
 				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
 			}
 			tasklet_unlock(t);
+			continue;
 		}
 
 		local_irq_disable();
@@ -502,10 +504,9 @@ static void tasklet_hi_action(struct sof
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
 				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
 			}
 			tasklet_unlock(t);
+			continue;
 		}
 
 		local_irq_disable();
_

Patches currently in -mm which might be from xtfeng@gmail.com are

linux-next.patch

