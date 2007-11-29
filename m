From: akpm@linux-foundation.org
Subject: + r6040-erroneous-dev-priv.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:04:10 -0800
Message-ID: <200711292304.lATN4A6F011963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934375AbXK2XEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:04:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     r6040: erroneous dev->priv
has been added to the -mm tree.  Its filename is
     r6040-erroneous-dev-priv.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r6040: erroneous dev->priv
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r6040.c~r6040-erroneous-dev-priv drivers/net/r6040.c
--- a/drivers/net/r6040.c~r6040-erroneous-dev-priv
+++ a/drivers/net/r6040.c
@@ -674,7 +674,7 @@ static void r6040_up(struct net_device *
 static void r6040_timer(unsigned long data)
 {
 	struct net_device *dev = (struct net_device *)data;
-	struct r6040_private *lp = netdev_priv(dev->priv);
+	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
 	u16 phy_mode;
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-netdev-all.patch
r6040-compile-error.patch
r6040-remove-virt_to_bus.patch
r6040-erroneous-dev-priv.patch
r6040-cleanups.patch
