Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98F8C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB15221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709450;
	bh=WGgeCkwvIT6dRkDFJ3Qu0l+1YNyTSlugr8y6fBUsjyU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IqtSL4BE8pRtHNZ+MaLfJ8FV2hqW2sANiyFrfJpnNbwpYehvzOGvbuDP6y9nPjcUz
	 uKnoTgsW4YOWKMdc+jTFizK2G/+9aMW2mvpaxyCFooNZTDAUyLaMdozlqRGhHz3+II
	 NreHiH1HwbGHmpjSK9/V5YTF3+TwwyIb66TPG9tU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgJNVEK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVEK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B9B206B2;
        Wed, 14 Oct 2020 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709447;
        bh=WGgeCkwvIT6dRkDFJ3Qu0l+1YNyTSlugr8y6fBUsjyU=;
        h=Date:From:To:Subject:From;
        b=E1JtpCMNBrOslR+ARpvDEpzclPHhT+QPkUpHctJVfAb8p4VRxAEEfEUzIZFzOYbzr
         Xdu2e5BykOpfEADzboyqGJ+IUx4A8RPlfcQ0a13QWv78v/YMUzwKXI1K8WMMF87nYf
         jGMyv6Vjg/aXLapVbw8pt5cm0Fnfeo8gVI2CiBAg=
Date:   Wed, 14 Oct 2020 14:04:07 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempool-add-else-to-split-mutually-exclusive-case.patch removed from -mm
 tree
Message-ID: <20201014210407.8bscyQ8jQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: add 'else' to split mutually exclusive case
has been removed from the -mm tree.  Its filename was
     mm-mempool-add-else-to-split-mutually-exclusive-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempool: add 'else' to split mutually exclusive case

Add else to split mutually exclusive case and avoid some unnecessary check.
It doesn't seem to change code generation (compiler is smart), but I think
it helps readability.

[akpm@linux-foundation.org: fix comment location]
Link: https://lkml.kernel.org/r/20200924111641.28922-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case
+++ a/mm/mempool.c
@@ -58,11 +58,10 @@ static void __check_element(mempool_t *p
 static void check_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
 		__check_element(pool, element, ksize(element));
-
-	/* Mempools backed by page allocator */
-	if (pool->free == mempool_free_pages) {
+	} else if (pool->free == mempool_free_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -82,11 +81,10 @@ static void __poison_element(void *eleme
 static void poison_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
 		__poison_element(element, ksize(element));
-
-	/* Mempools backed by page allocator */
-	if (pool->alloc == mempool_alloc_pages) {
+	} else if (pool->alloc == mempool_alloc_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -107,7 +105,7 @@ static __always_inline void kasan_poison
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_poison_kfree(element, _RET_IP_);
-	if (pool->alloc == mempool_alloc_pages)
+	else if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
 
@@ -115,7 +113,7 @@ static void kasan_unpoison_element(mempo
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_unpoison_slab(element);
-	if (pool->alloc == mempool_alloc_pages)
+	else if (pool->alloc == mempool_alloc_pages)
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

