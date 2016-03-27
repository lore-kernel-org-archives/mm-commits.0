From: akpm@linux-foundation.org
Subject: [merged]
 oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:30:08 -0700
Message-ID: <56f753c0.KCTTe9QU/+/eF6n5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0DaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: protect oom_reaper_list using simpler way
has been removed from the -mm tree.  Its filename was
     oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -547,7 +547,7 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	if (!oom_reaper_th)
+	if (!oom_reaper_th || tsk->oom_reaper_list)
 		return;
 
 	get_task_struct(tsk);
@@ -681,7 +681,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-	bool can_oom_reap;
+	bool can_oom_reap = true;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -743,10 +743,6 @@ void oom_kill_process(struct oom_control
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
 	atomic_inc(&mm->mm_count);
-
-	/* Make sure we do not try to oom reap the mm multiple times */
-	can_oom_reap = !test_and_set_bit(MMF_OOM_KILLED, &mm->flags);
