From: akpm@linux-foundation.org
Subject: - use-wake_up_locked-in-eventpoll.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:05 -0800
Message-ID: <200802012230.m11MU5QH001879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758059AbYBAWoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:44:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, davidel@xmailserver.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Use wake_up_locked() in eventpoll
has been removed from the -mm tree.  Its filename was
     use-wake_up_locked-in-eventpoll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use wake_up_locked() in eventpoll
From: Matthew Wilcox <matthew@wil.cx>

Replace the uses of __wake_up_locked() with the equivalent wake_up_locked().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/eventpoll.c~use-wake_up_locked-in-eventpoll fs/eventpoll.c
--- a/fs/eventpoll.c~use-wake_up_locked-in-eventpoll
+++ a/fs/eventpoll.c
@@ -656,8 +656,7 @@ is_linked:
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq))
-		__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-				 TASK_INTERRUPTIBLE);
+		wake_up_locked(&ep->wq);
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -780,7 +779,7 @@ static int ep_insert(struct eventpoll *e
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
-			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
+			wake_up_locked(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
@@ -854,8 +853,7 @@ static int ep_modify(struct eventpoll *e
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
-				__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-						 TASK_INTERRUPTIBLE);
+				wake_up_locked(&ep->wq);
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
@@ -978,8 +976,7 @@ errxit:
 		 * wait list (delayed after we release the lock).
 		 */
 		if (waitqueue_active(&ep->wq))
-			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-					 TASK_INTERRUPTIBLE);
+			wake_up_locked(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch
