From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:31 -0700
Message-ID: <200706292041.l5TKfV9n022581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbXF2Uut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Use mutex instead of semaphore in the MTD DataFlash driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 9 insertions(+), 8 deletions(-)

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
git-mtd.patch
git-netdev-all.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
