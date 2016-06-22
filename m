From: akpm@linux-foundation.org
Subject: + mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
 added to -mm tree
Date: Wed, 22 Jun 2016 14:46:04 -0700
Message-ID: <576b071c.wSZ7QyiHFEGh4OUM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcFVVqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: task_will_free_mem should skip oom_reaped tasks
has been added to the -mm tree.  Its filename is
     mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch

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
Subject: mm, oom: task_will_free_mem should skip oom_reaped tasks

0-day robot has encountered the following:
[   82.694232] Out of memory: Kill process 3914 (trinity-c0) score 167 or sacrifice child
[   82.695110] Killed process 3914 (trinity-c0) total-vm:55864kB, anon-rss:1512kB, file-rss:1088kB, shmem-rss:25616kB
[   82.706724] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26488kB
[   82.715540] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26900kB
[   82.717662] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26900kB
[   82.725804] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:27296kB
[   82.739091] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:28148kB

oom_reaper is trying to reap the same task again and again.  This is
possible only when the oom killer is bypassed because of
task_will_free_mem because we skip over tasks with MMF_OOM_REAPED already
set during select_bad_process.  Teach task_will_free_mem to skip over
MMF_OOM_REAPED tasks as well because they will be unlikely to free
anything more.

Analyzed by Tetsuo Handa.

Link: http://lkml.kernel.org/r/1466426628-15074-9-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/oom_kill.c~mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks
+++ a/mm/oom_kill.c
@@ -747,6 +747,16 @@ bool task_will_free_mem(struct task_stru
 		return false;
 
 	mm = p->mm;
+
+	/*
+	 * This task has already been drained by the oom reaper so there are
+	 * only small chances it will free some more
+	 */
+	if (test_bit(MMF_OOM_REAPED, &mm->flags)) {
+		task_unlock(p);
+		return false;
+	}
+
 	if (atomic_read(&mm->mm_users) <= 1) {
 		task_unlock(p);
 		return true;
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

