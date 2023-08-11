Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77202C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjHKWii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWii (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:38:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7BF1FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FA963AA9
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8377C433C8;
        Fri, 11 Aug 2023 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793516;
        bh=zISdvmry2NGOdif+nALOh/Vkl9yFt6srfl1EAnatuVE=;
        h=Date:To:From:Subject:From;
        b=eyfRvyechiRB4LIlD0wrUZmRluzi0ywZ5mNpsvjzqvWtwUI0fD2pkkUlM4gOdXraH
         VyVsxjuQByTgM/J4TvKUvbjti7++bTDnmrFnfYbPANKj03YbvGxburbcHn4Q3jSo/7
         gVvW/lgL68aZaa0kElo1lyeJt100zQG1M55dYOzU=
Date:   Fri, 11 Aug 2023 15:38:36 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch removed from -mm tree
Message-Id: <20230811223836.B8377C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch

This patch was dropped because it was folded into powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
Date: Wed, 26 Jul 2023 10:52:33 +0530

We should look at ppc64 not including radix headers if
CONFIG_PPC_RADIX_MMU is disabled.

Link: https://lkml.kernel.org/r/87zg3jw8km.fsf@linux.ibm.com
Signed-off-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/radix.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/radix.h~powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -364,8 +364,10 @@ int radix__remove_section_mapping(unsign
 
 void radix__kernel_map_pages(struct page *page, int numpages, int enable);
 
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+#endif
 
 #define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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
powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch
mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

