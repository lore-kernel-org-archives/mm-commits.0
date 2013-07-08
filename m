From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:24:03 -0700
Message-ID: <51db11d3.DqlW1MvinbJr9xOW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GHTYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, huawei.libin@huawei.com

Subject: [merged] mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch removed from -mm tree
To: huawei.libin@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:03 -0700


The patch titled
     Subject: mm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     mm-use-vma_pages-to-replace-vm_end-vm_start-page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2904,7 +2904,7 @@ static inline void unmap_mapping_range_t
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

