From: akpm@linux-foundation.org
Subject: + spi-new-orion_spi-driver-fixes.patch added to -mm tree
Date: Wed, 30 Jul 2008 01:53:42 -0700
Message-ID: <200807300853.m6U8rgt1017136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbYG3IyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 04:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shadi@marvell.com, buytenh@marvell.com, dbrownell@users.sourceforge.net, saeed@marvell.com


The patch titled
     spi: new orion_spi driver (fixes)
has been added to the -mm tree.  Its filename is
     spi-new-orion_spi-driver-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: new orion_spi driver (fixes)
From: Shadi Ammouri <shadi@marvell.com>

added cancel_work_sync to cancel the work of the device when removing it, 
and flush_workqueue on the driver's removal.
here is the patch with the modifications needed by the two comments:

Cc: Saeed Bishara <saeed@marvell.com>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/orion_spi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/spi/orion_spi.c~spi-new-orion_spi-driver-fixes drivers/spi/orion_spi.c
--- a/drivers/spi/orion_spi.c~spi-new-orion_spi-driver-fixes
+++ a/drivers/spi/orion_spi.c
@@ -138,6 +138,7 @@ orion_spi_setup_transfer(struct spi_devi
 	struct orion_spi *orion_spi;
 	unsigned int speed = spi->max_speed_hz;
 	unsigned int bits_per_word = spi->bits_per_word;
+	int	rc;
 
 	orion_spi = spi_master_get_devdata(spi->master);
 
@@ -147,13 +148,11 @@ orion_spi_setup_transfer(struct spi_devi
 	if ((t != NULL) && t->bits_per_word)
 		bits_per_word = t->bits_per_word;
 
-	if (orion_spi_baudrate_set(spi, speed) != 0)
-		return -EINVAL;
-
-	if (orion_spi_set_transfer_size(orion_spi, bits_per_word) != 0)
-		return -EINVAL;
+	rc = orion_spi_baudrate_set(spi, speed);
+	if (rc)
+		return rc;
 
-	return 0;
+	return orion_spi_set_transfer_size(orion_spi, bits_per_word);
 }
 
 static void orion_spi_set_cs(struct orion_spi *orion_spi, int enable)
@@ -530,6 +529,8 @@ static int __exit orion_spi_remove(struc
 	master = dev_get_drvdata(&pdev->dev);
 	spi = spi_master_get_devdata(master);
 
+	cancel_work_sync(&spi->work);
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, (r->end - r->start) + 1);
 
@@ -561,6 +562,7 @@ module_init(orion_spi_init);
 
 static void __exit orion_spi_exit(void)
 {
+	flush_workqueue(orion_spi_wq);
 	platform_driver_unregister(&orion_spi_driver);
 
 	destroy_workqueue(orion_spi_wq);
_

Patches currently in -mm which might be from shadi@marvell.com are

spi-new-orion_spi-driver.patch
spi-new-orion_spi-driver-fixes.patch

