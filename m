From: akpm@linux-foundation.org
Subject: - usb-hcd-avoid-duplicate-local_irq_disable.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:24 -0800
Message-ID: <200711262149.lAQLnO46024755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081AbXKZV6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB HCD: avoid duplicate local_irq_disable()
has been removed from the -mm tree.  Its filename was
     usb-hcd-avoid-duplicate-local_irq_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1311,8 +1311,8 @@ void usb_hcd_flush_endpoint(struct usb_d
 	hcd = bus_to_hcd(udev->bus);
 
 	/* No more submits can occur */
-rescan:
 	spin_lock_irq(&hcd_urb_list_lock);
+rescan:
 	list_for_each_entry (urb, &ep->urb_list, urb_list) {
 		int	is_in;
 
@@ -1345,6 +1345,7 @@ rescan:
 		usb_put_urb (urb);
 
 		/* list contents may have changed */
+		spin_lock(&hcd_urb_list_lock);
 		goto rescan;
 	}
 	spin_unlock_irq(&hcd_urb_list_lock);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-acpi.patch
scsi-early-detection-of-medium-not-present-updated.patch
