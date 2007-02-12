From: akpm@linux-foundation.org
Subject: - spi-add-spi_set_drvdata-and-spi_get_drvdata.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:41 -0800
Message-ID: <200702122244.l1CMifZJ013627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030276AbXBLWox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: add spi_set_drvdata() and spi_get_drvdata()
has been removed from the -mm tree.  Its filename was
     spi-add-spi_set_drvdata-and-spi_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: add spi_set_drvdata() and spi_get_drvdata()
From: Ben Dooks <ben@fluff.org>

Add wrappers for getting and setting the driver data using spi_device
instead of using dev_{get|set}_drvdata with &spi->dev, to mirror the
platform_{get|set}_drvdata.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |    2 +-
 include/linux/spi/spi.h       |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-add-spi_set_drvdata-and-spi_get_drvdata Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-add-spi_set_drvdata-and-spi_get_drvdata
+++ a/Documentation/spi/spi-summary
@@ -312,7 +312,7 @@ might look like this unless you're creat
 		chip = kzalloc(sizeof *chip, GFP_KERNEL);
 		if (!chip)
 			return -ENOMEM;
-		dev_set_drvdata(&spi->dev, chip);
+		spi_set_drvdata(spi, chip);
 
 		... etc
 		return 0;
diff -puN include/linux/spi/spi.h~spi-add-spi_set_drvdata-and-spi_get_drvdata include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-add-spi_set_drvdata-and-spi_get_drvdata
+++ a/include/linux/spi/spi.h
@@ -114,6 +114,17 @@ static inline void spi_set_ctldata(struc
 	spi->controller_state = state;
 }
 
+/* device driver data */
+
+static inline void spi_set_drvdata(struct spi_device *spi, void *data)
+{
+	dev_set_drvdata(&spi->dev, data);
+}
+
+static inline void *spi_get_drvdata(struct spi_device *spi)
+{
+	return dev_get_drvdata(&spi->dev);
+}
 
 struct spi_message;
 
_

Patches currently in -mm which might be from ben@fluff.org are

origin.patch
