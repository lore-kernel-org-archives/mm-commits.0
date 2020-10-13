Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1514AC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88D92222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633467;
	bh=JS9d2oUKbbF8EmaX68GnGaI0e1tKrYH9LCdMOAo0cgU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GWMGLOgZ8d/zLGwvOL1B5bxi2/fMv05N419AY/eJjNDeZ2zRA1gpvLyner4lLIxNN
	 Jh21jxwSQgrnoARY5lrzvR+bDQgAsi2KVwnnKP50mqtMXu7uBoSXJkG5bIQsOQbw3x
	 GzE7pC7Rr3kpUVQSnQYsms+h5PER6XYtPa2CyWwo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389375AbgJMX5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389008AbgJMX5r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE1DD22248;
        Tue, 13 Oct 2020 23:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633467;
        bh=JS9d2oUKbbF8EmaX68GnGaI0e1tKrYH9LCdMOAo0cgU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PGH5F82cr9zuf2BIUdLC6DUaVHKRdMWlqk0azFCIPNgMIfKyVRVcADbNoBjF8YqLX
         FnZhw5IkCCJqt1LbHYXwRmPXzSQSiEmxzEOJBQSYZ5auU4IB/ijGe7hRSQ6R9z2JnR
         xVi/eODvNS4w33k7tjaT09TqrCL3HQs3+JWmSL3A=
Date:   Tue, 13 Oct 2020 16:57:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dave.hansen@linux.intel.com, dja@axtens.net,
        hbathini@linux.ibm.com, hch@lst.de, jcmvbkbc@gmail.com,
        Jonathan.Cameron@huawei.com, kernel@esmil.dk, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  [patch 168/181] mircoblaze: drop unneeded NUMA and
 sparsemem initializations
Message-ID: <20201013235745.1cqpI8lYX%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
