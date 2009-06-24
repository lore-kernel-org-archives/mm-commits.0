From: akpm@linux-foundation.org
Subject: [merged] usb-mutually-exclusive-port_status.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:12 -0700
Message-ID: <200906241911.n5OJBCa8011509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbZFXTLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, avorontsov@ru.mvista.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: mutually exclusive port_status
has been removed from the -mm tree.  Its filename was
     usb-mutually-exclusive-port_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: mutually exclusive port_status
From: Roel Kluin <roel.kluin@gmail.com>

FHCI_PORT_DISABLED, -LOW and -FULL are mutually exclusive as status.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/fhci-sched.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/usb/host/fhci-sched.c~usb-mutually-exclusive-port_status drivers/usb/host/fhci-sched.c
--- a/drivers/usb/host/fhci-sched.c~usb-mutually-exclusive-port_status
+++ a/drivers/usb/host/fhci-sched.c
@@ -576,9 +576,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd
 			out_be16(&usb->fhci->regs->usb_event,
 				 usb->saved_msk);
 		} else if (usb->port_status == FHCI_PORT_DISABLED) {
-			if (fhci_ioports_check_bus_state(fhci) == 1 &&
-					usb->port_status != FHCI_PORT_LOW &&
-					usb->port_status != FHCI_PORT_FULL)
+			if (fhci_ioports_check_bus_state(fhci) == 1)
 				fhci_device_connected_interrupt(fhci);
 		}
 		usb_er &= ~USB_E_RESET_MASK;
@@ -605,9 +603,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd
 	}
 
 	if (usb_er & USB_E_IDLE_MASK) {
-		if (usb->port_status == FHCI_PORT_DISABLED &&
-				usb->port_status != FHCI_PORT_LOW &&
-				usb->port_status != FHCI_PORT_FULL) {
+		if (usb->port_status == FHCI_PORT_DISABLED) {
 			usb_er &= ~USB_E_RESET_MASK;
 			fhci_device_connected_interrupt(fhci);
 		} else if (usb->port_status ==
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

