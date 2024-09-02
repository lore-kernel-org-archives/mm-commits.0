Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B791448ED
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248847; cv=none; b=lxDiva/5SO0K5VupdZeEWfeh369sIEIJXir1Cm8N7BwSVe3ub7MH7unGUZWG+lMwRneqTCJiMDCuwUDzpfoeJPorIuKUN1zvoD+QoqGqz0HtLpU0LRbcDPJ8IOUEnQ0RMeTCXKgIj1OMbRhi9CqYDX2O91nzWFkxmxiHURp8D5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248847; c=relaxed/simple;
	bh=3OTHAemLBH5MPACCkGvlzw3vIjSZHL3XF3o7dVCREiE=;
	h=Date:To:From:Subject:Message-Id; b=W2cPPrHBQ1X7HmW6Baq6OdQ0WvHcpUdQZr3Vmv7it8ZZHUzL6Xzb5oPAM4RKBirvU4EESDdPsd8BpWhH99MPS3jgYUIhLslEbQhoX92xokJyPITHVxdR5YPtrUAIgD+sn4JP6AR4WAaVgyt0me+V/WJjNbhlJ/Kfo8qDrk8qxyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DKv2hUb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKv2hUb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA41C4CEC7;
	Mon,  2 Sep 2024 03:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248847;
	bh=3OTHAemLBH5MPACCkGvlzw3vIjSZHL3XF3o7dVCREiE=;
	h=Date:To:From:Subject:From;
	b=DKv2hUb24zNw8qx62OPKFjme4s0X5wpUa7CfNPALd111BNIVVofzoIQcEsjdEX0/u
	 edUDZYpBX+J1D3b78OM8iHoniXARPACGOWkXqleYXtC4i87GGgy3SVWedsH+U5irRm
	 g0c2K4MOTZ+ZenRo35h5hXH6TJcVKdt9JylQtZpc=
Date: Sun, 01 Sep 2024 20:47:26 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,peterz@infradead.org,mjguzik@gmail.com,mic@digikod.net,davidgow@google.com,akpm@linux-foundation.org,agruenba@redhat.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch removed from -mm tree
Message-Id: <20240902034727.1AA41C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kthread: fix task state in kthread worker if being frozen
has been removed from the -mm tree.  Its filename was
     kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: kthread: fix task state in kthread worker if being frozen
Date: Tue, 27 Aug 2024 19:23:08 +0800

When analyzing a kernel waring message, Peter pointed out that there is a
race condition when the kworker is being frozen and falls into
try_to_freeze() with TASK_INTERRUPTIBLE, which could trigger a
might_sleep() warning in try_to_freeze().  Although the root cause is not
related to freeze()[1], it is still worthy to fix this issue ahead.

One possible race scenario:

        CPU 0                                           CPU 1
        -----                                           -----

        // kthread_worker_fn
        set_current_state(TASK_INTERRUPTIBLE);
                                                       suspend_freeze_processes()
                                                         freeze_processes
                                                           static_branch_inc(&freezer_active);
                                                         freeze_kernel_threads
                                                           pm_nosig_freezing = true;
        if (work) { //false
          __set_current_state(TASK_RUNNING);

        } else if (!freezing(current)) //false, been frozen

                      freezing():
                      if (static_branch_unlikely(&freezer_active))
                        if (pm_nosig_freezing)
                          return true;
          schedule()
	}

        // state is still TASK_INTERRUPTIBLE
        try_to_freeze()
          might_sleep() <--- warning

Fix this by explicitly set the TASK_RUNNING before entering
try_to_freeze().

Link: https://lore.kernel.org/lkml/Zs2ZoAcUsZMX2B%2FI@chenyu5-mobl2/ [1]
Link: https://lkml.kernel.org/r/20240827112308.181081-1-yu.c.chen@intel.com
Fixes: b56c0d8937e6 ("kthread: implement kthread_worker")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread-fix-task-state-in-kthread-worker-if-being-frozen
+++ a/kernel/kthread.c
@@ -845,8 +845,16 @@ repeat:
 		 * event only cares about the address.
 		 */
 		trace_sched_kthread_work_execute_end(work, func);
-	} else if (!freezing(current))
+	} else if (!freezing(current)) {
 		schedule();
+	} else {
+		/*
+		 * Handle the case where the current remains
+		 * TASK_INTERRUPTIBLE. try_to_freeze() expects
+		 * the current to be TASK_RUNNING.
+		 */
+		__set_current_state(TASK_RUNNING);
+	}
 
 	try_to_freeze();
 	cond_resched();
_

Patches currently in -mm which might be from yu.c.chen@intel.com are


