From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-update-comment-in-unmap_single_vma.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:34:19 -0700
Message-ID: <53445d4b.IKQS7HuQZAQJgVG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com

Subject: [merged] mm-memoryc-update-comment-in-unmap_single_vma.patch removed from -mm tree
To: davidlohr@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:34:19 -0700


The patch titled
     Subject: mm/memory.c: update comment in unmap_single_vma()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-update-comment-in-unmap_single_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/memory.c: update comment in unmap_single_vma()

The described issue now occurs inside mmap_region().  And unfortunately is
still valid.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-update-comment-in-unmap_single_vma mm/memory.c
--- a/mm/memory.c~mm-memoryc-update-comment-in-unmap_single_vma
+++ a/mm/memory.c
@@ -1320,9 +1320,9 @@ static void unmap_single_vma(struct mmu_
 			 * It is undesirable to test vma->vm_file as it
 			 * should be non-null for valid hugetlb area.
 			 * However, vm_file will be NULL in the error
-			 * cleanup path of do_mmap_pgoff. When
+			 * cleanup path of mmap_region. When
 			 * hugetlbfs ->mmap method fails,
-			 * do_mmap_pgoff() nullifies vma->vm_file
+			 * mmap_region() nullifies vma->vm_file
 			 * before calling this function to clean up.
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch

