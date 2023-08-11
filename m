Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B46C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjHKWhv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CEE1FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DC963AA9
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C441C433C8;
        Fri, 11 Aug 2023 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793469;
        bh=LTNEMRR7ioKsQPpGGkeXeDYmbx5VIuI4UxO4PMs802c=;
        h=Date:To:From:Subject:From;
        b=AKR3afoe/lNJmP4Wv7bU1357SiRE67IQ+Xkh3GwildCDs0AF3qwjvwCoRzJWOPdps
         LakbRVw4QeduBPgkV2dUxkWYGqgbY9ti9JH3nbAWphTXfRWWSEspkLTIge7fekpoJ5
         z55BVnrKrk8B6sW8rJiPNZCK94mJ22pF3I3dPD8M=
Date:   Fri, 11 Aug 2023 15:37:48 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch removed from -mm tree
Message-Id: <20230811223749.6C441C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch

This patch was dropped because it was folded into powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: fix section mismatch warning
Date: Thu, 27 Jul 2023 10:16:19 +0530

remove_pte_table is only called from remove_pmd_table which is marked
__meminit.  These functions are used only during memory hotplug and they
also call functions marked __meminit.  Mark remote_pte_table also with
__meminit so that we can avoid the section mismatch warning below.

WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x230 (section: .text.remove_pte_table) -> free_vmemmap_pages (section: .meminit.text)
WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x43c (section: .text.remove_pte_table) -> vmemmap_populated (section: .meminit.text)
WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x4a4 (section: .text.remove_pte_table) -> free_vmemmap_pages (section: .meminit.text)

Link: https://lkml.kernel.org/r/87h6pqvu5g.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
  Closes: https://lkml.kernel.org/r/20230727142844.5e00c84d@canb.auug.org.au
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -793,9 +793,9 @@ static void __meminit free_vmemmap_pages
 		free_pages((unsigned long)page_address(page), order);
 }
 
-static void remove_pte_table(pte_t *pte_start, unsigned long addr,
-			     unsigned long end, bool direct,
-			     struct vmem_altmap *altmap)
+static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
+				       unsigned long end, bool direct,
+				       struct vmem_altmap *altmap)
 {
 	unsigned long next, pages = 0;
 	pte_t *pte;
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
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch
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

