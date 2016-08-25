From: akpm@linux-foundation.org
Subject: + mmoom_reaper-do-not-attempt-to-reap-a-task-twice.patch added to -mm tree
Date: Thu, 25 Aug 2016 14:42:01 -0700
Message-ID: <57bf6629.M/H6bL5aOZTMW0nP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58841 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754447AbcHYVmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, oleg@redhat.com, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom_reaper: do not attempt to reap a task twice
has been added to the -mm tree.  Its filename is
     mmoom_reaper-do-not-attempt-to-reap-a-task-twice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom_reaper-do-not-attempt-to-reap-a-task-twice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom_reaper-do-not-attempt-to-reap-a-task-twice.patch

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
Subject: mm,oom_reaper: do not attempt to reap a task twice

"mm, oom_reaper: do not attempt to reap a task twice" tried to give the
OOM reaper one more chance to retry using MMF_OOM_NOT_REAPABLE flag.  But
the usefulness of the flag is rather limited and actually never shown in
practice.  If the flag is set, it means that the holder of mm->mmap_sem
cannot call up_write() due to presumably being blocked at unkillable wait
waiting for other thread's memory allocation.  But since one of threads
sharing that mm will queue that mm immediately via task_will_free_mem()
shortcut (otherwise, oom_badness() will select the same mm again due to
oom_score_adj value unchanged), retrying MMF_OOM_NOT_REAPABLE mm is
unlikely helpful.

Let's always set MMF_OOM_REAPED.

Link: http://lkml.kernel.org/r/1472119394-11342-3-git-send-email-mhocko@kernel.org
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 mm/oom_kill.c         |   15 +++------------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN include/linux/sched.h~mmoom_reaper-do-not-attempt-to-reap-a-task-twice include/linux/sched.h
--- a/include/linux/sched.h~mmoom_reaper-do-not-attempt-to-reap-a-task-twice
+++ a/include/linux/sched.h
@@ -523,7 +523,6 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_REAPED		21	/* mm has been already reaped */
-#define MMF_OOM_NOT_REAPABLE	22	/* mm couldn't be reaped */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN mm/oom_kill.c~mmoom_reaper-do-not-attempt-to-reap-a-task-twice mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom_reaper-do-not-attempt-to-reap-a-task-twice
+++ a/mm/oom_kill.c
@@ -578,20 +578,11 @@ static void oom_reap_task(struct task_st
 	if (attempts <= MAX_OOM_REAP_RETRIES)
 		goto done;
 
+	/* Ignore this mm because somebody can't call up_write(mmap_sem). */
+	set_bit(MMF_OOM_REAPED, &mm->flags);
+
 	pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
 		task_pid_nr(tsk), tsk->comm);
