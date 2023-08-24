Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AC7C6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjHXXvv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244064AbjHXXRg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664111FCA
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0ED160EF0
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55735C433C7;
        Thu, 24 Aug 2023 23:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919043;
        bh=jjhd2k6l68j0BjlSD0jkZgzq8kCul9DegyQjPnoJaCI=;
        h=Date:To:From:Subject:From;
        b=EhQuhpdSzeaJQ2rdtRWRuwa6s1G21IauvXZEUUAfEkt+6g89hBICN0ccbjf25v4wk
         PimUml4q9q6vtExXyE7BFDmF8r2EUIgD9iHy2dMOdUtkZR0Qmw76K6gQQSY3JWXD4S
         LIpEW/c+vwAPzAlrsYUMKKbBzyjZDUwlKs9IBSFI=
Date:   Thu, 24 Aug 2023 16:17:22 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-get_mctgt_type-kernel-doc-fix-2.patch removed from -mm tree
Message-Id: <20230824231723.55735C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-get_mctgt_type-kernel-doc-fix-2
has been removed from the -mm tree.  Its filename was
     mm-fix-get_mctgt_type-kernel-doc-fix-2.patch

This patch was dropped because it was folded into mm-fix-get_mctgt_type-kernel-doc.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-fix-get_mctgt_type-kernel-doc-fix-2
Date: Tue, 22 Aug 2023 21:25:25 +0100

Randy and I had a further discussion offline, and I added this change
too:

Link: https://lkml.kernel.org/r/ZOUZtZizeQG7PcsM@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-fix-get_mctgt_type-kernel-doc-fix-2
+++ a/mm/memcontrol.c
@@ -5867,10 +5867,10 @@ out:
  * * MC_TARGET_NONE - If the pte is not a target for move charge.
  * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
  *   move charge. If @target is not NULL, the page is stored in target->page
- *   with extra refcnt taken (Callers should handle it).
+ *   with extra refcnt taken (Caller should release it).
  * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
- *   target for charge migration.  If @target is not NULL, the entry is stored
- *   in target->ent.
+ *   target for charge migration.  If @target is not NULL, the entry is
+ *   stored in target->ent.
  * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
  *   thus not on the lru.  For now such page is charged like a regular page
  *   would be as it is just special memory taking the place of a regular page.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

