From: akpm@linux-foundation.org
Subject: [merged] epoll-fix-spurious-lockdep-warnings.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:17:00 -0700
Message-ID: <201111012117.pA1LH0kM019194@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nelhage@nelhage.com, davej@redhat.com, davidel@xmailserver.org, jbaron@redhat.com, pebolle@tiscali.nl, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: fix spurious lockdep warnings
has been removed from the -mm tree.  Its filename was
     epoll-fix-spurious-lockdep-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Nelson Elhage <nelhage@nelhage.com>
Subject: epoll: fix spurious lockdep warnings

epoll can acquire recursively acquire ep->mtx on multiple "struct
eventpoll"s at once in the case where one epoll fd is monitoring another
epoll fd.  This is perfectly OK, since we're careful about the lock
ordering, but it causes spurious lockdep warnings.  Annotate the recursion
using mutex_lock_nested, and add a comment explaining the nesting rules
for good measure.

Recent versions of systemd are triggering this, and it can also be
demonstrated with the following trivial test program:

--------------------8<--------------------

int main(void) {
   int e1, e2;
   struct epoll_event evt = {
       .events = EPOLLIN
   };

   e1 = epoll_create1(0);
   e2 = epoll_create1(0);
   epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
   return 0;
}
--------------------8<--------------------

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-spurious-lockdep-warnings fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-spurious-lockdep-warnings
+++ a/fs/eventpoll.c
@@ -70,6 +70,15 @@
  * simultaneous inserts (A into B and B into A) from racing and
  * constructing a cycle without either insert observing that it is
  * going to.
+ * It is necessary to acquire multiple "ep->mtx"es at once in the
+ * case when one epoll fd is added to another. In this case, we
+ * always acquire the locks in the order of nesting (i.e. after
+ * epoll_ctl(e1, EPOLL_CTL_ADD, e2), e1->mtx will always be acquired
+ * before e2->mtx). Since we disallow cycles of epoll file
+ * descriptors, this ensures that the mutexes are well-ordered. In
+ * order to communicate this nesting to lockdep, when walking a tree
+ * of epoll file descriptors, we use the current recursion depth as
+ * the lockdep subkey.
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -464,13 +473,15 @@ static void ep_unregister_pollwait(struc
  * @ep: Pointer to the epoll private data structure.
  * @sproc: Pointer to the scan callback.
  * @priv: Private opaque data passed to the @sproc callback.
+ * @depth: The current depth of recursive f_op->poll calls.
  *
  * Returns: The same integer error code returned by the @sproc callback.
  */
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv)
+			      void *priv,
+			      int depth)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -481,7 +492,7 @@ static int ep_scan_ready_list(struct eve
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -670,7 +681,7 @@ static int ep_read_events_proc(struct ev
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -737,7 +748,7 @@ void eventpoll_release_file(struct file 
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		mutex_lock(&ep->mtx);
+		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
@@ -1134,7 +1145,7 @@ static int ep_send_events(struct eventpo
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1267,7 +1278,7 @@ static int ep_loop_check_proc(void *priv
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1409,7 +1420,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	}
 
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
_

Patches currently in -mm which might be from nelhage@nelhage.com are

origin.patch

