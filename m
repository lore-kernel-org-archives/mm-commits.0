From: akpm@linux-foundation.org
Subject: [merged] mtd-plat_nand-add-platform-probe-remove-callbacks.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:11:55 -0700
Message-ID: <200906091811.n59IBtaf018219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758642AbZFISMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hsweeten@visionengravers.com, alex@digriz.org.uk, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: plat_nand: add platform probe/remove callbacks
has been removed from the -mm tree.  Its filename was
     mtd-plat_nand-add-platform-probe-remove-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: plat_nand: add platform probe/remove callbacks
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Add optional probe and remove callbacks to the plat_nand driver.

Some platforms may require additional setup, such as configuring the
memory controller, before the nand device can be accessed.  This patch
provides an optional callback to handle this setup as well as a callback
to teardown the setup.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Tested-by: Alexander Clouter <alex@digriz.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/plat_nand.c |   13 +++++++++++--
 include/linux/mtd/nand.h     |    7 +++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/nand/plat_nand.c~mtd-plat_nand-add-platform-probe-remove-callbacks drivers/mtd/nand/plat_nand.c
--- a/drivers/mtd/nand/plat_nand.c~mtd-plat_nand-add-platform-probe-remove-callbacks
+++ a/drivers/mtd/nand/plat_nand.c
@@ -70,6 +70,13 @@ static int __devinit plat_nand_probe(str
 
 	platform_set_drvdata(pdev, data);
 
+	/* Handle any platform specific setup */
+	if (pdata->ctrl.probe) {
+		res = pdata->ctrl.probe(pdev);
+		if (res)
+			goto out;
+	}
+
 	/* Scan to find existance of the device */
 	if (nand_scan(&data->mtd, 1)) {
 		res = -ENXIO;
@@ -99,6 +106,8 @@ static int __devinit plat_nand_probe(str
 
 	nand_release(&data->mtd);
 out:
+	if (pdata->ctrl.remove)
+		pdata->ctrl.remove(pdev);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(data->io_base);
 	kfree(data);
@@ -111,15 +120,15 @@ out:
 static int __devexit plat_nand_remove(struct platform_device *pdev)
 {
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
-#ifdef CONFIG_MTD_PARTITIONS
 	struct platform_nand_data *pdata = pdev->dev.platform_data;
-#endif
 
 	nand_release(&data->mtd);
 #ifdef CONFIG_MTD_PARTITIONS
 	if (data->parts && data->parts != pdata->chip.partitions)
 		kfree(data->parts);
 #endif
+	if (pdata->ctrl.remove)
+		pdata->ctrl.remove(pdev);
 	iounmap(data->io_base);
 	kfree(data);
 
diff -puN include/linux/mtd/nand.h~mtd-plat_nand-add-platform-probe-remove-callbacks include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~mtd-plat_nand-add-platform-probe-remove-callbacks
+++ a/include/linux/mtd/nand.h
@@ -577,8 +577,13 @@ struct platform_nand_chip {
 	void			*priv;
 };
 
+/* Keep gcc happy */
+struct platform_device;
+
 /**
  * struct platform_nand_ctrl - controller level device structure
+ * @probe:		platform specific function to probe/setup hardware
+ * @remove:		platform specific function to remove/teardown hardware
  * @hwcontrol:		platform specific hardware control structure
  * @dev_ready:		platform specific function to read ready/busy pin
  * @select_chip:	platform specific chip select function
@@ -589,6 +594,8 @@ struct platform_nand_chip {
  * All fields are optional and depend on the hardware driver requirements
  */
 struct platform_nand_ctrl {
+	int		(*probe)(struct platform_device *pdev);
+	void		(*remove)(struct platform_device *pdev);
 	void		(*hwcontrol)(struct mtd_info *mtd, int cmd);
 	int		(*dev_ready)(struct mtd_info *mtd);
 	void		(*select_chip)(struct mtd_info *mtd, int chip);
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

linux-next.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

