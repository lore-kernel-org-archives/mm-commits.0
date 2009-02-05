From: akpm@linux-foundation.org
Subject: [merged] usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:36 -0800
Message-ID: <200902051914.n15JEao1011915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbZBET0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: fsl_qe_udc: Fix disconnects reporting during bus reset
has been removed from the -mm tree.  Its filename was
     usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fsl_qe_udc: Fix disconnects reporting during bus reset
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Freescale QE UDC controllers can't report the "port change" states, so the
only way to handle disconnects is to process bus reset interrupts.  The
bus reset can take some time, that is, few irqs.  Gadgets may print the
disconnection events, and this causes few repetitive messages in the
kernel log.

This patch fixes the issue by using the usb_state machine, if the usb
controller has been already reset, just quit the reset irq early.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -2161,6 +2161,9 @@ static int reset_irq(struct qe_udc *udc)
 {
 	unsigned char i;
 
+	if (udc->usb_state == USB_STATE_DEFAULT)
+		return 0;
+
 	qe_usb_disable();
 	out_8(&udc->usb_regs->usb_usadr, 0);
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch

