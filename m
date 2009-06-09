From: akpm@linux-foundation.org
Subject: + usb-mutually-exclusive-port_status.patch added to -mm tree
Date: Tue, 09 Jun 2009 14:58:35 -0700
Message-ID: <200906092158.n59LwZ26008086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759162AbZFIWAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 18:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, avorontsov@ru.mvista.com, gregkh@suse.de


The patch titled
     usb: mutually exclusive port_status
has been added to the -mm tree.  Its filename is
     usb-mutually-exclusive-port_status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
tvp514x-try_count-off-by-one.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
usb-mutually-exclusive-port_status.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-fix-off-by-one-errors.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

