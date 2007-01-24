From: akpm@osdl.org
Subject: + spi-remove-return-in-spi_unregister_driver.patch added to -mm tree
Date: Tue, 23 Jan 2007 17:08:53 -0800
Message-ID: <200701240108.l0O18rOB004622@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129AbXAXBJG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 20:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: remove return in spi_unregister_driver()
has been added to the -mm tree.  Its filename is
     spi-remove-return-in-spi_unregister_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: remove return in spi_unregister_driver()
From: Ben Dooks <ben@fluff.org>

Make the spi_unregister_driver() code fit in with the rest of the header
file, and only do the action if the driver passed is non-NULL.

This also makes the code a line smaller.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/spi/spi.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/spi/spi.h~spi-remove-return-in-spi_unregister_driver include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-remove-return-in-spi_unregister_driver
+++ a/include/linux/spi/spi.h
@@ -148,13 +148,11 @@ extern int spi_register_driver(struct sp
 
 static inline void spi_unregister_driver(struct spi_driver *sdrv)
 {
-	if (!sdrv)
-		return;
-	driver_unregister(&sdrv->driver);
+	if (sdrv)
+		driver_unregister(&sdrv->driver);
 }
 
 
-
 /**
  * struct spi_master - interface to SPI master controller
  * @cdev: class interface to this driver
_

Patches currently in -mm which might be from ben@fluff.org are

spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
spi-remove-return-in-spi_unregister_driver.patch
