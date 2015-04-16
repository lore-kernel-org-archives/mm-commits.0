From: akpm@linux-foundation.org
Subject: [merged]
 dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:53:10 -0700
Message-ID: <552fe8f6.1pJ6UG5j8bDJrVFC%akpm__24630.1421350383$1429202888$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boaz@plexistor.com, david@fromorbit.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, stable@vger.kernel.org, yigal@plexistor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: use pfn_mkwrite to update c/mtime + freeze protection
has been removed from the -mm tree.  Its filename was
     dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boaz Harrosh <boaz@plexistor.com>
Subject: dax: use pfn_mkwrite to update c/mtime + freeze protection

From: Yigal Korman <yigal@plexistor.com>

[v1]
Without this patch, c/mtime is not updated correctly when mmap'ed page is
first read from and then written to.

A new xfstest is submitted for testing this (generic/080)

[v2]
Jan Kara has pointed out that if we add the
sb_start/end_pagefault pair in the new pfn_mkwrite we
are then fixing another bug where: A user could start
writing to the page while filesystem is frozen.

Signed-off-by: Yigal Korman <yigal@plexistor.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |   17 +++++++++++++++++
 fs/ext2/file.c     |    1 +
 fs/ext4/file.c     |    1 +
 include/linux/fs.h |    1 +
 4 files changed, 20 insertions(+)

diff -puN fs/dax.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection fs/dax.c
--- a/fs/dax.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection
+++ a/fs/dax.c
@@ -464,6 +464,23 @@ int dax_fault(struct vm_area_struct *vma
 EXPORT_SYMBOL_GPL(dax_fault);
 
 /**
+ * dax_pfn_mkwrite - handle first write to DAX page
+ * @vma: The virtual memory area where the fault occurred
+ * @vmf: The description of the fault
+ *
+ */
+int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+	sb_end_pagefault(sb);
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
+
+/**
  * dax_zero_page_range - zero a range within a page of a DAX file
  * @inode: The file being truncated
  * @from: The file offset that is being truncated to
diff -puN fs/ext2/file.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection fs/ext2/file.c
--- a/fs/ext2/file.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection
+++ a/fs/ext2/file.c
@@ -39,6 +39,7 @@ static int ext2_dax_mkwrite(struct vm_ar
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	.page_mkwrite	= ext2_dax_mkwrite,
+	.pfn_mkwrite	= dax_pfn_mkwrite,
 };
 
 static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/ext4/file.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection fs/ext4/file.c
--- a/fs/ext4/file.c~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection
+++ a/fs/ext4/file.c
@@ -206,6 +206,7 @@ static int ext4_dax_mkwrite(struct vm_ar
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.page_mkwrite	= ext4_dax_mkwrite,
+	.pfn_mkwrite	= dax_pfn_mkwrite,
 };
 #else
 #define ext4_dax_vm_ops	ext4_file_vm_ops
diff -puN include/linux/fs.h~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection include/linux/fs.h
--- a/include/linux/fs.h~dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection
+++ a/include/linux/fs.h
@@ -2620,6 +2620,7 @@ int dax_clear_blocks(struct inode *, sec
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
+int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
 #define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
 
 #ifdef CONFIG_BLOCK
_

Patches currently in -mm which might be from boaz@plexistor.com are

origin.patch
linux-next.patch
gitignore-ignore-tar.patch

