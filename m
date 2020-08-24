Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B23C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9EE2074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598299448;
	bh=tlMu5qKz+Xn5TTXVW7y6TMnDXeSF94Oshag1bZ/cmjk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yujKXb+DVCLlUZEKS1BySn3ys5mblktTV3k4+kkqxSBoHoIm42UbtzwcfpMszWjxV
	 bJaclPkxCuzF86Bb+0GoShf/Z1nzMgEl+DYOT/FS9HtAfoU8w4HiQnnABWfZypZDte
	 LvSgUJbUcoVlb2GaoPqAj1OtIKhxKqfmNfaWpRpY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHXUEH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHXUEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:04:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D04820656;
        Mon, 24 Aug 2020 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598299446;
        bh=tlMu5qKz+Xn5TTXVW7y6TMnDXeSF94Oshag1bZ/cmjk=;
        h=Date:From:To:Subject:From;
        b=a+DoTNlsifaY9oNt9ovigCkjkw4Qzi2zgeGJSxrJzTacnPK51YhH8Rl2daDLTzUsm
         e803lU6BrBea68qF7cED5kpGoUXz/J4/wq1irGegnQAiCy2R0R0mZZ/Vy7FYzkUT6M
         xXvRvB/bB79skPwb12lkWW4ygxHluAvYWZtjkHmU=
Date:   Mon, 24 Aug 2020 13:04:06 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch added to -mm
 tree
Message-ID: <20200824200406.YYlh45Tjs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempool-add-else-to-split-mutually-exclusive-case-fix
has been added to the -mm tree.  Its filename is
     mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch

