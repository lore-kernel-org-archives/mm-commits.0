Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79647C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF45221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709459;
	bh=vXTBOG7snhJmzuY7+oaaBJgRAld3hujpJj/L48/8IuQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U6pfoJDHEhXsb+/ne7QkUWwjQH8rarfkrryAzM2J/woIwCMEsjo5tcT7lk9mb5Rrg
	 L5ljS7f9nvt5t1hZOhlLiRqJl6Iw10JJltP93R0z1g5O1ioMhoqVr8ze2IVVRbwgbx
	 ho6HHEi6HdrYr2DnkSU1ufAV2zpOgFCwQGPpGNSY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgJNVES (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1544206B2;
        Wed, 14 Oct 2020 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709455;
        bh=vXTBOG7snhJmzuY7+oaaBJgRAld3hujpJj/L48/8IuQ=;
        h=Date:From:To:Subject:From;
        b=yS3RzbsAJ3xK0LvLoJ34cMthE+9A3tjR2rmhkHusMxcI7NbeE+NrNeEa9Gx0bwT+u
         9WsnTb5t2uaAB/oWnwuf1rrQo46+ccm6Euq7C246YwC/oKa3xrABQz7zj5jwebUN/h
         4nIotXS0TgmxoR3eCTZyd6jrJzeQ6rq4/njd9UwA=
Date:   Wed, 14 Oct 2020 14:04:13 -0700
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
 dma-contiguous-simplify-cma_early_percent_memory.patch removed from -mm
 tree
Message-ID: <20201014210413.L1f3FKpYL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-contiguous: simplify cma_early_percent_memory()
has been removed from the -mm tree.  Its filename was
     dma-contiguous-simplify-cma_early_percent_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: dma-contiguous: simplify cma_early_percent_memory()

The memory size calculation in cma_early_percent_memory() traverses
memblock.memory rather than simply call memblock_phys_mem_size().  The
comment in that function suggests that at some point there should have
been call to memblock_analyze() before memblock_phys_mem_size() could be
used.  As of now, there is no memblock_analyze() at all and
memblock_phys_mem_size() can be used as soon as cold-plug memory is
registered with memblock.

Replace loop over memblock.memory with a call to memblock_phys_mem_size().

Link: https://lkml.kernel.org/r/20200818151634.14343-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 kernel/dma/contiguous.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/kernel/dma/contiguous.c~dma-contiguous-simplify-cma_early_percent_memory
+++ a/kernel/dma/contiguous.c
@@ -73,16 +73,7 @@ early_param("cma", early_cma);
 
 static phys_addr_t __init __maybe_unused cma_early_percent_memory(void)
 {
-	struct memblock_region *reg;
-	unsigned long total_pages = 0;
-
-	/*
-	 * We cannot use memblock_phys_mem_size() here, because
-	 * memblock_analyze() has not been called yet.
-	 */
-	for_each_memblock(memory, reg)
-		total_pages += memblock_region_memory_end_pfn(reg) -
-			       memblock_region_memory_base_pfn(reg);
+	unsigned long total_pages = PHYS_PFN(memblock_phys_mem_size());
 
 	return (total_pages * CONFIG_CMA_SIZE_PERCENTAGE / 100) << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

