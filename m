From: akpm@linux-foundation.org
Subject: + drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch added to -mm tree
Date: Wed, 10 Sep 2008 15:45:43 -0700
Message-ID: <200809102245.m8AMjhUj030444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYIJWpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 18:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven.noonan@uplinklabs.net, greg@kroah.com, stern@rowland.harvard.edu, steven@uplinklabs.net


The patch titled
     drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
has been added to the -mm tree.  Its filename is
     drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch

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
Subject: drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
From: Steven Noonan <steven.noonan@uplinklabs.net>

Instead of waiting a painful 5000ms, quirk_usb_disable_ehci() now does a
250ms loop to verify the EHCI handoff completed.  If it didn't, it tries
to force the ownership by writing the OS ownership bit.  It then does a
second 250ms loop which will terminate early if the bit change is
reflected when reading the ownership state.  If it's still not proper,
print a warning.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
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

