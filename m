From: akpm@osdl.org
Subject: + spi-cleanup-method-param-becomes-non-const.patch added to -mm tree
Date: Thu, 25 Jan 2007 20:42:39 -0800
Message-ID: <200701260442.l0Q4gda0007568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030647AbXAZEmv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 23:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-peter.nilsson@axis.com, dbrownell@users.sourceforge.net, hp@axis.com


The patch titled
     SPI cleanup() method param becomes non-const
has been added to the -mm tree.  Its filename is
     spi-cleanup-method-param-becomes-non-const.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI cleanup() method param becomes non-const
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>

I'd like to assign NULL to kfree()d members of a structure.  I can't do
that without ugly casting (see the PXA patch) when the structure pointed to
is const-qualified.  I don't really see a reason why the cleanup method
isn't allowed to alter the object it should clean up.  :-)

No, I didn't test the PXA patch, but I verified that the NULL-assignment
doesn't stop me from doing rmmod/insmodding my own spi_bitbang-based
driver.

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/pxa2xx_spi.c        |    4 ++--
 drivers/spi/spi.c               |    2 +-
 drivers/spi/spi_bitbang.c       |    2 +-
 include/linux/spi/spi.h         |    2 +-
 include/linux/spi/spi_bitbang.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-cleanup-method-param-becomes-non-const drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-cleanup-method-param-becomes-non-const
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1214,9 +1214,9 @@ static int setup(struct spi_device *spi)
 	return 0;
 }
 
-static void cleanup(const struct spi_device *spi)
+static void cleanup(struct spi_device *spi)
 {
-	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
+	struct chip_data *chip = spi_get_ctldata(spi);
 
 	kfree(chip);
 }
diff -puN drivers/spi/spi_bitbang.c~spi-cleanup-method-param-becomes-non-const drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-cleanup-method-param-becomes-non-const
+++ a/drivers/spi/spi_bitbang.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL_GPL(spi_bitbang_setup);
 /**
  * spi_bitbang_cleanup - default cleanup for per-word I/O loops
  */
-void spi_bitbang_cleanup(const struct spi_device *spi)
+void spi_bitbang_cleanup(struct spi_device *spi)
 {
 	kfree(spi->controller_state);
 }
diff -puN drivers/spi/spi.c~spi-cleanup-method-param-becomes-non-const drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-cleanup-method-param-becomes-non-const
+++ a/drivers/spi/spi.c
@@ -32,7 +32,7 @@
  */
 static void spidev_release(struct device *dev)
 {
-	const struct spi_device	*spi = to_spi_device(dev);
+	struct spi_device	*spi = to_spi_device(dev);
 
 	/* spi masters may cleanup for released devices */
 	if (spi->master->cleanup)
diff -puN include/linux/spi/spi_bitbang.h~spi-cleanup-method-param-becomes-non-const include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi-cleanup-method-param-becomes-non-const
+++ a/include/linux/spi/spi_bitbang.h
@@ -55,7 +55,7 @@ struct spi_bitbang {
  * methods, if you like.
  */
 extern int spi_bitbang_setup(struct spi_device *spi);
-extern void spi_bitbang_cleanup(const struct spi_device *spi);
+extern void spi_bitbang_cleanup(struct spi_device *spi);
 extern int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m);
 extern int spi_bitbang_setup_transfer(struct spi_device *spi,
 				      struct spi_transfer *t);
diff -puN include/linux/spi/spi.h~spi-cleanup-method-param-becomes-non-const include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-cleanup-method-param-becomes-non-const
+++ a/include/linux/spi/spi.h
@@ -220,7 +220,7 @@ struct spi_master {
 						struct spi_message *mesg);
 
 	/* called on release() to free memory provided by spi_master */
-	void			(*cleanup)(const struct spi_device *spi);
+	void			(*cleanup)(struct spi_device *spi);
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
_

Patches currently in -mm which might be from hans-peter.nilsson@axis.com are

spi_bitbang-use-overridable-setup_transfer-method.patch
spi-cleanup-method-param-becomes-non-const.patch
