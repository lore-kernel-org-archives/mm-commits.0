Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF913747F
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398849; cv=none; b=pBCNKxD0YlohbvKOXLHu4ffpVPQ6KK1xY294UOTKL7NliSFXPmQ6KaHcctHfts6/6DZ6GxsxiQcKQhzFlzjJms9PVl+tTWos4rI8FgbEVYoskeENsP9yJY+4Zkysqz0RplQr2+4ehy4SVHn4FLRy79Fn/qlTiat9D44msNvN79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398849; c=relaxed/simple;
	bh=Dpo2Jzo6x9iDDgNyLSFPBuZ/Uil6KkgX8j73Wb/ckF8=;
	h=Date:To:From:Subject:Message-Id; b=f3nULX0TnNBwCqhhKlSyS8aE+/9c3LQvV97RFuAlCobFwm0hUUFH8NUl4mj95YrqreglpBqDwx0KinjR4wCAqxW4CIR4gQ+o5eRv2MB4VT7l4H835qI9MDQd95TOg74XNTlwEunzWtj0lxJCopzlzVjCv2+V7RdlTjy0CiKWBmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLqv5lq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLqv5lq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BDEC4CED2;
	Thu,  9 Jan 2025 05:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398849;
	bh=Dpo2Jzo6x9iDDgNyLSFPBuZ/Uil6KkgX8j73Wb/ckF8=;
	h=Date:To:From:Subject:From;
	b=gLqv5lq9rMW2jIb1S+ay4kEIe5fLnq5V94tY1rthym69CxVPM8ZW+j3IN4P+LIrIr
	 dQuTTdUO0HKzuVzLsj9wKoJGJv50RHDVq35xbAYXk6NSaPydHWu8BojEkQlBNHUVKP
	 XWdLhlaC+FLj8JH8DkCUiui0yO5g0nElOxvfNl9M=
Date: Wed, 08 Jan 2025 21:00:48 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch added to mm-unstable branch
Message-Id: <20250109050049.64BDEC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: pgtable: add statistics for PUD and P4D level page table
has been added to the -mm mm-unstable branch.  Its filename is
     s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: s390: pgtable: add statistics for PUD and P4D level page table
Date: Wed, 8 Jan 2025 14:57:22 +0800

Like PMD and PTE level page table, also add statistics for PUD and P4D
page table.

Link: https://lkml.kernel.org/r/4707dffce228ccec5c6662810566dd12b5741c4b.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgalloc.h |   29 +++++++++++++++++++++--------
 arch/s390/include/asm/tlb.h     |    2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/arch/s390/include/asm/pgalloc.h~s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table
+++ a/arch/s390/include/asm/pgalloc.h
@@ -53,29 +53,42 @@ static inline p4d_t *p4d_alloc_one(struc
 {
 	unsigned long *table = crst_table_alloc(mm);
 
-	if (table)
-		crst_table_init(table, _REGION2_ENTRY_EMPTY);
+	if (!table)
+		return NULL;
+	crst_table_init(table, _REGION2_ENTRY_EMPTY);
+	pagetable_p4d_ctor(virt_to_ptdesc(table));
+
 	return (p4d_t *) table;
 }
 
 static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 {
-	if (!mm_p4d_folded(mm))
-		crst_table_free(mm, (unsigned long *) p4d);
+	if (mm_p4d_folded(mm))
+		return;
+
+	pagetable_p4d_dtor(virt_to_ptdesc(p4d));
+	crst_table_free(mm, (unsigned long *) p4d);
 }
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	unsigned long *table = crst_table_alloc(mm);
-	if (table)
-		crst_table_init(table, _REGION3_ENTRY_EMPTY);
+
+	if (!table)
+		return NULL;
+	crst_table_init(table, _REGION3_ENTRY_EMPTY);
+	pagetable_pud_ctor(virt_to_ptdesc(table));
+
 	return (pud_t *) table;
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 {
-	if (!mm_pud_folded(mm))
-		crst_table_free(mm, (unsigned long *) pud);
+	if (mm_pud_folded(mm))
+		return;
+
+	pagetable_pud_dtor(virt_to_ptdesc(pud));
+	crst_table_free(mm, (unsigned long *) pud);
 }
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
--- a/arch/s390/include/asm/tlb.h~s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table
+++ a/arch/s390/include/asm/tlb.h
@@ -122,6 +122,7 @@ static inline void p4d_free_tlb(struct m
 {
 	if (mm_p4d_folded(tlb->mm))
 		return;
+	pagetable_p4d_dtor(virt_to_ptdesc(p4d));
 	__tlb_adjust_range(tlb, address, PAGE_SIZE);
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
@@ -140,6 +141,7 @@ static inline void pud_free_tlb(struct m
 {
 	if (mm_pud_folded(tlb->mm))
 		return;
+	pagetable_pud_dtor(virt_to_ptdesc(pud));
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_p4ds = 1;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
mm-pgtable-make-ptlock-be-freed-by-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch
revert-mm-pgtable-make-ptlock-be-freed-by-rcu.patch
mm-pgtable-add-statistics-for-p4d-level-page-table.patch
arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table.patch
s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch
mm-pgtable-introduce-pagetable_dtor.patch
arm-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
arm64-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
riscv-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
x86-pgtable-convert-__tlb_remove_table-to-use-struct-ptdesc.patch
x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths.patch
mm-pgtable-introduce-generic-__tlb_remove_table.patch
mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch
mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch
mm-pgtable-introduce-generic-pagetable_dtor_free.patch

