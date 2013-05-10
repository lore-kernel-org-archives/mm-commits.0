From: akpm@linux-foundation.org
Subject: + mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch added to -mm tree
Date: Fri, 10 May 2013 13:49:48 -0700
Message-ID: <20130510204948.CE8DC31C078@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:65143 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3EJUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 16:49:49 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so433690qec.5
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 13:49:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huawei.libin@huawei.com


The patch titled
     Subject: mm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been added to the -mm tree.  Its filename is
     mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

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
Subject: mm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 mm/mmap.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift mm/memory.c
--- a/mm/memory.c~mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift
+++ a/mm/memory.c
@@ -2913,7 +2913,7 @@ static inline void unmap_mapping_range_t
 			details->first_index, details->last_index) {
 
 		vba = vma->vm_pgoff;
-		vea = vba + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) - 1;
+		vea = vba + vma_pages(vma) - 1;
 		/* Assume for now that PAGE_CACHE_SHIFT == PAGE_SHIFT */
 		zba = details->first_index;
 		if (zba < vba)
diff -puN mm/mmap.c~mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift mm/mmap.c
--- a/mm/mmap.c~mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift
+++ a/mm/mmap.c
@@ -955,7 +955,7 @@ can_vma_merge_after(struct vm_area_struc
 	if (is_mergeable_vma(vma, file, vm_flags) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
-		vm_pglen = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+		vm_pglen = vma_pages(vma);
 		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
 			return 1;
 	}
_

Patches currently in -mm which might be from huawei.libin@huawei.com are

origin.patch
mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
ncpfs-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
char-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch
uio-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

