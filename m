From: akpm@linux-foundation.org
Subject: + s390-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:40 -0700
Message-ID: <200806050029.m550Tel1016936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756108AbYFEAac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     s390-use-simple_read_from_buffer.patch

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
Subject: s390: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/hypfs/inode.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff -puN arch/s390/hypfs/inode.c~s390-use-simple_read_from_buffer arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~s390-use-simple_read_from_buffer
+++ a/arch/s390/hypfs/inode.c
@@ -150,33 +150,24 @@ static ssize_t hypfs_aio_read(struct kio
 			      unsigned long nr_segs, loff_t offset)
 {
 	char *data;
-	size_t len;
+	ssize_t ret;
 	struct file *filp = iocb->ki_filp;
 	/* XXX: temporary */
 	char __user *buf = iov[0].iov_base;
 	size_t count = iov[0].iov_len;
 
-	if (nr_segs != 1) {
-		count = -EINVAL;
-		goto out;
-	}
+	if (nr_segs != 1)
+		return -EINVAL;
 
 	data = filp->private_data;
-	len = strlen(data);
-	if (offset > len) {
-		count = 0;
-		goto out;
-	}
-	if (count > len - offset)
-		count = len - offset;
-	if (copy_to_user(buf, data + offset, count)) {
-		count = -EFAULT;
-		goto out;
-	}
-	iocb->ki_pos += count;
+	ret = simple_read_from_buffer(buf, count, &offset, data, strlen(data));
+	if (ret <= 0)
+		return ret;
+
+	iocb->ki_pos += ret;
 	file_accessed(filp);
-out:
-	return count;
+
+	return ret;
 }
 static ssize_t hypfs_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			      unsigned long nr_segs, loff_t offset)
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

