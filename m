From: akpm@linux-foundation.org
Subject: + mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch added to -mm tree
Date: Thu, 13 Sep 2012 12:06:59 -0700
Message-ID: <20120913190700.35EA95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51888 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2IMTHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 15:07:03 -0400
Received: by fass10 with SMTP id s10so211850fas.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:07:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, aarcange@redhat.com, arnd@arndb.de, cmetcalf@tilera.com, gerald.schaefer@de.ibm.com, kirill@shutemov.name, mhocko@suse.cz, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm: thp: fix the update_mmu_cache() last argument passing in mm/huge_memory.c
has been added to the -mm tree.  Its filename is
     mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: thp: fix the update_mmu_cache() last argument passing in mm/huge_memory.c

The update_mmu_cache() takes a pointer (to pte_t by default) as the last
argument but the huge_memory.c passes a pmd_t value.  The patch changes
the argument to the pmd_t * pointer.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc
+++ a/mm/huge_memory.c
@@ -900,7 +900,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
-			update_mmu_cache(vma, address, entry);
+			update_mmu_cache(vma, address, pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
@@ -956,7 +956,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		update_mmu_cache(vma, address, entry);
+		update_mmu_cache(vma, address, pmd);
 		page_remove_rmap(page);
 		put_page(page);
 		ret |= VM_FAULT_WRITE;
@@ -2033,7 +2033,7 @@ static void collapse_huge_page(struct mm
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache(vma, address, _pmd);
+	update_mmu_cache(vma, address, pmd);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
mm-introduce-have_arch_transparent_hugepage.patch

