Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1420AEE4993
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 17:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjHVR4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 13:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjHVR4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 13:56:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B21310E4
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 10:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9148F614EE
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 17:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC976C433C7;
        Tue, 22 Aug 2023 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692727000;
        bh=IxhpariXmM6j8eSU4+gmJJLElpTiHuAsqQed1IFUH3g=;
        h=Date:To:From:Subject:From;
        b=M1fGxptSpD8KMtiM9eDb665oDrqi0inEqiQ/7c2v7GcKEwl1cvqoRbeG3EJsilIpM
         8TRjOQaL7J5xgeYMp/vgHK6KG7L7RPw746KCqWbCet2AR0hvboWZIYA727QGuzM2mp
         Y2RclpyicydquZL8W6qSFAHMNGS3HkLccn1KqEXw=
Date:   Tue, 22 Aug 2023 10:56:38 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-add-documentation-for-vma_kernel_pagesize.patch added to mm-unstable branch
Message-Id: <20230822175639.DC976C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add documentation for vma_kernel_pagesize()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-add-documentation-for-vma_kernel_pagesize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-add-documentation-for-vma_kernel_pagesize.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: add documentation for vma_kernel_pagesize()
Date: Tue, 22 Aug 2023 18:24:59 +0100

This is an exported symbol, so it should have kernel-doc.  Update it to
mention folios, and point out that they might be larger than the supported
page size for this VMA.

Link: https://lkml.kernel.org/r/20230822172459.4190699-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-documentation-for-vma_kernel_pagesize
+++ a/mm/hugetlb.c
@@ -968,9 +968,14 @@ pgoff_t linear_hugepage_index(struct vm_
 }
 EXPORT_SYMBOL_GPL(linear_hugepage_index);
 
-/*
- * Return the size of the pages allocated when backing a VMA. In the majority
- * cases this will be same size as used by the page table entries.
+/**
+ * vma_kernel_pagesize - Page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * Folios in this VMA will be aligned to, and at least the size of the
+ * number of bytes returned by this function.
+ *
+ * Return: The default size of the folios allocated when backing a VMA.
  */
 unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 {
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
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch

