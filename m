From: akpm@linux-foundation.org
Subject: + usb-remove-redundant-memset-from-amd5536udc.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:57:36 -0700
Message-ID: <200707290657.l6T6vaRj012643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759849AbXG2G5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, greg@kroah.com


The patch titled
     usb: remove redundant memset from amd5536udc
has been added to the -mm tree.  Its filename is
     usb-remove-redundant-memset-from-amd5536udc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: remove redundant memset from amd5536udc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Remove redundant memset() call from udc_pci_probe().  No functional change.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/usb/gadget/amd5536udc.c~usb-remove-redundant-memset-from-amd5536udc drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~usb-remove-redundant-memset-from-amd5536udc
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3244,7 +3244,6 @@ static int udc_pci_probe(
 		retval = -ENOMEM;
 		goto finished;
 	}
-	memset(dev, 0, sizeof(struct udc));
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
fs-9p-convc-error-path-fix.patch
