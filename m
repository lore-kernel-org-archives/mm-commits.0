Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7481C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiHOA15 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiHOA15 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E411C16
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1BD60F46
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91121C433C1;
        Mon, 15 Aug 2022 00:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660523274;
        bh=LaTWJs+khKSCM5cOBuex5LDpcbCLp8xDPomopHPek34=;
        h=Date:To:From:Subject:From;
        b=aRRpelaIu98veuzQHWVzHBafwgHCRqhnZqtfjxQHffD0ufmuxUcpLrrbg1k3LmoPG
         b2m55o5PTIFyiycFBm70tAMv3tO/CWe8bapcyZ5/1Fu2rpqum5ASKVxiTeqWbtTDsU
         RMsiQU8VYYeedzPljqDibWssBN2sj3HswsL58ExI=
Date:   Sun, 14 Aug 2022 17:27:53 -0700
To:     mm-commits@vger.kernel.org, liusong@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch added to mm-unstable branch
Message-Id: <20220815002754.91121C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: avoid duplicate memset within dma_pool_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch

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
From: Liu Song <liusong@linux.alibaba.com>
Subject: mm/dmapool.c: avoid duplicate memset within dma_pool_alloc
Date: Mon, 18 Jul 2022 14:28:10 +0800


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

mm-dmapoolc-avoid-duplicate-memset-within-dma_pool_alloc.patch

