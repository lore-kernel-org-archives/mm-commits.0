Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340D3C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E782822203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630589;
	bh=gwIQ90W0Qh4z8GZvO3kBpCWrCal+vc6+2y7ghKVVzsQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Okccsd6WZDkVfmRGFbrGcXQ7r1Go7EGCuXdnpgZTxh+w7Y6dDO/cRiaz3XiV5wXgp
	 CEY46rCw2GsQWY/0j+WmyK/HDAgZlUxm2rAbk6bE3KtM5N/mGmmRcfDG/Tp0QPlUGS
	 of90kT8blYY3EQQFQ9vL4ADE+L/uUckf/A9Y1COg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgJMXJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXJt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:09:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F79A21D40;
        Tue, 13 Oct 2020 23:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630587;
        bh=gwIQ90W0Qh4z8GZvO3kBpCWrCal+vc6+2y7ghKVVzsQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HADg9qP6FG7VdA5DcT7nNDx3vIx37q0KK0fRCim8KUfODDSelnhIoIn3yGQBcZpY6
         SsdiqjT08FKNkDk0Svdqnv1JUBilEe+yFEtz9I/FF4f041w2G8Td/DIy+lkge8EzLd
         6ij7PyquFEYNAobU6wfWJ7MGguqfCDStdQwC46cM=
Date:   Tue, 13 Oct 2020 16:09:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anders.roxell@linaro.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, rppt@linux.ibm.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-account-pmd-tables-like-pte-tables-fix.patch removed from -mm tree
Message-ID: <20201013230946.nZ7_HJaBF%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: __pmd_free_tlb(): call page table destructor
has been removed from the -mm tree.  Its filename was
     mm-account-pmd-tables-like-pte-tables-fix.patch

This patch was dropped because it was folded into mm-account-pmd-tables-like-pte-tables.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm: __pmd_free_tlb(): call page table destructor

As long as PMD tables are accounted as PTE tables ("mm: account PMD tables
like PTE tables") they can be freed only after pgtable_pmd_page_dtor() is
called.

Add the missing call in ARM's version of __pmd_free_tlb for
CONFIG_ARM_LPAE=y case.

Link: https://lkml.kernel.org/r/20200825111303.GB69694@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Tested-bt: Anders Roxell <anders.roxell@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/include/asm/tlb.h~mm-account-pmd-tables-like-pte-tables-fix
+++ a/arch/arm/include/asm/tlb.h
@@ -59,6 +59,7 @@ __pmd_free_tlb(struct mmu_gather *tlb, p
 #ifdef CONFIG_ARM_LPAE
 	struct page *page = virt_to_page(pmdp);
 
+	pgtable_pmd_page_dtor(page);
 	tlb_remove_table(tlb, page);
 #endif
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-account-pmd-tables-like-pte-tables.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-remove-unused-early_pfn_valid.patch

