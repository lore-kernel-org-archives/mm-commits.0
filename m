Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5E9C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE8921D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630839;
	bh=ve4kIxIrTr0HSNO7s2pCgOZoMg1H+IiKqh5PY2OM5i4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=exVmCNxAz9bdC0Aq/+AanHK384pZp8Up3Y7D9h12KFW0jibtq8TuUMTcD71ojKIhB
	 j5+oROyNh9PrLXHFrbijrVJPmG7wllJGO49EesVbUaA83PJJQOM02Me6aHflaVRfb0
	 aQA5sd89qVjBtINiJwKH3QsvCQf4AINjP2lfQUe0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbgJMXN7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388608AbgJMXN7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:13:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C235A20B1F;
        Tue, 13 Oct 2020 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630838;
        bh=ve4kIxIrTr0HSNO7s2pCgOZoMg1H+IiKqh5PY2OM5i4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=puLN6EcDhBaLYr5JM37++qnm1kyQZUN+HGTo8fGsSxs/q+pZoss8NNqL6f/I0Zs/E
         qOmktTABn4gB6LkAfyoby1xxtR//R1viSpIvDVP6QjgdybpCK39yizdMniLqD5D8Ms
         rlaIz6l+lmN+n7tfkfcqRvIlfe37Kbi2/x4LYhkE=
Date:   Tue, 13 Oct 2020 16:13:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch removed from
 -mm tree
Message-ID: <20201013231358.Sw1g0rPCw%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempool-add-else-to-split-mutually-exclusive-case-fix
has been removed from the -mm tree.  Its filename was
     mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch

This patch was dropped because it was folded into mm-mempool-add-else-to-split-mutually-exclusive-case.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempool-add-else-to-split-mutually-exclusive-case-fix

fix comment location

Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case-fix
+++ a/mm/mempool.c
@@ -60,8 +60,8 @@ static void check_element(mempool_t *poo
 	/* Mempools backed by slab allocator */
 	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
 		__check_element(pool, element, ksize(element));
-	/* Mempools backed by page allocator */
 	} else if (pool->free == mempool_free_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -83,8 +83,8 @@ static void poison_element(mempool_t *po
 	/* Mempools backed by slab allocator */
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
 		__poison_element(element, ksize(element));
-	/* Mempools backed by page allocator */
 	} else if (pool->alloc == mempool_alloc_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempool-add-else-to-split-mutually-exclusive-case.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

