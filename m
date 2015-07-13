From: akpm@linux-foundation.org
Subject: + xfs-huge-page-fault-support.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:32:13 -0700
Message-ID: <55a42e5d.WL6/7QBokh9ZvkGk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbGMVcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: huge page fault support
has been added to the -mm tree.  Its filename is
     xfs-huge-page-fault-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xfs-huge-page-fault-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xfs-huge-page-fault-support.patch

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
Subject: xfs: huge page fault support

Use DAX to provide support for huge pages.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c  |   30 +++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |    1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff -puN fs/xfs/xfs_file.c~xfs-huge-page-fault-support fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~xfs-huge-page-fault-support
+++ a/fs/xfs/xfs_file.c
@@ -1530,8 +1530,36 @@ xfs_filemap_fault(
 	return ret;
 }
 
+STATIC int
+xfs_filemap_pmd_fault(
+	struct vm_area_struct	*vma,
+	unsigned long		addr,
+	pmd_t			*pmd,
+	unsigned int		flags)
+{
+	struct inode		*inode = file_inode(vma->vm_file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			ret;
+
+	if (!IS_DAX(inode))
+		return VM_FAULT_FALLBACK;
+
+	trace_xfs_filemap_pmd_fault(ip);
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_direct,
+				    xfs_end_io_dax_write);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
+	.pmd_fault	= xfs_filemap_pmd_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 };
@@ -1544,7 +1572,7 @@ xfs_file_mmap(
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_MIXEDMAP;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	return 0;
 }
 
diff -puN fs/xfs/xfs_trace.h~xfs-huge-page-fault-support fs/xfs/xfs_trace.h
--- a/fs/xfs/xfs_trace.h~xfs-huge-page-fault-support
+++ a/fs/xfs/xfs_trace.h
@@ -687,6 +687,7 @@ DEFINE_INODE_EVENT(xfs_inode_clear_eofbl
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
+DEFINE_INODE_EVENT(xfs_filemap_pmd_fault);
 DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch

