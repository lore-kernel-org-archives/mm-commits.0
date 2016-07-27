From: akpm@linux-foundation.org
Subject: [merged] khugepaged-recheck-pmd-after-mmap_sem-re-acquired.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:08 -0700
Message-ID: <57990530.D0A/IAPNwcsVTS5S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: recheck pmd after mmap_sem re-acquired
has been removed from the -mm tree.  Its filename was
     khugepaged-recheck-pmd-after-mmap_sem-re-acquired.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: recheck pmd after mmap_sem re-acquired

Vlastimil noted[1] that pmd can be no longer valid after we drop
mmap_sem. We need recheck it once mmap_sem taken again.

[1] http://lkml.kernel.org/r/12918dcd-a695-c6f4-e06f-69141c5f357f@suse.cz

Link: http://lkml.kernel.org/r/1466021202-61880-6-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/huge_memory.c~khugepaged-recheck-pmd-after-mmap_sem-re-acquired mm/huge_memory.c
--- a/mm/huge_memory.c~khugepaged-recheck-pmd-after-mmap_sem-re-acquired
+++ a/mm/huge_memory.c
@@ -2433,6 +2433,9 @@ static bool __collapse_huge_page_swapin(
 			/* vma is no longer available, don't continue to swapin */
 			if (hugepage_vma_revalidate(mm, address))
 				return false;
+			/* check if the pmd is still valid */
+			if (mm_find_pmd(mm, address) != pmd)
+				return false;
 		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
@@ -2518,6 +2521,9 @@ static void collapse_huge_page(struct mm
 	result = hugepage_vma_revalidate(mm, address);
 	if (result)
 		goto out;
+	/* check if the pmd is still valid */
+	if (mm_find_pmd(mm, address) != pmd)
+		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


