From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch added to -mm tree
Date: Mon, 01 Feb 2016 22:37:35 -0800
Message-ID: <56b04eaf.WGrTCIPbv3bq1X/4%akpm__12080.700757406$1454395075$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcBBGhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, arekm@maven.pl, clameter@sgi.com, js1304@gmail.com, jstancek@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: fix wrong WQ sleep when memory reclaim doesn't make any progress
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: mm, vmstat: fix wrong WQ sleep when memory reclaim doesn't make any progress

Jan Stancek has reported that system occasionally hanging after "oom01"
testcase from LTP triggers OOM.  Guessing from a result that there is a
kworker thread doing memory allocation and the values between "Node 0
Normal free:" and "Node 0 Normal:" differs when hanging, vmstat is not
up-to-date for some reason.

According to commit 373ccbe59270 ("mm, vmstat: allow WQ concurrency to
discover memory reclaim doesn't make any progress"), it meant to force the
kworker thread to take a short sleep, but it by error used
schedule_timeout(1).  We missed that schedule_timeout() in state
TASK_RUNNING doesn't do anything.

Fix it by using schedule_timeout_uninterruptible(1) which forces the
kworker thread to take a short sleep in order to make sure that vmstat is
up-to-date.

Fixes: 373ccbe59270 ("mm, vmstat: allow WQ concurrency to discover memory reclaim doesn't make any progress")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Cristopher Lameter <clameter@sgi.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/backing-dev.c~mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress mm/backing-dev.c
--- a/mm/backing-dev.c~mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress
+++ a/mm/backing-dev.c
@@ -989,7 +989,7 @@ long wait_iff_congested(struct zone *zon
 		 * here rather than calling cond_resched().
 		 */
 		if (current->flags & PF_WQ_WORKER)
-			schedule_timeout(1);
+			schedule_timeout_uninterruptible(1);
 		else
 			cond_resched();
 
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch

