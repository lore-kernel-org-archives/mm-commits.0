From: akpm@linux-foundation.org
Subject: - mca-fix-bus-matching.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:51 -0700
Message-ID: <200705092149.l49LnpgS002734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbXEIVtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@SteelEye.com, mm-commits@vger.kernel.org


The patch titled
     mca: fix bus matching
has been removed from the -mm tree.  Its filename was
     mca-fix-bus-matching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mca: fix bus matching
From: James Bottomley <James.Bottomley@SteelEye.com>

There's a bug in the MCA bus matching algorithm in that it promotes from
signed short to int before comparing with the actual id and does sign
extension on anything > 0x7fff (which means that pos ids > 0x7fff never get
correctly matched).

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mca/mca-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mca/mca-bus.c~mca-fix-bus-matching drivers/mca/mca-bus.c
--- a/drivers/mca/mca-bus.c~mca-fix-bus-matching
+++ a/drivers/mca/mca-bus.c
@@ -47,7 +47,7 @@ static int mca_bus_match (struct device 
 {
 	struct mca_device *mca_dev = to_mca_device (dev);
 	struct mca_driver *mca_drv = to_mca_driver (drv);
-	const short *mca_ids = mca_drv->id_table;
+	const unsigned short *mca_ids = mca_drv->id_table;
 	int i;
 
 	if (!mca_ids)
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
fix--confusion-in-fusion-driver.patch
upper-32-bits.patch
