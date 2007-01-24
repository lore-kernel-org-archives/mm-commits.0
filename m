From: akpm@osdl.org
Subject: + spi-add-spi_set_drvdata-and-spi_get_drvdata.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:12:38 -0800
Message-ID: <200701240012.l0O0CclX003397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbXAXAMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: add spi_set_drvdata() and spi_get_drvdata()
has been added to the -mm tree.  Its filename is
     spi-add-spi_set_drvdata-and-spi_get_drvdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: add spi_set_drvdata() and spi_get_drvdata()
From: Ben Dooks <ben@fluff.org>

Add wrappers for getting and setting the driver data using spi_device
instead of using dev_{get|set}_drvdata with &spi->dev, to mirror the
platform_{get|set}_drvdata.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
