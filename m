From: akpm@linux-foundation.org
Subject: [patch 094/126] thp: support file pages in zap_huge_pmd()
Date: Tue, 26 Jul 2016 15:25:34 -0700
Message-ID: <5797e35e.MI78/9j+2X4VHQ9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZWZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: support file pages in zap_huge_pmd()

split_huge_pmd() for file mappings (and DAX too) is implemented by just
clearing pmd entry as we can re-fill this area from page cache on pte
level later.

This means we don't need deposit page tables when file THP is mapped.
Therefore we shouldn't try to withdraw a page table on zap_huge_pmd()
file THP PMD.

Link: http://lkml.kernel.org/r/1466021202-61880-14-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-support-file-pages-in-zap_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-support-file-pages-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -1689,10 +1689,16 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		struct page *page = pmd_page(orig_pmd);
 		page_remove_rmap(page, true);
 		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		VM_BUG_ON_PAGE(!PageHead(page), page);
-		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
-		atomic_long_dec(&tlb->mm->nr_ptes);
+		if (PageAnon(page)) {
+			pgtable_t pgtable;
+			pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
+			pte_free(tlb->mm, pgtable);
+			atomic_long_dec(&tlb->mm->nr_ptes);
+			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		} else {
+			add_mm_counter(tlb->mm, MM_FILEPAGES, -HPAGE_PMD_NR);
+		}
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, HPAGE_PMD_SIZE);
 	}
_
