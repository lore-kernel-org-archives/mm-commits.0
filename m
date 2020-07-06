From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 documentation-mm-add-descriptions-for-arch-page-table-helpers.patch added
 to -mm tree
Date: Mon, 06 Jul 2020 16:28:34 -0700
Message-ID: <20200706232834.otcVmc0HC%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFX2g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:28:36 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, kirill@shutemov.name, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, rppt@kernel.org, rppt@linux.ibm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, ziy@nvidia.com


The patch titled
     Subject: Documentation/mm: Add descriptions for arch page table helpers
has been added to the -mm tree.  Its filename is
     documentation-mm-add-descriptions-for-arch-page-table-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-mm-add-descriptions-for-arch-page-table-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Documentation/mm: Add descriptions for arch page table helpers

This adds a specific description file for all arch page table helpers which
is in sync with the semantics being tested via CONFIG_DEBUG_VM_PGTABLE. All
future changes either to these descriptions here or the debug test should
always remain in sync.

Link: http://lkml.kernel.org/r/1593996516-7186-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/arch_pgtable_helpers.rst |  258 ++++++++++++++++++++
 mm/debug_vm_pgtable.c                     |    6 
 2 files changed, 264 insertions(+)

--- /dev/null
+++ a/Documentation/vm/arch_pgtable_helpers.rst
@@ -0,0 +1,258 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _arch_page_table_helpers:
+
+===============================
+Architecture Page Table Helpers
+===============================
+
+Generic MM expects architectures (with MMU) to provide helpers to create, access
+and modify page table entries at various level for different memory functions.
+These page table helpers need to conform to a common semantics across platforms.
+Following tables describe the expected semantics which can also be tested during
+boot via CONFIG_DEBUG_VM_PGTABLE option. All future changes in here or the debug
+test need to be in sync.
+
+======================
+PTE Page Table Helpers
+======================
+
+--------------------------------------------------------------------------------
+| pte_same                  | Tests whether both PTE entries are the same      |
+--------------------------------------------------------------------------------
+| pte_bad                   | Tests a non-table mapped PTE                     |
+--------------------------------------------------------------------------------
+| pte_present               | Tests a valid mapped PTE                         |
+--------------------------------------------------------------------------------
+| pte_young                 | Tests a young PTE                                |
+--------------------------------------------------------------------------------
+| pte_dirty                 | Tests a dirty PTE                                |
+--------------------------------------------------------------------------------
+| pte_write                 | Tests a writable PTE                             |
+--------------------------------------------------------------------------------
+| pte_special               | Tests a special PTE                              |
+--------------------------------------------------------------------------------
+| pte_protnone              | Tests a PROT_NONE PTE                            |
+--------------------------------------------------------------------------------
+| pte_devmap                | Tests a ZONE_DEVICE mapped PTE                   |
+--------------------------------------------------------------------------------
+| pte_soft_dirty            | Tests a soft dirty PTE                           |
+--------------------------------------------------------------------------------
+| pte_swp_soft_dirty        | Tests a soft dirty swapped PTE                   |
+--------------------------------------------------------------------------------
+| pte_mkyoung               | Creates a young PTE                              |
+--------------------------------------------------------------------------------
+| pte_mkold                 | Creates an old PTE                               |
+--------------------------------------------------------------------------------
+| pte_mkdirty               | Creates a dirty PTE                              |
+--------------------------------------------------------------------------------
+| pte_mkclean               | Creates a clean PTE                              |
+--------------------------------------------------------------------------------
+| pte_mkwrite               | Creates a writable PTE                           |
+--------------------------------------------------------------------------------
+| pte_mkwrprotect           | Creates a write protected PTE                    |
+--------------------------------------------------------------------------------
+| pte_mkspecial             | Creates a special PTE                            |
+--------------------------------------------------------------------------------
+| pte_mkdevmap              | Creates a ZONE_DEVICE mapped PTE                 |
+--------------------------------------------------------------------------------
+| pte_mksoft_dirty          | Creates a soft dirty PTE                         |
+--------------------------------------------------------------------------------
+| pte_clear_soft_dirty      | Clears a soft dirty PTE                          |
+--------------------------------------------------------------------------------
+| pte_swp_mksoft_dirty      | Creates a soft dirty swapped PTE                 |
+--------------------------------------------------------------------------------
+| pte_swp_clear_soft_dirty  | Clears a soft dirty swapped PTE                  |
+--------------------------------------------------------------------------------
+| pte_mknotpresent          | Invalidates a mapped PTE                         |
+--------------------------------------------------------------------------------
+| ptep_get_and_clear        | Clears a PTE                                     |
+--------------------------------------------------------------------------------
+| ptep_get_and_clear_full   | Clears a PTE                                     |
+--------------------------------------------------------------------------------
+| ptep_test_and_clear_young | Clears young from a PTE                          |
+--------------------------------------------------------------------------------
+| ptep_set_wrprotect        | Converts into a write protected PTE              |
+--------------------------------------------------------------------------------
+| ptep_set_access_flags     | Converts into a more permissive PTE              |
+--------------------------------------------------------------------------------
+
+======================
+PMD Page Table Helpers
+======================
+
+--------------------------------------------------------------------------------
+| pmd_same                  | Tests whether both PMD entries are the same      |
+--------------------------------------------------------------------------------
+| pmd_bad                   | Tests a non-table mapped PMD                     |
+--------------------------------------------------------------------------------
+| pmd_leaf                  | Tests a leaf mapped PMD                          |
+--------------------------------------------------------------------------------
+| pmd_huge                  | Tests a HugeTLB mapped PMD                       |
+--------------------------------------------------------------------------------
+| pmd_trans_huge            | Tests a Transparent Huge Page (THP) at PMD       |
+--------------------------------------------------------------------------------
+| pmd_present               | Tests a valid mapped PMD                         |
+--------------------------------------------------------------------------------
+| pmd_young                 | Tests a young PMD                                |
+--------------------------------------------------------------------------------
+| pmd_dirty                 | Tests a dirty PMD                                |
+--------------------------------------------------------------------------------
+| pmd_write                 | Tests a writable PMD                             |
+--------------------------------------------------------------------------------
+| pmd_special               | Tests a special PMD                              |
+--------------------------------------------------------------------------------
+| pmd_protnone              | Tests a PROT_NONE PMD                            |
+--------------------------------------------------------------------------------
+| pmd_devmap                | Tests a ZONE_DEVICE mapped PMD                   |
+--------------------------------------------------------------------------------
+| pmd_soft_dirty            | Tests a soft dirty PMD                           |
+--------------------------------------------------------------------------------
+| pmd_swp_soft_dirty        | Tests a soft dirty swapped PMD                   |
+--------------------------------------------------------------------------------
+| pmd_mkyoung               | Creates a young PMD                              |
+--------------------------------------------------------------------------------
+| pmd_mkold                 | Creates an old PMD                               |
+--------------------------------------------------------------------------------
+| pmd_mkdirty               | Creates a dirty PMD                              |
+--------------------------------------------------------------------------------
+| pmd_mkclean               | Creates a clean PMD                              |
+--------------------------------------------------------------------------------
+| pmd_mkwrite               | Creates a writable PMD                           |
+--------------------------------------------------------------------------------
+| pmd_mkwrprotect           | Creates a write protected PMD                    |
+--------------------------------------------------------------------------------
+| pmd_mkspecial             | Creates a special PMD                            |
+--------------------------------------------------------------------------------
+| pmd_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
+--------------------------------------------------------------------------------
+| pmd_mksoft_dirty          | Creates a soft dirty PMD                         |
+--------------------------------------------------------------------------------
+| pmd_clear_soft_dirty      | Clears a soft dirty PMD                          |
+--------------------------------------------------------------------------------
+| pmd_swp_mksoft_dirty      | Creates a soft dirty swapped PMD                 |
+--------------------------------------------------------------------------------
+| pmd_swp_clear_soft_dirty  | Clears a soft dirty swapped PMD                  |
+--------------------------------------------------------------------------------
+| pmd_mkinvalid             | Invalidates a mapped PMD [1]                     |
+--------------------------------------------------------------------------------
+| pmd_set_huge              | Creates a PMD huge mapping                       |
+--------------------------------------------------------------------------------
+| pmd_clear_huge            | Clears a PMD huge mapping                        |
+--------------------------------------------------------------------------------
+| pmdp_get_and_clear        | Clears a PMD                                     |
+--------------------------------------------------------------------------------
+| pmdp_get_and_clear_full   | Clears a PMD                                     |
+--------------------------------------------------------------------------------
+| pmdp_test_and_clear_young | Clears young from a PMD                          |
+--------------------------------------------------------------------------------
+| pmdp_set_wrprotect        | Converts into a write protected PMD              |
+--------------------------------------------------------------------------------
+| pmdp_set_access_flags     | Converts into a more permissive PMD              |
+--------------------------------------------------------------------------------
+
+======================
+PUD Page Table Helpers
+======================
+
+--------------------------------------------------------------------------------
+| pud_same                  | Tests whether both PUD entries are the same      |
+--------------------------------------------------------------------------------
+| pud_bad                   | Tests a non-table mapped PUD                     |
+--------------------------------------------------------------------------------
+| pud_leaf                  | Tests a leaf mapped PUD                          |
+--------------------------------------------------------------------------------
+| pud_huge                  | Tests a HugeTLB mapped PUD                       |
+--------------------------------------------------------------------------------
+| pud_trans_huge            | Tests a Transparent Huge Page (THP) at PUD       |
+--------------------------------------------------------------------------------
+| pud_present               | Tests a valid mapped PUD                         |
+--------------------------------------------------------------------------------
+| pud_young                 | Tests a young PUD                                |
+--------------------------------------------------------------------------------
+| pud_dirty                 | Tests a dirty PUD                                |
+--------------------------------------------------------------------------------
+| pud_write                 | Tests a writable PUD                             |
+--------------------------------------------------------------------------------
+| pud_devmap                | Tests a ZONE_DEVICE mapped PUD                   |
+--------------------------------------------------------------------------------
+| pud_mkyoung               | Creates a young PUD                              |
+--------------------------------------------------------------------------------
+| pud_mkold                 | Creates an old PUD                               |
+--------------------------------------------------------------------------------
+| pud_mkdirty               | Creates a dirty PUD                              |
+--------------------------------------------------------------------------------
+| pud_mkclean               | Creates a clean PUD                              |
+--------------------------------------------------------------------------------
+| pud_mkwrite               | Creates a writable PMD                           |
+--------------------------------------------------------------------------------
+| pud_mkwrprotect           | Creates a write protected PMD                    |
+--------------------------------------------------------------------------------
+| pud_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
+--------------------------------------------------------------------------------
+| pud_mkinvalid             | Invalidates a mapped PUD [1]                     |
+--------------------------------------------------------------------------------
+| pud_set_huge              | Creates a PUD huge mapping                       |
+--------------------------------------------------------------------------------
+| pud_clear_huge            | Clears a PUD huge mapping                        |
+--------------------------------------------------------------------------------
+| pudp_get_and_clear        | Clears a PUD                                     |
+--------------------------------------------------------------------------------
+| pudp_get_and_clear_full   | Clears a PUD                                     |
+--------------------------------------------------------------------------------
+| pudp_test_and_clear_young | Clears young from a PUD                          |
+--------------------------------------------------------------------------------
+| pudp_set_wrprotect        | Converts into a write protected PUD              |
+--------------------------------------------------------------------------------
+| pudp_set_access_flags     | Converts into a more permissive PUD              |
+--------------------------------------------------------------------------------
+
+==========================
+HugeTLB Page Table Helpers
+==========================
+
+--------------------------------------------------------------------------------
+| pte_huge                  | Tests a HugeTLB                                  |
+--------------------------------------------------------------------------------
+| pte_mkhuge                | Creates a HugeTLB                                |
+--------------------------------------------------------------------------------
+| huge_pte_dirty            | Tests a dirty HugeTLB                            |
+--------------------------------------------------------------------------------
+| huge_pte_write            | Tests a writable HugeTLB                         |
+--------------------------------------------------------------------------------
+| huge_pte_mkdirty          | Creates a dirty HugeTLB                          |
+--------------------------------------------------------------------------------
+| huge_pte_mkwrite          | Creates a writable HugeTLB                       |
+--------------------------------------------------------------------------------
+| huge_pte_mkwrprotect      | Creates a write protected HugeTLB                |
+--------------------------------------------------------------------------------
+| huge_ptep_get_and_clear   | Clears a HugeTLB                                 |
+--------------------------------------------------------------------------------
+| huge_ptep_set_wrprotect   | Converts into a write protected HugeTLB          |
+--------------------------------------------------------------------------------
+| huge_ptep_set_access_flags  | Converts into a more permissive HugeTLB        |
+--------------------------------------------------------------------------------
+
+========================
+SWAP Page Table Helpers
+========================
+
+--------------------------------------------------------------------------------
+| __pte_to_swp_entry        | Creates a swapped entry (arch) from a mapepd PTE |
+--------------------------------------------------------------------------------
+| __swp_to_pte_entry        | Creates a mapped PTE from a swapped entry (arch) |
+--------------------------------------------------------------------------------
+| __pmd_to_swp_entry        | Creates a swapped entry (arch) from a mapepd PMD |
+--------------------------------------------------------------------------------
+| __swp_to_pmd_entry        | Creates a mapped PMD from a swapped entry (arch) |
+--------------------------------------------------------------------------------
+| is_migration_entry        | Tests a migration (read or write) swapped entry  |
+--------------------------------------------------------------------------------
+| is_write_migration_entry  | Tests a write migration swapped entry            |
+--------------------------------------------------------------------------------
+| make_migration_entry_read | Converts into read migration swapped entry       |
+--------------------------------------------------------------------------------
+| make_migration_entry      | Creates a migration swapped entry (read or write)|
+--------------------------------------------------------------------------------
+
+[1] https://lore.kernel.org/linux-mm/20181017020930.GN30832@redhat.com/
--- a/mm/debug_vm_pgtable.c~documentation-mm-add-descriptions-for-arch-page-table-helpers
+++ a/mm/debug_vm_pgtable.c
@@ -31,6 +31,12 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
+/*
+ * Please refer Documentation/vm/arch_pgtable_helpers.rst for the semantics
+ * expectations that are being validated here. All future changes in here
+ * or the documentation need to be in sync.
+ */
+
 #define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
 
 /*
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
