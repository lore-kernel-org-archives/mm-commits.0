From: akpm@linux-foundation.org
Subject: - matroxfb-support-g200ev-chip.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:00 -0700
Message-ID: <200810182318.m9INI0oY029197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYJRXSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, krzysztof.h1@wp.pl, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: support G200eV chip
has been removed from the -mm tree.  Its filename was
     matroxfb-support-g200ev-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: support G200eV chip
From: "Darrick J. Wong" <djwong@us.ibm.com>

Support the Matrox G200eV chip, based on timings that I found in the X.org
matrox driver.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_base.c |    9 +++++++++
 include/linux/pci_ids.h              |    1 +
 2 files changed, 10 insertions(+)

diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-support-g200ev-chip drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-support-g200ev-chip
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -1453,6 +1453,13 @@ static struct board {
 		MGA_G100,
 		&vbG100,
 		"MGA-G100 (AGP)"},
+	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,	0xFF,
+		0,			0,
+		DEVF_G200,
+		230000,
+		MGA_G200,
+		&vbG200,
+		"MGA-G200eV (PCI)"},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,	0xFF,
 		0,			0,
 		DEVF_G200,
@@ -2118,6 +2125,8 @@ static struct pci_device_id matroxfb_dev
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G100_AGP,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
+	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
+		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_AGP,
diff -puN include/linux/pci_ids.h~matroxfb-support-g200ev-chip include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~matroxfb-support-g200ev-chip
+++ a/include/linux/pci_ids.h
@@ -587,6 +587,7 @@
 #define PCI_DEVICE_ID_MATROX_G200_PCI	0x0520
 #define PCI_DEVICE_ID_MATROX_G200_AGP	0x0521
 #define	PCI_DEVICE_ID_MATROX_G400	0x0525
+#define	PCI_DEVICE_ID_MATROX_G200EV_PCI	0x0530
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch

