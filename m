From: akpm@linux-foundation.org
Subject: + usb-m66592-udc-fix-up-dev_set_name-badness.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:33:03 -0700
Message-ID: <200807292233.m6TMX31H025293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbYG2Wde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     USB: m66592-udc: Fix up dev_set_name() badness.
has been added to the -mm tree.  Its filename is
     usb-m66592-udc-fix-up-dev_set_name-badness.patch

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
Subject: USB: m66592-udc: Fix up dev_set_name() badness.
From: Paul Mundt <lethal@linux-sh.org>

Commit 0031a06e2f07ab0d1bc98c31dbb6801f95f4bf01 converted all of the USB
drivers to use dev_set_name(), though there was a typo on the m66592-udc
conversion that handed off the wrong pointer (we want the struct device
here obviously, not the struct usb_gadget).

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/m66592-udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/gadget/m66592-udc.c~usb-m66592-udc-fix-up-dev_set_name-badness drivers/usb/gadget/m66592-udc.c
--- a/drivers/usb/gadget/m66592-udc.c~usb-m66592-udc-fix-up-dev_set_name-badness
+++ a/drivers/usb/gadget/m66592-udc.c
@@ -1593,7 +1593,7 @@ static int __init m66592_probe(struct pl
 
 	m66592->gadget.ops = &m66592_gadget_ops;
 	device_initialize(&m66592->gadget.dev);
-	dev_set_name(&m66592->gadget, "gadget");
+	dev_set_name(&m66592->gadget.dev, "gadget");
 	m66592->gadget.is_dualspeed = 1;
 	m66592->gadget.dev.parent = &pdev->dev;
 	m66592->gadget.dev.dma_mask = pdev->dev.dma_mask;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

resource-add-resource_size.patch
usb-m66592-udc-fix-up-dev_set_name-badness.patch
linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

