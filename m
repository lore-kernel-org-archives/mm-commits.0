From: akpm@linux-foundation.org
Subject: [merged] fs-hugetlbfs-inodec-fix-pgoff-alignment-checking-on-32-bit.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:51:58 -0700
Message-ID: <201107260751.p6Q7p14V002907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab1GZHvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: beckyb@kernel.crashing.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     fs/hugetlbfs/inode.c: fix pgoff alignment checking on 32-bit
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-inodec-fix-pgoff-alignment-checking-on-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/hugetlbfs/inode.c: fix pgoff alignment checking on 32-bit
From: Becky Bruce <beckyb@kernel.crashing.org>

This:

vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT)

is incorrect on 32-bit.  It causes us to & the pgoff with something that
looks like this (for a 4m hugepage): 0xfff003ff.  The mask should be
flipped and *then* shifted, to give you 0x0000_03fff.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~fs-hugetlbfs-inodec-fix-pgoff-alignment-checking-on-32-bit fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-inodec-fix-pgoff-alignment-checking-on-32-bit
+++ a/fs/hugetlbfs/inode.c
@@ -94,7 +94,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	if (vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT))
+	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
_

Patches currently in -mm which might be from beckyb@kernel.crashing.org are

origin.patch
linux-next.patch

