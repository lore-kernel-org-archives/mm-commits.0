From: akpm@linux-foundation.org
Subject: [patch 05/12] soft_dirty: fix soft_dirty during THP split
Date: Thu, 25 Aug 2016 15:16:57 -0700
Message-ID: <57bf6e59.NAcyAjT9Vf2gbi7L%akpm__41002.2800126628$1472164946$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59253 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932816AbcHYWmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, kirill@shutemov.name, stable@vger.kernel.org, xemul@virtuozzo.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: soft_dirty: fix soft_dirty during THP split

While adding proper userfaultfd_wp support with bits in pagetable and swap
entry to avoid false positives WP userfaults through swap/fork/KSM/etc.. 
I've been adding a framework that mostly mirrors soft dirty.

So I noticed in one place I had to add uffd_wp support to the pagetables
that wasn't covered by soft_dirty and I think it should have.

Example: in the THP migration code migrate_misplaced_transhuge_page()
pmd_mkdirty is called unconditionally after mk_huge_pmd.

	entry = mk_huge_pmd(new_page, vma->vm_page_prot);
	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);

That sets soft dirty too (it's a false positive for soft dirty, the soft
dirty bit could be more finegrained and transfer the bit like uffd_wp will
do..  pmd/pte_uffd_wp() enforces the invariant that when it's set
pmd/pte_write is not set).

However in the THP split there's no unconditional pmd_mkdirty after
mk_huge_pmd and pte_swp_mksoft_dirty isn't called after the migration
entry is created.  The code sets the dirty bit in the struct page instead
of setting it in the pagetable (which is fully equivalent as far as the
real dirty bit is concerned, as the whole point of pagetable bits is to be
eventually flushed out of to the page, but that is not equivalent for the
soft-dirty bit that gets lost in translation).

This was found by code review only and totally untested as I'm working to
actually replace soft dirty and I don't have time to test potential soft
dirty bugfixes as well :).


Transfer the soft_dirty from pmd to pte during THP splits.

This fix avoids losing the soft_dirty bit and avoids userland memory
corruption in the checkpoint.

Fixes: eef1b3ba053aa6 ("thp: implement split_huge_pmd()")
Link: http://lkml.kernel.org/r/1471610515-30229-2-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~soft_dirty-fix-soft_dirty-during-thp-split mm/huge_memory.c
--- a/mm/huge_memory.c~soft_dirty-fix-soft_dirty-during-thp-split
+++ a/mm/huge_memory.c
@@ -1512,7 +1512,7 @@ static void __split_huge_pmd_locked(stru
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t _pmd;
-	bool young, write, dirty;
+	bool young, write, dirty, soft_dirty;
 	unsigned long addr;
 	int i;
 
@@ -1546,6 +1546,7 @@ static void __split_huge_pmd_locked(stru
 	write = pmd_write(*pmd);
 	young = pmd_young(*pmd);
 	dirty = pmd_dirty(*pmd);
+	soft_dirty = pmd_soft_dirty(*pmd);
 
 	pmdp_huge_split_prepare(vma, haddr, pmd);
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
@@ -1562,6 +1563,8 @@ static void __split_huge_pmd_locked(stru
 			swp_entry_t swp_entry;
 			swp_entry = make_migration_entry(page + i, write);
 			entry = swp_entry_to_pte(swp_entry);
+			if (soft_dirty)
+				entry = pte_swp_mksoft_dirty(entry);
 		} else {
 			entry = mk_pte(page + i, vma->vm_page_prot);
 			entry = maybe_mkwrite(entry, vma);
@@ -1569,6 +1572,8 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
+			if (soft_dirty)
+				entry = pte_mksoft_dirty(entry);
 		}
 		if (dirty)
 			SetPageDirty(page + i);
_
