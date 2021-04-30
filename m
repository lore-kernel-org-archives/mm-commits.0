Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED312C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C282461445
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3F0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhD3F0b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A141761434;
        Fri, 30 Apr 2021 05:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760343;
        bh=a9pi2yTzuH0TIdoErbiFrJGAI0tIQQAfQE7DHv3+weI=;
        h=Date:From:To:Subject:From;
        b=C4568ijXrvk/eSIFbcxmc1q5+zS4GFf5XCbRKgSos/ktLkVxxoXsJmW2RS1uSI5CW
         X8lisPfJ4bLxi33v/kwnXCj3owHUOjLZPPtOFaLjc4sLYa3oEOXbTwZzAT+fjrd4jT
         RYRG/lqMS552AWY6BfTTFn6zxqvRSjFKg9oylOE4=
Date:   Thu, 29 Apr 2021 22:25:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [folded-merged]
 x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch removed from -mm
 tree
Message-ID: <20210430052543.iHMe_hNBI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix
has been removed from the -mm tree.  Its filename was
     x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch

This patch was dropped because it was folded into x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix

It seems that we need to go back to the ifdef version as the IS_ENABLED
does not properly work and throws a warning.

Link: https://lkml.kernel.org/r/YGy++mSft7K4u+88@localhost.localdomain

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix
+++ a/arch/x86/mm/init_64.c
@@ -1068,15 +1068,16 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
-			} else if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
-				   vmemmap_pmd_is_unused(addr, next)) {
+			}
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+			else if (vmemmap_pmd_is_unused(addr, next)) {
 					free_hugepage_table(pmd_page(*pmd),
 							    altmap);
 					spin_lock(&init_mm.page_table_lock);
 					pmd_clear(pmd);
 					spin_unlock(&init_mm.page_table_lock);
 			}
-
+#endif
 			continue;
 		}
 
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
mmhugetlb-split-prep_new_huge_page-functionality.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
drivers-base-memory-introduce-memory_block_onlineoffline.patch
mmmemory_hotplug-relax-fully-spanned-sections-check.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

