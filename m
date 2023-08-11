Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BA9C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbjHKWhw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9821FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B28064E62
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C9AC433C7;
        Fri, 11 Aug 2023 22:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793470;
        bh=9isF4fWoYEvMFPDDNVhvtFsYsyHDM6zhVsuh99UJ9yA=;
        h=Date:To:From:Subject:From;
        b=M8aPtljLqGvneeRxL7AVNKjHzkdrQ9jNkGhVPDk8OxMQPcGrXrpq2QsWl34Zy7nZA
         4rd0jkqpxciO/WwdJGY5UPTE4AS3JrSRGodZP98rWjzwOe8rS23mcBz98PFm2ZJPki
         7fkH/65v41HncboolXSL+ce1upAq7hERvumDJDdg=
Date:   Fri, 11 Aug 2023 15:37:50 -0700
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch removed from -mm tree
Message-Id: <20230811223750.A0C9AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm: fix kernel build error
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch

This patch was dropped because it was folded into powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: fix kernel build error
Date: Fri, 28 Jul 2023 15:36:53 +0530

  CC      arch/powerpc/mm/init_64.o
src/linux/arch/powerpc/mm/init_64.c:324:12: error: no previous prototype for __vmemmap_free() [-Werror=missing-prototypes]
  324 | void __ref __vmemmap_free(unsigned long start, unsigned long end,

Link: https://lkml.kernel.org/r/877cqkwd20.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/init_64.c~powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2
+++ a/arch/powerpc/mm/init_64.c
@@ -308,8 +308,8 @@ static unsigned long vmemmap_list_free(u
 	return vmem_back->phys;
 }
 
-void __ref __vmemmap_free(unsigned long start, unsigned long end,
-			  struct vmem_altmap *altmap)
+static void __ref __vmemmap_free(unsigned long start, unsigned long end,
+				 struct vmem_altmap *altmap)
 {
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
 	unsigned long page_order = get_order(page_size);
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
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch
mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

