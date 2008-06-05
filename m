From: akpm@linux-foundation.org
Subject: + usbmon-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:45 -0700
Message-ID: <200806050029.m550Tj4S016942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099AbYFEAaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     usbmon: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     usbmon-use-simple_read_from_buffer.patch

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

