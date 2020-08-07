Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3F0C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34922177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781171;
	bh=t1meuJS9gVKSggsdND/htzTiHPaD/GvbXNGvZ8IM2ig=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=m6uzbXW9XijzTYiqcLJcLN7b6Y8p3+2zfilNDDxEzcqCQgqumNVeuh2MlsbXVV7Vh
	 Hmxo/E+Gi6zXpWg8kzauFg8K3TN7eHs+PIAr2m/Y6OVqGrwV3fQe38r6Szqoo89+sq
	 gHtnT0zYSjZLyTaGA2KkqbgdcjBhVlQg/cdx4FU8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGTb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5347122C9F;
        Fri,  7 Aug 2020 06:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781170;
        bh=t1meuJS9gVKSggsdND/htzTiHPaD/GvbXNGvZ8IM2ig=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uEsNrWY83cj8CgQTqxOQn6+VGBSFsD+FC79kVfgJ+RWQN2o9/xB6s54/z7bsyb4At
         L+NuCvHsApu8qn524AVmNXyGaX7zc/HhIauHkpYkLtABCuAqOIfmOEnVdjKcGppuIk
         j2bv98MuOpFi5JqvAH/Mw5I1ILTDFS6y2ADBj3Yo=
Date:   Thu, 06 Aug 2020 23:19:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, corbet@lwn.net, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, hpa@zytor.com, kirill@shutemov.name,
        linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, rppt@kernel.org, rppt@linux.ibm.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        vgupta@synopsys.com, will@kernel.org, ziy@nvidia.com
Subject:  [patch 043/163] Documentation/mm: add descriptions for
 arch page table helpers
Message-ID: <20200807061928.owCi0L_UF%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Documentation/mm: add descriptions for arch page table helpers

This adds a specific description file for all arch page table helpers which
is in sync with the semantics being tested via CONFIG_DEBUG_VM_PGTABLE. All
future changes either to these descriptions here or the debug test should
always remain in sync.

[anshuman.khandual@arm.com: fold in Mike's patch for the rst document, fix typos in the rst document]
  Link: http://lkml.kernel.org/r/1594610587-4172-5-git-send-email-anshuman.khandual@arm.com
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
++---------------------------+--------------------------------------------------+
+| pte_same                  | Tests whether both PTE entries are the same      |
++---------------------------+--------------------------------------------------+
+| pte_bad                   | Tests a non-table mapped PTE                     |
++---------------------------+--------------------------------------------------+
+| pte_present               | Tests a valid mapped PTE                         |
++---------------------------+--------------------------------------------------+
+| pte_young                 | Tests a young PTE                                |
++---------------------------+--------------------------------------------------+
+| pte_dirty                 | Tests a dirty PTE                                |
++---------------------------+--------------------------------------------------+
+| pte_write                 | Tests a writable PTE                             |
++---------------------------+--------------------------------------------------+
+| pte_special               | Tests a special PTE                              |
++---------------------------+--------------------------------------------------+
+| pte_protnone              | Tests a PROT_NONE PTE                            |
++---------------------------+--------------------------------------------------+
+| pte_devmap                | Tests a ZONE_DEVICE mapped PTE                   |
++---------------------------+--------------------------------------------------+
+| pte_soft_dirty            | Tests a soft dirty PTE                           |
++---------------------------+--------------------------------------------------+
+| pte_swp_soft_dirty        | Tests a soft dirty swapped PTE                   |
++---------------------------+--------------------------------------------------+
+| pte_mkyoung               | Creates a young PTE                              |
++---------------------------+--------------------------------------------------+
+| pte_mkold                 | Creates an old PTE                               |
++---------------------------+--------------------------------------------------+
+| pte_mkdirty               | Creates a dirty PTE                              |
++---------------------------+--------------------------------------------------+
+| pte_mkclean               | Creates a clean PTE                              |
++---------------------------+--------------------------------------------------+
+| pte_mkwrite               | Creates a writable PTE                           |
++---------------------------+--------------------------------------------------+
+| pte_mkwrprotect           | Creates a write protected PTE                    |
++---------------------------+--------------------------------------------------+
+| pte_mkspecial             | Creates a special PTE                            |
++---------------------------+--------------------------------------------------+
+| pte_mkdevmap              | Creates a ZONE_DEVICE mapped PTE                 |
++---------------------------+--------------------------------------------------+
+| pte_mksoft_dirty          | Creates a soft dirty PTE                         |
++---------------------------+--------------------------------------------------+
+| pte_clear_soft_dirty      | Clears a soft dirty PTE                          |
++---------------------------+--------------------------------------------------+
+| pte_swp_mksoft_dirty      | Creates a soft dirty swapped PTE                 |
++---------------------------+--------------------------------------------------+
+| pte_swp_clear_soft_dirty  | Clears a soft dirty swapped PTE                  |
++---------------------------+--------------------------------------------------+
+| pte_mknotpresent          | Invalidates a mapped PTE                         |
++---------------------------+--------------------------------------------------+
+| ptep_get_and_clear        | Clears a PTE                                     |
++---------------------------+--------------------------------------------------+
+| ptep_get_and_clear_full   | Clears a PTE                                     |
++---------------------------+--------------------------------------------------+
+| ptep_test_and_clear_young | Clears young from a PTE                          |
++---------------------------+--------------------------------------------------+
+| ptep_set_wrprotect        | Converts into a write protected PTE              |
++---------------------------+--------------------------------------------------+
+| ptep_set_access_flags     | Converts into a more permissive PTE              |
++---------------------------+--------------------------------------------------+
+
+======================
+PMD Page Table Helpers
+======================
+
++---------------------------+--------------------------------------------------+
+| pmd_same                  | Tests whether both PMD entries are the same      |
++---------------------------+--------------------------------------------------+
+| pmd_bad                   | Tests a non-table mapped PMD                     |
++---------------------------+--------------------------------------------------+
+| pmd_leaf                  | Tests a leaf mapped PMD                          |
++---------------------------+--------------------------------------------------+
+| pmd_huge                  | Tests a HugeTLB mapped PMD                       |
++---------------------------+--------------------------------------------------+
+| pmd_trans_huge            | Tests a Transparent Huge Page (THP) at PMD       |
++---------------------------+--------------------------------------------------+
+| pmd_present               | Tests a valid mapped PMD                         |
++---------------------------+--------------------------------------------------+
+| pmd_young                 | Tests a young PMD                                |
++---------------------------+--------------------------------------------------+
+| pmd_dirty                 | Tests a dirty PMD                                |
++---------------------------+--------------------------------------------------+
+| pmd_write                 | Tests a writable PMD                             |
++---------------------------+--------------------------------------------------+
+| pmd_special               | Tests a special PMD                              |
++---------------------------+--------------------------------------------------+
+| pmd_protnone              | Tests a PROT_NONE PMD                            |
++---------------------------+--------------------------------------------------+
+| pmd_devmap                | Tests a ZONE_DEVICE mapped PMD                   |
++---------------------------+--------------------------------------------------+
+| pmd_soft_dirty            | Tests a soft dirty PMD                           |
++---------------------------+--------------------------------------------------+
+| pmd_swp_soft_dirty        | Tests a soft dirty swapped PMD                   |
++---------------------------+--------------------------------------------------+
+| pmd_mkyoung               | Creates a young PMD                              |
++---------------------------+--------------------------------------------------+
+| pmd_mkold                 | Creates an old PMD                               |
++---------------------------+--------------------------------------------------+
+| pmd_mkdirty               | Creates a dirty PMD                              |
++---------------------------+--------------------------------------------------+
+| pmd_mkclean               | Creates a clean PMD                              |
++---------------------------+--------------------------------------------------+
+| pmd_mkwrite               | Creates a writable PMD                           |
++---------------------------+--------------------------------------------------+
+| pmd_mkwrprotect           | Creates a write protected PMD                    |
++---------------------------+--------------------------------------------------+
+| pmd_mkspecial             | Creates a special PMD                            |
++---------------------------+--------------------------------------------------+
+| pmd_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
++---------------------------+--------------------------------------------------+
+| pmd_mksoft_dirty          | Creates a soft dirty PMD                         |
++---------------------------+--------------------------------------------------+
+| pmd_clear_soft_dirty      | Clears a soft dirty PMD                          |
++---------------------------+--------------------------------------------------+
+| pmd_swp_mksoft_dirty      | Creates a soft dirty swapped PMD                 |
++---------------------------+--------------------------------------------------+
+| pmd_swp_clear_soft_dirty  | Clears a soft dirty swapped PMD                  |
++---------------------------+--------------------------------------------------+
+| pmd_mkinvalid             | Invalidates a mapped PMD [1]                     |
++---------------------------+--------------------------------------------------+
+| pmd_set_huge              | Creates a PMD huge mapping                       |
++---------------------------+--------------------------------------------------+
+| pmd_clear_huge            | Clears a PMD huge mapping                        |
++---------------------------+--------------------------------------------------+
+| pmdp_get_and_clear        | Clears a PMD                                     |
++---------------------------+--------------------------------------------------+
+| pmdp_get_and_clear_full   | Clears a PMD                                     |
++---------------------------+--------------------------------------------------+
+| pmdp_test_and_clear_young | Clears young from a PMD                          |
++---------------------------+--------------------------------------------------+
+| pmdp_set_wrprotect        | Converts into a write protected PMD              |
++---------------------------+--------------------------------------------------+
+| pmdp_set_access_flags     | Converts into a more permissive PMD              |
++---------------------------+--------------------------------------------------+
+
+======================
+PUD Page Table Helpers
+======================
+
++---------------------------+--------------------------------------------------+
+| pud_same                  | Tests whether both PUD entries are the same      |
++---------------------------+--------------------------------------------------+
+| pud_bad                   | Tests a non-table mapped PUD                     |
++---------------------------+--------------------------------------------------+
+| pud_leaf                  | Tests a leaf mapped PUD                          |
++---------------------------+--------------------------------------------------+
+| pud_huge                  | Tests a HugeTLB mapped PUD                       |
++---------------------------+--------------------------------------------------+
+| pud_trans_huge            | Tests a Transparent Huge Page (THP) at PUD       |
++---------------------------+--------------------------------------------------+
+| pud_present               | Tests a valid mapped PUD                         |
++---------------------------+--------------------------------------------------+
+| pud_young                 | Tests a young PUD                                |
++---------------------------+--------------------------------------------------+
+| pud_dirty                 | Tests a dirty PUD                                |
++---------------------------+--------------------------------------------------+
+| pud_write                 | Tests a writable PUD                             |
++---------------------------+--------------------------------------------------+
+| pud_devmap                | Tests a ZONE_DEVICE mapped PUD                   |
++---------------------------+--------------------------------------------------+
+| pud_mkyoung               | Creates a young PUD                              |
++---------------------------+--------------------------------------------------+
+| pud_mkold                 | Creates an old PUD                               |
++---------------------------+--------------------------------------------------+
+| pud_mkdirty               | Creates a dirty PUD                              |
++---------------------------+--------------------------------------------------+
+| pud_mkclean               | Creates a clean PUD                              |
++---------------------------+--------------------------------------------------+
+| pud_mkwrite               | Creates a writable PUD                           |
++---------------------------+--------------------------------------------------+
+| pud_mkwrprotect           | Creates a write protected PUD                    |
++---------------------------+--------------------------------------------------+
+| pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
++---------------------------+--------------------------------------------------+
+| pud_mkinvalid             | Invalidates a mapped PUD [1]                     |
++---------------------------+--------------------------------------------------+
+| pud_set_huge              | Creates a PUD huge mapping                       |
++---------------------------+--------------------------------------------------+
+| pud_clear_huge            | Clears a PUD huge mapping                        |
++---------------------------+--------------------------------------------------+
+| pudp_get_and_clear        | Clears a PUD                                     |
++---------------------------+--------------------------------------------------+
+| pudp_get_and_clear_full   | Clears a PUD                                     |
++---------------------------+--------------------------------------------------+
+| pudp_test_and_clear_young | Clears young from a PUD                          |
++---------------------------+--------------------------------------------------+
+| pudp_set_wrprotect        | Converts into a write protected PUD              |
++---------------------------+--------------------------------------------------+
+| pudp_set_access_flags     | Converts into a more permissive PUD              |
++---------------------------+--------------------------------------------------+
+
+==========================
+HugeTLB Page Table Helpers
+==========================
+
++---------------------------+--------------------------------------------------+
+| pte_huge                  | Tests a HugeTLB                                  |
++---------------------------+--------------------------------------------------+
+| pte_mkhuge                | Creates a HugeTLB                                |
++---------------------------+--------------------------------------------------+
+| huge_pte_dirty            | Tests a dirty HugeTLB                            |
++---------------------------+--------------------------------------------------+
+| huge_pte_write            | Tests a writable HugeTLB                         |
++---------------------------+--------------------------------------------------+
+| huge_pte_mkdirty          | Creates a dirty HugeTLB                          |
++---------------------------+--------------------------------------------------+
+| huge_pte_mkwrite          | Creates a writable HugeTLB                       |
++---------------------------+--------------------------------------------------+
+| huge_pte_mkwrprotect      | Creates a write protected HugeTLB                |
++---------------------------+--------------------------------------------------+
+| huge_ptep_get_and_clear   | Clears a HugeTLB                                 |
++---------------------------+--------------------------------------------------+
+| huge_ptep_set_wrprotect   | Converts into a write protected HugeTLB          |
++---------------------------+--------------------------------------------------+
+| huge_ptep_set_access_flags  | Converts into a more permissive HugeTLB        |
++---------------------------+--------------------------------------------------+
+
+========================
+SWAP Page Table Helpers
+========================
+
++---------------------------+--------------------------------------------------+
+| __pte_to_swp_entry        | Creates a swapped entry (arch) from a mapped PTE |
++---------------------------+--------------------------------------------------+
+| __swp_to_pte_entry        | Creates a mapped PTE from a swapped entry (arch) |
++---------------------------+--------------------------------------------------+
+| __pmd_to_swp_entry        | Creates a swapped entry (arch) from a mapped PMD |
++---------------------------+--------------------------------------------------+
+| __swp_to_pmd_entry        | Creates a mapped PMD from a swapped entry (arch) |
++---------------------------+--------------------------------------------------+
+| is_migration_entry        | Tests a migration (read or write) swapped entry  |
++---------------------------+--------------------------------------------------+
+| is_write_migration_entry  | Tests a write migration swapped entry            |
++---------------------------+--------------------------------------------------+
+| make_migration_entry_read | Converts into read migration swapped entry       |
++---------------------------+--------------------------------------------------+
+| make_migration_entry      | Creates a migration swapped entry (read or write)|
++---------------------------+--------------------------------------------------+
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
