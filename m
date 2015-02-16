From: akpm@linux-foundation.org
Subject: [folded-merged]
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch removed from -mm tree
Date: Mon, 16 Feb 2015 15:44:29 -0800
Message-ID: <54e280dd.KaBtNtQVsMYQhYfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2
has been removed from the -mm tree.  Its filename was
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch

This patch was dropped because it was folded into daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2

email->code comments

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2 fs/dax.c
--- a/fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2
+++ a/fs/dax.c
@@ -353,6 +353,10 @@ static int do_dax_fault(struct vm_area_s
 		}
 		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
+			/*
+			 * We have a struct page covering a hole in the file
+			 * from a read fault and we've raced with a truncate
+			 */
 			error = -EIO;
 			goto unlock_page;
 		}
@@ -360,7 +364,7 @@ static int do_dax_fault(struct vm_area_s
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
-		error = -EIO;
+		error = -EIO;		/* fs corruption? */
 	if (error)
 		goto unlock_page;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

