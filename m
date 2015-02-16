From: akpm@linux-foundation.org
Subject: [folded-merged]
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch removed from -mm tree
Date: Mon, 16 Feb 2015 15:44:31 -0800
Message-ID: <54e280df.MfHFKCvNYalzKgK2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3
has been removed from the -mm tree.  Its filename was
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch

This patch was dropped because it was folded into daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3

remap_file_pages went away

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3 fs/ext2/file.c
--- a/fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3
+++ a/fs/ext2/file.c
@@ -39,7 +39,6 @@ static int ext2_dax_mkwrite(struct vm_ar
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	.page_mkwrite	= ext2_dax_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

