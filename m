From: akpm@linux-foundation.org
Subject: + oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch
 added to -mm tree
Date: Tue, 22 Mar 2016 15:59:21 -0700
Message-ID: <56f1ce49.LKpL9q2cBksfhvEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbcCVW7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 18:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: protect oom_reaper_list using simpler way
has been added to the -mm tree.  Its filename is
     oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: oom, oom_reaper: protect oom_reaper_list using simpler way

"oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task" tried
to protect oom_reaper_list using MMF_OOM_KILLED flag.  But we can do it by
simply checking tsk->oom_reaper_list != NULL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 mm/oom_kill.c         |    8 ++------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~oom-oom_reaper-protect-oom_reaper_list-using-simpler-way include/linux/sched.h
--- a/include/linux/sched.h~oom-oom_reaper-protect-oom_reaper_list-using-simpler-way
+++ a/include/linux/sched.h
@@ -512,8 +512,6 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 
-#define MMF_OOM_KILLED		21	/* OOM killer has chosen this mm */
-
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
diff -puN mm/oom_kill.c~oom-oom_reaper-protect-oom_reaper_list-using-simpler-way mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-protect-oom_reaper_list-using-simpler-way
+++ a/mm/oom_kill.c
@@ -542,7 +542,7 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	if (!oom_reaper_th)
+	if (!oom_reaper_th || tsk->oom_reaper_list)
 		return;
 
 	get_task_struct(tsk);
@@ -676,7 +676,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-	bool can_oom_reap;
+	bool can_oom_reap = true;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -738,10 +738,6 @@ void oom_kill_process(struct oom_control
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
 	atomic_inc(&mm->mm_count);
-
-	/* Make sure we do not try to oom reap the mm multiple times */
-	can_oom_reap = !test_and_set_bit(MMF_OOM_KILLED, &mm->flags);
