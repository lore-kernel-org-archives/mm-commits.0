From: akpm@linux-foundation.org
Subject: [patch 053/119] mm: update comment describing
 tlb_gather_mmu
Date: Wed, 31 Jan 2018 16:17:17 -0800
Message-ID: <20180201001717.pFWV39Q6_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBAARU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm: update comment describing tlb_gather_mmu

The comment describes @fullmm argument, but the function has no such
parameter.

Update the comment to match the code and convert it to kernel-doc markup.

Link: http://lkml.kernel.org/r/1512394531-2264-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-update-comment-describing-tlb_gather_mmu mm/memory.c
--- a/mm/memory.c~mm-update-comment-describing-tlb_gather_mmu
+++ a/mm/memory.c
@@ -400,10 +400,17 @@ void tlb_remove_table(struct mmu_gather
 
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
-/* tlb_gather_mmu
- *	Called to initialize an (on-stack) mmu_gather structure for page-table
- *	tear-down from @mm. The @fullmm argument is used when @mm is without
- *	users and we're going to destroy the full address space (exit/execve).
+/**
+ * tlb_gather_mmu - initialize an mmu_gather structure for page-table tear-down
+ * @tlb: the mmu_gather structure to initialize
+ * @mm: the mm_struct of the target address space
+ * @start: start of the region that will be removed from the page-table
+ * @end: end of the region that will be removed from the page-table
+ *
+ * Called to initialize an (on-stack) mmu_gather structure for page-table
+ * tear-down from @mm. The @start and @end are set to 0 and -1
+ * respectively when @mm is without users and we're going to destroy
+ * the full address space (exit/execve).
  */
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 			unsigned long start, unsigned long end)
_
