From: akpm@linux-foundation.org
Subject: + hci_usb-replace-mb-with-smp_mb.patch added to -mm tree
Date: Thu, 14 Aug 2008 14:42:27 -0700
Message-ID: <200808142142.m7ELgRXC030985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309AbYHNVnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 17:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom.leiming@gmail.com, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     hci_usb: replace mb with smp_mb
has been added to the -mm tree.  Its filename is
     hci_usb-replace-mb-with-smp_mb.patch

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
Subject: hci_usb: replace mb with smp_mb
From: Ming Lei <tom.leiming@gmail.com>

smp_mb is enough for ordering memory operations among processors,and mb is
more expensive than smp_mb for UP machine, so replace it with smp_mb().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/bluetooth/hci_usb.h~hci_usb-replace-mb-with-smp_mb drivers/bluetooth/hci_usb.h
--- a/drivers/bluetooth/hci_usb.h~hci_usb-replace-mb-with-smp_mb
+++ a/drivers/bluetooth/hci_usb.h
@@ -70,8 +70,8 @@ static inline void _urb_queue_head(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
-	_urb->queue = q; mb(); list_add(&_urb->list, &q->head);
+	/* _urb_unlink needs to know which spinlock to use, thus smp_mb(). */
+	_urb->queue = q; smp_mb(); list_add(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -79,8 +79,8 @@ static inline void _urb_queue_tail(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
-	_urb->queue = q; mb(); list_add_tail(&_urb->list, &q->head);
+	/* _urb_unlink needs to know which spinlock to use, thus smp_mb(). */
+	_urb->queue = q; smp_mb(); list_add_tail(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -89,7 +89,7 @@ static inline void _urb_unlink(struct _u
 	struct _urb_queue *q;
 	unsigned long flags;
 
-	mb();
+	smp_mb();
 	q = _urb->queue;
 	/* If q is NULL, it will die at easy-to-debug NULL pointer dereference.
 	   No need to BUG(). */
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

hci_usb-replace-mb-with-smp_mb.patch

