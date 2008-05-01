From: akpm@linux-foundation.org
Subject: - signals-send_group_sigqueue-dont-take-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:31 -0700
Message-ID: <200805010926.m419QVGl030306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757458AbYEAJ1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_group_sigqueue: don't take tasklist_lock
has been removed from the -mm tree.  Its filename was
     signals-send_group_sigqueue-dont-take-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_group_sigqueue: don't take tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

handle_stop_signal() was changed, now send_group_sigqueue() doesn't need
tasklist_lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-send_group_sigqueue-dont-take-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-send_group_sigqueue-dont-take-tasklist_lock
+++ a/kernel/signal.c
@@ -1335,7 +1335,6 @@ send_group_sigqueue(int sig, struct sigq
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
-	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
@@ -1344,7 +1343,7 @@ send_group_sigqueue(int sig, struct sigq
 	__group_complete_signal(sig, p);
 
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	read_unlock(&tasklist_lock);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

