From: akpm@linux-foundation.org
Subject: [merged] spidev-add-proper-section-markers.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:24 -0800
Message-ID: <200912182027.nBIKROMq016631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802AbZLRU1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spidev: add proper section markers
has been removed from the -mm tree.  Its filename was
     spidev-add-proper-section-markers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spidev: add proper section markers
From: Mike Frysinger <vapier@gentoo.org>

The driver already uses __devexit_p() in the structure, but looks like
actual __dev{init,exit} markings were forgotten.

The spidev_spi driver also needs renaming to include a "_driver" suffix to
avoid section mismatch warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spidev.c~spidev-add-proper-section-markers drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-add-proper-section-markers
+++ a/drivers/spi/spidev.c
@@ -558,7 +558,7 @@ static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
-static int spidev_probe(struct spi_device *spi)
+static int __devinit spidev_probe(struct spi_device *spi)
 {
 	struct spidev_data	*spidev;
 	int			status;
@@ -607,7 +607,7 @@ static int spidev_probe(struct spi_devic
 	return status;
 }
 
-static int spidev_remove(struct spi_device *spi)
+static int __devexit spidev_remove(struct spi_device *spi)
 {
 	struct spidev_data	*spidev = spi_get_drvdata(spi);
 
@@ -629,7 +629,7 @@ static int spidev_remove(struct spi_devi
 	return 0;
 }
 
-static struct spi_driver spidev_spi = {
+static struct spi_driver spidev_spi_driver = {
 	.driver = {
 		.name =		"spidev",
 		.owner =	THIS_MODULE,
@@ -661,14 +661,14 @@ static int __init spidev_init(void)
 
 	spidev_class = class_create(THIS_MODULE, "spidev");
 	if (IS_ERR(spidev_class)) {
-		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 		return PTR_ERR(spidev_class);
 	}
 
-	status = spi_register_driver(&spidev_spi);
+	status = spi_register_driver(&spidev_spi_driver);
 	if (status < 0) {
 		class_destroy(spidev_class);
-		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 	}
 	return status;
 }
@@ -676,9 +676,9 @@ module_init(spidev_init);
 
 static void __exit spidev_exit(void)
 {
-	spi_unregister_driver(&spidev_spi);
+	spi_unregister_driver(&spidev_spi_driver);
 	class_destroy(spidev_class);
-	unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+	unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 }
 module_exit(spidev_exit);
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch

