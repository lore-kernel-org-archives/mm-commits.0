Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB5C3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbjHXXHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244021AbjHXXG6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:06:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65DE1981
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA886303C
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CB6C433C7;
        Thu, 24 Aug 2023 23:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918414;
        bh=rAkFd874aQDG5I365kMwH5wpHeycjMCvz19s8oyKkjU=;
        h=Date:To:From:Subject:From;
        b=pa5IXWeYAcQG9RHu6yRDRaaRBV3fJ82karClCucrGFEe/JyHDROZYATB0xaSyuZLH
         XHzi7fXHeTEsTvAugXdnMNjYxETCJ2LnXYIZBwJ1d6dtvbYEBb5qQ2Ty1T23JdBfVa
         CwF8y6YhzK2j3Z1Ee95YPGoU7Dy/KklNWpScOHeI=
Date:   Thu, 24 Aug 2023 16:06:53 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        conor.dooley@microchip.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch removed from -mm tree
Message-Id: <20230824230654.A1CB6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch

This patch was dropped because it was folded into mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
Date: Tue, 25 Jul 2023 15:31:17 +0100

fix riscv

Link: https://lkml.kernel.org/r/CAJuCfpE6GWEx1rPBmNpUfoD5o-gNFz9-UFywzCE2PbEGBiVz7g@mail.gmail.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
  Closes: https://lkml.kernel.org/r/20230725-anaconda-that-ac3f79880af1@wendy
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
+++ a/arch/riscv/mm/fault.c
@@ -296,7 +296,8 @@ void handle_page_fault(struct pt_regs *r
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
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
mm-remove-enum-page_entry_size-fix.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

