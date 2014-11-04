From: akpm@linux-foundation.org
Subject: + fs-affs-filec-adding-support-to-o_direct.patch added to -mm
 tree
Date: Tue, 04 Nov 2014 15:23:27 -0800
Message-ID: <54595fef.LUSJUFIwRDabubQq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKDXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: add support to O_DIRECT
has been added to the -mm tree.  Its filename is
     fs-affs-filec-adding-support-to-o_direct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-adding-support-to-o_direct.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-adding-support-to-o_direct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
kernel-add-panic_on_warn.patch
kernel-add-panic_on_warn-v7.patch
fs-affs-filec-forward-declaration-clean-up.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
fs-affs-filec-adding-support-to-o_direct.patch
linux-next.patch

