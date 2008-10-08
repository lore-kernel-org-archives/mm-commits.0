From: akpm@linux-foundation.org
Subject: + epoll-drop-unnecessary-test.patch added to -mm tree
Date: Wed, 08 Oct 2008 13:46:43 -0700
Message-ID: <200810082046.m98KkhVN008600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbYJHUrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 16:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, tglx@linutronix.de


The patch titled
     epoll: drop unnecessary test
has been added to the -mm tree.  Its filename is
     epoll-drop-unnecessary-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: drop unnecessary test
From: Davide Libenzi <davidel@xmailserver.org>

Thomas found that there is an unnecessary (always true) test in
ep_send_events().  The callback never inserts into ->rdllink while the
send loop is performed, and also does the ~EP_PRIVATE_BITS test.  Given
we're holding the mutex during this time, the conditions tested inside the
loop are always true.  This patch drops the test done inside the
re-insertion loop.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/eventpoll.c~epoll-drop-unnecessary-test fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-drop-unnecessary-test
+++ a/fs/eventpoll.c
@@ -927,14 +927,11 @@ errxit:
 	/*
 	 * During the time we spent in the loop above, some other events
 	 * might have been queued by the poll callback. We re-insert them
-	 * here (in case they are not already queued, or they're one-shot).
+	 * inside the main ready-list here.
 	 */
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
-		if (!ep_is_linked(&epi->rdllink) &&
-		    (epi->event.events & ~EP_PRIVATE_BITS))
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-	}
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR)
+		list_add_tail(&epi->rdllink, &ep->rdllist);
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-drop-unnecessary-test.patch

