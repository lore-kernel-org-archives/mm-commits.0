From: akpm@linux-foundation.org
Subject: [merged] epoll-fix-nested-calls-support.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:52 -0700
Message-ID: <200906182243.n5IMhqtX002937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613AbZFRWpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, stable@kernel.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     epoll: fix nested calls support
has been removed from the -mm tree.  Its filename was
     epoll-fix-nested-calls-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: fix nested calls support
From: Davide Libenzi <davidel@xmailserver.org>

This fixes a regression in 2.6.30.

I unfortunately accepted a patch time ago, to drop the "current" usage
from possible IRQ context, w/out proper thought over it.  The patch
switched to using the CPU id by bounding the nested call callback with a
get_cpu()/put_cpu().

Unfortunately the ep_call_nested() function can be called with a callback
that grabs sleepy locks (from own f_op->poll()), that results in epic
fails.  The following patch uses the proper "context" depending on the
path where it is called, and on the kind of callback.

This has been reported by Stefan Richter, that has also verified the patch
is his previously failing environment.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-nested-calls-support fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-nested-calls-support
+++ a/fs/eventpoll.c
@@ -98,7 +98,7 @@ struct epoll_filefd {
 struct nested_call_node {
 	struct list_head llink;
 	void *cookie;
-	int cpu;
+	void *ctx;
 };
 
 /*
@@ -317,17 +317,17 @@ static void ep_nested_calls_init(struct 
  * @nproc: Nested call core function pointer.
  * @priv: Opaque data to be passed to the @nproc callback.
  * @cookie: Cookie to be used to identify this nested call.
+ * @ctx: This instance context.
  *
  * Returns: Returns the code returned by the @nproc callback, or -1 if
  *          the maximum recursion limit has been exceeded.
  */
 static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
 			  int (*nproc)(void *, void *, int), void *priv,
-			  void *cookie)
+			  void *cookie, void *ctx)
 {
 	int error, call_nests = 0;
 	unsigned long flags;
-	int this_cpu = get_cpu();
 	struct list_head *lsthead = &ncalls->tasks_call_list;
 	struct nested_call_node *tncur;
 	struct nested_call_node tnode;
@@ -340,7 +340,7 @@ static int ep_call_nested(struct nested_
 	 * very much limited.
 	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-		if (tncur->cpu == this_cpu &&
+		if (tncur->ctx == ctx &&
 		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
@@ -352,7 +352,7 @@ static int ep_call_nested(struct nested_
 	}
 
 	/* Add the current task and cookie to the list */
-	tnode.cpu = this_cpu;
+	tnode.ctx = ctx;
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
@@ -364,10 +364,9 @@ static int ep_call_nested(struct nested_
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
- out_unlock:
+out_unlock:
 	spin_unlock_irqrestore(&ncalls->lock, flags);
 
-	put_cpu();
 	return error;
 }
 
@@ -408,8 +407,12 @@ static int ep_poll_wakeup_proc(void *pri
  */
 static void ep_poll_safewake(wait_queue_head_t *wq)
 {
+	int this_cpu = get_cpu();
+
 	ep_call_nested(&poll_safewake_ncalls, EP_MAX_NESTS,
-		       ep_poll_wakeup_proc, NULL, wq);
+		       ep_poll_wakeup_proc, NULL, wq, (void *) (long) this_cpu);
+
+	put_cpu();
 }
 
 /*
@@ -663,7 +666,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * could re-enter here.
 	 */
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep);
+				   ep_poll_readyevents_proc, ep, ep, current);
 
 	return pollflags != -1 ? pollflags : 0;
 }
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

