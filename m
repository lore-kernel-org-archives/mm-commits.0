From: akpm@linux-foundation.org
Subject: [merged] block-fix-pfn_mkwrite-dax-fault-handler.patch removed
 from -mm tree
Date: Wed, 10 Feb 2016 11:35:22 -0800
Message-ID: <56bb90fa.VrjX77RVMSoDTt8I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbcBJTfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: fix pfn_mkwrite() DAX fault handler
has been removed from the -mm tree.  Its filename was
     block-fix-pfn_mkwrite-dax-fault-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: block: fix pfn_mkwrite() DAX fault handler

Previously the pfn_mkwrite() fault handler for raw block devices called
bldev_dax_fault() -> __dax_fault() to do a full DAX page fault.  Really
what the pfn_mkwrite() fault handler needs to do is call dax_pfn_mkwrite()
to make sure that the radix tree entry for the given PTE is marked as
dirty so that a follow-up fsync or msync call will flush it durably to
media.

Fixes: 5a023cdba50c ("block: enable dax for raw block devices")
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~block-fix-pfn_mkwrite-dax-fault-handler fs/block_dev.c
--- a/fs/block_dev.c~block-fix-pfn_mkwrite-dax-fault-handler
+++ a/fs/block_dev.c
@@ -1730,6 +1730,12 @@ static int blkdev_dax_fault(struct vm_ar
 	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
 }
 
+static int blkdev_dax_pfn_mkwrite(struct vm_area_struct *vma,
+		struct vm_fault *vmf)
+{
+	return dax_pfn_mkwrite(vma, vmf);
+}
+
 static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned int flags)
 {
@@ -1739,7 +1745,7 @@ static int blkdev_dax_pmd_fault(struct v
 static const struct vm_operations_struct blkdev_dax_vm_ops = {
 	.fault		= blkdev_dax_fault,
 	.pmd_fault	= blkdev_dax_pmd_fault,
-	.pfn_mkwrite	= blkdev_dax_fault,
+	.pfn_mkwrite	= blkdev_dax_pfn_mkwrite,
 };
 
 static const struct vm_operations_struct blkdev_default_vm_ops = {
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


