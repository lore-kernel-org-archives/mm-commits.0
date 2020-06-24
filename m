From: akpm@linux-foundation.org
Subject: + mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 12:52:37 -0700
Message-ID: <20200624195237.zKgW-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406243AbgFXTwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, rppt@linux.ibm.com, ralf@linux-mips.org, paulburton@kernel.org, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, dansilsby@gmail.com, anshuman.khandual@arm.com, maobibo@loongson.cn


The patch titled
     Subject: mm/huge_memory.c: update tlb entry if pmd is changed
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bibo Mao <maobibo@loongson.cn>
Subject: mm/huge_memory.c: update tlb entry if pmd is changed

When set_pmd_at is called in function do_huge_pmd_anonymous_page, new tlb
entry can be added by software on MIPS platform.

Here add update_mmu_cache_pmd when pmd entry is set, and
update_mmu_cache_pmd is defined as empty excepts arc/mips platform.  This
patch has no negative effect on other platforms except arc/mips system.

Link: http://lkml.kernel.org/r/1592990792-1923-2-git-send-email-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Daniel Silsby <dansilsby@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed
+++ a/mm/huge_memory.c
@@ -643,6 +643,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
+		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
@@ -756,6 +757,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
 						   haddr, vmf->pmd, zero_page);
+				update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 				spin_unlock(vmf->ptl);
 				set = true;
 			}
_

Patches currently in -mm which might be from maobibo@loongson.cn are

mm-set-page-fault-address-for-update_mmu_cache_pmd.patch
mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch
mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch
