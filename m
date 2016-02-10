From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch removed from -mm tree
Date: Wed, 10 Feb 2016 11:35:38 -0800
Message-ID: <56bb910a.ccmv8iesdFPkR+t4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbcBJTfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, arekm@maven.pl, clameter@sgi.com, iamjoonsoo.kim@lge.com, jstancek@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: fix wrong WQ sleep when memory reclaim doesn't make any progress
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-wrong-wq-sleep-when-memory-reclaim-doesnt-make-any-progress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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


