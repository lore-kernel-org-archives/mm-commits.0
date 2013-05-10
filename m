From: akpm@linux-foundation.org
Subject: + ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch added to -mm tree
Date: Fri, 10 May 2013 13:49:50 -0700
Message-ID: <20130510204950.C65435A4028@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59875 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab3EJUtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 16:49:51 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so433487ggl.4
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 13:49:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huawei.libin@huawei.com


The patch titled
     Subject: ncpfs: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been added to the -mm tree.  Its filename is
     ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

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
mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

