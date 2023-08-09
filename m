Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82145C001DE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Aug 2023 19:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjHITR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjHITRs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2023 15:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA02738
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 12:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B920B644D3
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 19:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17174C433C8;
        Wed,  9 Aug 2023 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691608647;
        bh=7gKE1MDQkh6K4o9UBaqWoiS3fmkmBU9VoSsNJDkr0lQ=;
        h=Date:To:From:Subject:From;
        b=Ej0rNZ+lKYnEenjt1WLaUx3crIvN98xGcqsJ0ePAFER4iDxNWH0t2xl8XvuW+ijBA
         PmBkV3T1vF8hUrgsSNL0aaI41DkuN35madUGNXitHLO01IIEmjDMS5NRa4PjzjDVjW
         EIsNdPvoMyTdmJrk6fQNJEi3meV7pTJJOnmNXkmA=
Date:   Wed, 09 Aug 2023 12:17:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-implement-the-new-page-table-range-api-fix.patch added to mm-unstable branch
Message-Id: <20230809191727.17174C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64-implement-the-new-page-table-range-api-fix
has been added to the -mm mm-unstable branch.  Its filename is
     ia64-implement-the-new-page-table-range-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-implement-the-new-page-table-range-api-fix.patch

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
Subject: ia64-implement-the-new-page-table-range-api-fix
Date: Wed, 9 Aug 2023 20:12:56 +0100

fix folio_size() handling

Link: https://lkml.kernel.org/r/ZNPlOCe8F+nrzPxr@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |    6 +++++-
 arch/ia64/mm/init.c             |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/ia64/hp/common/sba_iommu.c~ia64-implement-the-new-page-table-range-api-fix
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -811,12 +811,16 @@ static void mark_clean(void *addr, size_
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= folio_size(folio)) {
-		set_bit(PG_arch_1, &folio->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &folio->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }
--- a/arch/ia64/mm/init.c~ia64-implement-the-new-page-table-range-api-fix
+++ a/arch/ia64/mm/init.c
@@ -76,12 +76,16 @@ void arch_dma_mark_clean(phys_addr_t pad
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= (ssize_t)folio_size(folio)) {
-		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock-fix.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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

