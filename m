From: akpm@linux-foundation.org
Subject: - nwflash-use-simple_read_from_buffer.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:37 -0700
Message-ID: <200807252301.m6PN1b0X003723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbYGYXGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, linux@arm.linux.org.uk, tim@physik3.uni-rostock.de, mm-commits@vger.kernel.org


The patch titled
     nwflash: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     nwflash-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nwflash: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tim Schmielau <tim@physik3.uni-rostock.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nwflash.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff -puN drivers/char/nwflash.c~nwflash-use-simple_read_from_buffer drivers/char/nwflash.c
--- a/drivers/char/nwflash.c~nwflash-use-simple_read_from_buffer
+++ a/drivers/char/nwflash.c
@@ -122,35 +122,20 @@ static int flash_ioctl(struct inode *ino
 static ssize_t flash_read(struct file *file, char __user *buf, size_t size,
 			  loff_t *ppos)
 {
-	unsigned long p = *ppos;
-	unsigned int count = size;
-	int ret = 0;
+	ssize_t ret;
 
 	if (flashdebug)
 		printk(KERN_DEBUG "flash_read: flash_read: offset=0x%lX, "
 		       "buffer=%p, count=0x%X.\n", p, buf, count);
+	/*
+	 * We now lock against reads and writes. --rmk
+	 */
+	if (mutex_lock_interruptible(&nwflash_mutex))
+		return -ERESTARTSYS;
 
-	if (count)
-		ret = -ENXIO;
+	ret = simple_read_from_buffer(buf, size, ppos, FLASH_BASE, gbFlashSize);
+	mutex_unlock(&nwflash_mutex);
 
-	if (p < gbFlashSize) {
-		if (count > gbFlashSize - p)
-			count = gbFlashSize - p;
-
-		/*
-		 * We now lock against reads and writes. --rmk
-		 */
-		if (mutex_lock_interruptible(&nwflash_mutex))
-			return -ERESTARTSYS;
-
-		ret = copy_to_user(buf, (void *)(FLASH_BASE + p), count);
-		if (ret == 0) {
-			ret = count;
-			*ppos += count;
-		} else
-			ret = -EFAULT;
-		mutex_unlock(&nwflash_mutex);
-	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

