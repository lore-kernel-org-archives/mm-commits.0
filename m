From: akpm@linux-foundation.org
Subject: - ttusb-use-simple_read_from_buffer.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:23 -0700
Message-ID: <200807141935.m6EJZNfQ023909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755108AbYGNTgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adq_dvb@lidskialf.net, js@linuxtv.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ttusb: use simple_read_from_buffer()()
has been removed from the -mm tree.  Its filename was
     ttusb-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/delay.h>
@@ -990,22 +991,9 @@ static int stc_open(struct inode *inode,
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
