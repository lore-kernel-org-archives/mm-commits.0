From: akpm@linux-foundation.org
Subject: + core-workqueue-return-on-workqueue-recursion.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:10:24 -0800
Message-ID: <201002041810.o14IAObR013090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab0BDSMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon.kagstrom@netinsight.net, mingo@elte.hu, oleg@redhat.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     ] core: workqueue: return on workqueue recursion
has been added to the -mm tree.  Its filename is
     core-workqueue-return-on-workqueue-recursion.patch

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
core-workqueue-return-on-workqueue-recursion.patch

