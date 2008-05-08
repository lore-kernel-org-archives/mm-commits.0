From: akpm@linux-foundation.org
Subject: + dm9000-update-and-fix-driver-debugging-messages.patch added to -mm tree
Date: Thu, 08 May 2008 13:12:25 -0700
Message-ID: <200805082012.m48KCPIe003580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbYEHUNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: enrico.scholz@sigma-chemnitz.de, ben-linux@fluff.org, jeff@garzik.org


The patch titled
     dm9000: update and fix driver debugging messages
has been added to the -mm tree.  Its filename is
     dm9000-update-and-fix-driver-debugging-messages.patch

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
Subject: dm9000: update and fix driver debugging messages
From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>

There was a missing newline in a dev_dbg() message.  Values read from/written
into PHY registers might be for interest too, so I added new dbg messages
there.

Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dm9000.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/dm9000.c~dm9000-update-and-fix-driver-debugging-messages drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~dm9000-update-and-fix-driver-debugging-messages
+++ a/drivers/net/dm9000.c
@@ -525,7 +525,7 @@ dm9000_probe(struct platform_device *pde
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	dev_dbg(&pdev->dev, "dm9000_probe()");
+	dev_dbg(&pdev->dev, "dm9000_probe()\n");
 
 	/* setup board info structure */
 	db = (struct board_info *) ndev->priv;
@@ -1288,6 +1288,8 @@ dm9000_phy_read(struct net_device *dev, 
 	spin_unlock_irqrestore(&db->lock,flags);
 
 	mutex_unlock(&db->addr_lock);
+
+	dm9000_dbg(db, 5, "phy_read[%02x] -> %04x\n", reg, ret);
 	return ret;
 }
 
@@ -1301,6 +1303,7 @@ dm9000_phy_write(struct net_device *dev,
 	unsigned long flags;
 	unsigned long reg_save;
 
+	dm9000_dbg(db, 5, "phy_write[%02x] = %04x\n", reg, value);
 	mutex_lock(&db->addr_lock);
 
 	spin_lock_irqsave(&db->lock,flags);
_

Patches currently in -mm which might be from enrico.scholz@sigma-chemnitz.de are

dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove.patch
dm9000-update-and-fix-driver-debugging-messages.patch
dm9000-use-delayed-work-to-update-mii-phy-state.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch

