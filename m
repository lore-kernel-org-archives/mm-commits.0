From: akpm@linux-foundation.org
Subject: + spidev-add-proper-section-markers.patch added to -mm tree
Date: Mon, 02 Nov 2009 13:41:44 -0800
Message-ID: <200911022141.nA2Lfi7c004122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbZKBVlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 16:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, david-b@pacbell.net


The patch titled
     spidev: add proper section markers
has been added to the -mm tree.  Its filename is
     spidev-add-proper-section-markers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN drivers/spi/spidev.c~spidev-add-proper-section-markers drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-add-proper-section-markers
+++ a/drivers/spi/spidev.c
@@ -561,7 +561,7 @@ static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
-static int spidev_probe(struct spi_device *spi)
+static int __devinit spidev_probe(struct spi_device *spi)
 {
 	struct spidev_data	*spidev;
 	int			status;
@@ -610,7 +610,7 @@ static int spidev_probe(struct spi_devic
 	return status;
 }
 
-static int spidev_remove(struct spi_device *spi)
+static int __devexit spidev_remove(struct spi_device *spi)
 {
 	struct spidev_data	*spidev = spi_get_drvdata(spi);
 
@@ -632,7 +632,7 @@ static int spidev_remove(struct spi_devi
 	return 0;
 }
 
-static struct spi_driver spidev_spi = {
+static struct spi_driver spidev_spi_driver = {
 	.driver = {
 		.name =		"spidev",
 		.owner =	THIS_MODULE,
@@ -664,14 +664,14 @@ static int __init spidev_init(void)
 
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
@@ -679,9 +679,9 @@ module_init(spidev_init);
 
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

origin.patch
linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
firmware-only-allow-edd-on-x86.patch
spidev-add-proper-section-markers.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

