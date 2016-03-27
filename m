From: akpm@linux-foundation.org
Subject: [merged] mm-oom_reaper-report-success-failure.patch removed from
 -mm tree
Date: Sat, 26 Mar 2016 20:29:56 -0700
Message-ID: <56f753b4.42kttGwbp3JQKcWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0D35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: report success/failure
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-report-success-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: report success/failure

Inform about the successful/failed oom_reaper attempts and dump all the
held locks to tell us more who is blocking the progress.

[akpm@linux-foundation.org: fix CONFIG_MMU=n build]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-report-success-failure mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-report-success-failure
+++ a/mm/oom_kill.c
@@ -410,6 +410,8 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 bool oom_killer_disabled __read_mostly;
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 #ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
@@ -479,6 +481,11 @@ static bool __oom_reap_task(struct task_
 					 &details);
 	}
 	tlb_finish_mmu(&tlb, 0, -1);
+	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
+			task_pid_nr(tsk), tsk->comm,
+			K(get_mm_counter(mm, MM_ANONPAGES)),
+			K(get_mm_counter(mm, MM_FILEPAGES)),
+			K(get_mm_counter(mm, MM_SHMEMPAGES)));
 	up_read(&mm->mmap_sem);
 
 	/*
@@ -495,14 +502,21 @@ out:
 	return ret;
 }
 
+#define MAX_OOM_REAP_RETRIES 10
 static void oom_reap_task(struct task_struct *tsk)
 {
 	int attempts = 0;
 
 	/* Retry the down_read_trylock(mmap_sem) a few times */
-	while (attempts++ < 10 && !__oom_reap_task(tsk))
+	while (attempts++ < MAX_OOM_REAP_RETRIES && !__oom_reap_task(tsk))
 		schedule_timeout_idle(HZ/10);
 
+	if (attempts > MAX_OOM_REAP_RETRIES) {
+		pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
+				task_pid_nr(tsk), tsk->comm);
+		debug_show_all_locks();
+	}
+
 	/* Drop a reference taken by wake_oom_reaper */
 	put_task_struct(tsk);
 }
@@ -649,7 +663,6 @@ static bool process_shares_mm(struct tas
 	return false;
 }
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
  * returning.
_

Patches currently in -mm which might be from mhocko@suse.com are

oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

