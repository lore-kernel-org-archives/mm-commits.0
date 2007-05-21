From: akpm@linux-foundation.org
Subject: + fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch added to -mm tree
Date: Sun, 20 May 2007 20:49:36 -0700
Message-ID: <200705210349.l4L3nZJp001812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528AbXEUDwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:52:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     Fix USB OHCI Subvendor for Toshiba Portege 4000
has been added to the -mm tree.  Its filename is
     fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix USB OHCI Subvendor for Toshiba Portege 4000
From: Andrey Borzenkov <arvidjaar@mail.ru>

For Portege 4000 Subvendor is 1179 (PCI_VENDOR_ID_TOSHIBA) not 0x102f
(PCI_VENDOR_ID_TOSHIBA_2)

00:02.0 USB Controller [0c03]: ALi Corporation USB 1.1 Controller
[10b9:5237] (rev 03) (prog-if 10 [OHCI])
        Subsystem: Toshiba America Info Systems Unknown device [1179:0004]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at f7eff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ohci-pci.c~fix-usb-ohci-subvendor-for-toshiba-portege-4000 drivers/usb/host/ohci-pci.c
--- a/drivers/usb/host/ohci-pci.c~fix-usb-ohci-subvendor-for-toshiba-portege-4000
+++ a/drivers/usb/host/ohci-pci.c
@@ -137,7 +137,7 @@ static const struct pci_device_id ohci_p
 		/* Toshiba portege 4000 */
 		.vendor		= PCI_VENDOR_ID_AL,
 		.device		= 0x5237,
-		.subvendor	= PCI_VENDOR_ID_TOSHIBA_2,
+		.subvendor	= PCI_VENDOR_ID_TOSHIBA,
 		.subdevice	= 0x0004,
 		.driver_data	= (unsigned long) broken_suspend,
 	},
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
