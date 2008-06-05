From: akpm@linux-foundation.org
Subject: + nwflash-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:42 -0700
Message-ID: <200806050029.m550TglS016939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbYFEAaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux@arm.linux.org.uk, tim@physik3.uni-rostock.de


The patch titled
     nwflash: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     nwflash-use-simple_read_from_buffer.patch

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

lib-export-bitrev16.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
binfmt_misc-use-simple_read_from_buffer.patch
ocfs2-use-simple_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
isdn-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
introduce-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
acpi-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
zorro-use-memory_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch

