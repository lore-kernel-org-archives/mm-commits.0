From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup.patch
 removed from -mm tree
Date: Tue, 31 May 2016 10:50:24 -0700
Message-ID: <574dcee0.HlAao5wz7wO6Yg3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcEaRuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom: do not reap task if there are live threads in threadgroup
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: oom: do not reap task if there are live threads in threadgroup

If the current process is exiting, we don't invoke oom killer, instead we
give it access to memory reserves and try to reap its mm in case nobody is
going to use it.  There's a mistake in the code performing this check - we
just ignore any process of the same thread group no matter if it is
exiting or not - see try_oom_reaper.  Fix it.

Link: http://lkml.kernel.org/r/1464087628-7318-1-git-send-email-vdavydov@virtuozzo.com
Fixes: 3ef22dfff239 ("oom, oom_reaper: try to reap tasks which skip regular OOM killer path")Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup
+++ a/mm/oom_kill.c
@@ -611,8 +611,6 @@ void try_oom_reaper(struct task_struct *
 
 			if (!process_shares_mm(p, mm))
 				continue;
-			if (same_thread_group(p, tsk))
-				continue;
 			if (fatal_signal_pending(p))
 				continue;
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch

