From: akpm@linux-foundation.org
Subject: - signalfd-retrieve-multiple-signals-with-one-read-call-tidy.patch removed from -mm tree
Date: Wed, 23 May 2007 13:41:11 -0700
Message-ID: <200705232041.l4NKfBVR031352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbXEWUmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davi@haxent.com.br, davidel@xmailserver.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     signalfd-retrieve-multiple-signals-with-one-read-call tidy
has been removed from the -mm tree.  Its filename was
     signalfd-retrieve-multiple-signals-with-one-read-call-tidy.patch

This patch was dropped because it was folded into signalfd-retrieve-multiple-signals-with-one-read-call.patch

------------------------------------------------------
Subject: signalfd-retrieve-multiple-signals-with-one-read-call tidy
From: Davi Arnaut <davi@haxent.com.br>

Simplify signalfd locking following suggestions by Oleg Nesterov.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff -puN fs/signalfd.c~signalfd-retrieve-multiple-signals-with-one-read-call-tidy fs/signalfd.c
--- a/fs/signalfd.c~signalfd-retrieve-multiple-signals-with-one-read-call-tidy
+++ a/fs/signalfd.c
@@ -211,13 +211,11 @@ static int signalfd_copyinfo(struct sign
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 				int nonblock)
 {
-	int locked;
 	ssize_t ret;
 	struct signalfd_lockctx lk;
 	DECLARE_WAITQUEUE(wait, current);
 
-	locked = signalfd_lock(ctx, &lk);
-	if (!locked)
+	if (!signalfd_lock(ctx, &lk))
 		return 0;
 
 	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
@@ -235,24 +233,24 @@ static ssize_t signalfd_dequeue(struct s
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		signalfd_unlock(&lk);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
 		}
-		signalfd_unlock(&lk);
 		schedule();
-		locked = signalfd_lock(ctx, &lk);
-		if (unlikely(!locked)) {
+		ret = signalfd_lock(ctx, &lk);
+		if (unlikely(!ret)) {
 			/*
 			 * Let the caller read zero byte, ala socket
 			 * recv() when the peer disconnect. This test
 			 * must be done before doing a dequeue_signal(),
 			 * because if the sighand has been orphaned,
-			 * the dequeue_signal() call is going to crash.
+			 * the dequeue_signal() call is going to crash
+			 * because ->sighand will be long gone.
 			 */
-			 ret = 0;
 			 break;
 		}
 	}
@@ -260,9 +258,6 @@ static ssize_t signalfd_dequeue(struct s
 	remove_wait_queue(&ctx->wqh, &wait);
 	__set_current_state(TASK_RUNNING);
 
-	if (likely(locked))
-		signalfd_unlock(&lk);
-
 	return ret;
 }
 
_

Patches currently in -mm which might be from davi@haxent.com.br are

signalfd-retrieve-multiple-signals-with-one-read-call.patch
signalfd-retrieve-multiple-signals-with-one-read-call-tidy.patch
