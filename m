Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFC1C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbjHKXGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbjHKXFG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD535A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CDF679F8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068DEC433C7;
        Fri, 11 Aug 2023 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794992;
        bh=/jhTPLh937gpfMBWcCRS1s4QIixQik7a//NomVuIdY4=;
        h=Date:To:From:Subject:From;
        b=Nq5+pNj4xsYphZrRrOAsCjpoUxmsBm2VI8Nlm7PfnrIQnxWJpEGQ1UwwdVa3mQXaU
         m0nZb/gFxnvVy7PlPlsS9B58TcVJI9RyhqtLkyQ2E1C4EO7QTy5Aj35ZC6CyoEn0Ym
         a7XPod/2ZJKmr020IylnIulbgF0o6xOR+BczaOjg=
Date:   Fri, 11 Aug 2023 16:03:11 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch removed from -mm tree
Message-Id: <20230811230312.068DEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change pudp_huge_get_and_clear_full take vm_area_struct as arg
has been removed from the -mm tree.  Its filename was
     mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

