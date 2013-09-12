From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-swimc-remove-unnecessary-platform_set_drvdata.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:42:09 -0700
Message-ID: <52321911.BnUiksmzB1EPda35%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khali@linux-fr.org, axboe@kernel.dk, jg1.han@samsung.com

Subject: [merged] drivers-block-swimc-remove-unnecessary-platform_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,axboe@kernel.dk,khali@linux-fr.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:09 -0700


The patch titled
     Subject: drivers/block/swim.c: remove unnecessary platform_set_drvdata()
has been removed from the -mm tree.  Its filename was
     drivers-block-swimc-remove-unnecessary-platform_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/swim.c: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/swim.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/swim.c~drivers-block-swimc-remove-unnecessary-platform_set_drvdata drivers/block/swim.c
--- a/drivers/block/swim.c~drivers-block-swimc-remove-unnecessary-platform_set_drvdata
+++ a/drivers/block/swim.c
@@ -924,7 +924,6 @@ static int swim_probe(struct platform_de
 	return 0;
 
 out_kfree:
-	platform_set_drvdata(dev, NULL);
 	kfree(swd);
 out_iounmap:
 	iounmap(swim_base);
@@ -962,7 +961,6 @@ static int swim_remove(struct platform_d
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 
-	platform_set_drvdata(dev, NULL);
 	kfree(swd);
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
kernel-replace-strict_strto-with-kstrto.patch

