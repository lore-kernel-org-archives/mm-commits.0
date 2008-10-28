From: akpm@linux-foundation.org
Subject: - epoll-avoid-double-inserts-in-case-of-efault.patch removed from -mm tree
Date: Mon, 27 Oct 2008 17:11:11 -0700
Message-ID: <200810280011.m9S0BBpp026962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYJ1ALW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, a.beregalov@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     epoll avoid double-inserts in case of EFAULT
has been removed from the -mm tree.  Its filename was
     epoll-avoid-double-inserts-in-case-of-efault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll avoid double-inserts in case of EFAULT
From: Davide Libenzi <davidel@xmailserver.org>

First Episode:

Thomas found that there is an unnecessary (always true) test in
ep_send_events(). The callback never inserts into ->rdllink while the
send loop is performed, and also does the ~EP_PRIVATE_BITS test. Given
we're holding the mutex during this time, the conditions tested inside the
loop are always true.
This patch drops the test done inside the re-insertion loop.

Second Episode:

The test "!ep_is_linked(&epi->rdllink)" wasn't there because we inserts
into ->rdllink, but because the send-events loop might terminate before
the whole list is scanned (-EFAULT). In such cases, when the loop
terminates early, and when a (leftover) file received an event while we're
performing the lockless loop, we need such test to avoid to double insert
the epoll items. The list_splice() done a few steps below, will correctly
re-insert the ones that were left on "txlist".
This should be the reason for the thread "2.6.27-05178-g2e532d6: list_add
corruption" from Alexander Beregalov.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-avoid-double-inserts-in-case-of-efault fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-avoid-double-inserts-in-case-of-efault
+++ a/fs/eventpoll.c
@@ -930,8 +930,15 @@ errxit:
 	 * inside the main ready-list here.
 	 */
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR)
-		list_add_tail(&epi->rdllink, &ep->rdllist);
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		/*
+		 * If the above loop quit with errors, the epoll item might still
+		 * be linked to "txlist", and the list_splice() done below will
+		 * take care of those cases.
+		 */
+		if (!ep_is_linked(&epi->rdllink))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
linux-next.patch

