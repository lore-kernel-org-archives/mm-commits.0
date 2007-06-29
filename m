From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:29 -0700
Message-ID: <200706292041.l5TKfTOT022578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbXF2Uut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Use mutex instead of semaphore in the MTD ST M25Pxx driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use mutex instead of semaphore in the MTD ST M25Pxx driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The MTD ST M25Pxx driver uses a semaphore as mutex.  Use the mutex API instead
of the (binary) semaphore.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver
+++ a/drivers/mtd/devices/m25p80.c
@@ -24,8 +24,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 
 /* NOTE: AT 25F and SST 25LF series are very similar,
@@ -65,7 +64,7 @@
 
 struct m25p {
 	struct spi_device	*spi;
-	struct semaphore	lock;
+	struct mutex		lock;
 	struct mtd_info		mtd;
 	unsigned		partitioned;
 	u8			command[4];
@@ -201,13 +200,13 @@ static int m25p80_erase(struct mtd_info 
 	addr = instr->addr;
 	len = instr->len;
 
-  	down(&flash->lock);
+	mutex_lock(&flash->lock);
 
 	/* now erase those sectors */
 	while (len) {
 		if (erase_sector(flash, addr)) {
 			instr->state = MTD_ERASE_FAILED;
-			up(&flash->lock);
+			mutex_unlock(&flash->lock);
 			return -EIO;
 		}
 
@@ -215,7 +214,7 @@ static int m25p80_erase(struct mtd_info 
 		len -= mtd->erasesize;
 	}
 
-  	up(&flash->lock);
+	mutex_unlock(&flash->lock);
 
 	instr->state = MTD_ERASE_DONE;
 	mtd_erase_callback(instr);
@@ -260,12 +259,12 @@ static int m25p80_read(struct mtd_info *
 	if (retlen)
 		*retlen = 0;
 
-	down(&flash->lock);
+	mutex_lock(&flash->lock);
 
 	/* Wait till previous write/erase is done. */
 	if (wait_till_ready(flash)) {
 		/* REVISIT status return?? */
-		up(&flash->lock);
+		mutex_unlock(&flash->lock);
 		return 1;
 	}
 
@@ -281,7 +280,7 @@ static int m25p80_read(struct mtd_info *
 
 	*retlen = m.actual_length - sizeof(flash->command);
 
-  	up(&flash->lock);
+	mutex_unlock(&flash->lock);
 
 	return 0;
 }
@@ -323,7 +322,7 @@ static int m25p80_write(struct mtd_info 
 	t[1].tx_buf = buf;
 	spi_message_add_tail(&t[1], &m);
 
-  	down(&flash->lock);
+	mutex_lock(&flash->lock);
 
 	/* Wait until finished previous write command. */
 	if (wait_till_ready(flash))
@@ -384,7 +383,7 @@ static int m25p80_write(struct mtd_info 
 	        }
  	}
 
-	up(&flash->lock);
+	mutex_unlock(&flash->lock);
 
 	return 0;
 }
@@ -456,7 +455,7 @@ static int __devinit m25p_probe(struct s
 		return -ENOMEM;
 
 	flash->spi = spi;
-	init_MUTEX(&flash->lock);
+	mutex_init(&flash->lock);
 	dev_set_drvdata(&spi->dev, flash);
 
 	if (data->name)
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
