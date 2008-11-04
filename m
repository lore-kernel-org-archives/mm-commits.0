From: akpm@linux-foundation.org
Subject: - drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch removed from -mm tree
Date: Mon, 03 Nov 2008 17:55:20 -0800
Message-ID: <200811040155.mA41tK9H032033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbYKDBz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 20:55:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steven.noonan@uplinklabs.net, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu, steven@uplinklabs.net, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
has been removed from the -mm tree.  Its filename was
     drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
From: Steven Noonan <steven.noonan@uplinklabs.net>

Instead of waiting a painful 5000ms, quirk_usb_disable_ehci() now does a
1000ms loop to verify the EHCI handoff completed.  If it didn't, it tries
to force the ownership by writing the OS ownership bit.  It then does a
second 1000ms loop which will terminate early if the bit change is
reflected when reading the ownership state.  If it's still not proper,
print a warning.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/pci-quirks.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci drivers/usb/host/pci-quirks.c
--- a/drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci
+++ a/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = 250;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
@@ -283,9 +283,16 @@ static void __devinit quirk_usb_disable_
 				/* well, possibly buggy BIOS... try to shut
 				 * it down, and hope nothing goes too wrong
 				 */
-				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
-						" (BIOS bug?) %08x\n", cap);
+				dev_warn(&pdev->dev, "EHCI: Forcing OS ownership\n");
 				pci_write_config_byte(pdev, offset + 2, 0);
+
+				/* verify that the BIOS handoff was forced */
+				msec = 250;
+				while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
+					msleep(10);
+					msec -= 10;
+					pci_read_config_dword(pdev, offset, &cap);
+				}
 			}
 
 			/* just in case, always disable EHCI SMIs */
@@ -293,6 +300,12 @@ static void __devinit quirk_usb_disable_
 					offset + EHCI_USBLEGCTLSTS,
 					0);
 
+			pci_read_config_dword(pdev, offset, &cap);
+			if (cap & EHCI_USBLEGSUP_BIOS) {
+				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
+						" (BIOS bug?) %08x\n", cap);
+			}
+
 			/* If the BIOS ever owned the controller then we
 			 * can't expect any power sessions to remain intact.
 			 */
_

Patches currently in -mm which might be from steven.noonan@uplinklabs.net are

drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch
drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix.patch

