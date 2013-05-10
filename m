From: akpm@linux-foundation.org
Subject: + uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch added to -mm tree
Date: Fri, 10 May 2013 13:49:54 -0700
Message-ID: <20130510204954.C3DFB31C078@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51132 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3EJUtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 16:49:55 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so434402vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 13:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huawei.libin@huawei.com


The patch titled
     Subject: uio: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been added to the -mm tree.  Its filename is
     uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

