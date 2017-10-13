From: akpm@linux-foundation.org
Subject: + epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake.patch
 added to -mm tree
Date: Fri, 13 Oct 2017 14:00:52 -0700
Message-ID: <59e12984.AsMYE9vNsGo3PgX/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdJMVAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, sqazi@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: avoid calling ep_call_nested() from ep_poll_safewake()
has been added to the -mm tree.  Its filename is
     epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: avoid calling ep_call_nested() from ep_poll_safewake()

ep_poll_safewake() is used to wakeup potentially nested epoll file
descriptors.  The function uses ep_call_nested() to prevent entering the
same wake up queue more than once, and to prevent excessively deep wakeup
paths (deeper than EP_MAX_NESTS).  However, this is not necessary since we
are already preventing these conditions during EPOLL_CTL_ADD.  This saves
extra function calls, and avoids taking a global lock during the
ep_call_nested() calls.

I have, however, left ep_call_nested() for the CONFIG_DEBUG_LOCK_ALLOC
case, since ep_call_nested() keeps track of the nesting level, and this is
required by the call to spin_lock_irqsave_nested().  It would be nice to
remove the ep_call_nested() calls for the CONFIG_DEBUG_LOCK_ALLOC case as
well, however its not clear how to simply pass the nesting level through
multiple wake_up() levels without more surgery.  In any case, I don't
think CONFIG_DEBUG_LOCK_ALLOC is generally used for production.  This
patch, also apparently fixes a workload at Google that Salman Qazi
reported by completely removing the poll_safewake_ncalls->lock from wakeup
paths.

Link: http://lkml.kernel.org/r/1507920533-8812-1-git-send-email-jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Salman Qazi <sqazi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff -puN fs/eventpoll.c~epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake
+++ a/fs/eventpoll.c
@@ -276,9 +276,6 @@ static DEFINE_MUTEX(epmutex);
 /* Used to check for epoll file descriptor inclusion loops */
 static struct nested_calls poll_loop_ncalls;
 
-/* Used for safe wake up implementation */
-static struct nested_calls poll_safewake_ncalls;
-
 /* Used to call file's f_op->poll() under the nested calls boundaries */
 static struct nested_calls poll_readywalk_ncalls;
 
@@ -551,40 +548,21 @@ out_unlock:
  * this special case of epoll.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
-				     unsigned long events, int subclass)
+
+static struct nested_calls poll_safewake_ncalls;
+
+static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
 	unsigned long flags;
+	wait_queue_head_t *wqueue = (wait_queue_head_t *)cookie;
 
-	spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
-	wake_up_locked_poll(wqueue, events);
+	spin_lock_irqsave_nested(&wqueue->lock, flags, call_nests + 1);
+	wake_up_locked_poll(wqueue, POLLIN);
 	spin_unlock_irqrestore(&wqueue->lock, flags);
-}
-#else
-static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
-				     unsigned long events, int subclass)
-{
-	wake_up_poll(wqueue, events);
-}
-#endif
 
-static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
-{
-	ep_wake_up_nested((wait_queue_head_t *) cookie, POLLIN,
-			  1 + call_nests);
 	return 0;
 }
 
-/*
- * Perform a safe wake up of the poll wait list. The problem is that
- * with the new callback'd wake up system, it is possible that the
- * poll callback is reentered from inside the call to wake_up() done
- * on the poll wait queue head. The rule is that we cannot reenter the
- * wake up code from the same task more than EP_MAX_NESTS times,
- * and we cannot reenter the same wait queue head at all. This will
- * enable to have a hierarchy of epoll file descriptor of no more than
- * EP_MAX_NESTS deep.
- */
 static void ep_poll_safewake(wait_queue_head_t *wq)
 {
 	int this_cpu = get_cpu();
@@ -595,6 +573,15 @@ static void ep_poll_safewake(wait_queue_
 	put_cpu();
 }
 
+#else
+
+static void ep_poll_safewake(wait_queue_head_t *wq)
+{
+	wake_up_poll(wq, POLLIN);
+}
+
+#endif
+
 static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 {
 	wait_queue_head_t *whead;
@@ -2315,8 +2302,10 @@ static int __init eventpoll_init(void)
 	 */
 	ep_nested_calls_init(&poll_loop_ncalls);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
+#endif
 
 	/* Initialize the structure used to perform file's f_op->poll() calls */
 	ep_nested_calls_init(&poll_readywalk_ncalls);
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-avoid-calling-ep_call_nested-from-ep_poll_safewake.patch

