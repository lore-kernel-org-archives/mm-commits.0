From: akpm@linux-foundation.org
Subject: - libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:30 -0700
Message-ID: <200810152113.m9FLDUQt005576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbYJOVOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, cooloney@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: blackfin Pata Driver: Add proper PM operation into ATAPI driver
has been removed from the -mm tree.  Its filename was
     libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: blackfin Pata Driver: Add proper PM operation into ATAPI driver
From: Sonic Zhang <sonic.zhang@analog.com>

[akpm@linux-foundation.org: remove ifdefs, make things static]
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_bf54x.c |   34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff -puN drivers/ata/pata_bf54x.c~libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver drivers/ata/pata_bf54x.c
--- a/drivers/ata/pata_bf54x.c~libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver
+++ a/drivers/ata/pata_bf54x.c
@@ -1632,6 +1632,8 @@ static int __devinit bfin_atapi_probe(st
 		return -ENODEV;
 	}
 
+	dev_set_drvdata(&pdev->dev, host);
+
 	return 0;
 }
 
@@ -1648,6 +1650,7 @@ static int __devexit bfin_atapi_remove(s
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
+	dev_set_drvdata(&pdev->dev, NULL);
 
 	peripheral_free_list(atapi_io_port);
 
@@ -1655,27 +1658,44 @@ static int __devexit bfin_atapi_remove(s
 }
 
 #ifdef CONFIG_PM
-int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	return 0;
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	if (host)
+		return ata_host_suspend(host, state);
+	else
+		return 0;
 }
 
-int bfin_atapi_resume(struct platform_device *pdev)
+static int bfin_atapi_resume(struct platform_device *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (host) {
+		ret = bfin_reset_controller(host);
+		if (ret) {
+			printk(KERN_ERR DRV_NAME ": Error during HW init\n");
+			return ret;
+		}
+		ata_host_resume(host);
+	}
+
 	return 0;
 }
+#else
+#define bfin_atapi_suspend NULL
+#define bfin_atapi_resume NULL
 #endif
 
 static struct platform_driver bfin_atapi_driver = {
 	.probe			= bfin_atapi_probe,
 	.remove			= __devexit_p(bfin_atapi_remove),
+	.suspend		= bfin_atapi_suspend,
+	.resume			= bfin_atapi_resume,
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
-		.suspend	= bfin_atapi_suspend,
-		.resume		= bfin_atapi_resume,
-#endif
 	},
 };
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch

