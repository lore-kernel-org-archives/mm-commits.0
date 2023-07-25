Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A973FC001DF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjGYTb6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjGYTbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DD5211E
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 372D36189B
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB80C433C8;
        Tue, 25 Jul 2023 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313501;
        bh=+R/o6Fw+jCHxzAtdCyHtqpKMLs6rfKWjQxBuAz/5D8M=;
        h=Date:To:From:Subject:From;
        b=IC/SwUUqtGrtj2ud+HByCEA9+KT9nzCSDDQYuNg/i68n5H3VpNCab7xzPhletdOaP
         cdotIpyexPgDGxHtD1TcTXiUyEjyRXY6FGOluGD3yGeKPAZeT4Tr5zjTl6+sRTQw6u
         VD0eDurE88PtqbEd6QJyMXqyCKQ4rjUnnrebnGsg=
Date:   Tue, 25 Jul 2023 12:31:40 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch added to mm-unstable branch
Message-Id: <20230725193141.8CB80C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/book3s64/radix: add debug message to give more details of vmemmap allocation
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

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
Subject: powerpc/book3s64/radix: add debug message to give more details of vmemmap allocation
Date: Tue, 25 Jul 2023 00:37:59 +0530

Add some extra vmemmap pr_debug message that will indicate the type of
vmemmap allocations.

For ex: with DAX vmemmap optimization we can find the below details:
[  187.166580] radix-mmu: PAGE_SIZE vmemmap mapping
[  187.166587] radix-mmu: PAGE_SIZE vmemmap mapping
[  187.166591] radix-mmu: Tail page reuse vmemmap mapping
[  187.166594] radix-mmu: Tail page reuse vmemmap mapping
[  187.166598] radix-mmu: Tail page reuse vmemmap mapping
[  187.166601] radix-mmu: Tail page reuse vmemmap mapping
[  187.166604] radix-mmu: Tail page reuse vmemmap mapping
[  187.166608] radix-mmu: Tail page reuse vmemmap mapping
[  187.166611] radix-mmu: Tail page reuse vmemmap mapping
[  187.166614] radix-mmu: Tail page reuse vmemmap mapping
[  187.166617] radix-mmu: Tail page reuse vmemmap mapping
[  187.166620] radix-mmu: Tail page reuse vmemmap mapping
[  187.166623] radix-mmu: Tail page reuse vmemmap mapping
[  187.166626] radix-mmu: Tail page reuse vmemmap mapping
[  187.166629] radix-mmu: Tail page reuse vmemmap mapping
[  187.166632] radix-mmu: Tail page reuse vmemmap mapping

And without vmemmap optimization
[  293.549931] radix-mmu: PMD_SIZE vmemmap mapping
[  293.549984] radix-mmu: PMD_SIZE vmemmap mapping
[  293.550032] radix-mmu: PMD_SIZE vmemmap mapping
[  293.550076] radix-mmu: PMD_SIZE vmemmap mapping
[  293.550117] radix-mmu: PMD_SIZE vmemmap mapping

Link: https://lkml.kernel.org/r/20230724190759.483013-14-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 arch/powerpc/mm/book3s64/radix_pgtable.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1033,6 +1033,7 @@ static pte_t * __meminit radix__vmemmap_
 				p = vmemmap_alloc_block_buf(PAGE_SIZE, node, NULL);
 			if (!p)
 				return NULL;
+			pr_debug("PAGE_SIZE vmemmap mapping\n");
 		} else {
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
@@ -1045,6 +1046,7 @@ static pte_t * __meminit radix__vmemmap_
 			 */
 			get_page(reuse);
 			p = page_to_virt(reuse);
+			pr_debug("Tail page reuse vmemmap mapping\n");
 		}
 
 		VM_BUG_ON(!PAGE_ALIGNED(addr));
@@ -1154,6 +1156,7 @@ int __meminit radix__vmemmap_populate(un
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
 			if (p) {
 				vmemmap_set_pmd(pmd, p, node, addr, next);
+				pr_debug("PMD_SIZE vmemmap mapping\n");
 				continue;
 			} else if (altmap) {
 				/*
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

