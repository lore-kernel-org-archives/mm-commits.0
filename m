From: akpm@linux-foundation.org
Subject: + ehci-disable-the-philips-isp1561-usb-hub.patch added to -mm tree
Date: Fri, 21 Dec 2007 15:58:30 -0800
Message-ID: <200712212358.lBLNwVqA005601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbXLUX6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 18:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruno@altarisoluzione.com, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     ehci: disable the Philips ISP1561 usb hub
has been added to the -mm tree.  Its filename is
     ehci-disable-the-philips-isp1561-usb-hub.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ehci: disable the Philips ISP1561 usb hub
From: Bruno Redondi <bruno@altarisoluzione.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=9562

I am trying to use a PCMCIA PC-CARD GPRS/UMTS/HSDPA MODEM PC-CARD is branded
as ONDA H600 and is extremely popular in Italy since it is the "default" UMTS
PC-CARD by a provider in the country.  PC-CARD is actually a re-branded ZTE
MF330 so it should be quite popular in other countries as well.  Apparently,
also the older ONDA NH501HS is again a ZTE MF330, so the following should
apply also to that card.


When the card is inserted into the PCMCIA slot, the following should happen:

- kernel should recognize an OHCI Host Controller

- kernel should recognize an ONDA CDMA Technologies MSM (Manufacturer:
  Qualcomm, Incorporated) attached to it

- kernel should configure 3 ttyUSB devices provided by the 3 serial
  interfaces of the ONDA MSM

Unfortunately, with the linux kernel this does not happen Rather, the kernel
gets confused, detects an EHCI Controller, loads the kernel module for it and
no serial interfaces appear.

As an hack, the correct behaviour can be obtained by blacklisting the ehci_hcd
for instance in /etc/modprobe.d/blacklist-modem.  When the ehci_hcd is
blacklisted everything works correctly and the ONDA Wireless UMTS PC-CARD gets
perfectly usable.

lspci reports the datacard as a Philips ISP1561 EHCI USB 2.0 (1131:1562), so I
excluded this device from ehci-pci and i can use the datacard without
blacklisting the module.

Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/usb/host/ehci-pci.c~ehci-disable-the-philips-isp1561-usb-hub drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c~ehci-disable-the-philips-isp1561-usb-hub
+++ a/drivers/usb/host/ehci-pci.c
@@ -141,6 +141,14 @@ static int ehci_pci_setup(struct usb_hcd
 			goto done;
 		}
 		break;
+	case PCI_VENDOR_ID_PHILIPS:
+		/* ISP1561 EHCI USB 2.0 doesn't work. */
+		if (pdev->device == 0x1562) {
+			ehci_info(ehci, "ignoring ISP1561\n");
+			retval = -EIO;
+			goto done;
+		}
+		break;
 	case PCI_VENDOR_ID_NVIDIA:
 		switch (pdev->device) {
 		/* Some NForce2 chips have problems with selective suspend;
_

Patches currently in -mm which might be from bruno@altarisoluzione.com are

ehci-disable-the-philips-isp1561-usb-hub.patch
