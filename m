From: akpm@linux-foundation.org
Subject: [alternative-merged] thp-reintroduce-split_huge_page-fix.patch
 removed from -mm tree
Date: Wed, 21 Oct 2015 13:33:49 -0700
Message-ID: <5627f6ad.bnJWq+2SZq4kNsD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbJUUdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark head page dirty in split_huge_page
has been removed from the -mm tree.  Its filename was
     thp-reintroduce-split_huge_page-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: mark head page dirty in split_huge_page

In thp split in old THP refcount, we mappped all of pages (ie, head +
tails) to pte_mkdirty and mark PG_flags to every tail pages.

But with THP refcount redesign, we can lose dirty bit in page table and
PG_dirty for head page if we want to free the THP page using
migration_entry.

It ends up discarding head page by madvise_free suddenly.  This patch
fixes it by mark the head page PG_dirty when VM splits the THP page.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix
+++ a/mm/huge_memory.c
@@ -3156,6 +3156,7 @@ static void __split_huge_page(struct pag
 	atomic_sub(tail_mapcount, &head->_count);
 
 	ClearPageCompound(head);
+	SetPageDirty(head);
 	spin_unlock_irq(&zone->lru_lock);
 
 	unfreeze_page(page_anon_vma(head), head);
_

Patches currently in -mm which might be from minchan@kernel.org are

thp-use-is_zero_pfn-only-after-pte_present-check.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-5.patch
mm-support-madvisemadv_free-fix-6.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

