From: akpm@linux-foundation.org
Subject: - usbmon-use-simple_read_from_buffer.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:33 -0700
Message-ID: <200806232102.m5NL2Xfc016085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959AbYFWVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, greg@kroah.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usbmon: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     usbmon-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbmon: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_stat.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/usb/mon/mon_stat.c~usbmon-use-simple_read_from_buffer drivers/usb/mon/mon_stat.c
--- a/drivers/usb/mon/mon_stat.c~usbmon-use-simple_read_from_buffer
+++ a/drivers/usb/mon/mon_stat.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/usb.h>
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 
 #include "usb_mon.h"
@@ -42,19 +43,8 @@ static ssize_t mon_stat_read(struct file
 				size_t nbytes, loff_t *ppos)
 {
 	struct snap *sp = file->private_data;
-	loff_t pos = *ppos;
-	int cnt;
 
-	if (pos < 0 || pos >= sp->slen)
-		return 0;
-	if (nbytes == 0)
-		return 0;
-	if ((cnt = sp->slen - pos) > nbytes)
-		cnt = nbytes;
-	if (copy_to_user(buf, sp->str + pos, cnt))
-		return -EFAULT;
-	*ppos = pos + cnt;
-	return cnt;
+	return simple_read_from_buffer(buf, nbytes, ppos, sp->str, sp->slen);
 }
 
 static int mon_stat_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ttusb-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

