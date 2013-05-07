From: akpm@linux-foundation.org
Subject: + drivers-block-xsysacec-fix-id-with-missing-port-number.patch added to -mm tree
Date: Tue, 07 May 2013 14:40:43 -0700
Message-ID: <20130507214043.7B3B55A42DC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59287 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759852Ab3EGVko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 17:40:44 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so114759ggl.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 14:40:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gvormayr@gmail.com, axboe@kernel.dk, grant.likely@linaro.org, gregkh@linuxfoundation.org, rob.herring@calxeda.com


The patch titled
     Subject: drivers/block/xsysace.c: fix id with missing port-number
has been added to the -mm tree.  Its filename is
     drivers-block-xsysacec-fix-id-with-missing-port-number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1161,8 +1161,7 @@ static int ace_probe(struct platform_dev
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

drivers-block-xsysacec-fix-id-with-missing-port-number.patch

