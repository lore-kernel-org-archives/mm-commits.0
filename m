From: akpm@linux-foundation.org
Subject: [patch 086/126] khugepaged: recheck pmd after mmap_sem
 re-acquired
Date: Tue, 26 Jul 2016 15:25:12 -0700
Message-ID: <5797e348.P2wN5JDSvX3ZVgKI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbcGZWZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

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
