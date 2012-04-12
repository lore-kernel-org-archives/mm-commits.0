From: akpm@linux-foundation.org
Subject: + mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch added to -mm tree
Date: Thu, 12 Apr 2012 16:37:27 -0700
Message-ID: <20120412233727.C8DE0A02AD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:48552 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966211Ab2DLXh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 19:37:29 -0400
Received: by vcbfk26 with SMTP id fk26so315466vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:37:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com


The patch titled
     Subject: mm: call complete_vfork_done() after clearing child_tid and flushing rss-counters
has been added to the -mm tree.  Its filename is
     mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: call complete_vfork_done() after clearing child_tid and flushing rss-counters

Child should wake up the parent from vfork() only after finishing all
operations with shared mm.  There is no sense in using
CLONE_CHILD_CLEARTID together with CLONE_VFORK, but it looks more accurate
now.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters kernel/fork.c
--- a/kernel/fork.c~mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters
+++ a/kernel/fork.c
@@ -756,9 +756,6 @@ void mm_release(struct task_struct *tsk,
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
 	/*
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
@@ -787,6 +784,13 @@ void mm_release(struct task_struct *tsk,
 	 */
 	if (mm)
 		sync_mm_rss(mm);
+
+	/*
+	 * All done, finally we can wake up parent and return this mm to him.
+	 * Also kthread_stop() uses this completion for synchronization.
+	 */
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 }
 
 /*
_
Subject: Subject: mm: call complete_vfork_done() after clearing child_tid and flushing rss-counters

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-remove-swap-token-code.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch

