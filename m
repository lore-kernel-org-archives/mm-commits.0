From: akpm@linux-foundation.org
Subject: [merged]
 uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:24:07 -0700
Message-ID: <51db11d7.9tcDbVaMQs9f7EWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3GHTYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, huawei.libin@huawei.com

Subject: [merged] uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from -mm tree
To: huawei.libin@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:07 -0700


The patch titled
     Subject: uio: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libin <huawei.libin@huawei.com>
Subject: uio: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uio/uio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/uio/uio.c~uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift drivers/uio/uio.c
--- a/drivers/uio/uio.c~uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift
+++ a/drivers/uio/uio.c
@@ -677,7 +677,7 @@ static int uio_mmap(struct file *filep,
 	if (mi < 0)
 		return -EINVAL;
 
-	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	requested_pages = vma_pages(vma);
 	actual_pages = ((idev->info->mem[mi].addr & ~PAGE_MASK)
 			+ idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
 	if (requested_pages > actual_pages)
_

Patches currently in -mm which might be from huawei.libin@huawei.com are

origin.patch

