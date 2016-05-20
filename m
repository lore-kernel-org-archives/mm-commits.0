From: akpm@linux-foundation.org
Subject: [patch 018/162] mm, oom_reaper: hide oom reaped tasks from OOM
 killer more carefully
Date: Fri, 20 May 2016 16:57:18 -0700
Message-ID: <573fa45e.cyLAGrhNpKWqbIsq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcETX5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: hide oom reaped tasks from OOM killer more carefully

36324a990cf5 ("oom: clear TIF_MEMDIE after oom_reaper managed to unmap the
address space") not only clears TIF_MEMDIE for oom reaped task but also
set OOM_SCORE_ADJ_MIN for the target task to hide it from the oom killer. 
This works in simple cases but it is not sufficient for (unlikely) cases
where the mm is shared between independent processes (as they do not share
signal struct).  If the mm had only small amount of memory which could be
reaped then another task sharing the mm could be selected and that
wouldn't help to move out from the oom situation.

Introduce MMF_OOM_REAPED mm flag which is checked in oom_badness (same as
OOM_SCORE_ADJ_MIN) and task is skipped if the flag is set.  Set the flag
after __oom_reap_task is done with a task.  This will force the
select_bad_process() to ignore all already oom reaped tasks as well as no
such task is sacrificed for its parent.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 mm/oom_kill.c         |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully
+++ a/include/linux/sched.h
@@ -521,6 +521,7 @@ static inline int get_dumpable(struct mm
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
+#define MMF_OOM_REAPED		21	/* mm has been already reaped */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN mm/oom_kill.c~mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully
+++ a/mm/oom_kill.c
@@ -174,8 +174,13 @@ unsigned long oom_badness(struct task_st
 	if (!p)
 		return 0;
 
+	/*
+	 * Do not even consider tasks which are explicitly marked oom
+	 * unkillable or have been already oom reaped.
+	 */
 	adj = (long)p->signal->oom_score_adj;
-	if (adj == OOM_SCORE_ADJ_MIN) {
+	if (adj == OOM_SCORE_ADJ_MIN ||
+			test_bit(MMF_OOM_REAPED, &p->mm->flags)) {
 		task_unlock(p);
 		return 0;
 	}
@@ -513,7 +518,7 @@ static bool __oom_reap_task(struct task_
 	 * This task can be safely ignored because we cannot do much more
 	 * to release its memory.
 	 */
-	tsk->signal->oom_score_adj = OOM_SCORE_ADJ_MIN;
+	set_bit(MMF_OOM_REAPED, &mm->flags);
 out:
 	mmput(mm);
 	return ret;
_
