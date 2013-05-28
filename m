From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-xsysacec-fix-id-with-missing-port-number.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:36:32 -0700
Message-ID: <51a50740.SVVL+PfRWspRnchG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3E1Tgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob.herring@calxeda.com, gregkh@linuxfoundation.org, grant.likely@linaro.org, axboe@kernel.dk, gvormayr@gmail.com

Subject: [merged] drivers-block-xsysacec-fix-id-with-missing-port-number.patch removed from -mm tree
To: gvormayr@gmail.com,axboe@kernel.dk,grant.likely@linaro.org,gregkh@linuxfoundation.org,rob.herring@calxeda.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:32 -0700


The patch titled
     Subject: drivers/block/xsysace.c: fix id with missing port-number
has been removed from the -mm tree.  Its filename was
     drivers-block-xsysacec-fix-id-with-missing-port-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gernot Vormayr <gvormayr@gmail.com>
Subject: drivers/block/xsysace.c: fix id with missing port-number

If the port number is missing from the device-tree the device gets named
xs` instead of xsa.  This fixes the check for missing ids.

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/xsysace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/xsysace.c~drivers-block-xsysacec-fix-id-with-missing-port-number drivers/block/xsysace.c
--- a/drivers/block/xsysace.c~drivers-block-xsysacec-fix-id-with-missing-port-number
+++ a/drivers/block/xsysace.c
@@ -1160,8 +1160,7 @@ static int ace_probe(struct platform_dev
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
 
 	/* device id and bus width */
-	of_property_read_u32(dev->dev.of_node, "port-number", &id);
-	if (id < 0)
+	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
 		id = 0;
 	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
_

Patches currently in -mm which might be from gvormayr@gmail.com are


