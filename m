From: akpm@linux-foundation.org
Subject: + ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock.patch added to -mm tree
Date: Fri, 28 Oct 2011 15:27:10 -0700
Message-ID: <201110282227.p9SMRA1b022361@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:9981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab1J1W1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaowanlong@cn.fujitsu.com, C.Emde@osadl.org, manfred@colorfullife.com, tglx@linutronix.de


The patch titled
     Subject: ipc/mqueue.c: fix wrong use of schedule_hrtimeout_range_clock()
has been added to the -mm tree.  Its filename is
     ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock.patch

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
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: ipc/mqueue.c: fix wrong use of schedule_hrtimeout_range_clock()

Fix the wrong use of schedule_hrtimeout_range_clock() in wq_sleep(),
although it is harmless for the syscall mq_timed* now.  It was introduced
by 9ca7d8e ("mqueue: Convert message queue timeout to use hrtimers").

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock
+++ a/ipc/mqueue.c
@@ -449,8 +449,8 @@ static int wq_sleep(struct mqueue_inode_
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_hrtimeout_range_clock(timeout,
-		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
+		time = schedule_hrtimeout_range_clock(timeout, 0,
+			HRTIMER_MODE_ABS, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
_
Subject: Subject: ipc/mqueue.c: fix wrong use of schedule_hrtimeout_range_clock()

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch
ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock.patch
ksm-fix-the-comment-of-try_to_unmap_one.patch

