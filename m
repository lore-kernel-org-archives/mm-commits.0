From: akpm@linux-foundation.org
Subject: + dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove.patch added to -mm tree
Date: Thu, 08 May 2008 13:12:23 -0700
Message-ID: <200805082012.m48KCNsB003576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbYEHUNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: enrico.scholz@sigma-chemnitz.de, ben-linux@fluff.org, jeff@garzik.org


The patch titled
     dm9000: add __devinit and __devexit attributes to probe and remove
has been added to the -mm tree.  Its filename is
     dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove.patch

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
Subject: dm9000: add __devinit and __devexit attributes to probe and remove
From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>

There were missing __dev* annotations for the dm9000_probe() and
dm9000_drv_remove() functions.

Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dm9000.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/dm9000.c~dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove
+++ a/drivers/net/dm9000.c
@@ -503,7 +503,7 @@ dm9000_release_board(struct platform_dev
 /*
  * Search DM9000 board, allocate space and register it
  */
-static int
+static int __devinit
 dm9000_probe(struct platform_device *pdev)
 {
 	struct dm9000_plat_data *pdata = pdev->dev.platform_data;
@@ -1372,7 +1372,7 @@ dm9000_drv_resume(struct platform_device
 	return 0;
 }
 
-static int
+static int __devexit
 dm9000_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
@@ -1393,7 +1393,7 @@ static struct platform_driver dm9000_dri
 		.owner	 = THIS_MODULE,
 	},
 	.probe   = dm9000_probe,
-	.remove  = dm9000_drv_remove,
+	.remove  = __devexit_p(dm9000_drv_remove),
 	.suspend = dm9000_drv_suspend,
 	.resume  = dm9000_drv_resume,
 };
_

Patches currently in -mm which might be from enrico.scholz@sigma-chemnitz.de are

dm9000-add-__devinit-and-__devexit-attributes-to-probe-and-remove.patch
dm9000-update-and-fix-driver-debugging-messages.patch
dm9000-use-delayed-work-to-update-mii-phy-state.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch

