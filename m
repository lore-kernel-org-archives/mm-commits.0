From: akpm@linux-foundation.org
Subject: - isdn-use-simple_read_from_buffer.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:00 -0700
Message-ID: <200806122037.m5CKb01N005389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755792AbYFLUhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     isdn-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_procconf.c |   27 ++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN drivers/isdn/hysdn/hysdn_procconf.c~isdn-use-simple_read_from_buffer drivers/isdn/hysdn/hysdn_procconf.c
--- a/drivers/isdn/hysdn/hysdn_procconf.c~isdn-use-simple_read_from_buffer
+++ a/drivers/isdn/hysdn/hysdn_procconf.c
@@ -207,30 +207,17 @@ hysdn_conf_write(struct file *file, cons
 /* read conf file -> output card info data */
 /*******************************************/
 static ssize_t
-hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t * off)
+hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 {
 	char *cp;
-	int i;
 
-	if (file->f_mode & FMODE_READ) {
-		if (!(cp = file->private_data))
-			return (-EFAULT);	/* should never happen */
-		i = strlen(cp);	/* get total string length */
-		if (*off < i) {
-			/* still bytes to transfer */
-			cp += *off;	/* point to desired data offset */
-			i -= *off;	/* remaining length */
-			if (i > count)
-				i = count;	/* limit length to transfer */
-			if (copy_to_user(buf, cp, i))
-				return (-EFAULT);	/* copy error */
-			*off += i;	/* adjust offset */
-		} else
-			return (0);
-	} else
-		return (-EPERM);	/* no permission to read */
+	if (!(file->f_mode & FMODE_READ))
+		return -EPERM;	/* no permission to read */
 
-	return (i);
+	if (!(cp = file->private_data))
+		return -EFAULT;	/* should never happen */
+
+	return simple_read_from_buffer(buf, count, off, cp, strlen(cp));
 }				/* hysdn_conf_read */
 
 /******************/
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ttusb-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

