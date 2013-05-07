From: akpm@linux-foundation.org
Subject: + wait-fix-false-timeouts-when-using-wait_event_timeout.patch added to -mm tree
Date: Tue, 07 May 2013 16:13:10 -0700
Message-ID: <20130507231310.7D52D5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:47864 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EGXNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 19:13:11 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so112270ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 16:13:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@intel.com, axboe@kernel.dk, daniel.vetter@ffwll.ch, davej@redhat.com, dhowells@redhat.com, lczerner@redhat.com, paulmck@linux.vnet.ibm.com


The patch titled
     Subject: wait: fix false timeouts when using wait_event_timeout()
has been added to the -mm tree.  Its filename is
     wait-fix-false-timeouts-when-using-wait_event_timeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Imre Deak <imre.deak@intel.com>
Subject: wait: fix false timeouts when using wait_event_timeout()

Many callers of the wait_event_timeout() and
wait_event_interruptible_timeout() expect that the return value will be
positive if the specified condition becomes true before the timeout
elapses.  However, at the moment this isn't guaranteed.  If the wake-up
handler is delayed enough, the time remaining until timeout will be
calculated as 0 - and passed back as a return value - even if the
condition became true before the timeout has passed.

Fix this by returning at least 1 if the condition becomes true.  This
semantic is in line with what wait_for_condition_timeout() does; see
commit bb10ed09 ("sched: fix wait_for_completion_timeout() spurious
failure under heavy load").

Daniel said "We have 3 instances of this bug in drm/i915.  One case even
where we switch between the interruptible and not interruptible
wait_event_timeout variants, foolishly presuming they have the same
semantics.  I very much like this."

Signed-off-by: Imre Deak <imre.deak@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E.  McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/wait.h~wait-fix-false-timeouts-when-using-wait_event_timeout include/linux/wait.h
--- a/include/linux/wait.h~wait-fix-false-timeouts-when-using-wait_event_timeout
+++ a/include/linux/wait.h
@@ -217,6 +217,8 @@ do {									\
 		if (!ret)						\
 			break;						\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -233,8 +235,9 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, and the remaining
- * jiffies if the condition evaluated to true before the timeout elapsed.
+ * The function returns 0 if the @timeout elapsed, or the remaining
+ * jiffies (at least 1) if the @condition evaluated to %true before
+ * the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -302,6 +305,8 @@ do {									\
 		ret = -ERESTARTSYS;					\
 		break;							\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -318,9 +323,10 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
- * was interrupted by a signal, and the remaining jiffies otherwise
- * if the condition evaluated to true before the timeout elapsed.
+ * Returns:
+ * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
+ * a signal, or the remaining jiffies (at least 1) if the @condition
+ * evaluated to %true before the @timeout elapsed.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
_

Patches currently in -mm which might be from imre.deak@intel.com are

origin.patch
linux-next.patch
wait-fix-false-timeouts-when-using-wait_event_timeout.patch

