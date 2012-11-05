From: akpm@linux-foundation.org
Subject: + tasklet-ignore-disabled-tasklet-in-tasklet_action.patch added to -mm tree
Date: Mon, 05 Nov 2012 14:52:24 -0800
Message-ID: <20121105225225.1C308200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42935 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab2KEWw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 17:52:28 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so406491fae.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 14:52:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xtfeng@gmail.com, dannyfeng@tencent.com, eric.dumazet@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: tasklet: ignore disabled tasklet in tasklet_action()
has been added to the -mm tree.  Its filename is
     tasklet-ignore-disabled-tasklet-in-tasklet_action.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: tasklet: ignore disabled tasklet in tasklet_action()

We met a ksoftirqd 100% issue, the perf top shows kernel is busy with
tasklet_action(), but no actual action is shown.  From dumped kernel,
there's only one disabled tasklet on the tasklet_vec.

tasklet_action might be handled after tasklet is disabled, this will
make disabled tasklet stayed on tasklet_vec. tasklet_action will not
handle disabled tasklet, but place it on the tail of tasklet_vec,
still raise softirq for this tasklet. Things will become worse if
device driver uses tasklet_disable on its device remove/close code.
The disabled tasklet will stay on the vec, frequently __raise_softirq_off()
and make ksoftirqd wakeup even if no tasklets need to be handled.

This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
in tasklet_action(), simply ignore the disabled tasklet and don't raise
the softirq nr. In my previous patch, I remove tasklet_hi_enable() since
it is the same as tasklet_enable(). So only tasklet_enable() needs to be
modified, if tasklet state is changed from disable to enable, use
__tasklet_schedule() to put it on the right vec.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |   12 ++++++++++--
 kernel/softirq.c          |    8 ++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

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
@@ -593,7 +594,14 @@ static inline void tasklet_disable(struc
 static inline void tasklet_enable(struct tasklet_struct *t)
 {
 	smp_mb__before_atomic_dec();
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
 
 static inline void tasklet_hi_enable(struct tasklet_struct *t)
diff -puN kernel/softirq.c~tasklet-ignore-disabled-tasklet-in-tasklet_action kernel/softirq.c
--- a/kernel/softirq.c~tasklet-ignore-disabled-tasklet-in-tasklet_action
+++ a/kernel/softirq.c
@@ -431,6 +431,7 @@ void __tasklet_hi_schedule(struct taskle
 	*__this_cpu_read(tasklet_hi_vec.tail) = t;
 	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
 	raise_softirq_irqoff(HI_SOFTIRQ);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	local_irq_restore(flags);
 }
 
@@ -442,6 +443,7 @@ void __tasklet_hi_schedule_first(struct 
 
 	t->next = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, t);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
 
@@ -467,10 +469,9 @@ static void tasklet_action(struct softir
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
@@ -502,10 +503,9 @@ static void tasklet_hi_action(struct sof
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
tasklet-ignore-disabled-tasklet-in-tasklet_action.patch

