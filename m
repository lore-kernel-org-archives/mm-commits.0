Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0280C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B90222251
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709470;
	bh=WBYeCr7d+uFx//IYzGKPsM2MwZNEjTkUSuJ9GgSDuwc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mV4Js7hCFdjgcz/MkPnMAL4CQaCZsQHo3Fyro9PhNE3ZDr2blWjr599Kw9X/uHiUm
	 PZ2nI6+pmwQ1rJGDpWjtsk3lReIL5M8UKfNao0kR6V4m52DW0MXegwIoG70WulvpV4
	 0YpBoBDetAfKome3aNGeM07teS682PkC+w9fWK0Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgJNVEa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgJNVEa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11153221FF;
        Wed, 14 Oct 2020 21:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709468;
        bh=WBYeCr7d+uFx//IYzGKPsM2MwZNEjTkUSuJ9GgSDuwc=;
        h=Date:From:To:Subject:From;
        b=N8hmFi1fm/3FOgy3tWnnHNiVxNR+dl3XvJazrCjl4krOt+tXfpmVXpO5ynugrc40a
         oRzfMx08N73r7oDXNsEaNuhVh2tbTfgYu6JDILDqavdmGXrjiKI4PhQ4NWG5fWD+n4
         oshOtRTkkqiEotFfTO+52mInZjrBzrMknUddQJ4g=
Date:   Wed, 14 Oct 2020 14:04:26 -0700
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
Subject:  [merged]
 h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch removed
 from -mm tree
Message-ID: <20201014210426.4ncCBeDX9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300, nds32, openrisc: simplify detection of memory extents
has been removed from the -mm tree.  Its filename was
     h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: h8300, nds32, openrisc: simplify detection of memory extents

Instead of traversing memblock.memory regions to find memory_start and
memory_end, simply query memblock_{start,end}_of_DRAM().

Link: https://lkml.kernel.org/r/20200818151634.14343-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c    |    8 +++-----
 arch/nds32/kernel/setup.c    |    8 ++------
 arch/openrisc/kernel/setup.c |    9 ++-------
 3 files changed, 7 insertions(+), 18 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-nds32-openrisc-simplify-detection-of-memory-extents
+++ a/arch/h8300/kernel/setup.c
@@ -74,17 +74,15 @@ static void __init bootmem_init(void)
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel */
-	for_each_memblock(memory, region) {
-		memory_start = region->base;
-		memory_end = region->base + region->size;
-	}
+	memory_start = memblock_start_of_DRAM();
+	memory_end = memblock_end_of_DRAM();
 
 	if (!memory_end)
 		panic("No memory!");
 
 	/* setup bootmem globals (we use no_bootmem, but mm still depends on this) */
 	min_low_pfn = PFN_UP(memory_start);
-	max_low_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_low_pfn = PFN_DOWN(memory_end);
 	max_pfn = max_low_pfn;
 
 	memblock_reserve(__pa(_stext), _end - _stext);
--- a/arch/nds32/kernel/setup.c~h8300-nds32-openrisc-simplify-detection-of-memory-extents
+++ a/arch/nds32/kernel/setup.c
@@ -249,12 +249,8 @@ static void __init setup_memory(void)
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel */
-	for_each_memblock(memory, region) {
-		memory_start = region->base;
-		memory_end = region->base + region->size;
-		pr_info("%s: Memory: 0x%x-0x%x\n", __func__,
-			memory_start, memory_end);
-	}
+	memory_start = memblock_start_of_DRAM();
+	memory_end = memblock_end_of_DRAM();
 
 	if (!memory_end) {
 		panic("No memory!");
--- a/arch/openrisc/kernel/setup.c~h8300-nds32-openrisc-simplify-detection-of-memory-extents
+++ a/arch/openrisc/kernel/setup.c
@@ -48,17 +48,12 @@ static void __init setup_memory(void)
 	unsigned long ram_start_pfn;
 	unsigned long ram_end_pfn;
 	phys_addr_t memory_start, memory_end;
-	struct memblock_region *region;
 
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel, we assume its the only one */
-	for_each_memblock(memory, region) {
-		memory_start = region->base;
-		memory_end = region->base + region->size;
-		printk(KERN_INFO "%s: Memory: 0x%x-0x%x\n", __func__,
-		       memory_start, memory_end);
-	}
+	memory_start = memblock_start_of_DRAM();
+	memory_end = memblock_end_of_DRAM();
 
 	if (!memory_end) {
 		panic("No memory!");
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

