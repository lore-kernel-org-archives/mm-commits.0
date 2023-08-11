Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A41C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbjHKXGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbjHKXFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA313C3C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA9D65772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C86C433C7;
        Fri, 11 Aug 2023 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691795007;
        bh=qOGRJbZQsqxBjUut++3mm6Z/QraxkDjR89QOuiQB93U=;
        h=Date:To:From:Subject:From;
        b=eJ3KfA0d1h0nnCCMAE9ISe4BFnhhdB/ka8ssxz1gajx8w3/Mei7TGVzMtG7Z7Na6x
         bn6dOkDje+FHObatiIf4ayRQrAAr3AqOx/CEHQQcvxetJplOw2m8CRad0JY4ezWwcl
         Rj1nUK5C4Sjn4RJCJ/pJEzJ+yXdgnSCXkEoq+18o=
Date:   Fri, 11 Aug 2023 16:03:26 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch removed from -mm tree
Message-Id: <20230811230326.E7C86C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/book3s64/radix: add debug message to give more details of vmemmap allocation
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

