From: akpm@linux-foundation.org
Subject: [merged]
 ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:24:05 -0700
Message-ID: <51db11d5.riud2Lc+E+etlPAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab3GHTYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, huawei.libin@huawei.com

Subject: [merged] ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from -mm tree
To: huawei.libin@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:05 -0700


The patch titled
     Subject: ncpfs: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libin <huawei.libin@huawei.com>
Subject: ncpfs: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/mmap.c~ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift
+++ a/fs/ncpfs/mmap.c
@@ -117,7 +117,7 @@ int ncp_mmap(struct file *file, struct v
 		return -EINVAL;
 	/* we do not support files bigger than 4GB... We eventually 
 	   supports just 4GB... */
-	if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff 
+	if (vma_pages(vma) + vma->vm_pgoff
 	   > (1U << (32 - PAGE_SHIFT)))
 		return -EFBIG;
 
_

Patches currently in -mm which might be from huawei.libin@huawei.com are

origin.patch

