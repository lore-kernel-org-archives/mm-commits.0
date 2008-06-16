From: akpm@linux-foundation.org
Subject: - macb-use-random-mac-if-stored-address-in-eeprom-is-invalid.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:33 -0700
Message-ID: <200806160604.m5G64X7F010693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbYFPGE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svens@stackframe.org, hskinnemoen@atmel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     macb: use random mac if stored address in EEPROM is invalid
has been removed from the -mm tree.  Its filename was
     macb-use-random-mac-if-stored-address-in-eeprom-is-invalid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macb: use random mac if stored address in EEPROM is invalid
From: Sven Schnelle <svens@stackframe.org>

We should use a random mac address if the EEPROM doesn't contain a valid
one. This makes life on Boards with unprogrammed EEPROM devices easier.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/macb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/macb.c~macb-use-random-mac-if-stored-address-in-eeprom-is-invalid drivers/net/macb.c
--- a/drivers/net/macb.c~macb-use-random-mac-if-stored-address-in-eeprom-is-invalid
+++ a/drivers/net/macb.c
@@ -80,8 +80,12 @@ static void __init macb_get_hwaddr(struc
 	addr[4] = top & 0xff;
 	addr[5] = (top >> 8) & 0xff;
 
-	if (is_valid_ether_addr(addr))
+	if (is_valid_ether_addr(addr)) {
 		memcpy(bp->dev->dev_addr, addr, sizeof(addr));
+	} else {
+		dev_info(&bp->pdev->dev, "invalid hw address, using random\n");
+		random_ether_addr(bp->dev->dev_addr);
+	}
 }
 
 static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
_

Patches currently in -mm which might be from svens@stackframe.org are

linux-next.patch

