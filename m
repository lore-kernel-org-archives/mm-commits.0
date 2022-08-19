Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C02C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243443AbiHSFNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbiHSFNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5634C63E
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 213C6B82569
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AC9C433D6;
        Fri, 19 Aug 2022 05:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660886013;
        bh=g9Jeo/+/GPIJAJUXLrfHOqIgIf2ZT4k96CzKPHrhDx8=;
        h=Date:To:From:Subject:From;
        b=cx4Vdf0RnbhfEaQ5IY+CzZSPwDAM9x00pRdcskepfL51H5lu4OwPonCzZAXDSEHmw
         32b4s/UhXmBsiIZmgoPadtt+EcY5jMCYHV0YOnjotLEsBhxcqDFeH7u1+b2b7PI4TW
         ksx6paCm4rQdMJH4VgsrE3G+jkOPWhu2vfZODkDg=
Date:   Thu, 18 Aug 2022 22:13:32 -0700
To:     mm-commits@vger.kernel.org, liusong@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch removed from -mm tree
Message-Id: <20220819051333.B6AC9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/dmapool.c: avoid duplicate memset within dma_pool_alloc
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Liu Song <liusong@linux.alibaba.com>
Subject: mm/dmapool.c: avoid duplicate memset within dma_pool_alloc
Date: Mon, 18 Jul 2022 14:28:10 +0800

From: Liu Song <liusong@linux.alibaba.com>

In "dma_alloc_from_dev_coherent" and "dma_direct_alloc",
the allocated memory is explicitly set to 0.

A helper function "use_dev_coherent_memory" is introduced here to
determine whether the memory is allocated by "dma_alloc_from_dev_coherent".

And use "get_dma_ops" to determine whether the memory is allocated by
"dma_direct_alloc".

After this modification, memory allocated using "dma_pool_zalloc" can avoid
duplicate memset.

Link: https://lkml.kernel.org/r/1658125690-76930-1-git-send-email-liusong@linux.alibaba.com
Signed-off-by: Liu Song <liusong@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-map-ops.h |    5 +++++
 mm/dmapool.c                |    5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/dma-map-ops.h~mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc
+++ a/include/linux/dma-map-ops.h
@@ -183,6 +183,10 @@ int dma_alloc_from_dev_coherent(struct d
 int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr);
 int dma_mmap_from_dev_coherent(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, size_t size, int *ret);
+static inline bool use_dev_coherent_memory(struct device *dev)
+{
+	return dev->dma_mem ? true : false;
+}
 #else
 static inline int dma_declare_coherent_memory(struct device *dev,
 		phys_addr_t phys_addr, dma_addr_t device_addr, size_t size)
@@ -194,6 +198,7 @@ static inline int dma_declare_coherent_m
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
 static inline void dma_release_coherent_memory(struct device *dev) { }
+#define use_dev_coherent_memory(dev) (0)
 #endif /* CONFIG_DMA_DECLARE_COHERENT */
 
 #ifdef CONFIG_DMA_GLOBAL_POOL
--- a/mm/dmapool.c~mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc
+++ a/mm/dmapool.c
@@ -21,6 +21,7 @@
 
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-map-ops.h>
 #include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -372,7 +373,9 @@ void *dma_pool_alloc(struct dma_pool *po
 #endif
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (want_init_on_alloc(mem_flags))
+	if (want_init_on_alloc(mem_flags) &&
+		!use_dev_coherent_memory(pool->dev) &&
+		get_dma_ops(pool->dev))
 		memset(retval, 0, pool->size);
 
 	return retval;
_

Patches currently in -mm which might be from liusong@linux.alibaba.com are


