From: akpm@linux-foundation.org
Subject: + completions-un-inline-try_wait_for_completion-and-completion_done.patch added to -mm tree
Date: Thu, 14 Aug 2008 15:58:57 -0700
Message-ID: <200808142258.m7EMwvQJ001723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbYHNW7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 18:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, geert@linux-m68k.org, mingo@elte.hu


The patch titled
     completions: uninline try_wait_for_completion and completion_done
has been added to the -mm tree.  Its filename is
     completions-un-inline-try_wait_for_completion-and-completion_done.patch

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
Subject: completions: uninline try_wait_for_completion and completion_done
From: Dave Chinner <david@fromorbit.com>

m68k fails to build with these functions inlined in completion.h.  Move
them out of line into sched.c and export them to avoid this problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/completion.h |   46 +----------------------------------
 kernel/sched.c             |   46 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 44 deletions(-)

diff -puN include/linux/completion.h~completions-un-inline-try_wait_for_completion-and-completion_done include/linux/completion.h
--- a/include/linux/completion.h~completions-un-inline-try_wait_for_completion-and-completion_done
+++ a/include/linux/completion.h
@@ -49,6 +49,8 @@ extern unsigned long wait_for_completion
 						   unsigned long timeout);
 extern unsigned long wait_for_completion_interruptible_timeout(
 			struct completion *x, unsigned long timeout);
+extern bool try_wait_for_completion(struct completion *x);
+extern bool completion_done(struct completion *x);
 
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
@@ -56,48 +58,4 @@ extern void complete_all(struct completi
 #define INIT_COMPLETION(x)	((x).done = 0)
 
 
-/**
- *	try_wait_for_completion - try to decrement a completion without blocking
- *	@x:	completion structure
- *
- *	Returns: 0 if a decrement cannot be done without blocking
- *		 1 if a decrement succeeded.
- *
- *	If a completion is being used as a counting completion,
- *	attempt to decrement the counter without blocking. This
- *	enables us to avoid waiting if the resource the completion
- *	is protecting is not available.
- */
-static inline bool try_wait_for_completion(struct completion *x)
-{
-	int ret = 1;
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done)
-		ret = 0;
-	else
-		x->done--;
-	spin_unlock_irq(&x->wait.lock);
-	return ret;
-}
-
-/**
- *	completion_done - Test to see if a completion has any waiters
- *	@x:	completion structure
- *
- *	Returns: 0 if there are waiters (wait_for_completion() in progress)
- *		 1 if there are no waiters.
- *
- */
-static inline bool completion_done(struct completion *x)
-{
-	int ret = 1;
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done)
-		ret = 0;
-	spin_unlock_irq(&x->wait.lock);
-	return ret;
-}
-
 #endif
diff -puN kernel/sched.c~completions-un-inline-try_wait_for_completion-and-completion_done kernel/sched.c
--- a/kernel/sched.c~completions-un-inline-try_wait_for_completion-and-completion_done
+++ a/kernel/sched.c
@@ -4669,6 +4669,52 @@ int __sched wait_for_completion_killable
 }
 EXPORT_SYMBOL(wait_for_completion_killable);
 
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
+bool try_wait_for_completion(struct completion *x)
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
+EXPORT_SYMBOL(try_wait_for_completion);
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+EXPORT_SYMBOL(completion_done);
+
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
_

Patches currently in -mm which might be from david@fromorbit.com are

xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch
completions-un-inline-try_wait_for_completion-and-completion_done.patch
linux-next.patch

