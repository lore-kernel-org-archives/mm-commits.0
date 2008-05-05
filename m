From: akpm@linux-foundation.org
Subject: - hci_usbh-fix-hard-to-trigger-race.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:43 -0700
Message-ID: <200805051916.m45JGhHU000324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760741AbYEETQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, hidave.darkstar@gmail.com, marcel@holtmann.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hci_usb.h: fix hard-to-trigger race
has been removed from the -mm tree.  Its filename was
     hci_usbh-fix-hard-to-trigger-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hci_usb.h: fix hard-to-trigger race
From: Pavel Machek <pavel@ucw.cz>

If someone tries to _urb_unlink while _urb_queue_head is running, he'll see
_urb->queue == NULL and fail to do any locking.  Prevent that from happening
by strategically placed barriers.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/bluetooth/hci_usb.h~hci_usbh-fix-hard-to-trigger-race drivers/bluetooth/hci_usb.h
--- a/drivers/bluetooth/hci_usb.h~hci_usbh-fix-hard-to-trigger-race
+++ a/drivers/bluetooth/hci_usb.h
@@ -70,7 +70,8 @@ static inline void _urb_queue_head(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	list_add(&_urb->list, &q->head); _urb->queue = q;
+	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
+	_urb->queue = q; mb(); list_add(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -78,19 +79,23 @@ static inline void _urb_queue_tail(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	list_add_tail(&_urb->list, &q->head); _urb->queue = q;
+	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
+	_urb->queue = q; mb(); list_add_tail(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 static inline void _urb_unlink(struct _urb *_urb)
 {
-	struct _urb_queue *q = _urb->queue;
+	struct _urb_queue *q;
 	unsigned long flags;
-	if (q) {
-		spin_lock_irqsave(&q->lock, flags);
-		list_del(&_urb->list); _urb->queue = NULL;
-		spin_unlock_irqrestore(&q->lock, flags);
-	}
+
+	mb();
+	q = _urb->queue;
+	/* If q is NULL, it will die at easy-to-debug NULL pointer dereference.
+	   No need to BUG(). */
+	spin_lock_irqsave(&q->lock, flags);
+	list_del(&_urb->list); _urb->queue = NULL;
+	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 struct hci_usb {
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
acpi_pm_device_sleep_state-cleanup.patch

