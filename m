From: akpm@linux-foundation.org
Subject: + dax-move-dax-related-functions-to-a-new-header.patch added to
 -mm tree
Date: Mon, 13 Jul 2015 14:31:57 -0700
Message-ID: <55a42e4d.428vnJygT/sEtDVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbGMVb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: Move DAX-related functions to a new header
has been added to the -mm tree.  Its filename is
     dax-move-dax-related-functions-to-a-new-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-move-dax-related-functions-to-a-new-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-move-dax-related-functions-to-a-new-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: Move DAX-related functions to a new header

In order to handle the !CONFIG_TRANSPARENT_HUGEPAGES case, we need to
return VM_FAULT_FALLBACK from the inlined dax_pmd_fault(), which is
defined in linux/mm.h.  Given that we don't want to include <linux/mm.h>
in <linux/fs.h>, the easiest solution is to move the DAX-related functions
to a new header, <linux/dax.h>.  We could also have moved VM_FAULT_*
definitions to a new header, or a different header that isn't quite such a
boil-the-ocean header as <linux/mm.h>, but this felt like the best option.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c      |    1 +
 fs/ext2/file.c      |    1 +
 fs/ext2/inode.c     |    1 +
 fs/ext4/file.c      |    1 +
 fs/ext4/indirect.c  |    1 +
 fs/ext4/inode.c     |    1 +
 fs/xfs/xfs_buf.h    |    1 +
 include/linux/dax.h |   21 +++++++++++++++++++++
 include/linux/fs.h  |   14 --------------
 9 files changed, 28 insertions(+), 14 deletions(-)

diff -puN fs/block_dev.c~dax-move-dax-related-functions-to-a-new-header fs/block_dev.c
--- a/fs/block_dev.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/block_dev.c
@@ -28,6 +28,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/dax.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN fs/ext2/file.c~dax-move-dax-related-functions-to-a-new-header fs/ext2/file.c
--- a/fs/ext2/file.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/ext2/file.c
@@ -20,6 +20,7 @@
 
 #include <linux/time.h>
 #include <linux/pagemap.h>
+#include <linux/dax.h>
 #include <linux/quotaops.h>
 #include "ext2.h"
 #include "xattr.h"
diff -puN fs/ext2/inode.c~dax-move-dax-related-functions-to-a-new-header fs/ext2/inode.c
--- a/fs/ext2/inode.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/ext2/inode.c
@@ -25,6 +25,7 @@
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
+#include <linux/dax.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
diff -puN fs/ext4/file.c~dax-move-dax-related-functions-to-a-new-header fs/ext4/file.c
--- a/fs/ext4/file.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/ext4/file.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/path.h>
+#include <linux/dax.h>
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include <linux/uio.h>
diff -puN fs/ext4/indirect.c~dax-move-dax-related-functions-to-a-new-header fs/ext4/indirect.c
--- a/fs/ext4/indirect.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/ext4/indirect.c
@@ -22,6 +22,7 @@
 
 #include "ext4_jbd2.h"
 #include "truncate.h"
+#include <linux/dax.h>
 #include <linux/uio.h>
 
 #include <trace/events/ext4.h>
diff -puN fs/ext4/inode.c~dax-move-dax-related-functions-to-a-new-header fs/ext4/inode.c
--- a/fs/ext4/inode.c~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/ext4/inode.c
@@ -22,6 +22,7 @@
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
+#include <linux/dax.h>
 #include <linux/quotaops.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
diff -puN fs/xfs/xfs_buf.h~dax-move-dax-related-functions-to-a-new-header fs/xfs/xfs_buf.h
--- a/fs/xfs/xfs_buf.h~dax-move-dax-related-functions-to-a-new-header
+++ a/fs/xfs/xfs_buf.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/dax.h>
 #include <linux/buffer_head.h>
 #include <linux/uio.h>
 #include <linux/list_lru.h>
diff -puN /dev/null include/linux/dax.h
--- /dev/null
+++ a/include/linux/dax.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_DAX_H
+#define _LINUX_DAX_H
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <asm/pgtable.h>
+
+ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
+		  get_block_t, dio_iodone_t, int flags);
+int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
+int dax_truncate_page(struct inode *, loff_t from, get_block_t);
+int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
+		dax_iodone_t);
+int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
+		dax_iodone_t);
+int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
+#define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
+#define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
+
+#endif
diff -puN include/linux/fs.h~dax-move-dax-related-functions-to-a-new-header include/linux/fs.h
--- a/include/linux/fs.h~dax-move-dax-related-functions-to-a-new-header
+++ a/include/linux/fs.h
@@ -51,7 +51,6 @@ struct swap_info_struct;
 struct seq_file;
 struct workqueue_struct;
 struct iov_iter;
-struct vm_fault;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -2655,19 +2654,6 @@ extern loff_t fixed_size_llseek(struct f
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
-ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
-		  get_block_t, dio_iodone_t, int flags);
-int dax_clear_blocks(struct inode *, sector_t block, long size);
-int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
-int dax_truncate_page(struct inode *, loff_t from, get_block_t);
-int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-		dax_iodone_t);
-int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-		dax_iodone_t);
-int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
-#define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
-#define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
