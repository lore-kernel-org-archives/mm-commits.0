Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD6AC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3252072D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598305522;
	bh=TgnI9DfACm6fOiuEeK5II2OsU5NkReO6aokIdFXiheY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aHyRBdbHARHmVR9kg/3/HaWUbaCAH8KymTdLLq206EyuADb8RgTxh7jiB89yErvSj
	 JIbllrOZUsYPMLF2aTf12236KRfrUNIlBgDb+uvLGuYJSk3UnFi2NB3xxjX8mqrtMP
	 /u6nishZIF7wXvqseBVr2SOFExdC0VGDxy83SPsU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgHXVpW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXVpV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:45:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2EF20702;
        Mon, 24 Aug 2020 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598305520;
        bh=TgnI9DfACm6fOiuEeK5II2OsU5NkReO6aokIdFXiheY=;
        h=Date:From:To:Subject:From;
        b=kuoRyTGbo3TJ/79Pn654EglGUC+7IQRlKPr6S74fvEgRJqUIbQ55GfgKigsLMA4bP
         QC19VmQcWBnTphxP5lZrsqM7QlBdh0cfGXqT0ph2Y+HLNFN7flZnsrPdUJXXj00G6b
         R4ZaEQQdaSRquclvYzd9mH1JmC431WuXlRcjanxc=
Date:   Mon, 24 Aug 2020 14:45:19 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch removed from
 -mm tree
Message-ID: <20200824214519.v_ZKnvboL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
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
From: Joe Perches <joe@perches.com>
Subject: mm-mempool-add-else-to-split-mutually-exclusive-case-fix

style: braces should be added to the first test.

Link: https://lkml.kernel.org/r/37bbda0e0d94d3324210fa807f4061a9e9bd66bc.camel@perches.com
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case-fix
+++ a/mm/mempool.c
@@ -57,11 +57,12 @@ static void __check_element(mempool_t *p
 
 static void check_element(mempool_t *pool, void *element)
 {
-	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+	if (pool->free == mempool_free_slab ||
+	    pool->free == mempool_kfree) {
+		/* Mempools backed by slab allocator */
 		__check_element(pool, element, ksize(element));
-	/* Mempools backed by page allocator */
-	else if (pool->free == mempool_free_pages) {
+	} else if (pool->free == mempool_free_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -83,8 +84,9 @@ static void poison_element(mempool_t *po
 	/* Mempools backed by slab allocator */
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		__poison_element(element, ksize(element));
+
 	/* Mempools backed by page allocator */
-	else if (pool->alloc == mempool_alloc_pages) {
+	if (pool->alloc == mempool_alloc_pages) {
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -105,7 +107,7 @@ static __always_inline void kasan_poison
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_poison_kfree(element, _RET_IP_);
-	else if (pool->alloc == mempool_alloc_pages)
+	if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
 
@@ -113,7 +115,7 @@ static void kasan_unpoison_element(mempo
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_unpoison_slab(element);
-	else if (pool->alloc == mempool_alloc_pages)
+	if (pool->alloc == mempool_alloc_pages)
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

