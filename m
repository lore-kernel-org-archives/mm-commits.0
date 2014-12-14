From: akpm@linux-foundation.org
Subject: [merged] fs-affs-filec-adding-support-to-o_direct.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:09:45 -0800
Message-ID: <548d0d89.dzWzwpB/fNw2pyQY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaLNEJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: add support to O_DIRECT
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-adding-support-to-o_direct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: add support to O_DIRECT

Based on ext2_direct_IO

Tested with O_DIRECT file open and sysbench/mariadb with 1% written
queries improvement (update_non_index test) on a volume created with
mkaffs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN fs/affs/file.c~fs-affs-filec-adding-support-to-o_direct fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-adding-support-to-o_direct
+++ a/fs/affs/file.c
@@ -12,6 +12,7 @@
  *  affs regular file handling primitives
  */
 
+#include <linux/aio.h>
 #include "affs.h"
 
 #if PAGE_SIZE < 4096
@@ -392,6 +393,22 @@ static void affs_write_failed(struct add
 	}
 }
 
+static ssize_t
+affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+	       loff_t offset)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	size_t count = iov_iter_count(iter);
+	ssize_t ret;
+
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
+	if (ret < 0 && (rw & WRITE))
+		affs_write_failed(mapping, offset + count);
+	return ret;
+}
+
 static int affs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -418,6 +435,7 @@ const struct address_space_operations af
 	.writepage = affs_writepage,
 	.write_begin = affs_write_begin,
 	.write_end = generic_write_end,
+	.direct_IO = affs_direct_IO,
 	.bmap = _affs_bmap
 };
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

