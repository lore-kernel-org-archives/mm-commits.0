From: akpm@linux-foundation.org
Subject: + workqueue-remove-redundant-function-invocation.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:20:10 -0700
Message-ID: <200804292020.m3TKKAdQ007786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbYD2UV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shengping.liu@windriver.com, mingo@elte.hu, oleg@tv-sign.ru, pavel@ucw.cz


The patch titled
     workqueue: remove redundant function invocation
has been added to the -mm tree.  Its filename is
     workqueue-remove-redundant-function-invocation.patch

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
Subject: workqueue: remove redundant function invocation
From: Andrew Liu <shengping.liu@windriver.com>

timer_stats_timer_set_start_info is invoked twice, additionally, the
invocation of this function can be moved to where it is only called when a
delay is really required.

Signed-off-by: Andrew Liu <shengping.liu@windriver.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~workqueue-remove-redundant-function-invocation kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-remove-redundant-function-invocation
+++ a/kernel/workqueue.c
@@ -195,7 +195,6 @@ static void delayed_work_timer_fn(unsign
 int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	timer_stats_timer_set_start_info(&dwork->timer);
 	if (delay == 0)
 		return queue_work(wq, &dwork->work);
 
@@ -219,11 +218,12 @@ int queue_delayed_work_on(int cpu, struc
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
-	timer_stats_timer_set_start_info(&dwork->timer);
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
+		timer_stats_timer_set_start_info(&dwork->timer);
+
 		/* This stores cwq for the moment, for the timer_fn */
 		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
@@ -564,7 +564,6 @@ EXPORT_SYMBOL(schedule_work);
 int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
-	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work(keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
@@ -581,7 +580,6 @@ EXPORT_SYMBOL(schedule_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
_

Patches currently in -mm which might be from shengping.liu@windriver.com are

workqueue-remove-redundant-function-invocation.patch

