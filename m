From: akpm@linux-foundation.org
Subject: [patch 086/117] mm, oom_reaper: clear TIF_MEMDIE for all tasks
 queued for oom_reaper
Date: Thu, 19 May 2016 17:13:15 -0700
Message-ID: <573e569b.wfGuEz8Xg8NI3Ei9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbcETANR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, daniel.vetter@intel.com, mst@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rmaksudova@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: clear TIF_MEMDIE for all tasks queued for oom_reaper

Right now the oom reaper will clear TIF_MEMDIE only for tasks which were
successfully reaped.  This is the safest option because we know that such
an oom victim would only block forward progress of the oom killer without
a good reason because it is highly unlikely it would release much more
memory.  Basically most of its memory has been already torn down.

We can relax this assumption to catch more corner cases though.

The first obvious one is when the oom victim clears its mm and gets stuck
later on.  oom_reaper would back of on find_lock_task_mm returning NULL. 
We can safely try to clear TIF_MEMDIE in this case because such a task
would be ignored by the oom killer anyway.  The flag would be cleared by
that time already most of the time anyway.

The less obvious one is when the oom reaper fails due to mmap_sem
contention.  Even if we clear TIF_MEMDIE for this task then it is not very
likely that we would select another task too easily because we haven't
reaped the last victim and so it would be still the #1 candidate.  There
is a rare race condition possible when the current victim terminates
before the next select_bad_process but considering that oom_reap_task had
retried several times before giving up then this sounds like a borderline
thing.

After this patch we should have a guarantee that the OOM killer will not
be block for unbounded amount of time for most cases.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Raushaniya Maksudova <rmaksudova@parallels.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper
+++ a/mm/oom_kill.c
@@ -510,14 +510,10 @@ static bool __oom_reap_task(struct task_
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
-	 * reasonably reclaimable memory anymore. OOM killer can continue
-	 * by selecting other victim if unmapping hasn't led to any
-	 * improvements. This also means that selecting this task doesn't
-	 * make any sense.
+	 * This task can be safely ignored because we cannot do much more
+	 * to release its memory.
 	 */
 	tsk->signal->oom_score_adj = OOM_SCORE_ADJ_MIN;
-	exit_oom_victim(tsk);
 out:
 	mmput(mm);
 	return ret;
@@ -538,6 +534,15 @@ static void oom_reap_task(struct task_st
 		debug_show_all_locks();
 	}
 
+	/*
+	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
+	 * reasonably reclaimable memory anymore or it is not a good candidate
+	 * for the oom victim right now because it cannot release its memory
+	 * itself nor by the oom reaper.
+	 */
+	tsk->oom_reaper_list = NULL;
+	exit_oom_victim(tsk);
+
 	/* Drop a reference taken by wake_oom_reaper */
 	put_task_struct(tsk);
 }
_
