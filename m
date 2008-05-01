From: akpm@linux-foundation.org
Subject: - signals-send_signal-be-paranoid-about-signalfd_notify.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:00 -0700
Message-ID: <200805010927.m419R0jt030355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758187AbYEAJqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_signal: be paranoid about signalfd_notify()
has been removed from the -mm tree.  Its filename was
     signals-send_signal-be-paranoid-about-signalfd_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_signal: be paranoid about signalfd_notify()
From: Oleg Nesterov <oleg@tv-sign.ru>

send_signal() shouldn't call signalfd_notify() if it then fails with -EAGAIN. 
Harmless, just a paranoid cleanup.

Also remove the comment.  It is obsolete, signalfd_notify() was simplified and
does a simple wakeup.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN kernel/signal.c~signals-send_signal-be-paranoid-about-signalfd_notify kernel/signal.c
--- a/kernel/signal.c~signals-send_signal-be-paranoid-about-signalfd_notify
+++ a/kernel/signal.c
@@ -772,13 +772,6 @@ static int send_signal(int sig, struct s
 	 */
 	if (legacy_queue(pending, sig))
 		return 0;
-
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(t, sig);
