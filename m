From: akpm@linux-foundation.org
Subject: + freezer-oom-check-tif_memdie-on-the-correct-task.patch added to -mm tree
Date: Wed, 29 Jun 2016 23:56:23 -0700
Message-ID: <5774c297.wcEVwc/ozrQqoG8k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcF3HGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jun 2016 03:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, miaox@cn.fujitsu.com, rientjes@google.com, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: freezer, oom: check TIF_MEMDIE on the correct task
has been added to the -mm tree.  Its filename is
     freezer-oom-check-tif_memdie-on-the-correct-task.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/freezer-oom-check-tif_memdie-on-the-correct-task.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/freezer-oom-check-tif_memdie-on-the-correct-task.patch

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
Subject: freezer, oom: check TIF_MEMDIE on the correct task

freezing_slow_path() is checking TIF_MEMDIE to skip OOM killed tasks.  It
is, however, checking the flag on the current task rather than the given
one.  This is really confusing because freezing() can be called also on
!current tasks.  It would end up working correctly for its main purpose
because __refrigerator will be always called on the current task so the
oom victim will never get frozen.  But it could lead to surprising results
when a task which is freezing a cgroup got oom killed because only part of
the cgroup would get frozen.  This is highly unlikely but worth fixing as
the resulting code would be more clear anyway.

Link: http://lkml.kernel.org/r/1467029719-17602-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/freezer.c~freezer-oom-check-tif_memdie-on-the-correct-task kernel/freezer.c
--- a/kernel/freezer.c~freezer-oom-check-tif_memdie-on-the-correct-task
+++ a/kernel/freezer.c
@@ -42,7 +42,7 @@ bool freezing_slow_path(struct task_stru
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
-	if (test_thread_flag(TIF_MEMDIE))
+	if (test_tsk_thread_flag(p, TIF_MEMDIE))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
_

Patches currently in -mm which might be from mhocko@suse.com are

arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
mm-oom-fortify-task_will_free_mem-fix.patch
freezer-oom-check-tif_memdie-on-the-correct-task.patch
cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch

