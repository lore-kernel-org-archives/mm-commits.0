From: akpm@linux-foundation.org
Subject: - signals-send_sig_info-dont-take-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:37 -0700
Message-ID: <200805010926.m419QbMq030315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_sig_info: don't take tasklist_lock
has been removed from the -mm tree.  Its filename was
     signals-send_sig_info-dont-take-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_sig_info: don't take tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

The comment in send_sig_info() is wrong, tasklist_lock can't help.

The caller must ensure the task can't go away, otherwise ->sighand can be NULL
even before we take the lock.

p->sighand could be changed by exec(), but I can't imagine how it is possible
to prevent exit(), but not exec().

Since the things seem to work, I assume all callers are correct.  However,
drm_vbl_send_signals() looks broken.  block_all_signals() which is solely used
by drm is definitely broken.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN kernel/signal.c~signals-send_sig_info-dont-take-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-send_sig_info-dont-take-tasklist_lock
+++ a/kernel/signal.c
@@ -1138,8 +1138,7 @@ static int kill_something_info(int sig, 
  */
 
 /*
- * These two are the most common entry points.  They send a signal
- * just to the specific thread.
+ * The caller must ensure the task can't exit.
  */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
@@ -1154,17 +1153,9 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	/*
-	 * We need the tasklist lock even for the specific
-	 * thread case (when we don't need to follow the group
-	 * lists) in order to avoid races with "p->sighand"
-	 * going away or changing from under us.
-	 */
-	read_lock(&tasklist_lock);  
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	ret = specific_send_sig_info(sig, info, p);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	read_unlock(&tasklist_lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

