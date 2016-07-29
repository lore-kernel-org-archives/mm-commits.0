From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch removed
 from -mm tree
Date: Fri, 29 Jul 2016 11:54:01 -0700
Message-ID: <579ba649.rSuUqW6QOlJW3ubO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcG2SyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: do not attempt to reap a task more than twice
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: do not attempt to reap a task more than twice

oom_reaper relies on the mmap_sem for read to do its job.  Many places
which might block readers have been converted to use down_write_killable
and that has reduced chances of the contention a lot.  Some paths where
the mmap_sem is held for write can take other locks and they might either
be not prepared to fail due to fatal signal pending or too impractical to
be changed.

This patch introduces MMF_OOM_NOT_REAPABLE flag which gets set after the
first attempt to reap a task's mm fails.  If the flag is present after the
failure then we set MMF_OOM_REAPED to hide this mm from the oom killer
completely so it can go and chose another victim.

As a result a risk of OOM deadlock when the oom victim would be blocked
indefinetly and so the oom killer cannot make any progress should be
mitigated considerably while we still try really hard to perform all
reclaim attempts and stay predictable in the behavior.

Link: http://lkml.kernel.org/r/1466426628-15074-10-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 mm/oom_kill.c         |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/sched.h~mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice
+++ a/include/linux/sched.h
@@ -523,6 +523,7 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_REAPED		21	/* mm has been already reaped */
+#define MMF_OOM_NOT_REAPABLE	22	/* mm couldn't be reaped */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN mm/oom_kill.c~mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice
+++ a/mm/oom_kill.c
@@ -556,8 +556,27 @@ static void oom_reap_task(struct task_st
 		schedule_timeout_idle(HZ/10);
 
 	if (attempts > MAX_OOM_REAP_RETRIES) {
+		struct task_struct *p;
+
 		pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
 				task_pid_nr(tsk), tsk->comm);
+
+		/*
+		 * If we've already tried to reap this task in the past and
+		 * failed it probably doesn't make much sense to try yet again
+		 * so hide the mm from the oom killer so that it can move on
+		 * to another task with a different mm struct.
+		 */
+		p = find_lock_task_mm(tsk);
+		if (p) {
+			if (test_and_set_bit(MMF_OOM_NOT_REAPABLE, &p->mm->flags)) {
+				pr_info("oom_reaper: giving up pid:%d (%s)\n",
+						task_pid_nr(tsk), tsk->comm);
+				set_bit(MMF_OOM_REAPED, &p->mm->flags);
+			}
+			task_unlock(p);
+		}
+
 		debug_show_all_locks();
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are


