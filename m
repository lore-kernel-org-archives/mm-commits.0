From: akpm@linux-foundation.org
Subject: + g_ncr5380-remove-misleading-pnp-error-message.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:20:57 -0800
Message-ID: <200912302120.nBULKvMP002919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbZL3VVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, James.Bottomley@HansenPartnership.com


The patch titled
     g_NCR5380: remove misleading pnp error message
has been added to the -mm tree.  Its filename is
     g_ncr5380-remove-misleading-pnp-error-message.patch

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
Subject: g_NCR5380: remove misleading pnp error message
From: Ondrej Zary <linux@rainbow-software.org>

Remove misleading error message that appears after pnp card has been
detected correctly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-remove-misleading-pnp-error-message drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~g_ncr5380-remove-misleading-pnp-error-message
+++ a/drivers/scsi/g_NCR5380.c
@@ -322,10 +322,8 @@ int __init generic_NCR5380_detect(struct
 		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
 			if (count >= NO_OVERRIDES)
 				break;
-			if (pnp_device_attach(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: attach failed\n");
+			if (pnp_device_attach(dev) < 0)
 				continue;
-			}
 			if (pnp_activate_dev(dev) < 0) {
 				printk(KERN_ERR "dtc436e probe: activate failed\n");
 				pnp_device_detach(dev);
_

Patches currently in -mm which might be from linux@rainbow-software.org are

usbtouchscreen-convert-from-usb_device-to-usb_interface.patch
usbtouchscreen-find-input-endpoint-automatically.patch
usbtouchscreen-add-nexio-or-inexio-support.patch
usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch
usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch
usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch
g_ncr5380-remove-misleading-pnp-error-message.patch

