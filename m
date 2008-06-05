From: akpm@linux-foundation.org
Subject: + ttusb-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:47 -0700
Message-ID: <200806050029.m550Tl01016945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbYFEAau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adq_dvb@lidskialf.net, js@linuxtv.org, mchehab@infradead.org


The patch titled
     ttusb: use simple_read_from_buffer()()
has been added to the -mm tree.  Its filename is
     ttusb-use-simple_read_from_buffer.patch

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
Subject: ttusb: use simple_read_from_buffer()()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: Johannes Stezenbach <js@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   18 ++----------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~ttusb-use-simple_read_from_buffer drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~ttusb-use-simple_read_from_buffer
+++ a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 
 #include "dvb_frontend.h"
 #include "dmxdev.h"
@@ -983,22 +984,9 @@ static int stc_open(struct inode *inode,
 }
 
 static ssize_t stc_read(struct file *file, char *buf, size_t count,
-		 loff_t * offset)
+		 loff_t *offset)
 {
-	int tc = count;
-
-	if ((tc + *offset) > 8192)
-		tc = 8192 - *offset;
-
-	if (tc < 0)
-		return 0;
-
-	if (copy_to_user(buf, stc_firmware + *offset, tc))
-		return -EFAULT;
-
-	*offset += tc;
-
-	return tc;
+	return simple_read_from_buffer(buf, count, offset, stc_firmware, 8192);
 }
 
 static int stc_release(struct inode *inode, struct file *file)
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

