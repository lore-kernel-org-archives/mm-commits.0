Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC47B80034
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724800608; cv=none; b=G3/DeIYcs7FptmLSHV0ZHRpN2sDwAuygLQgH4KzvG/5MaXFgJ9mRnNebPFWY4MtKvjWi6Gl+xnxa2C8TzfxmmxTez9PJ0jrno9+HpUUiI5zuAktPxQFV4p0PmrA+Jun1gPSr1aAgOh9FN76y/FUjrO87Oh9wf50gsj3p11CgIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724800608; c=relaxed/simple;
	bh=AsaYI7TVRw/M++d9QRZ0nCpRaYrg9IIom4IMMApkr40=;
	h=Date:To:From:Subject:Message-Id; b=XQdlJjnEygou/7sFdof7YWFgcIi9hyn8AdDQJ7WhpSjPPzV5FXMUTu79am/GWAbSQBsKVjlegjP46JnIXm3bPPpvkjr5VEyIFP01nWviC54vx0NuK8pecQ3PeIZTuxFg64JorRnAQZNDBZNQQAA50sQDENhQBCdDnxZjaNrVYmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XNzC8aiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XNzC8aiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C9BC4AF12;
	Tue, 27 Aug 2024 23:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724800608;
	bh=AsaYI7TVRw/M++d9QRZ0nCpRaYrg9IIom4IMMApkr40=;
	h=Date:To:From:Subject:From;
	b=XNzC8aiF0d+ImrNcszkVehML8WpejeOMrVSbVdPlsysN5y2l5VP5JH1l7ki0z5SzH
	 2QGLWJg/YoEB8/ipwauRxUBXWMvrEEEYgafW39hYciPXJrb3q/EwEvmx9kV0/8HLTF
	 l+nPtNBxRAvxbNFog+0znqDuq5qcg1WAgSJE9U5A=
Date: Tue, 27 Aug 2024 16:16:47 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,peterz@infradead.org,mjguzik@gmail.com,mic@digikod.net,davidgow@google.com,akpm@linux-foundation.org,agruenba@redhat.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch added to mm-nonmm-unstable branch
Message-Id: <20240827231648.56C9BC4AF12@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kthread: fix task state in kthread worker if being frozen
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kthread-fix-task-state-in-kthread-worker-if-being-frozen.patch

