From: akpm@linux-foundation.org
Subject: +
 mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch added to -mm tree
Date: Wed, 24 Jun 2020 12:52:39 -0700
Message-ID: <20200624195239.1oEGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406243AbgFXTwk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:52:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, rppt@linux.ibm.com, ralf@linux-mips.org, paulburton@kernel.org, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, dansilsby@gmail.com, anshuman.khandual@arm.com, maobibo@loongson.cn


The patch titled
     Subject: MIPS: do not call flush_tlb_all when setting pmd entry
has been added to the -mm tree.  Its filename is
     mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch

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
Subject: MIPS: do not call flush_tlb_all when setting pmd entry

Function set_pmd_at is to set pmd entry, if tlb entry need to be flushed,
there exists pmdp_huge_clear_flush alike function before set_pmd_at is
called.  So it is not necessary to call flush_tlb_all in this function.

In these scenarios, tlb for the pmd range needs to be flushed:
1. privilege degrade such as wrprotect is set on the pmd entry
2. pmd entry is cleared
3. there is exception if set_pmd_at is issued by dup_mmap, since
flush_tlb_mm is called for parent process, it is not necessary
to flush tlb in function copy_huge_pmd.

Link: http://lkml.kernel.org/r/1592990792-1923-3-git-send-email-maobibo@loongson.cn
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

 arch/mips/mm/pgtable-32.c |    1 -
 arch/mips/mm/pgtable-64.c |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/mips/mm/pgtable-32.c~mips-do-not-call-flush_tlb_all-when-setting-pmd-entry
+++ a/arch/mips/mm/pgtable-32.c
@@ -45,7 +45,6 @@ void set_pmd_at(struct mm_struct *mm, un
 		pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
-	flush_tlb_all();
 }
 #endif /* defined(CONFIG_TRANSPARENT_HUGEPAGE) */
 
--- a/arch/mips/mm/pgtable-64.c~mips-do-not-call-flush_tlb_all-when-setting-pmd-entry
+++ a/arch/mips/mm/pgtable-64.c
@@ -100,7 +100,6 @@ void set_pmd_at(struct mm_struct *mm, un
 		pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
-	flush_tlb_all();
 }
 
 void __init pagetable_init(void)
_

Patches currently in -mm which might be from maobibo@loongson.cn are

mm-set-page-fault-address-for-update_mmu_cache_pmd.patch
mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch
mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch
