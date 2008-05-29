From: akpm@linux-foundation.org
Subject: + signals-collect_signal-simplify-the-still_pending-logic.patch added to -mm tree
Date: Wed, 28 May 2008 17:32:13 -0700
Message-ID: <200805290032.m4T0WD2o008108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbYE2Acs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 20:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: collect_signal: simplify the "still_pending" logic
has been added to the -mm tree.  Its filename is
     signals-collect_signal-simplify-the-still_pending-logic.patch

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
Subject: signals: collect_signal: simplify the "still_pending" logic
From: Oleg Nesterov <oleg@tv-sign.ru>

Factor out sigdelset() calls and remove the "still_pending" variable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic kernel/signal.c
--- a/kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic
+++ a/kernel/signal.c
@@ -341,7 +341,6 @@ unblock_all_signals(void)
 static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-	int still_pending = 0;
 
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
@@ -349,26 +348,24 @@ static int collect_signal(int sig, struc
 	*/
 	list_for_each_entry(q, &list->list, list) {
 		if (q->info.si_signo == sig) {
-			if (first) {
-				still_pending = 1;
-				break;
-			}
+			if (first)
+				goto still_pending;
 			first = q;
 		}
 	}
+
+	sigdelset(&list->signal, sig);
+
 	if (first) {
+still_pending:
 		list_del_init(&first->list);
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
-		if (!still_pending)
-			sigdelset(&list->signal, sig);
 	} else {
