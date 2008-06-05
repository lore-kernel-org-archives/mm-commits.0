From: akpm@linux-foundation.org
Subject: + binfmt_misc-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:29 -0700
Message-ID: <200806050029.m550TTdP016918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYFEA3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     binfmt_misc: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     binfmt_misc-use-simple_read_from_buffer.patch

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
Subject: binfmt_misc: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-use-simple_read_from_buffer fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-use-simple_read_from_buffer
+++ a/fs/binfmt_misc.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/syscalls.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 
@@ -535,31 +536,16 @@ static ssize_t
 bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
 {
 	Node *e = file->f_path.dentry->d_inode->i_private;
-	loff_t pos = *ppos;
 	ssize_t res;
 	char *page;
-	int len;
 
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
 	entry_status(e, page);
-	len = strlen(page);
 
-	res = -EINVAL;
-	if (pos < 0)
-		goto out;
-	res = 0;
-	if (pos >= len)
-		goto out;
-	if (len < pos + nbytes)
-		nbytes = len - pos;
-	res = -EFAULT;
-	if (copy_to_user(buf, page + pos, nbytes))
-		goto out;
-	*ppos = pos + nbytes;
-	res = nbytes;
-out:
+	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
+
 	free_page((unsigned long) page);
 	return res;
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

