From: akpm@linux-foundation.org
Subject: [merged] mm-oom-kill-all-tasks-sharing-the-mm.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:53:52 -0700
Message-ID: <579ba640.x5Qfpl+DfuryVli7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcG2Sxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: kill all tasks sharing the mm
has been removed from the -mm tree.  Its filename was
     mm-oom-kill-all-tasks-sharing-the-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: kill all tasks sharing the mm

Currently oom_kill_process skips both the oom reaper and SIG_KILL if a
process sharing the same mm is unkillable via OOM_ADJUST_MIN.  After "mm,
oom_adj: make sure processes sharing mm have same view of oom_score_adj"
all such processes are sharing the same value so we shouldn't see such a
task at all (oom_badness would rule them out).

We can still encounter oom disabled vforked task which has to be killed as
well if we want to have other tasks sharing the mm reapable because it can
access the memory before doing exec.  Killing such a task should be
acceptable because it is highly unlikely it has done anything useful
because it cannot modify any memory before it calls exec.  An alternative
would be to keep the task alive and skip the oom reaper and risk all the
weird corner cases where the OOM killer cannot make forward progress
because the oom victim hung somewhere on the way to exit.

[rientjes@google.com - drop printk when OOM_SCORE_ADJ_MIN killed task
 the setting is inherently racy and we cannot do much about it without
 introducing locks in hot paths]
Link: http://lkml.kernel.org/r/1466426628-15074-7-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-kill-all-tasks-sharing-the-mm mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-kill-all-tasks-sharing-the-mm
+++ a/mm/oom_kill.c
@@ -852,8 +852,7 @@ void oom_kill_process(struct oom_control
 			continue;
 		if (same_thread_group(p, victim))
 			continue;
-		if (unlikely(p->flags & PF_KTHREAD) || is_global_init(p) ||
-		    p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		if (unlikely(p->flags & PF_KTHREAD) || is_global_init(p)) {
 			/*
 			 * We cannot use oom_reaper for the mm shared by this
 			 * process because it wouldn't get killed and so the
_

Patches currently in -mm which might be from mhocko@suse.com are


