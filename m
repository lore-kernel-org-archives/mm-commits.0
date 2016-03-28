From: akpm@linux-foundation.org
Subject: [alternative-merged]
 oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
 removed from -mm tree
Date: Mon, 28 Mar 2016 15:55:41 -0700
Message-ID: <56f9b66d.tite3BzTCbNmTXdy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbcC1Wzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 18:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hughd@google.com, mgorman@techsingularity.net, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task
has been removed from the -mm tree.  Its filename was
     oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch

This patch was dropped because an alternative patch was merged

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
@@ -512,6 +512,8 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 
+#define MMF_OOM_KILLED		21	/* OOM killer has chosen this mm */
+
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
diff -puN mm/oom_kill.c~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task
+++ a/mm/oom_kill.c
@@ -680,7 +680,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-	bool can_oom_reap = true;
+	bool can_oom_reap;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -742,6 +742,10 @@ void oom_kill_process(struct oom_control
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

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

