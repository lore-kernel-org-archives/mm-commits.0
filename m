From: akpm@linux-foundation.org
Subject: [merged] epoll-remove-unnecessary-xchg.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:33 -0700
Message-ID: <200904011840.n31IeX0M009056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933469AbZDATOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: remove unnecessary xchg
has been removed from the -mm tree.  Its filename was
     epoll-remove-unnecessary-xchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: remove unnecessary xchg
From: Tony Battersby <tonyb@cybernetics.com>

xchg in ep_unregister_pollwait() is unnecessary because it is protected by
either epmutex or ep->mtx (the same protection as ep_remove()).

If xchg was necessary, it would be insufficient to protect against
problems: if multiple concurrent calls to ep_unregister_pollwait() were
possible then a second caller that returns without doing anything because
nwait == 0 could return before the waitqueues are removed by the first
caller, which looks like it could lead to problematic races with
ep_poll_callback().

So remove xchg and add comments about the locking.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/eventpoll.c~epoll-remove-unnecessary-xchg fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-remove-unnecessary-xchg
+++ a/fs/eventpoll.c
@@ -394,27 +394,21 @@ static void ep_poll_safewake(wait_queue_
 }
 
 /*
- * This function unregister poll callbacks from the associated file descriptor.
- * Since this must be called without holding "ep->lock" the atomic exchange trick
- * will protect us from multiple unregister.
+ * This function unregisters poll callbacks from the associated file
+ * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
+ * ep_free).
  */
 static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 {
-	int nwait;
 	struct list_head *lsthead = &epi->pwqlist;
 	struct eppoll_entry *pwq;
 
-	/* This is called without locks, so we need the atomic exchange */
-	nwait = xchg(&epi->nwait, 0);
+	while (!list_empty(lsthead)) {
+		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
-	if (nwait) {
-		while (!list_empty(lsthead)) {
-			pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
