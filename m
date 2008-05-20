From: akpm@linux-foundation.org
Subject: + signals-collect_signal-remove-the-unneeded-sigismember-check.patch added to -mm tree
Date: Mon, 19 May 2008 23:34:34 -0700
Message-ID: <200805200634.m4K6YYWP009022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbYETGfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: collect_signal: remove the unneeded sigismember() check
has been added to the -mm tree.  Its filename is
     signals-collect_signal-remove-the-unneeded-sigismember-check.patch

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
Subject: signals: collect_signal: remove the unneeded sigismember() check
From: Oleg Nesterov <oleg@tv-sign.ru>

collect_signal() checks sigismember(&list->signal, sig), this is not
needed.  This "sig" was just found by next_signal(), so it must be valid.

We have a (completely broken) call to ->notifier in between, but it must
not play with sigpending->signal bits or unlock ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/signal.c~signals-collect_signal-remove-the-unneeded-sigismember-check kernel/signal.c
--- a/kernel/signal.c~signals-collect_signal-remove-the-unneeded-sigismember-check
+++ a/kernel/signal.c
@@ -309,9 +309,6 @@ static int collect_signal(int sig, struc
 	struct sigqueue *q, *first = NULL;
 	int still_pending = 0;
 
-	if (unlikely(!sigismember(&list->signal, sig)))
-		return 0;
