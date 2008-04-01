From: akpm@linux-foundation.org
Subject: + hci_usbh-fix-hard-to-trigger-race.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:29:36 -0700
Message-ID: <200804012229.m31MTaLZ016898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206AbYDAWaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, hidave.darkstar@gmail.com, marcel@holtmann.org, pavel@suse.cz


The patch titled
     hci_usb.h: fix hard-to-trigger race
has been added to the -mm tree.  Its filename is
     hci_usbh-fix-hard-to-trigger-race.patch

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

git-x86.patch
git-acpi.patch
pm-remove-destroy_suspended_device.patch
git-hrt.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

