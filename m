From: akpm@linux-foundation.org
Subject: [merged]
 oom-oom_reaper-do-not-enqueue-task-if-it-is-on-the-oom_reaper_list-head.patch removed from -mm tree
Date: Mon, 04 Apr 2016 11:09:47 -0700
Message-ID: <5702adeb.jXdwbyZEWAMnhImI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbcDDSJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: do not enqueue task if it is on the oom_reaper_list head
has been removed from the -mm tree.  Its filename was
     oom-oom_reaper-do-not-enqueue-task-if-it-is-on-the-oom_reaper_list-head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom, oom_reaper: do not enqueue task if it is on the oom_reaper_list head

bb29902a7515 ("oom, oom_reaper: protect oom_reaper_list using simpler
way") has simplified the check for tasks already enqueued for the oom
reaper by checking tsk->oom_reaper_list != NULL.  This check is not
sufficient because the tsk might be the head of the queue without any
other tasks queued and then we would simply lockup looping on the same
task.  Fix the condition by checking for the head as well.

Fixes: bb29902a7515 ("oom, oom_reaper: protect oom_reaper_list using simpler way")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-oom_reaper-do-not-enqueue-task-if-it-is-on-the-oom_reaper_list-head mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-do-not-enqueue-task-if-it-is-on-the-oom_reaper_list-head
+++ a/mm/oom_kill.c
@@ -547,7 +547,11 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	if (!oom_reaper_th || tsk->oom_reaper_list)
+	if (!oom_reaper_th)
+		return;
+
+	/* tsk is already queued? */
+	if (tsk == oom_reaper_list || tsk->oom_reaper_list)
 		return;
 
 	get_task_struct(tsk);
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

