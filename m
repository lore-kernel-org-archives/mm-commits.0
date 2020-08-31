Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F565C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A9C207BB
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834769;
	bh=8H5DcPv+KCW5GiIyCZgpNAKWFLP7177phLnSrzoOg8I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fo4lEoebj58X6kUpSHBeI/oxYwQNDAr4N0GjcbYRG1bGxQHA0m2+7EpKSKAsEagbL
	 B+ix/UZI4vWL4xyNYgIqrXgYzxOHaVaswdbyLsxYod55+zRu8SBDaQNs4oK6nfjp4B
	 Owjgs7Ria700y7/9os77u6GuGT28vQOwW4IFfr/U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHaAqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgHaAqH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 20:46:07 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08167206CD;
        Mon, 31 Aug 2020 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834766;
        bh=8H5DcPv+KCW5GiIyCZgpNAKWFLP7177phLnSrzoOg8I=;
        h=Date:From:To:Subject:From;
        b=RhsfYzrAPOpwU0tlN/tiMVlg1Mb3LdK9cGKgxr4pD0sSczm39+ZWV4s/5yeEku1zP
         /TyitVzmjfY2T72Jg1RVZJPpeQ+rvuYRS/caHpmFSuZUTy2sMyVZW6U8WR+RxwMZip
         ahU0izXteiacRcHNzLAyUAci7Fq9DEVEhLLFqbGM=
Date:   Sun, 30 Aug 2020 17:46:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.ibm.com
Subject:  +
 arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
 added to -mm tree
Message-ID: <20200831004605.UVYZe%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: fix cavium-octeon build caused by memblock refactoring
has been added to the -mm tree.  Its filename is
     arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch

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
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch

