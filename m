From: akpm@linux-foundation.org
Subject: + mm-write-protect-madv_free-pages.patch added to -mm tree
Date: Mon, 23 Jan 2017 15:30:09 -0800
Message-ID: <58869201.ekqqR1pRsxGrtvq9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdAWXaK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:30:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hughd@google.com, minchan@kernel.org, riel@surriel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: write protect MADV_FREE pages
has been added to the -mm tree.  Its filename is
     mm-write-protect-madv_free-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-write-protect-madv_free-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-write-protect-madv_free-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1397,6 +1397,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 			tlb->fullmm);
 		orig_pmd = pmd_mkold(orig_pmd);
 		orig_pmd = pmd_mkclean(orig_pmd);
+		orig_pmd = pmd_wrprotect(orig_pmd);
 
 		set_pmd_at(mm, addr, pmd, orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
diff -puN mm/madvise.c~mm-write-protect-madv_free-pages mm/madvise.c
--- a/mm/madvise.c~mm-write-protect-madv_free-pages
+++ a/mm/madvise.c
@@ -373,6 +373,7 @@ static int madvise_free_pte_range(pmd_t
 
 			ptent = pte_mkold(ptent);
 			ptent = pte_mkclean(ptent);
+			ptent = pte_wrprotect(ptent);
 			set_pte_at(mm, addr, pte, ptent);
 			if (PageActive(page))
 				deactivate_page(page);
_

Patches currently in -mm which might be from shli@fb.com are

mm-write-protect-madv_free-pages.patch

