From: akpm@linux-foundation.org
Subject: + block-fix-pfn_mkwrite-dax-fault-handler.patch added to -mm tree
Date: Mon, 01 Feb 2016 15:26:07 -0800
Message-ID: <56afe98f.oJ3rrxM38WgF+zl7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbcBAX0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: fix pfn_mkwrite() DAX fault handler
has been added to the -mm tree.  Its filename is
     block-fix-pfn_mkwrite-dax-fault-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-fix-pfn_mkwrite-dax-fault-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-fix-pfn_mkwrite-dax-fault-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jan Kara <jack@suse.com>
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
@@ -1761,7 +1767,7 @@ static const struct vm_operations_struct
 	.close		= blkdev_vm_close,
 	.fault		= blkdev_dax_fault,
 	.pmd_fault	= blkdev_dax_pmd_fault,
-	.pfn_mkwrite	= blkdev_dax_fault,
+	.pfn_mkwrite	= blkdev_dax_pfn_mkwrite,
 };
 
 static const struct vm_operations_struct blkdev_default_vm_ops = {
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

block-fix-pfn_mkwrite-dax-fault-handler.patch

