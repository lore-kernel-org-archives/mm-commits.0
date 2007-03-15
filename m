From: akpm@linux-foundation.org
Subject: - tulip-fix-for-64-bit-mips.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:00 -0800
Message-ID: <200703152159.l2FLx0sH027776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42755 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbXCOWDo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maillist@jg555.com, grundler@parisc-linux.org, pdh@colonel-panic.org, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     tulip: fix for 64-bit mips
has been removed from the -mm tree.  Its filename was
     tulip-fix-for-64-bit-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tulip: fix for 64-bit mips
From: Jim Gifford <maillist@jg555.com>,
      Grant Grundler <grundler@parisc-linux.org>,
      Peter Horton <pdh@colonel-panic.org>

With Grant's help I was able to get the tulip driver to work with 64 bit 
MIPS.

Cc: Valerie Henson <val_henson@linux.intel.com>

[akpm: this is a previously-nacked patch, but the problem is real]

Jeff sez:

| Answer hasn't changed since this was last discussed:  sleep, rather than
| delay for an extra-long time.  That's the only hurdle for the tulip
| patches you keep resending.

| Francois Romieu even had an untested patch that attempted this,
| somewhere.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/tulip/media.c |   22 ++++++++++++++++++++--
 drivers/net/tulip/tulip.h |    7 +++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff -puN drivers/net/tulip/media.c~tulip-fix-for-64-bit-mips drivers/net/tulip/media.c
--- a/drivers/net/tulip/media.c~tulip-fix-for-64-bit-mips
+++ a/drivers/net/tulip/media.c
@@ -44,8 +44,10 @@ static const unsigned char comet_miireg2
 
 /* MII transceiver control section.
    Read and write the MII registers using software-generated serial
-   MDIO protocol.  See the MII specifications or DP83840A data sheet
-   for details. */
+   MDIO protocol.
+   See IEEE 802.3-2002.pdf (Section 2, Chapter "22.2.4 Management functions")
+   or DP83840A data sheet for more details.
+   */
 
 int tulip_mdio_read(struct net_device *dev, int phy_id, int location)
 {
@@ -272,13 +274,29 @@ void tulip_select_media(struct net_devic
 				int reset_length = p[2 + init_length];
 				misc_info = (u16*)(reset_sequence + reset_length);
 				if (startup) {
+					int timeout = 10;	/* max 1 ms */
 					iowrite32(mtable->csr12dir | 0x100, ioaddr + CSR12);
 					for (i = 0; i < reset_length; i++)
 						iowrite32(reset_sequence[i], ioaddr + CSR12);
+
+					/* flush posted writes */
+					ioread32(ioaddr + CSR12);
+
+					/* Sect 3.10.3 in DP83840A.pdf (p39) */
+					udelay(500);
+
+					/* Section 4.2 in DP83840A.pdf (p43) */
+					/* and IEEE 802.3 "22.2.4.1.1 Reset" */
+					while (timeout-- &&
+						(tulip_mdio_read (dev, phy_num, MII_BMCR) & BMCR_RESET))
+						udelay(100);
 				}
 				for (i = 0; i < init_length; i++)
 					iowrite32(init_sequence[i], ioaddr + CSR12);
+
+				ioread32(ioaddr + CSR12);	/* flush posted writes */
 			}
+
 			tmp_info = get_u16(&misc_info[1]);
 			if (tmp_info)
 				tp->advertising[phy_num] = tmp_info | 1;
diff -puN drivers/net/tulip/tulip.h~tulip-fix-for-64-bit-mips drivers/net/tulip/tulip.h
--- a/drivers/net/tulip/tulip.h~tulip-fix-for-64-bit-mips
+++ a/drivers/net/tulip/tulip.h
@@ -482,8 +482,11 @@ static inline void tulip_stop_rxtx(struc
 			udelay(10);
 
 		if (!i)
-			printk(KERN_DEBUG "%s: tulip_stop_rxtx() failed\n",
-					pci_name(tp->pdev));
+			printk(KERN_DEBUG "%s: tulip_stop_rxtx() failed"
+					" (CSR5 0x%x CSR6 0x%x)\n",
+					pci_name(tp->pdev),
+					ioread32(ioaddr + CSR5),
+					ioread32(ioaddr + CSR6));
 	}
 }
 
_

Patches currently in -mm which might be from maillist@jg555.com are

git-netdev-all.patch
