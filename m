From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch added to -mm tree
Date: Mon, 14 May 2007 20:00:55 -0700
Message-ID: <200705150300.l4F30t8O032712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbXEODBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 23:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, dwmw2@infradead.org


The patch titled
     Use mutex instead of semaphore in the MTD DataFlash driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in the MTD DataFlash driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The MTD DataFlash driver uses a semaphore as mutex.  Use the mutex API instead
of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
@@ -89,7 +90,7 @@ struct dataflash {
 	unsigned short		page_offset;	/* offset in flash address */
 	unsigned int		page_size;	/* of bytes per page */
 
-	struct semaphore	lock;
+	struct mutex		lock;
 	struct spi_device	*spi;
 
 	struct mtd_info		mtd;
@@ -167,7 +168,7 @@ static int dataflash_erase(struct mtd_in
 	x.len = 4;
 	spi_message_add_tail(&x, &msg);
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 	while (instr->len > 0) {
 		unsigned int	pageaddr;
 		int		status;
@@ -210,7 +211,7 @@ static int dataflash_erase(struct mtd_in
 			instr->len -= priv->page_size;
 		}
 	}
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	/* Inform MTD subsystem that erase is complete */
 	instr->state = MTD_ERASE_DONE;
@@ -266,7 +267,7 @@ static int dataflash_read(struct mtd_inf
 	x[1].len = len;
 	spi_message_add_tail(&x[1], &msg);
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 
 	/* Continuous read, max clock = f(car) which may be less than
 	 * the peak rate available.  Some chips support commands with
@@ -279,7 +280,7 @@ static int dataflash_read(struct mtd_inf
 	/* plus 4 "don't care" bytes */
 
 	status = spi_sync(priv->spi, &msg);
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	if (status >= 0) {
 		*retlen = msg.actual_length - 8;
@@ -336,7 +337,7 @@ static int dataflash_write(struct mtd_in
 	else
 		writelen = len;
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 	while (remaining > 0) {
 		DEBUG(MTD_DEBUG_LEVEL3, "write @ %i:%i len=%i\n",
 			pageaddr, offset, writelen);
@@ -441,7 +442,7 @@ static int dataflash_write(struct mtd_in
 		else
 			writelen = remaining;
 	}
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	return status;
 }
@@ -463,7 +464,7 @@ add_dataflash(struct spi_device *spi, ch
 	if (!priv)
 		return -ENOMEM;
 
-	init_MUTEX(&priv->lock);
+	mutex_init(&priv->lock);
 	priv->spi = spi;
 	priv->page_size = pagesize;
 	priv->page_offset = pageoffset;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
use-mutex-instead-of-semaphore-in-ide-driver.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
