From: akpm@linux-foundation.org
Subject: + task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm.patch added to -mm tree
Date: Wed, 04 May 2011 16:37:15 -0700
Message-ID: <201105042337.p44NbFDg021393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab1EDXiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.stultz@linaro.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, tglx@linutronix.de, tytso@mit.edu


The patch titled
     task->comm: timerstats: protect task->comm access by using get_task_comm()
has been added to the -mm tree.  Its filename is
     task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm.patch

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
Subject: task->comm: timerstats: protect task->comm access by using get_task_comm()
From: John Stultz <john.stultz@linaro.org>

Convert the timerstats code to use get_task_comm() for protected comm
access.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm kernel/timer.c
--- a/kernel/timer.c~task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm
+++ a/kernel/timer.c
@@ -379,7 +379,7 @@ void __timer_stats_timer_set_start_info(
 		return;
 
 	timer->start_site = addr;
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	get_task_comm(timer->start_comm, current);
 	timer->start_pid = current->pid;
 }
 
_

Patches currently in -mm which might be from john.stultz@linaro.org are

mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access.patch
task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm.patch
task-comm-ext4-protect-task-comm-access-by-using-get_task_comm.patch
drivers-rtc-rtc-pcf50633c-dont-request-update-irq.patch

