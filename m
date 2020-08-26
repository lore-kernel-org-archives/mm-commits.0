Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFE5C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B7A20737
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401964;
	bh=c6hh0tm0MF4EFBTBS1T3+UUtrPaRH1i5mWxj0xjxGII=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zvl3r9yQQrSYqzT8DjNScRQNOBzeuD8nVMz1wXEs9eLRXZRhpcQ16xKHR4DOKrhPo
	 8godoTUJc8uF8wd8aEa5EPHPQjhbJkQ4L/T2fDhHWiXm2e0j1xbhOr6WUhflJN1hmE
	 EET4KOiRbYWHS38WirwIOz3LuD0cUfLElheihPuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHZAco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgHZAcn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:32:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 969FC20707;
        Wed, 26 Aug 2020 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401962;
        bh=c6hh0tm0MF4EFBTBS1T3+UUtrPaRH1i5mWxj0xjxGII=;
        h=Date:From:To:Subject:From;
        b=fAshiVPU38Xv/9ua+0GrggZd76VtuyVjrwpQcz/qL72YnBfsbVKPW6uIx6oZlS8S7
         FWZd7FSpKlqXr+9up/dlxHab6bZgm2bDGCMjMXk6O7NJxVq/+k8VhKgzGvLQ5TrNke
         K+I9u8oWjmpjMA0SucLiKCibGwx/zzokDSGWVIqM=
Date:   Tue, 25 Aug 2020 17:32:42 -0700
From:   akpm@linux-foundation.org
To:     anders.roxell@linaro.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, rppt@linux.ibm.com, sfr@canb.auug.org.au
Subject:  + mm-account-pmd-tables-like-pte-tables-fix.patch added
 to -mm tree
Message-ID: <20200826003242.8Nsr3EIrg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: __pmd_free_tlb(): call page table desctructor
has been added to the -mm tree.  Its filename is
     mm-account-pmd-tables-like-pte-tables-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-account-pmd-tables-like-pte-tables-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pmd-tables-like-pte-tables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm: __pmd_free_tlb(): call page table desctructor

As long as PMD tables are accounted as PTE tables ("mm: account PMD tables
like PTE tables") they can be freed only after pgtable_pmd_page_dtor() is
called.

Add the missing call in ARM's version of __pmd_free_tlb for
CONFIG_ARM_LPAE=y case.

Link: https://lkml.kernel.org/r/20200825111303.GB69694@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
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

mm-account-pmd-tables-like-pte-tables-fix.patch
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
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch

