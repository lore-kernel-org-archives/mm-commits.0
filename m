From: akpm@linux-foundation.org
Subject: - asic3-remove-children-platform-data.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:06:05 -0700
Message-ID: <200807070306.m67365NR004875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYGGDGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     asic3: remove children platform data
has been removed from the -mm tree.  Its filename was
     asic3-remove-children-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asic3: remove children platform data
From: Samuel Ortiz <sameo@openedhand.com>

Platform devices should be dynamically allocated, and each supported
device should have its own platform data.  For now we just remove this
buggy code.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c       |    8 --------
 include/linux/mfd/asic3.h |    3 ---
 2 files changed, 11 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-remove-children-platform-data drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-remove-children-platform-data
+++ a/drivers/mfd/asic3.c
@@ -607,14 +607,6 @@ static int asic3_probe(struct platform_d
 		goto out_irq;
 	}
 
-	if (pdata->children) {
-		int i;
-		for (i = 0; i < pdata->n_children; i++) {
-			pdata->children[i]->dev.parent = &pdev->dev;
-			platform_device_register(pdata->children[i]);
-		}
-	}
-
 	printk(KERN_INFO "ASIC3 Core driver\n");
 
 	return 0;
diff -puN include/linux/mfd/asic3.h~asic3-remove-children-platform-data include/linux/mfd/asic3.h
--- a/include/linux/mfd/asic3.h~asic3-remove-children-platform-data
+++ a/include/linux/mfd/asic3.h
@@ -32,9 +32,6 @@ struct asic3_platform_data {
 	unsigned int irq_base;
 
 	unsigned int gpio_base;
