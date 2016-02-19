From: akpm@linux-foundation.org
Subject: +
 oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch added
 to -mm tree
Date: Fri, 19 Feb 2016 12:18:26 -0800
Message-ID: <56c77892.UFIQSKaj7sXk0zsu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993551AbcBSUS1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2016 15:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hughd@google.com, mgorman@techsingularity.net, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task
has been added to the -mm tree.  Its filename is
     oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch

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
Subject: oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task

Tetsuo has reported that oom_kill_allocating_task=1 will cause
oom_reaper_list corruption because oom_kill_process doesn't follow
standard OOM exclusion (aka ignores TIF_MEMDIE) and allows to enqueue
the same task multiple times - e.g. by sacrificing the same child
multiple times.

This patch fixes the issue by introducing a new MMF_OOM_KILLED mm flag
which is set in oom_kill_process atomically and oom reaper is disabled
if the flag was already set.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 mm/oom_kill.c         |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task include/linux/sched.h
--- a/include/linux/sched.h~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task
+++ a/include/linux/sched.h
@@ -513,6 +513,8 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 
+#define MMF_OOM_KILLED		21	/* OOM killer has chosen this mm */
+
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
diff -puN mm/oom_kill.c~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task
+++ a/mm/oom_kill.c
@@ -686,7 +686,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-	bool can_oom_reap = true;
+	bool can_oom_reap;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -748,6 +748,10 @@ void oom_kill_process(struct oom_control
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
 	atomic_inc(&mm->mm_count);
+
+	/* Make sure we do not try to oom reap the mm multiple times */
+	can_oom_reap = !test_and_set_bit(MMF_OOM_KILLED, &mm->flags);
+
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

