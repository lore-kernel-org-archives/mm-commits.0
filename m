From: akpm@linux-foundation.org
Subject: + usb-fix-sb700-usb-subsystem-hang-bug.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:42:12 -0800
Message-ID: <200811150042.mAF0gCrJ027018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYKOAmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andiry.xu@amd.com, libin.yang@amd.com, volker.armin.hemmann@tu-clausthal.de


The patch titled
     usb: fix SB700 usb subsystem hang bug
has been added to the -mm tree.  Its filename is
     usb-fix-sb700-usb-subsystem-hang-bug.patch

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
Subject: usb: fix SB700 usb subsystem hang bug
From: Andiry Xu <andiry.xu@amd.com>

This patch is required for AMD SB700 south bridge revision A12 and A13 to
avoid USB subsystem hang symptom.  The USB subsystem hang symptom is
observed when the system has multiple USB devices connected to it.  In
some cases a USB hub may be required to observe this symptom.

This patch works around the problem by correcting the internal register
setting that will help by changing the behavior of the internal logic to
avoid the USB subsystem hang issue.  The change in the behavior of the
logic does not impact the normal operation of the USB subsystem.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Libin Yang <libin.yang@amd.com>
Reported-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Tested-by: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-pci.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/usb/host/ehci-pci.c~usb-fix-sb700-usb-subsystem-hang-bug drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c~usb-fix-sb700-usb-subsystem-hang-bug
+++ a/drivers/usb/host/ehci-pci.c
@@ -66,6 +66,8 @@ static int ehci_pci_setup(struct usb_hcd
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+	struct pci_dev		*p_smbus;
+	u8			rev;
 	u32			temp;
 	int			retval;
 
@@ -166,6 +168,25 @@ static int ehci_pci_setup(struct usb_hcd
 			pci_write_config_byte(pdev, 0x4b, tmp | 0x20);
 		}
 		break;
+	case PCI_VENDOR_ID_ATI:
+		/* SB700 old version has a bug in EHCI controller,
+		 * which causes usb devices lose response in some cases.
+		 */
+		if (pdev->device == 0x4396) {
+			p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
+						 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+						 NULL);
+			if (!p_smbus)
+				break;
+			rev = p_smbus->revision;
+			if ((rev == 0x3a) || (rev == 0x3b)) {
+				u8 tmp;
+				pci_read_config_byte(pdev, 0x53, &tmp);
+				pci_write_config_byte(pdev, 0x53, tmp | (1<<3));
+			}
+			pci_dev_put(p_smbus);
+		}
+		break;
 	}
 
 	ehci_reset(ehci);
_

Patches currently in -mm which might be from andiry.xu@amd.com are

usb-fix-sb700-usb-subsystem-hang-bug.patch

