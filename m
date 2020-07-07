From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures]
 kthread-work-could-not-be-queued-when-worker-being-destroyed.patch removed
 from -mm tree
Date: Tue, 07 Jul 2020 12:39:37 -0700
Message-ID: <20200707193937.-C-gHvj5I%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgGGTji (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:39:38 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.dooks@codethink.co.uk, bfields@redhat.com, cl@rock-chips.com, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, qiang.zhang@windriver.com, tj@kernel.org


The patch titled
     Subject: kthread: work could not be queued when worker being destroyed
has been removed from the -mm tree.  Its filename was
     kthread-work-could-not-be-queued-when-worker-being-destroyed.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Zhang Qiang <qiang.zhang@windriver.com>
Subject: kthread: work could not be queued when worker being destroyed

The "queuing_blocked" func should print warning message and returns true
when the worker being destroyed.

Before the work is put into the queue of the worker thread, the state of
the worker thread needs to be detected,because the worker thread may be in
the destruction state at this time.

Link: http://lkml.kernel.org/r/20200705013018.7375-1-qiang.zhang@windriver.com
Link: http://lkml.kernel.org/r/20200702070156.5862-1-qiang.zhang@windriver.com
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Liang Chen <cl@rock-chips.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kthread.c~kthread-work-could-not-be-queued-when-worker-being-destroyed
+++ a/kernel/kthread.c
@@ -814,6 +814,9 @@ static inline bool queuing_blocked(struc
 {
 	lockdep_assert_held(&worker->lock);
 
+	if (WARN_ON(!worker->task))
+		return true;
+
 	return !list_empty(&work->node) || work->canceling;
 }
 
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are
