From: akpm@linux-foundation.org
Subject: +
 mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 13:32:22 -0700
Message-ID: <572121d6.MlGJIQlmZluU907a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbcD0UcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: hide oom reaped tasks from OOM killer more carefully
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -511,6 +511,7 @@ static inline int get_dumpable(struct mm
 
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

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch

