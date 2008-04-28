From: akpm@linux-foundation.org
Subject: - gxfb-use-pci_device-for-gxfbs-pci-device-table.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:35 -0700
Message-ID: <200804282157.m3SLvZBV018410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964805AbYD1V5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: use PCI_DEVICE() for gxfb's pci device table
has been removed from the -mm tree.  Its filename was
     gxfb-use-pci_device-for-gxfbs-pci-device-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -398,9 +398,7 @@ static void gxfb_remove(struct pci_dev *
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

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

