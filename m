From: akpm@linux-foundation.org
Subject: + xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:12 -0700
Message-ID: <200807111844.m6BIir4T030907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbYGKSpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com


The patch titled
     xfs: extend completions to provide XFS object flush requirements
has been added to the -mm tree.  Its filename is
     xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: extend completions to provide XFS object flush requirements
From: Dave Chinner <david@fromorbit.com>

XFS object flushing doesn't quite match existing completion semantics.  It
mixed exclusive access with completion.  That is, we need to mark an object as
being flushed before flushing it to disk, and then block any other attempt to
flush it until the completion occurs.  We do this but adding an extra count to
the completion before we start using them.  However, we still need to
determine if there is a completion in progress, and allow no-blocking attempts
fo completions to decrement the count.

To do this we introduce:

int try_wait_for_completion(struct completion *x)
	returns a failure status if done == 0, otherwise decrements done
	to zero and returns a "started" status. This is provided
	to allow counted completions to begin safely while holding
	object locks in inverted order.

int completion_done(struct completion *x)
	returns 1 if there is no waiter, 0 if there is a waiter
	(i.e. a completion in progress).

This replaces the use of semaphores for providing this exclusion
and completion mechanism.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/completion.h |   45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN include/linux/completion.h~xfs-extend-completions-to-provide-xfs-object-flush-requirements include/linux/completion.h
--- a/include/linux/completion.h~xfs-extend-completions-to-provide-xfs-object-flush-requirements
+++ a/include/linux/completion.h
@@ -55,4 +55,49 @@ extern void complete_all(struct completi
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+static inline bool try_wait_for_completion(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+static inline bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
 #endif
_

Patches currently in -mm which might be from david@fromorbit.com are

xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch

