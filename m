From: akpm@linux-foundation.org
Subject: + workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:29:28 -0800
Message-ID: <200811140029.mAE0TSeC021780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbYKNAaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com


The patch titled
     workqueues: kill cpu_singlethread_map, use get_cpu_mask() instead
has been added to the -mm tree.  Its filename is
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

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
Subject: workqueues: kill cpu_singlethread_map, use get_cpu_mask() instead
From: Oleg Nesterov <oleg@redhat.com>

Now that we have cpu_bit_bitmap[] we don't need cpu_singlethread_map, we
can use get_cpu_mask(singlethread_cpu) directly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead
+++ a/kernel/workqueue.c
@@ -73,7 +73,6 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static cpumask_t cpu_singlethread_map __read_mostly;
 /*
  * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
@@ -92,7 +91,7 @@ static inline int is_single_threaded(str
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
 }
 
 static
@@ -1019,7 +1018,6 @@ void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
-	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
forkc-cleanup-for-copy_sighand.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

