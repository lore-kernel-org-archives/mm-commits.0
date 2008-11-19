From: akpm@linux-foundation.org
Subject: - usb-fix-sb700-usb-subsystem-hang-bug.patch removed from -mm tree
Date: Wed, 19 Nov 2008 12:48:04 -0800
Message-ID: <200811192048.mAJKm42d007244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbYKSUsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 15:48:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andiry.xu@amd.com, libin.yang@amd.com, volker.armin.hemmann@tu-clausthal.de, mm-commits@vger.kernel.org


The patch titled
     usb: fix SB700 usb subsystem hang bug
has been removed from the -mm tree.  Its filename was
     usb-fix-sb700-usb-subsystem-hang-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

