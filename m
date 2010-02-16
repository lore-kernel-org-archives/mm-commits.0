From: akpm@linux-foundation.org
Subject: [merged] core-workqueue-return-on-workqueue-recursion.patch removed from -mm tree
Date: Tue, 16 Feb 2010 10:35:09 -0800
Message-ID: <201002161835.o1GIZ9Et030412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933208Ab0BPSgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 13:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon.kagstrom@netinsight.net, mingo@elte.hu, oleg@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ] core: workqueue: return on workqueue recursion
has been removed from the -mm tree.  Its filename was
     core-workqueue-return-on-workqueue-recursion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ] core: workqueue: return on workqueue recursion
From: Simon Kagstrom <simon.kagstrom@netinsight.net>

When the workqueue is flushed from workqueue context (recursively), the
system enters a strange state where things at random (dependent on the
global workqueue) start misbehaving.  For example, for us the console and
logins locks up while the web server continues running.

The system becomes unstable since the workqueue barrier locks the
workqueue.  This patch instead returns if the workqueue is flushed
recursively, which keeps the workqueue alive but warns.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~core-workqueue-return-on-workqueue-recursion kernel/workqueue.c
--- a/kernel/workqueue.c~core-workqueue-return-on-workqueue-recursion
+++ a/kernel/workqueue.c
@@ -482,7 +482,8 @@ static int flush_cpu_workqueue(struct cp
 	int active = 0;
 	struct wq_barrier barr;
 
-	WARN_ON(cwq->thread == current);
+	if (WARN_ON(cwq->thread == current))
+		return 1;
 
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
_

Patches currently in -mm which might be from simon.kagstrom@netinsight.net are

linux-next.patch
lkdtm-add-debugfs-access-and-loosen-kprobe-ties.patch

