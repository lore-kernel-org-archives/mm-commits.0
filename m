From: akpm@linux-foundation.org
Subject: + use-wake_up_locked-in-eventpoll.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:27:15 -0700
Message-ID: <200710250327.l9P3RFm6029476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288AbXJYD1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:27:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, davidel@xmailserver.org, willy@linux.intel.com


The patch titled
     Use wake_up_locked() in eventpoll
has been added to the -mm tree.  Its filename is
     use-wake_up_locked-in-eventpoll.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

use-wake_up_locked-in-eventpoll.patch
make-sure-nobodys-leaking-resources.patch
