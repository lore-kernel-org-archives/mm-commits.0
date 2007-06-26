From: akpm@linux-foundation.org
Subject: + avoid-spurious-pollin-returns-in-signalfd.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:16:43 -0700
Message-ID: <200706260416.l5Q4GhnN018115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXFZERY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, oleg@tv-sign.ru


The patch titled
     avoid spurious POLLIN returns in signalfd
has been added to the -mm tree.  Its filename is
     avoid-spurious-pollin-returns-in-signalfd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: avoid spurious POLLIN returns in signalfd
From: Davide Libenzi <davidel@xmailserver.org>

The new code in kernel/signal.c does not allow fetching private signals
from another task.  This patch avoid spurious POLLIN returns from a
signalfd poll(2) operation.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/signalfd.c~avoid-spurious-pollin-returns-in-signalfd fs/signalfd.c
--- a/fs/signalfd.c~avoid-spurious-pollin-returns-in-signalfd
+++ a/fs/signalfd.c
@@ -133,7 +133,8 @@ static unsigned int signalfd_poll(struct
 	 * the peer disconnects.
 	 */
 	if (signalfd_lock(ctx, &lk)) {
-		if (next_signal(&lk.tsk->pending, &ctx->sigmask) > 0 ||
+		if ((lk.tsk == current &&
+		     next_signal(&lk.tsk->pending, &ctx->sigmask) > 0) ||
 		    next_signal(&lk.tsk->signal->shared_pending,
 				&ctx->sigmask) > 0)
 			events |= POLLIN;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

eventfd-clean-compile-when-config_eventfd=n.patch
avoid-spurious-pollin-returns-in-signalfd.patch
introduce-o_cloexec-take-2.patch
