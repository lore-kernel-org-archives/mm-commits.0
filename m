Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15B1C3DA6F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 21:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbjHWVY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 17:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbjHWVYQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 17:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33E710D0
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 14:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 810B563633
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 21:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913FCC433C8;
        Wed, 23 Aug 2023 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692825853;
        bh=VyceuHPeBqEzmtXaldPZfAg09gf8h6zP5+OYZNHZKGo=;
        h=Date:To:From:Subject:From;
        b=KOC6Hhyd9P++rY94rwirXPJR0DLd/FcGF2ksxCXBeV+0t2HQ4MYb3maSqHjpq6z0A
         FCyM933iQHbyIqH6TcVn5tj6jON/DLD2Hhgaq37gvWiTVZM+BMAHUn4rdTChMdZwr5
         mqi/KIM/KKxEuK3oUHVdIt5jKtA7TJYvCdAVZIaI=
Date:   Wed, 23 Aug 2023 14:24:12 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-get_mctgt_type-kernel-doc-fix-2.patch added to mm-unstable branch
Message-Id: <20230823212413.913FCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-get_mctgt_type-kernel-doc-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-get_mctgt_type-kernel-doc-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-get_mctgt_type-kernel-doc-fix-2.patch

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
@@ -5855,10 +5855,10 @@ out:
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
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api-fix-2.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
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
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch

