From: akpm@linux-foundation.org
Subject: [merged]
 mmoom_reaper-remove-pointless-kthread_run-error-check.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:05:28 -0800
Message-ID: <20171116200528.Or0TSX7Wc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936737AbdKPUF3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: mm,oom_reaper: remove pointless kthread_run() error check
has been removed from the -mm tree.  Its filename was
     mmoom_reaper-remove-pointless-kthread_run-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom_reaper: remove pointless kthread_run() error check

Since oom_init() is called before userspace processes start, memory
allocation failure for creating the OOM reaper kernel thread will let the
OOM killer call panic() rather than wake up the OOM reaper.

Link: http://lkml.kernel.org/r/1510137800-4602-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/oom_kill.c~mmoom_reaper-remove-pointless-kthread_run-error-check mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom_reaper-remove-pointless-kthread_run-error-check
+++ a/mm/oom_kill.c
@@ -640,9 +640,6 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	if (!oom_reaper_th)
-		return;
