From: akpm@linux-foundation.org
Subject: - avoid-spurious-pollin-returns-in-signalfd.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:45 -0700
Message-ID: <200706292040.l5TKeji6022450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041AbXF2Uui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     avoid spurious POLLIN returns in signalfd
has been removed from the -mm tree.  Its filename was
     avoid-spurious-pollin-returns-in-signalfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 2 insertions(+), 1 deletion(-)

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

origin.patch
git-kvm.patch
introduce-o_cloexec-take-2.patch
