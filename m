Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B21C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609912087D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598296768;
	bh=rcVHv04X0B311Oe2kSuSVmibimp19VQtplMcGW/mKwI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=L+hnEK++FlRXE8qdOm9BqYP/anTMDVj+iqnFTScoVk9WkZIPHFZNu1tn/K6mP9/1D
	 D3wUbtYra4lr6Z31oto6oaCc6w8P4R6ukzliIqQwdlbZQ2EOXI5sCcipMvNRIuivZk
	 ExFBH49pcM9ZtEVR22DkTJUOvYOU3KoYOlB/PCEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHXTT2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgHXTT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 15:19:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959BB20578;
        Mon, 24 Aug 2020 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598296766;
        bh=rcVHv04X0B311Oe2kSuSVmibimp19VQtplMcGW/mKwI=;
        h=Date:From:To:Subject:From;
        b=aS8QhipijXa7pNh5o6OTTX73LU8rzMGCkGvvCa3VDywQVrhn4VvDvxVrzW+RCYLcu
         XQRJY5YQzhnZJWWRWRA5OUjOCYFQWFmUMLZXNL+o8nx7mM2Bf6tcgdAUuT0xnk6X/R
         Yem2zalxHJDsaZ75W7lJdGAlf46qG/9/1u88phSU=
Date:   Mon, 24 Aug 2020 12:19:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mempool-add-else-to-split-mutually-exclusive-case.patch added to -mm
 tree
Message-ID: <20200824191926.TROJJlzxb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: Add 'else' to split mutually exclusive case
has been added to the -mm tree.  Its filename is
     mm-mempool-add-else-to-split-mutually-exclusive-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempool: Add 'else' to split mutually exclusive case

Add else to split mutually exclusive cases and to avoid some unnecessary
check.

akpm: doesn't affect code generation but it's a little cleaner.

Link: https://lkml.kernel.org/r/20200824115354.7879-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case
+++ a/mm/mempool.c
@@ -60,9 +60,8 @@ static void check_element(mempool_t *poo
 	/* Mempools backed by slab allocator */
 	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
 		__check_element(pool, element, ksize(element));
-
 	/* Mempools backed by page allocator */
-	if (pool->free == mempool_free_pages) {
+	else if (pool->free == mempool_free_pages) {
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -84,9 +83,8 @@ static void poison_element(mempool_t *po
 	/* Mempools backed by slab allocator */
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		__poison_element(element, ksize(element));
-
 	/* Mempools backed by page allocator */
-	if (pool->alloc == mempool_alloc_pages) {
+	else if (pool->alloc == mempool_alloc_pages) {
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

mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

