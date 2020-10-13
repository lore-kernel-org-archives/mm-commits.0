Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F411C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E869921582
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630895;
	bh=jQF+cJ906SJTYUZ59UxdUBUaYlNEJ1+d8q5rMKSoyiU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iPZ2Qq+p/IfYHu3c3NiM7jd8RqsY06pNRJS1mKkr1Dh9u0w/YnzwXZMc8hHAVv74Q
	 bM4/4/UFc+Sg1wgMsrMwYqVXEQF4eJ7O2+DNFP6R6R5yvEjhFpjpA5VGpD1SB/KOOa
	 BZWV5zM36GAzG5OEoyE6y8hY7u14JQ9D6VV2cpkc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgJMXOz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbgJMXOz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:14:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2BE20B1F;
        Tue, 13 Oct 2020 23:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630895;
        bh=jQF+cJ906SJTYUZ59UxdUBUaYlNEJ1+d8q5rMKSoyiU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P3qgm2cAcaTzTJ3ymBMG6Y9Qm4oe2aEv77MPkTAyxghWSUyNUrrhg9XSwsZJug9Ew
         MwdQ+ipMlq6EMDlaXIaE6k96o9r1dhllpX6TlEsqS3rUWHRtwGN7yII3WSfw0VXvwb
         M2P588WXfRSX1tM5k4753M9a6Pnl4o4nUiPXqw1s=
Date:   Tue, 13 Oct 2020 16:14:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
 removed from -mm tree
Message-ID: <20201013231454.-gCmHev6y%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: fix cavium-octeon build caused by memblock refactoring
has been removed from the -mm tree.  Its filename was
     arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch

This patch was dropped because it was folded into arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mips: fix cavium-octeon build caused by memblock refactoring

MIPS cavium_octeon_defconfig build failed like this:

arch/mips/cavium-octeon/dma-octeon.c:205:7: error: `mem' undeclared
(first use in this function); did you mean `sem'?

Caused by patch ("arch, drivers: replace for_each_membock() with
for_each_mem_range()")

Replacing stale 'mem->base' reference with 'start' fixes the issue.

Link: http://lkml.kernel.org/r/20200827124549.GD167163@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported by "kernelci.org bot" <bot@kernelci.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/dma-octeon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/dma-octeon.c~arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2
+++ a/arch/mips/cavium-octeon/dma-octeon.c
@@ -202,7 +202,7 @@ void __init plat_swiotlb_setup(void)
 
 	for_each_mem_range(i, &start, &end) {
 		/* These addresses map low for PCI. */
-		if (mem->base > 0x410000000ull && !OCTEON_IS_OCTEON2())
+		if (start > 0x410000000ull && !OCTEON_IS_OCTEON2())
 			continue;
 
 		addr_size += (end - start);
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
mm-remove-unused-early_pfn_valid.patch

