From: akpm@linux-foundation.org
Subject: - spi-remove-return-in-spi_unregister_driver.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:46 -0800
Message-ID: <200702122244.l1CMiki9013633@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030271AbXBLWow (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: remove return in spi_unregister_driver()
has been removed from the -mm tree.  Its filename was
     spi-remove-return-in-spi_unregister_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: remove return in spi_unregister_driver()
From: Ben Dooks <ben@fluff.org>

Make the spi_unregister_driver() code fit in with the rest of the header
file, and only do the action if the driver passed is non-NULL.

This also makes the code a line smaller.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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

origin.patch
