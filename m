Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BA6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7E0207BB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865232;
	bh=y1lxTQri7DYzDHQw9Hox28iALQENiQl2MfsReXZ2+oY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c2WlQe/J0Pn6XEW44FjuQAx66bzye222vDIAbF6hdvwGtGNGbGHxzJ0eTBEWOyBA0
	 MgPiZk36YA8QV4Iot4iikMwq4zlKZ0amDg6DSKZ7mXBZYKJe0zZx4hNE2iJ95XFw4Q
	 sunHEUaMJuFcrJ/BsVkqiVn8gvcLDaV3Kph5LR4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHST1L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHST1L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:27:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4F82078D;
        Wed, 19 Aug 2020 19:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865230;
        bh=y1lxTQri7DYzDHQw9Hox28iALQENiQl2MfsReXZ2+oY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vYEOlgisW9F/jqspCaES138au2DItloWnBa+7CISY5iPYpg/rocZR9QdS2wDjB61b
         1JzOZ4fHZeBfwbl9ts8qruz9KONqJpRqY+dccYyCqu9TZnWhpwPNLduJlBr1tcCTqY
         b7VcizFQPPeA1qE54MNej88JqG0Z0XV4PW+Nax4U=
Date:   Wed, 19 Aug 2020 12:27:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     benh@kernel.crashing.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dja@axtens.net, hbathini@linux.ibm.com, hch@lst.de,
        jcmvbkbc@gmail.com, Jonathan.Cameron@huawei.com, kernel@esmil.dk,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  + kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch added
 to -mm tree
Message-ID: <20200819192708.mptBJogs8%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: KVM: PPC: Book3S HV: simplify kvm_cma_reserve()
has been added to the -mm tree.  Its filename is
     kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch

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
Subject: KVM: PPC: Book3S HV: simplify kvm_cma_reserve()

Patch series "memblock: seasonal cleaning^w cleanup", v3.

These patches simplify several uses of memblock iterators and hide some of
the memblock implementation details from the rest of the system.


This patch (of 17):

The memory size calculation in kvm_cma_reserve() traverses memblock.memory
rather than simply call memblock_phys_mem_size().  The comment in that
function suggests that at some point there should have been call to
memblock_analyze() before memblock_phys_mem_size() could be used.  As of
now, there is no memblock_analyze() at all and memblock_phys_mem_size()
can be used as soon as cold-plug memory is registered with memblock.

Replace loop over memblock.memory with a call to memblock_phys_mem_size().

Link: https://lkml.kernel.org/r/20200818151634.14343-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20200818151634.14343-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_builtin.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_builtin.c~kvm-ppc-book3s-hv-simplify-kvm_cma_reserve
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -95,23 +95,15 @@ EXPORT_SYMBOL_GPL(kvm_free_hpt_cma);
 void __init kvm_cma_reserve(void)
 {
 	unsigned long align_size;
-	struct memblock_region *reg;
-	phys_addr_t selected_size = 0;
+	phys_addr_t selected_size;
 
 	/*
 	 * We need CMA reservation only when we are in HV mode
 	 */
 	if (!cpu_has_feature(CPU_FTR_HVMODE))
 		return;
-	/*
-	 * We cannot use memblock_phys_mem_size() here, because
-	 * memblock_analyze() has not been called yet.
-	 */
-	for_each_memblock(memory, reg)
-		selected_size += memblock_region_memory_end_pfn(reg) -
-				 memblock_region_memory_base_pfn(reg);
 
-	selected_size = (selected_size * kvm_cma_resv_ratio / 100) << PAGE_SHIFT;
+	selected_size = PAGE_ALIGN(memblock_phys_mem_size() * kvm_cma_resv_ratio / 100);
 	if (selected_size) {
 		pr_info("%s: reserving %ld MiB for global area\n", __func__,
 			 (unsigned long)selected_size / SZ_1M);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

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

