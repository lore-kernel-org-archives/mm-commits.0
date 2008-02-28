From: akpm@linux-foundation.org
Subject: + gxfb-use-pci_device-for-gxfbs-pci-device-table.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:31:44 -0800
Message-ID: <200802280031.m1S0Vib0006878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYB1AiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:38:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org


The patch titled
     gxfb: use PCI_DEVICE() for gxfb's pci device table
has been added to the -mm tree.  Its filename is
     gxfb-use-pci_device-for-gxfbs-pci-device-table.patch

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
Subject: gxfb: use PCI_DEVICE() for gxfb's pci device table
From: Andres Salomon <dilinger@queued.net>

Drop the class/class_mask stuff; it's unnecessary as long as the vendor and
device IDs match.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gxfb_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~gxfb-use-pci_device-for-gxfbs-pci-device-table drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-use-pci_device-for-gxfbs-pci-device-table
+++ a/drivers/video/geode/gxfb_core.c
@@ -396,9 +396,7 @@ static void gxfb_remove(struct pci_dev *
 }
 
 static struct pci_device_id gxfb_id_table[] = {
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_GX_VIDEO,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_GX_VIDEO) },
 	{ 0, }
 };
 
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
