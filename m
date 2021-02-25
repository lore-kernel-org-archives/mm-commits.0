Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE881C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C37564F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhBYTT3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhBYTRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFFB964F40;
        Thu, 25 Feb 2021 19:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280341;
        bh=VJdgU4dZkeWU+wekyagxaBGbyL8+a6y9hgJ5NmvElVg=;
        h=Date:From:To:Subject:From;
        b=rgnOsaUx0UU5s5yLX3zpB+SMVYJbNe/ohWAB6XAjy8Ax00pq1+DktoaY/1D4Qtp95
         g1lhW5qbhav5JhVle8K3WDMyd1j4H7GMJ8y3duTuK9jQJOhfo0dbFdKYhzfXh+bw/0
         tjmmZXsGTDKyy8wS3FODVhUuTA0AJQi5TI4ruxNc=
Date:   Thu, 25 Feb 2021 11:12:20 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, gerald.schaefer@de.ibm.com,
        gerald.schaefer@linux.ibm.com, mm-commits@vger.kernel.org,
        paul.walmsley@sifive.com, steven.price@arm.com, vgupta@synopsys.com
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-basic-add-validation-for-dirtiness-a?=
 =?US-ASCII?Q?fter-write-protect.patch?= removed from -mm tree
Message-ID: <20210225191220.k_62YBj0I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect

Patch series "mm/debug_vm_pgtable: Some minor updates", v3.

This series contains some cleanups and new test suggestions from Catalin
from an earlier discussion.

https://lore.kernel.org/linux-mm/20201123142237.GF17833@gaia/


This patch (of 2):

This adds validation tests for dirtiness after write protect conversion
for each page table level.  There are two new separate test types involved
here.

The first test ensures that a given page table entry does not become dirty
after pxx_wrprotect().  This is important for platforms like arm64 which
transfers and drops the hardware dirty bit (!PTE_RDONLY) to the software
dirty bit while making it an write protected one.  This test ensures that
no fresh page table entry could be created with hardware dirty bit set. 
The second test ensures that a given page table entry always preserve the
dirty information across pxx_wrprotect().

This adds two previously missing PUD level basic tests and while here
fixes pxx_wrprotect() related typos in the documentation file.

Link: https://lkml.kernel.org/r/1611137241-26220-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1611137241-26220-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> [s390]
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/arch_pgtable_helpers.rst |    8 ++--
 mm/debug_vm_pgtable.c                     |   39 ++++++++++++++++++++
 2 files changed, 43 insertions(+), 4 deletions(-)

--- a/Documentation/vm/arch_pgtable_helpers.rst~mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect
+++ a/Documentation/vm/arch_pgtable_helpers.rst
@@ -50,7 +50,7 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mkwrite               | Creates a writable PTE                           |
 +---------------------------+--------------------------------------------------+
-| pte_mkwrprotect           | Creates a write protected PTE                    |
+| pte_wrprotect             | Creates a write protected PTE                    |
 +---------------------------+--------------------------------------------------+
 | pte_mkspecial             | Creates a special PTE                            |
 +---------------------------+--------------------------------------------------+
@@ -120,7 +120,7 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_mkwrite               | Creates a writable PMD                           |
 +---------------------------+--------------------------------------------------+
-| pmd_mkwrprotect           | Creates a write protected PMD                    |
+| pmd_wrprotect             | Creates a write protected PMD                    |
 +---------------------------+--------------------------------------------------+
 | pmd_mkspecial             | Creates a special PMD                            |
 +---------------------------+--------------------------------------------------+
@@ -186,7 +186,7 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_mkwrite               | Creates a writable PUD                           |
 +---------------------------+--------------------------------------------------+
-| pud_mkwrprotect           | Creates a write protected PUD                    |
+| pud_wrprotect             | Creates a write protected PUD                    |
 +---------------------------+--------------------------------------------------+
 | pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
 +---------------------------+--------------------------------------------------+
@@ -224,7 +224,7 @@ HugeTLB Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | huge_pte_mkwrite          | Creates a writable HugeTLB                       |
 +---------------------------+--------------------------------------------------+
-| huge_pte_mkwrprotect      | Creates a write protected HugeTLB                |
+| huge_pte_wrprotect        | Creates a write protected HugeTLB                |
 +---------------------------+--------------------------------------------------+
 | huge_ptep_get_and_clear   | Clears a HugeTLB                                 |
 +---------------------------+--------------------------------------------------+
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect
+++ a/mm/debug_vm_pgtable.c
@@ -63,6 +63,16 @@ static void __init pte_basic_tests(unsig
 	pte_t pte = pfn_pte(pfn, prot);
 
 	pr_debug("Validating PTE basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pte() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pte_dirty(pte_wrprotect(pte)));
+
 	WARN_ON(!pte_same(pte, pte));
 	WARN_ON(!pte_young(pte_mkyoung(pte_mkold(pte))));
 	WARN_ON(!pte_dirty(pte_mkdirty(pte_mkclean(pte))));
@@ -70,6 +80,8 @@ static void __init pte_basic_tests(unsig
 	WARN_ON(pte_young(pte_mkold(pte_mkyoung(pte))));
 	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte))));
+	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
+	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }
 
 static void __init pte_advanced_tests(struct mm_struct *mm,
@@ -137,6 +149,17 @@ static void __init pmd_basic_tests(unsig
 		return;
 
 	pr_debug("Validating PMD basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pmd() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pmd_dirty(pmd_wrprotect(pmd)));
+
+
 	WARN_ON(!pmd_same(pmd, pmd));
 	WARN_ON(!pmd_young(pmd_mkyoung(pmd_mkold(pmd))));
 	WARN_ON(!pmd_dirty(pmd_mkdirty(pmd_mkclean(pmd))));
@@ -144,6 +167,8 @@ static void __init pmd_basic_tests(unsig
 	WARN_ON(pmd_young(pmd_mkold(pmd_mkyoung(pmd))));
 	WARN_ON(pmd_dirty(pmd_mkclean(pmd_mkdirty(pmd))));
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd))));
+	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
@@ -257,11 +282,25 @@ static void __init pud_basic_tests(unsig
 		return;
 
 	pr_debug("Validating PUD basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pud() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pud_dirty(pud_wrprotect(pud)));
+
 	WARN_ON(!pud_same(pud, pud));
 	WARN_ON(!pud_young(pud_mkyoung(pud_mkold(pud))));
+	WARN_ON(!pud_dirty(pud_mkdirty(pud_mkclean(pud))));
+	WARN_ON(pud_dirty(pud_mkclean(pud_mkdirty(pud))));
 	WARN_ON(!pud_write(pud_mkwrite(pud_wrprotect(pud))));
 	WARN_ON(pud_write(pud_wrprotect(pud_mkwrite(pud))));
 	WARN_ON(pud_young(pud_mkold(pud_mkyoung(pud))));
+	WARN_ON(pud_dirty(pud_wrprotect(pud_mkclean(pud))));
+	WARN_ON(!pud_dirty(pud_wrprotect(pud_mkdirty(pud))));
 
 	if (mm_pmd_folded(mm))
 		return;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
arm64-mm-define-arch_get_mappable_range.patch
s390-mm-define-arch_get_mappable_range.patch

