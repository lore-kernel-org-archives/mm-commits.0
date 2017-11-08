From: akpm@linux-foundation.org
Subject: + mmoom_reaper-remove-pointless-kthread_run-error-check.patch
 added to -mm tree
Date: Wed, 08 Nov 2017 15:35:38 -0800
Message-ID: <5a0394ca.GAVXwDeoWW2Nnj4N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbdKHXfk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2017 18:35:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom_reaper: remove pointless kthread_run() error check
has been added to the -mm tree.  Its filename is
     mmoom_reaper-remove-pointless-kthread_run-error-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom_reaper-remove-pointless-kthread_run-error-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom_reaper-remove-pointless-kthread_run-error-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -641,9 +641,6 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	if (!oom_reaper_th)
-		return;
