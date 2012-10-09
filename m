From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:09 -0700
Message-ID: <20121009181310.5461520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41968 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JISNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:13 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362365bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, aarcange@redhat.com, arnd@arndb.de, cmetcalf@tilera.com, gerald.schaefer@de.ibm.com, kirill@shutemov.name, mhocko@suse.cz, ralf@linux-mips.org, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix the update_mmu_cache() last argument passing in mm/huge_memory.c
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc
+++ a/mm/huge_memory.c
@@ -889,7 +889,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
-			update_mmu_cache(vma, address, entry);
+			update_mmu_cache(vma, address, pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
@@ -941,7 +941,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		pmdp_clear_flush_notify(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		update_mmu_cache(vma, address, entry);
+		update_mmu_cache(vma, address, pmd);
 		page_remove_rmap(page);
 		put_page(page);
 		ret |= VM_FAULT_WRITE;
@@ -2002,7 +2002,7 @@ static void collapse_huge_page(struct mm
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
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

