From: akpm@linux-foundation.org
Subject: [merged] fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:07 -0700
Message-ID: <20120601193407.79CEEA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46196 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125Ab2FATeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:08 -0400
Received: by vcbfl13 with SMTP id fl13so245502vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: call complete_vfork_done() after clearing child_tid and flushing rss-counters
has been removed from the -mm tree.  Its filename was
     fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: fork: call complete_vfork_done() after clearing child_tid and flushing rss-counters

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

diff -puN kernel/fork.c~fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters kernel/fork.c
--- a/kernel/fork.c~fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters
+++ a/kernel/fork.c
@@ -787,9 +787,6 @@ void mm_release(struct task_struct *tsk,
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
 	/*
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
@@ -810,6 +807,13 @@ void mm_release(struct task_struct *tsk,
 		}
 		tsk->clear_child_tid = NULL;
 	}
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

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

