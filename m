From: akpm@linux-foundation.org
Subject: - via-quirk-fix-update.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:45 -0800
Message-ID: <200702022137.l12LbjlM018534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41531 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946114AbXBBVhu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, alan@lxorguk.ukuu.org.uk, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     via quirk update
has been removed from the -mm tree.  Its filename was
     via-quirk-fix-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: via quirk update
From: Jean Delvare <jdelvare@suse.de>

Add special handling for the VT82C686.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/pci/quirks.c~via-quirk-fix-update drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~via-quirk-fix-update
+++ a/drivers/pci/quirks.c
@@ -661,9 +661,11 @@ static void quirk_via_bridge(struct pci_
 	/* See what bridge we have and find the device ranges */
 	switch (dev->device) {
 	case PCI_DEVICE_ID_VIA_82C686:
-		/* 82C686 is special */
-		via_vlink_dev_lo = 7;
-		via_vlink_dev_hi = 7;
+		/* The VT82C686 is special, it attaches to PCI and can have
+		   any device number. All its subdevices are functions of
+		   that single device. */
+		via_vlink_dev_lo = PCI_SLOT(dev->devfn);
+		via_vlink_dev_hi = PCI_SLOT(dev->devfn);
 		break;
 	case PCI_DEVICE_ID_VIA_8237:
 	case PCI_DEVICE_ID_VIA_8237A:
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
