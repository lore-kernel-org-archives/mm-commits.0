From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:22 -0700
Message-ID: <201111012107.pA1L7Meu028176@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, C.Emde@osadl.org, manfred@colorfullife.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue.c: fix wrong use of schedule_hrtimeout_range_clock()
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-fix-wrong-use-of-schedule_hrtimeout_range_clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch

