From: akpm@linux-foundation.org
Subject: - gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:47 -0700
Message-ID: <200810012152.m91LqlR5006081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbYJAVyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: afleming@freescale.com, danielm77@spray.se, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     gianfar: free/iounmap memory after an error in mii bus initialization
has been removed from the -mm tree.  Its filename was
     gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gianfar: free/iounmap memory after an error in mii bus initialization
From: Andy Fleming <afleming@freescale.com>

Recent changes to MII bus initialization code added exit points which
didn't free or iounmap the bus before returning.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11372.

Signed-off-by: Andy Fleming <afleming@freescale.com>
Reported-by: Daniel Marjamki <danielm77@spray.se>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/gianfar_mii.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/net/gianfar_mii.c~gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization drivers/net/gianfar_mii.c
--- a/drivers/net/gianfar_mii.c~gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization
+++ a/drivers/net/gianfar_mii.c
@@ -211,19 +211,21 @@ static int gfar_mdio_probe(struct device
 	gfar_write(&enet_regs->tbipa, 0);
 	for (i = PHY_MAX_ADDR; i > 0; i--) {
 		u32 phy_id;
-		int r;
 
-		r = get_phy_id(new_bus, i, &phy_id);
-		if (r)
-			return r;
+		err = get_phy_id(new_bus, i, &phy_id);
+		if (err)
+			goto bus_register_fail;
 
 		if (phy_id == 0xffffffff)
 			break;
 	}
 
 	/* The bus is full.  We don't support using 31 PHYs, sorry */
-	if (i == 0)
-		return -EBUSY;
+	if (i == 0) {
+		err = -EBUSY;
+
+		goto bus_register_fail;
+	}
 
 	gfar_write(&enet_regs->tbipa, i);
 
_

Patches currently in -mm which might be from afleming@freescale.com are

git-net.patch

