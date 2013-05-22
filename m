From: akpm@linux-foundation.org
Subject: [withdrawn]
 char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from -mm tree
Date: Wed, 22 May 2013 15:31:57 -0700
Message-ID: <519d475d.BruDik7hXW6coFPM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab3EVWb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 18:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, huawei.libin@huawei.com

Subject: [withdrawn] char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from -mm tree
To: huawei.libin@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 15:31:57 -0700


The patch titled
     Subject: char: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Libin <huawei.libin@huawei.com>
Subject: char: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mspec.c~char-use-vma_pages-to-replace-vm_end-vm_start-page_shift drivers/char/mspec.c
--- a/drivers/char/mspec.c~char-use-vma_pages-to-replace-vm_end-vm_start-page_shift
+++ a/drivers/char/mspec.c
@@ -168,7 +168,7 @@ mspec_close(struct vm_area_struct *vma)
 	if (!atomic_dec_and_test(&vdata->refcnt))
 		return;
 
-	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
+	last_index = vma_pages(vdata);
 	for (index = 0; index < last_index; index++) {
 		if (vdata->maddr[index] == 0)
 			continue;
_

Patches currently in -mm which might be from huawei.libin@huawei.com are

linux-next.patch
mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

