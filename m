Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC108C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2D8613A9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhDGEDv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Apr 2021 00:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhDGEDv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Apr 2021 00:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956D46124C;
        Wed,  7 Apr 2021 04:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617768222;
        bh=p3kMjzyFWLwFTetAR1ATR+vIRcnf3Zduu+vp1qU/MNk=;
        h=Date:From:To:Subject:From;
        b=oh3d8C5AjJu5xDKP50ZPksnEhfqdvRaZUAvRbfh6cfjlWyG7Dw7ZIny24xPi0G5xh
         wufLaelE4UawX7+M1Q9r0OK6sh86tW7Pj8rsHsWZxOySLt3Y16iXJZcD3gKwg25ZkQ
         OoJHQZyo3HrOOONhvH+fKxd0sOvRz91Qne9dKfVU=
Date:   Tue, 06 Apr 2021 21:03:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  + x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
 added to -mm tree
Message-ID: <20210407040342.4b3B2HrqA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix
has been added to the -mm tree.  Its filename is
     x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

