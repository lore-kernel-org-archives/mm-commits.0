From: akpm@linux-foundation.org
Subject: + gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization.patch added to -mm tree
Date: Fri, 19 Sep 2008 17:24:45 -0700
Message-ID: <200809200024.m8K0OjAV014806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYITAZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 20:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: afleming@freescale.com, danielm77@spray.se, jeff@garzik.org


The patch titled
     gianfar: free/iounmap memory after an error in mii bus initialization
has been added to the -mm tree.  Its filename is
     gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

gianfar-free-iounmap-memory-after-an-error-in-mii-bus-initialization.patch

