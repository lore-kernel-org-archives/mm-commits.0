Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3E3C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 20:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiAMUoZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:44:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44670 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiAMUoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 15:44:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F50A61073
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 20:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B97C36AEB;
        Thu, 13 Jan 2022 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642106664;
        bh=oUmy5d4KyWVPTUlVQt+zjh6JBGQVfnpzLqAgYrzYbsw=;
        h=Date:From:To:Subject:From;
        b=fmlSXa5FeReLCHEzS8gsCbm69Jl//WShkXTn6hC5oahdC3D5lOoseY2iiYwENiBfV
         q0JgthR/EBWVdKFhutKjq9WeBWaMwfaPSUFeqD8SC83ajUZ3yu4OkDV3EZNQaI+ayk
         v6kIaYJfrSLAh04cpbFpjJxVkZ7f+wN1rk/vpv1Y=
Date:   Thu, 13 Jan 2022 12:44:23 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        npiggin@gmail.com, uladzislau.rezki@sony.com,
        xuyu@linux.alibaba.com
Subject:  [folded-merged]
 mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch removed from -mm
 tree
Message-ID: <20220113204423.qhCqr9bG1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-allocate-small-pages-for-area-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch

This patch was dropped because it was folded into mm-vmalloc-allocate-small-pages-for-area-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-allocate-small-pages-for-area-pages-fix

tweak code layout

Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-allocate-small-pages-for-area-pages-fix
+++ a/mm/vmalloc.c
@@ -2932,12 +2932,14 @@ static void *__vmalloc_area_node(struct
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
+	unsigned int nr_small_pages, max_small_pages;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
+	nr_small_pages = size >> PAGE_SHIFT;
+	max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
+
 	array_size = (unsigned long)max_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch

