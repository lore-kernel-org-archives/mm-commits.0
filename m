Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CFFC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D370F22258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709478;
	bh=ivWA5G7FqC3R+TPW01d+C46Ian9PAFwjk1iAolaG69Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QPyg51ss4wmvKyqRf6Z+XCFLnzmYHbtMRwZKSwcvs88EmS+2Rnyba4edq9QFVLRCt
	 03Wnc/lyp3MqLptD+UKcpW0vQwnwd88AJ/f0A9mxlta0gAZy+zYWVSm+vIM//W3AOD
	 jvQxI6T/AEykJ0m7IX+aU2RaxdN9CJTE/0ScXLfk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgJNVEi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgJNVEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAC522253;
        Wed, 14 Oct 2020 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709477;
        bh=ivWA5G7FqC3R+TPW01d+C46Ian9PAFwjk1iAolaG69Y=;
        h=Date:From:To:Subject:From;
        b=XNoOxWFkclOuq2OmXmwn8tb3/INrJejEOKc97sHlLl8KALMZ+yqIVfjIGV65RNhya
         Kk2ezEmBWHwVh13Qp7B57+6ABB73F1R68hTbEnwEMgTYRLzCh5Vhge824IxOMz8vbi
         UGHApZNF5+0xakHNzx6y4QHGq90MVQp52CzbRTOA=
Date:   Wed, 14 Oct 2020 14:04:35 -0700
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
 mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch removed
 from -mm tree
Message-ID: <20201014210435.yGwjVouzn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mircoblaze: drop unneeded NUMA and sparsemem initializations
has been removed from the -mm tree.  Its filename was
     mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mircoblaze: drop unneeded NUMA and sparsemem initializations

microblaze does not support neither NUMA not SPARSMEM, so there is no
point to call memblock_set_node() and
sparse_memory_present_with_active_regions() functions during microblaze
memory initialization.

Remove these calls and the surrounding code.

Link: https://lkml.kernel.org/r/20200818151634.14343-8-rppt@kernel.org
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
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/init.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/arch/microblaze/mm/init.c~mircoblaze-drop-unneeded-numa-and-sparsemem-initializations
+++ a/arch/microblaze/mm/init.c
@@ -108,9 +108,8 @@ static void __init paging_init(void)
 
 void __init setup_memory(void)
 {
-	struct memblock_region *reg;
-
 #ifndef CONFIG_MMU
+	struct memblock_region *reg;
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
@@ -164,17 +163,6 @@ void __init setup_memory(void)
 	pr_info("%s: max_low_pfn: %#lx\n", __func__, max_low_pfn);
 	pr_info("%s: max_pfn: %#lx\n", __func__, max_pfn);
 
-	/* Add active regions with valid PFNs */
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-		memblock_set_node(start_pfn << PAGE_SHIFT,
-				  (end_pfn - start_pfn) << PAGE_SHIFT,
-				  &memblock.memory, 0);
-	}
-
 	paging_init();
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

