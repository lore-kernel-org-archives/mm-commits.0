From: akpm@linux-foundation.org
Subject: [withdrawn] mm-write-protect-madv_free-pages.patch removed from
 -mm tree
Date: Tue, 31 Jan 2017 14:15:42 -0800
Message-ID: <58910c8e.j/BI2bMM1KFlkDtE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdAaW00 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:26:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hughd@google.com, minchan@kernel.org, riel@surriel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: write protect MADV_FREE pages
has been removed from the -mm tree.  Its filename was
     mm-write-protect-madv_free-pages.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: write protect MADV_FREE pages

Page reclaim has an assumption that writing to a page with clean pte
should trigger a page fault, because there is a window between pte zero
and tlb flush where a new write could come.  If the new write doesn't
trigger page fault, page reclaim will not notice it and think the page is
clean and reclaim it.  The MADV_FREE pages don't comply with the rule and
the pte is just cleaned without writeprotect, so there will be no
pagefault for new write.  This will cause data corruption.

I don't have a real workload to trigger this, it's from code
inspection.  A workload like this may trigger the bug:

madvise(MADV_FREE) /* memory range */
write to the memory range
read from the memory range

With memory pressure, the data read by the application could be all 0s
instead of those written.

Link: http://lkml.kernel.org/r/791151284cd6941296f08488b8cb7f1968175a0a.1485212872.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 mm/madvise.c     |    1 +
 2 files changed, 2 insertions(+)

diff -puN mm/huge_memory.c~mm-write-protect-madv_free-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-write-protect-madv_free-pages
+++ a/mm/huge_memory.c
@@ -1399,6 +1399,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 			tlb->fullmm);
 		orig_pmd = pmd_mkold(orig_pmd);
 		orig_pmd = pmd_mkclean(orig_pmd);
+		orig_pmd = pmd_wrprotect(orig_pmd);
 
 		set_pmd_at(mm, addr, pmd, orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
diff -puN mm/madvise.c~mm-write-protect-madv_free-pages mm/madvise.c
--- a/mm/madvise.c~mm-write-protect-madv_free-pages
+++ a/mm/madvise.c
@@ -376,6 +376,7 @@ static int madvise_free_pte_range(pmd_t
 
 			ptent = pte_mkold(ptent);
 			ptent = pte_mkclean(ptent);
+			ptent = pte_wrprotect(ptent);
 			set_pte_at(mm, addr, pte, ptent);
 			if (PageActive(page))
 				deactivate_page(page);
_

Patches currently in -mm which might be from shli@fb.com are


