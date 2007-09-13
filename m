From: akpm@linux-foundation.org
Subject: - sundance-phy-address-form-0-only-for-device-id-0x0200.patch removed from -mm tree
Date: Thu, 13 Sep 2007 15:10:03 -0700
Message-ID: <200709132210.l8DMA3I9008381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbXIMWKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse@icplus.com.tw, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sundance: PHY address form 0, only for device ID 0x0200 (IP100A) (20070605)
has been removed from the -mm tree.  Its filename was
     sundance-phy-address-form-0-only-for-device-id-0x0200.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: sundance: PHY address form 0, only for device ID 0x0200 (IP100A) (20070605)
From: Jesse Huang <jesse@icplus.com.tw>

Search PHY address form 0, only for device ID 0x0200 (IP100A).  Other
device are from PHY address 1.

Signed-off-by: Jesse Huang <jesse@icplus.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sundance.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/sundance.c~sundance-phy-address-form-0-only-for-device-id-0x0200 drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-phy-address-form-0-only-for-device-id-0x0200
+++ a/drivers/net/sundance.c
@@ -559,7 +559,11 @@ static int __devinit sundance_probe1 (st
 	 * It seems some phys doesn't deal well with address 0 being accessed
 	 * first, so leave address zero to the end of the loop (32 & 31).
 	 */
-	for (phy = 1; phy <= 32 && phy_idx < MII_CNT; phy++) {
+	if (sundance_pci_tbl[np->chip_id].device == 0x0200)
+		phy = 0;
+	else
+		phy = 1;
+	for (; phy <= 32 && phy_idx < MII_CNT; phy++) {
 		int phyx = phy & 0x1f;
 		int mii_status = mdio_read(dev, phyx, MII_BMSR);
 		if (mii_status != 0xffff  &&  mii_status != 0x0000) {
_

Patches currently in -mm which might be from jesse@icplus.com.tw are

sundance-phy-address-form-0-only-for-device-id-0x0200.patch
