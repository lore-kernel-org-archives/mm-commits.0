Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E60C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE0622248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709465;
	bh=DeDEYLxnTFH+yPMC5GD5lRb/ysnmN5Y5SrTZNGwDato=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=12vXTxMYq3L7UscmPoRM2gv7JAPaggBN+aO0u5Eq6YF1/27nThYvK4VaLEJpc786R
	 KTcNPE+4Yy6SROzVYr6g70/ILMI3ZSl1cX5IX8wG5NeI5rTww0eNGCO1SquAXm10ii
	 MEBdnhJ24VZ1J6TCIyH16RlWbxSsPtu+zwrI3Gh4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJNVEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbgJNVEZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C6B206B2;
        Wed, 14 Oct 2020 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709464;
        bh=DeDEYLxnTFH+yPMC5GD5lRb/ysnmN5Y5SrTZNGwDato=;
        h=Date:From:To:Subject:From;
        b=PKDxQG/ZSmEjnmA6/64eLv5g6+e7BZA48V7RZSy4mBz0FLutzstEV9V+A1c3SvvO0
         bLANgDTtxwrn1yPSYl7KYrm9Jj7qwiJmpCELohAWSbgM+l/7UZTS1iEGfVxB3UBjo5
         PWO5FuZ8ga2cXacTa2waK4cBdIlJZp9hEYXAARvI=
Date:   Wed, 14 Oct 2020 14:04:22 -0700
From:   akpm@linux-foundation.org
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
Subject:  [merged] arm64-numa-simplify-dummy_numa_init.patch
 removed from -mm tree
Message-ID: <20201014210422.iI_ww4Lbk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: numa: simplify dummy_numa_init()
has been removed from the -mm tree.  Its filename was
     arm64-numa-simplify-dummy_numa_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm64: numa: simplify dummy_numa_init()

dummy_numa_init() loops over memblock.memory and passes nid=0 to
numa_add_memblk() which essentially wraps memblock_set_node().  However,
memblock_set_node() can cope with entire memory span itself, so the loop
over memblock.memory regions is redundant.

Using a single call to memblock_set_node() rather than a loop also fixes
an issue with a buggy ACPI firmware in which the SRAT table covers some
but not all of the memory in the EFI memory map.

Jonathan Cameron says:

  This issue can be easily triggered by having an SRAT table which fails
  to cover all elements of the EFI memory map.

  This firmware error is detected and a warning printed. e.g.
  "NUMA: Warning: invalid memblk node 64 [mem 0x240000000-0x27fffffff]"
  At that point we fall back to dummy_numa_init().

  However, the failed ACPI init has left us with our memblocks all broken
  up as we split them when trying to assign them to NUMA nodes.

  We then iterate over the memblocks and add them to node 0.

  numa_add_memblk() calls memblock_set_node() which merges regions that
  were previously split up during the earlier attempt to add them to
  different nodes during parsing of SRAT.

  This means elements are moved in the memblock array and we can end up
  in a different memblock after the call to numa_add_memblk().
  Result is:

  Unable to handle kernel paging request at virtual address 0000000000003a40
  Mem abort info:
    ESR = 0x96000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000004
    CM = 0, WnR = 0
  [0000000000003a40] user address but active_mm is swapper
  Internal error: Oops: 96000004 [#1] PREEMPT SMP

  ...

  Call trace:
    sparse_init_nid+0x5c/0x2b0
    sparse_init+0x138/0x170
    bootmem_init+0x80/0xe0
    setup_arch+0x2a0/0x5fc
    start_kernel+0x8c/0x648

Replace the loop with a single call to memblock_set_node() to the entire
memory.

Link: https://lkml.kernel.org/r/20200818151634.14343-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/numa.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/numa.c~arm64-numa-simplify-dummy_numa_init
+++ a/arch/arm64/mm/numa.c
@@ -427,19 +427,16 @@ out_free_distance:
  */
 static int __init dummy_numa_init(void)
 {
+	phys_addr_t start = memblock_start_of_DRAM();
+	phys_addr_t end = memblock_end_of_DRAM();
 	int ret;
-	struct memblock_region *mblk;
 
 	if (numa_off)
 		pr_info("NUMA disabled\n"); /* Forced off on command line. */
-	pr_info("Faking a node at [mem %#018Lx-%#018Lx]\n",
-		memblock_start_of_DRAM(), memblock_end_of_DRAM() - 1);
-
-	for_each_memblock(memory, mblk) {
-		ret = numa_add_memblk(0, mblk->base, mblk->base + mblk->size);
-		if (!ret)
-			continue;
+	pr_info("Faking a node at [mem %#018Lx-%#018Lx]\n", start, end - 1);
 
+	ret = numa_add_memblk(0, start, end);
+	if (ret) {
 		pr_err("NUMA init failed\n");
 		return ret;
 	}
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

