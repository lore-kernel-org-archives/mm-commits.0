From: akpm@linux-foundation.org
Subject: + char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch added to -mm tree
Date: Fri, 10 May 2013 13:49:52 -0700
Message-ID: <20130510204952.C64F15A4028@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:35917 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3EJUtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 16:49:53 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so433573yen.2
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 13:49:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huawei.libin@huawei.com


The patch titled
     Subject: char: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been added to the -mm tree.  Its filename is
     char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

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

origin.patch
mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

