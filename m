From: akpm@linux-foundation.org
Subject: [merged] kernel-workqueuec-remove-noop-in-workqueue.patch removed from -mm tree
Date: Mon, 10 Jan 2011 13:30:32 -0800
Message-ID: <201101102132.p0ALWmi9012824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab1AJVcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 16:32:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/workqueue.c: remove noop in workqueue
has been removed from the -mm tree.  Its filename was
     kernel-workqueuec-remove-noop-in-workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/workqueue.c: remove noop in workqueue
From: Hillf Danton <dhillf@gmail.com>

Checking WORKER_NOT_RUNNING in the flags word of worker is unnecessary if
it is set in the flags parameter.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/workqueue.c~kernel-workqueuec-remove-noop-in-workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~kernel-workqueuec-remove-noop-in-workqueue
+++ a/kernel/workqueue.c
@@ -770,7 +770,6 @@ static inline void worker_clr_flags(stru
 
 	/* if transitioning out of NOT_RUNNING, increment nr_running */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
-		if (!(worker->flags & WORKER_NOT_RUNNING))
 			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
 }
 
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch

