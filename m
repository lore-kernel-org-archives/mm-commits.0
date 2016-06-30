From: akpm@linux-foundation.org
Subject: +
 cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch added
 to -mm tree
Date: Wed, 29 Jun 2016 23:56:25 -0700
Message-ID: <5774c299.n0IQ4WAJczDLw2Mw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbcF3HGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jun 2016 03:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, miaox@cn.fujitsu.com, rientjes@google.com, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset, mm: fix TIF_MEMDIE check in cpuset_change_task_nodemask
has been added to the -mm tree.  Its filename is
     cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch

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
Subject: cpuset, mm: fix TIF_MEMDIE check in cpuset_change_task_nodemask

c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
cpuset's mems") has added TIF_MEMDIE and PF_EXITING check but it is
checking the flag on the current task rather than the given one.  This
doesn't make much sense and it is actually wrong.  If the current task
which updates the nodemask of a cpuset got killed by the OOM killer then a
part of the cpuset cgroup processes would have incompatible nodemask which
is surprising to say the least.

The comment suggests the intention was to skip oom victim or an exiting
task so we should be checking the given task.  But even then it would be
layering violation becuase it is the memory allocator to interpret the
TIF_MEMDIE meaning.  Simply drop both checks.  All tasks in the cpuset
should simply follow the same mask.

Link: http://lkml.kernel.org/r/1467029719-17602-3-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN kernel/cpuset.c~cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask
+++ a/kernel/cpuset.c
@@ -1034,15 +1034,6 @@ static void cpuset_change_task_nodemask(
 {
 	bool need_loop;
 
-	/*
-	 * Allow tasks that have access to memory reserves because they have
-	 * been OOM killed to get memory anywhere.
-	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
-		return;
-	if (current->flags & PF_EXITING) /* Let dying task have memory */
-		return;
-
 	task_lock(tsk);
 	/*
 	 * Determine if a loop is necessary if another thread is doing
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

