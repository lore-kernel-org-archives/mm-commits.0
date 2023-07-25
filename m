Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB43C001DE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjGYTbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjGYTbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76445FE
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E1761890
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFB6C433C7;
        Tue, 25 Jul 2023 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313470;
        bh=YwXuivWRxX/CPUom5bXajsBkRV9dkCmVkLO5tJvHJm8=;
        h=Date:To:From:Subject:From;
        b=SvIEVs5CYKIB/BuA730KXOL/qsoGgHXPq3CmXUxut6zo3mXlUFVLgkVGGGMO9PAjZ
         DCpxzR1sXlt5L8iYkf7S83PUpnenc6gozSq0Xp4JF0KNQaiYU+yIf/6ZNkSUXXsR+7
         ZqwvIg9tF4YLwPpVUy59/yCJJUuK3/6GXD42W3XU=
Date:   Tue, 25 Jul 2023 12:31:09 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch added to mm-unstable branch
Message-Id: <20230725193110.5DFB6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change pudp_huge_get_and_clear_full take vm_area_struct as arg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch

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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm: change pudp_huge_get_and_clear_full take vm_area_struct as arg
Date: Tue, 25 Jul 2023 00:37:48 +0530

We will use this in a later patch to do tlb flush when clearing pud
entries on powerpc.  This is similar to commit 93a98695f2f9 ("mm: change
pmdp_huge_get_and_clear_full take vm_area_struct as arg")

Link: https://lkml.kernel.org/r/20230724190759.483013-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 ++--
 mm/debug_vm_pgtable.c   |    2 +-
 mm/huge_memory.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/pgtable.h~mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg
+++ a/include/linux/pgtable.h
@@ -456,11 +456,11 @@ static inline pmd_t pmdp_huge_get_and_cl
 #endif
 
 #ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR_FULL
-static inline pud_t pudp_huge_get_and_clear_full(struct mm_struct *mm,
+static inline pud_t pudp_huge_get_and_clear_full(struct vm_area_struct *vma,
 					    unsigned long address, pud_t *pudp,
 					    int full)
 {
-	return pudp_huge_get_and_clear(mm, address, pudp);
+	return pudp_huge_get_and_clear(vma->vm_mm, address, pudp);
 }
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
--- a/mm/debug_vm_pgtable.c~mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg
+++ a/mm/debug_vm_pgtable.c
@@ -385,7 +385,7 @@ static void __init pud_advanced_tests(st
 	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pudp_huge_get_and_clear_full(args->mm, vaddr, args->pudp, 1);
+	pudp_huge_get_and_clear_full(args->vma, vaddr, args->pudp, 1);
 	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
--- a/mm/huge_memory.c~mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg
+++ a/mm/huge_memory.c
@@ -1981,7 +1981,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	if (!ptl)
 		return 0;
 
-	pudp_huge_get_and_clear_full(tlb->mm, addr, pud, tlb->fullmm);
+	pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
 	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

