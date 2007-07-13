From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-spi-core-init-code.patch added to -mm tree
Date: Fri, 13 Jul 2007 13:45:34 -0700
Message-ID: <200707132045.l6DKjY6e018794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757512AbXGMUqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 16:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, david-b@pacbell.net


The patch titled
     use mutex instead of semaphore in SPI core/init code
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-spi-core-init-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in SPI core/init code
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The SPI core/init code uses a semaphore as mutex.  Use the mutex API instead
of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi.c~use-mutex-instead-of-semaphore-in-spi-core-init-code drivers/spi/spi.c
--- a/drivers/spi/spi.c~use-mutex-instead-of-semaphore-in-spi-core-init-code
+++ a/drivers/spi/spi.c
@@ -23,6 +23,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/cache.h>
+#include <linux/mutex.h>
 #include <linux/spi/spi.h>
 
 
@@ -185,7 +186,7 @@ struct boardinfo {
 };
 
 static LIST_HEAD(board_list);
-static DECLARE_MUTEX(board_lock);
+static DEFINE_MUTEX(board_lock);
 
 
 /**
@@ -292,9 +293,9 @@ spi_register_board_info(struct spi_board
 	bi->n_board_info = n;
 	memcpy(bi->board_info, info, n * sizeof *info);
 
-	down(&board_lock);
+	mutex_lock(&board_lock);
 	list_add_tail(&bi->list, &board_list);
-	up(&board_lock);
+	mutex_unlock(&board_lock);
 	return 0;
 }
 
@@ -308,7 +309,7 @@ scan_boardinfo(struct spi_master *master
 	struct boardinfo	*bi;
 	struct device		*dev = master->cdev.dev;
 
-	down(&board_lock);
+	mutex_lock(&board_lock);
 	list_for_each_entry(bi, &board_list, list) {
 		struct spi_board_info	*chip = bi->board_info;
 		unsigned		n;
@@ -330,7 +331,7 @@ scan_boardinfo(struct spi_master *master
 			(void) spi_new_device(master, chip);
 		}
 	}
-	up(&board_lock);
+	mutex_unlock(&board_lock);
 }
 
 /*-------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
git-net.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
git-block.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
