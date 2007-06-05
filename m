From: akpm@linux-foundation.org
Subject: + sundance-phy-address-form-0-only-for-device-id-0x0200.patch added to -mm tree
Date: Mon, 04 Jun 2007 21:48:43 -0700
Message-ID: <200706050448.l554mg1L029518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbXFEEtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 00:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesse@icplus.com.tw, jeff@garzik.org


The patch titled
     sundance: PHY address form 0, only for device ID 0x0200 (IP100A) (20070605)
has been added to the -mm tree.  Its filename is
     sundance-phy-address-form-0-only-for-device-id-0x0200.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/sundance.c~sundance-phy-address-form-0-only-for-device-id-0x0200 drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-phy-address-form-0-only-for-device-id-0x0200
+++ a/drivers/net/sundance.c
@@ -562,7 +562,11 @@ static int __devinit sundance_probe1 (st
 	 * It seems some phys doesn't deal well with address 0 being accessed
 	 * first, so leave address zero to the end of the loop (32 & 31).
 	 */
-	for (phy = 1; phy <= 32 && phy_idx < MII_CNT; phy++) {
+	if(sundance_pci_tbl[np->chip_id].device == 0x0200)
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
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
