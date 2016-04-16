From: akpm@linux-foundation.org
Subject: + dax-add-dax_get_unmapped_area-for-pmd-mappings.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 22:05:53 -0700
Message-ID: <5711c831.5A3rRSxi6nfSm3VO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcDPFFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, adilger.kernel@dilger.ca, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add dax_get_unmapped_area for pmd mappings
has been added to the -mm tree.  Its filename is
     dax-add-dax_get_unmapped_area-for-pmd-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-dax_get_unmapped_area-for-pmd-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-dax_get_unmapped_area-for-pmd-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: dax: add dax_get_unmapped_area for pmd mappings

When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page size. 
This feature relies on both mmap virtual address and FS block (i.e. 
physical address) to be aligned by the pmd page size.  Users can use mkfs
options to specify FS to align block allocations.  However, aligning mmap
address requires code changes to existing applications for providing a
pmd-aligned address to mmap().

For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].  It
calls mmap() with a NULL address, which needs to be changed to provide a
pmd-aligned address for testing with DAX pmd mappings.  Changing all
applications that call mmap() with NULL is undesirable.

Add dax_get_unmapped_area(), which can be called by filesystem's
get_unmapped_area to align an mmap address by the pmd size for a DAX file.
It calls the default handler, mm->get_unmapped_area(), to find a range
and then aligns it for a DAX file.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c

The point is that we do not need to modify existing applications for using
DAX PMD mappings.

For instance, fio with "ioengine=mmap" performs I/Os with mmap(). 
https://github.com/caius/fio/blob/master/engines/mmap.c

With this change, unmodified fio can be used for testing with DAX PMD
mappings.  There are many examples like this, and I do not think we want
to modify all applications that we want to evaluate/test with.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   43 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |    3 ++
 2 files changed, 46 insertions(+)

diff -puN fs/dax.c~dax-add-dax_get_unmapped_area-for-pmd-mappings fs/dax.c
--- a/fs/dax.c~dax-add-dax_get_unmapped_area-for-pmd-mappings
+++ a/fs/dax.c
@@ -1158,3 +1158,46 @@ int dax_truncate_page(struct inode *inod
 	return dax_zero_page_range(inode, from, length, get_block);
 }
 EXPORT_SYMBOL_GPL(dax_truncate_page);
+
+/**
+ * dax_get_unmapped_area - handle get_unmapped_area for a DAX file
+ * @filp: The file being mmap'd, if not NULL
+ * @addr: The mmap address. If NULL, the kernel assigns the address
+ * @len: The mmap size in bytes
+ * @pgoff: The page offset in the file where the mapping starts from.
+ * @flags: The mmap flags
+ *
+ * This function can be called by a filesystem for get_unmapped_area().
+ * When a target file is a DAX file, it aligns the mmap address at the
+ * beginning of the file by the pmd size.
+ */
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX_PMD) ||
+	    !filp || addr || !IS_DAX(filp->f_mapping->host))
+		goto out;
+
+	off = pgoff << PAGE_SHIFT;
+	off_end = off + len;
+	off_pmd = round_up(off, PMD_SIZE);  /* pmd-aligned offset */
+
+	if ((off_end <= off_pmd) || ((off_end - off_pmd) < PMD_SIZE))
+		goto out;
+
+	len_pmd = len + PMD_SIZE;
+	if ((off + len_pmd) < off)
+		goto out;
+
+	addr_pmd = current->mm->get_unmapped_area(filp, addr, len_pmd,
+						  pgoff, flags);
+	if (!IS_ERR_VALUE(addr_pmd)) {
+		addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);
+		return addr_pmd;
+	}
+out:
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(dax_get_unmapped_area);
diff -puN include/linux/dax.h~dax-add-dax_get_unmapped_area-for-pmd-mappings include/linux/dax.h
--- a/include/linux/dax.h~dax-add-dax_get_unmapped_area-for-pmd-mappings
+++ a/include/linux/dax.h
@@ -17,12 +17,15 @@ int __dax_fault(struct vm_area_struct *,
 
 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags);
 #else
 static inline struct page *read_dax_sector(struct block_device *bdev,
 		sector_t n)
 {
 	return ERR_PTR(-ENXIO);
 }
+#define dax_get_unmapped_area	NULL
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

dax-add-dax_get_unmapped_area-for-pmd-mappings.patch
ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch

