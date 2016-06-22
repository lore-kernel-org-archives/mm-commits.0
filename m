From: akpm@linux-foundation.org
Subject: + mm-oom-kill-all-tasks-sharing-the-mm.patch added to -mm tree
Date: Wed, 22 Jun 2016 14:46:00 -0700
Message-ID: <576b0718.vL7ljofDNd/OaCUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcFVVqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: kill all tasks sharing the mm
has been added to the -mm tree.  Its filename is
     mm-oom-kill-all-tasks-sharing-the-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-kill-all-tasks-sharing-the-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-kill-all-tasks-sharing-the-mm.patch

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

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch
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

