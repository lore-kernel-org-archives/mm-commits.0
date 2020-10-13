Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F9CC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EF922244
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633435;
	bh=8wR9Db7o3tZqekyzSrQg0y1ACKcRYI2bQg6Ai/umGcM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qFEpunbb3bypBMc8p1yD2CU2WRNcK7LXO/3kbnI/D9RXuGKzJFaXj7mUN2NsZ9Ceh
	 /VuRUiUBX2Je5tiO7rOU1Cz+VWh2x7+f2CDW21duEbetJ5zDeAuaF3oXSwWGjc38KL
	 +b/pRqqJyOOSyNIZUYDIKqoyKfcJGyJuqYcj4mz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389233AbgJMX5P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389185AbgJMX5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 979952222E;
        Tue, 13 Oct 2020 23:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633434;
        bh=8wR9Db7o3tZqekyzSrQg0y1ACKcRYI2bQg6Ai/umGcM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r0BBD34FFkB1Nskv/yaT7PhoZuRuFT0cAe7ERuYAGR34Z0xYrPg6o2nFMFukaUH1C
         TG5BhK1gMwNbprsols8GM81DuFMYU8v0B1Bo8vhUYvAH2nCeV1nddl4Zh+spjHvFvN
         qM+MayKtmdOygnXSUGw61xOSMmZmVZFXjgpCWqTA=
Date:   Tue, 13 Oct 2020 16:57:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 161/181] mm/mempool: add 'else' to split mutually
 exclusive case
Message-ID: <20201013235714.wNuzZsMUR%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
