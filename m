From: akpm@linux-foundation.org
Subject: + usb-hcd-avoid-duplicate-local_irq_disable.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:36:10 -0700
Message-ID: <200710242236.l9OMaAxS016063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbXJXWgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, arnd@arndb.de, greg@kroah.com


The patch titled
     USB HCD: avoid duplicate local_irq_disable()
has been added to the -mm tree.  Its filename is
     usb-hcd-avoid-duplicate-local_irq_disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB HCD: avoid duplicate local_irq_disable()
From: Alan Stern <stern@rowland.harvard.edu>

Arnd Bergmann wrote:

usb_hcd_flush_endpoint() has a retry loop that starts with a spin_lock_irq(),
but only gives up the spinlock, not the irq_disable before jumping to the
rescan label.

Alan Stern:

I agree with your sentiment, but it would be better to solve this
problem without using local_irq_disable().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/hcd.c~usb-hcd-avoid-duplicate-local_irq_disable drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~usb-hcd-avoid-duplicate-local_irq_disable
+++ a/drivers/usb/core/hcd.c
@@ -1312,8 +1312,8 @@ void usb_hcd_flush_endpoint(struct usb_d
 	hcd = bus_to_hcd(udev->bus);
 
 	/* No more submits can occur */
-rescan:
 	spin_lock_irq(&hcd_urb_list_lock);
+rescan:
 	list_for_each_entry (urb, &ep->urb_list, urb_list) {
 		int	is_in;
 
@@ -1346,6 +1346,7 @@ rescan:
 		usb_put_urb (urb);
 
 		/* list contents may have changed */
+		spin_lock(&hcd_urb_list_lock);
 		goto rescan;
 	}
 	spin_unlock_irq(&hcd_urb_list_lock);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-early-detection-of-medium-not-present-updated.patch
usb-hcd-avoid-duplicate-local_irq_disable.patch
