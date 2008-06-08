From: akpm@linux-foundation.org
Subject: + macb-use-random-mac-if-stored-address-in-eeprom-is-invalid.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:58:23 -0700
Message-ID: <200806081958.m58JwNub017933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbYFHT6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svens@stackframe.org, hskinnemoen@atmel.com, jeff@garzik.org


The patch titled
     macb: use random mac if stored address in EEPROM is invalid
has been added to the -mm tree.  Its filename is
     macb-use-random-mac-if-stored-address-in-eeprom-is-invalid.patch

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

macb-use-random-mac-if-stored-address-in-eeprom-is-invalid.patch

