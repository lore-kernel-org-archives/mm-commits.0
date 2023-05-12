Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67653C77B7F
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 21:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbjELVSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 17:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240399AbjELVST (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 17:18:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F7CE7
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 14:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BF061CF4
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 21:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194D0C433D2;
        Fri, 12 May 2023 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683925809;
        bh=PNSGVIWYRffpH9zduoKn4+JrZHbXLe7rNksLq3/8XqE=;
        h=Date:To:From:Subject:From;
        b=E/rSKsHZZiLZpgfj57LZX09lKO7mxy4JMGwGPVrUpztb3PxFCvczqxJHYqr74DVq+
         DB4wBs9AkdOqcg9F9lf0h1mAmhr932gY4OMSb2dDg3cm5eUclC1IWIE5LZTpDga+pv
         SslwruNVl2YYL715YT4vRNw4VInqsIidK0dOkK7U=
Date:   Fri, 12 May 2023 14:10:08 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        thunder.leizhen@huawei.com, song.bao.hua@hisilicon.com,
        rostedt@goodmis.org, robin.murphy@arm.com, rdunlap@infradead.org,
        peterz@infradead.org, paulmck@kernel.org, m.szyprowski@samsung.com,
        minchan@kernel.org, kim.phillips@amd.com, hch@lst.de,
        corbet@lwn.net, catalin.marinas@arm.com, bp@suse.de,
        bhe@redhat.com, ardb@kernel.org, anshuman.khandual@arm.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-contiguous-support-per-numa-cma-for-all-architectures.patch added to mm-unstable branch
Message-Id: <20230512211009.194D0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-contiguous: support per-numa CMA for all architectures
has been added to the -mm mm-unstable branch.  Its filename is
     dma-contiguous-support-per-numa-cma-for-all-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-contiguous-support-per-numa-cma-for-all-architectures.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: dma-contiguous: support per-numa CMA for all architectures
Date: Fri, 12 May 2023 17:42:10 +0800

In commit b7176c261cdb ("dma-contiguous: provide the ability to reserve
per-numa CMA"), Barry adds DMA_PERNUMA_CMA for ARM64.

But this feature is architecture independent, so support per-numa CMA for
all architectures, and enable it by default if NUMA.

Link: https://lkml.kernel.org/r/20230512094210.141540-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 arch/arm64/mm/init.c                            |    2 --
 include/linux/dma-map-ops.h                     |    6 ------
 kernel/dma/Kconfig                              |    6 +++---
 kernel/dma/contiguous.c                         |    8 +++++++-
 5 files changed, 11 insertions(+), 13 deletions(-)

--- a/arch/arm64/mm/init.c~dma-contiguous-support-per-numa-cma-for-all-architectures
+++ a/arch/arm64/mm/init.c
@@ -410,8 +410,6 @@ void __init bootmem_init(void)
 	arm64_hugetlb_cma_reserve();
 #endif
 
-	dma_pernuma_cma_reserve();
-
 	kvm_hyp_reserve();
 
 	/*
--- a/Documentation/admin-guide/kernel-parameters.txt~dma-contiguous-support-per-numa-cma-for-all-architectures
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -692,7 +692,7 @@
 			kernel/dma/contiguous.c
 
 	cma_pernuma=nn[MG]
-			[ARM64,KNL,CMA]
+			[KNL,CMA]
 			Sets the size of kernel per-numa memory area for
 			contiguous memory allocations. A value of 0 disables
 			per-numa CMA altogether. And If this option is not
--- a/include/linux/dma-map-ops.h~dma-contiguous-support-per-numa-cma-for-all-architectures
+++ a/include/linux/dma-map-ops.h
@@ -168,12 +168,6 @@ static inline void dma_free_contiguous(s
 }
 #endif /* CONFIG_DMA_CMA*/
 
-#ifdef CONFIG_DMA_PERNUMA_CMA
-void dma_pernuma_cma_reserve(void);
-#else
-static inline void dma_pernuma_cma_reserve(void) { }
-#endif /* CONFIG_DMA_PERNUMA_CMA */
-
 #ifdef CONFIG_DMA_DECLARE_COHERENT
 int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		dma_addr_t device_addr, size_t size);
--- a/kernel/dma/contiguous.c~dma-contiguous-support-per-numa-cma-for-all-architectures
+++ a/kernel/dma/contiguous.c
@@ -128,7 +128,7 @@ static inline __maybe_unused phys_addr_t
 #endif
 
 #ifdef CONFIG_DMA_PERNUMA_CMA
-void __init dma_pernuma_cma_reserve(void)
+static void __init dma_pernuma_cma_reserve(void)
 {
 	int nid;
 
@@ -153,6 +153,10 @@ void __init dma_pernuma_cma_reserve(void
 			(unsigned long long)pernuma_size_bytes / SZ_1M, nid);
 	}
 }
+#else
+static inline void __init dma_pernuma_cma_reserve(void)
+{
+}
 #endif
 
 /**
@@ -171,6 +175,8 @@ void __init dma_contiguous_reserve(phys_
 	phys_addr_t selected_limit = limit;
 	bool fixed = false;
 
+	dma_pernuma_cma_reserve();
+
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
 	if (size_cmdline != -1) {
--- a/kernel/dma/Kconfig~dma-contiguous-support-per-numa-cma-for-all-architectures
+++ a/kernel/dma/Kconfig
@@ -140,10 +140,10 @@ if  DMA_CMA
 
 config DMA_PERNUMA_CMA
 	bool "Enable separate DMA Contiguous Memory Area for each NUMA Node"
-	default NUMA && ARM64
+	default NUMA
 	help
-	  Enable this option to get pernuma CMA areas so that devices like
-	  ARM64 SMMU can get local memory by DMA coherent APIs.
+	  Enable this option to get pernuma CMA areas so that NUMA devices
+	  can get local memory by DMA coherent APIs.
 
 	  You can set the size of pernuma CMA by specifying "cma_pernuma=size"
 	  on the kernel's command line.
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

dma-contiguous-support-per-numa-cma-for-all-architectures.patch

