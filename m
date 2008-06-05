From: akpm@linux-foundation.org
Subject: + isdn-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:36 -0700
Message-ID: <200806050029.m550Tab1016927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYFEA3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, kkeil@suse.de


The patch titled
     isdn: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     isdn-use-simple_read_from_buffer.patch

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

