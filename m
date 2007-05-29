From: akpm@linux-foundation.org
Subject: - ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:03 -0700
Message-ID: <200705291853.l4TIr2aC008444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765284AbXE2S4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leoli@freescale.com, david-b@pacbell.net, greg@kroah.com, reyems@telkomsa.net, mm-commits@vger.kernel.org


The patch titled
     ehci-fsl: fix cache coherency problem on system with large memory
has been removed from the -mm tree.  Its filename was
     ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehci-fsl: fix cache coherency problem on system with large memory
From: Li Yang <leoli@freescale.com>

The patch fix bug http://bugzilla.kernel.org/show_bug.cgi?id=7482.
It sets USB snooping on 4G space for PowerPC platforms without
CONFIG_NOT_COHERENT_CACHE defined.

Reported-by: Stefan Meyer <reyems@telkomsa.net>
Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-fsl.c |   13 +++++++++++++
 drivers/usb/host/ehci-fsl.h |    1 +
 2 files changed, 14 insertions(+)

diff -puN drivers/usb/host/ehci-fsl.c~ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory drivers/usb/host/ehci-fsl.c
--- a/drivers/usb/host/ehci-fsl.c~ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory
+++ a/drivers/usb/host/ehci-fsl.c
@@ -193,6 +193,19 @@ static void mpc83xx_usb_setup(struct usb
 	out_be32(non_ehci + FSL_SOC_USB_CTRL, 0x00000004);
 	out_be32(non_ehci + FSL_SOC_USB_SNOOP1, 0x0000001b);
 
+#if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
+	/*
+	 * Turn on cache snooping hardware, since some PowerPC platforms
+	 * wholly rely on hardware to deal with cache coherent
+	 */
+
+	/* Setup Snooping for all the 4GB space */
+	/* SNOOP1 starts from 0x0, size 2G */
+	out_be32(non_ehci + FSL_SOC_USB_SNOOP1, 0x0 | SNOOP_SIZE_2GB);
+	/* SNOOP2 starts from 0x80000000, size 2G */
+	out_be32(non_ehci + FSL_SOC_USB_SNOOP2, 0x80000000 | SNOOP_SIZE_2GB);
+#endif
+
 	if (pdata->operating_mode == FSL_USB2_DR_HOST)
 		mpc83xx_setup_phy(ehci, pdata->phy_mode, 0);
 
diff -puN drivers/usb/host/ehci-fsl.h~ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory drivers/usb/host/ehci-fsl.h
--- a/drivers/usb/host/ehci-fsl.h~ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory
+++ a/drivers/usb/host/ehci-fsl.h
@@ -34,4 +34,5 @@
 #define FSL_SOC_USB_PRICTRL	0x40c	/* NOTE: big-endian */
 #define FSL_SOC_USB_SICTRL	0x410	/* NOTE: big-endian */
 #define FSL_SOC_USB_CTRL	0x500	/* NOTE: big-endian */
+#define SNOOP_SIZE_2GB		0x1e
 #endif				/* _EHCI_FSL_H */
_

Patches currently in -mm which might be from leoli@freescale.com are

powerpc-fix-section-mismatch-warnings.patch
