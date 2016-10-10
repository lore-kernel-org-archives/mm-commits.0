From: akpm@linux-foundation.org
Subject: [merged] thp-dax-add-thp_get_unmapped_area-for-pmd-mappings.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:54 -0700
Message-ID: <57fc19e6.7z9XOrupxLAF8Ri/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36837 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcJJWoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, adilger.kernel@dilger.ca, dan.j.williams@intel.com, david@fromorbit.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mawilcox@microsoft.com, mike.kravetz@oracle.com, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, dax: add thp_get_unmapped_area for pmd mappings
has been removed from the -mm tree.  Its filename was
     thp-dax-add-thp_get_unmapped_area-for-pmd-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: thp, dax: add thp_get_unmapped_area for pmd mappings

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

Add thp_get_unmapped_area(), which can be called by filesystem's
get_unmapped_area to align an mmap address by the pmd size for a DAX file.
It calls the default handler, mm->get_unmapped_area(), to find a range
and then aligns it for a DAX file.

The patch is based on Matthew Wilcox's change that allows adding support
of the pud page size easily.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c
Link: http://lkml.kernel.org/r/1472497881-9323-2-git-send-email-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 ++++++
 mm/huge_memory.c        |   43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff -puN include/linux/huge_mm.h~thp-dax-add-thp_get_unmapped_area-for-pmd-mappings include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-dax-add-thp_get_unmapped_area-for-pmd-mappings
+++ a/include/linux/huge_mm.h
@@ -87,6 +87,10 @@ extern bool is_vma_temporary_stack(struc
 
 extern unsigned long transparent_hugepage_flags;
 
+extern unsigned long thp_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags);
+
 extern void prep_transhuge_page(struct page *page);
 extern void free_transhuge_page(struct page *page);
 
@@ -169,6 +173,9 @@ void put_huge_zero_page(void);
 static inline void prep_transhuge_page(struct page *page) {}
 
 #define transparent_hugepage_flags 0UL
+
+#define thp_get_unmapped_area	NULL
+
 static inline int
 split_huge_page_to_list(struct page *page, struct list_head *list)
 {
diff -puN mm/huge_memory.c~thp-dax-add-thp_get_unmapped_area-for-pmd-mappings mm/huge_memory.c
--- a/mm/huge_memory.c~thp-dax-add-thp_get_unmapped_area-for-pmd-mappings
+++ a/mm/huge_memory.c
@@ -469,6 +469,49 @@ void prep_transhuge_page(struct page *pa
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
+unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+		loff_t off, unsigned long flags, unsigned long size)
+{
+	unsigned long addr;
+	loff_t off_end = off + len;
+	loff_t off_align = round_up(off, size);
+	unsigned long len_pad;
+
+	if (off_end <= off_align || (off_end - off_align) < size)
+		return 0;
+
+	len_pad = len + size;
+	if (len_pad < len || (off + len_pad) < off)
+		return 0;
+
+	addr = current->mm->get_unmapped_area(filp, 0, len_pad,
+					      off >> PAGE_SHIFT, flags);
+	if (IS_ERR_VALUE(addr))
+		return 0;
+
+	addr += (off - addr) & (size - 1);
+	return addr;
+}
+
+unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
+
+	if (addr)
+		goto out;
+	if (!IS_DAX(filp->f_mapping->host) || !IS_ENABLED(CONFIG_FS_DAX_PMD))
+		goto out;
+
+	addr = __thp_get_unmapped_area(filp, len, off, flags, PMD_SIZE);
+	if (addr)
+		return addr;
+
+ out:
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
+
 static int __do_huge_pmd_anonymous_page(struct fault_env *fe, struct page *page,
 		gfp_t gfp)
 {
_

Patches currently in -mm which might be from toshi.kani@hpe.com are


