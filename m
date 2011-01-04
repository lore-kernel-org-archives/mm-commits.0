From: akpm@linux-foundation.org
Subject: + kernel-workqueuec-remove-noop-in-workqueue.patch added to -mm tree
Date: Tue, 04 Jan 2011 13:35:37 -0800
Message-ID: <201101042135.p04LZb3f025451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADVfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 16:35:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, tj@kernel.org


The patch titled
     kernel/workqueue.c: remove noop in workqueue
has been added to the -mm tree.  Its filename is
     kernel-workqueuec-remove-noop-in-workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-workqueuec-remove-noop-in-workqueue.patch

