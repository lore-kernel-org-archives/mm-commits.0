From: akpm@linux-foundation.org
Subject: - s390-use-simple_read_from_buffer.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:26 -0700
Message-ID: <200807112351.m6BNpQNA011040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbYGKXxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     s390-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
ttusb-use-simple_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

