Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0557C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjBMX4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjBMXzk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF70417CF2
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57A4A6135D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7B4C433D2;
        Mon, 13 Feb 2023 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332536;
        bh=0//zkRGdTwu5shb2zqFJ2OouTtWlY6Zaxik+bo56lzk=;
        h=Date:To:From:Subject:From;
        b=1xkV/Akf4E/DcRyPQhXm36F1C8NTZBpVQud7CG+GiuIr+EKWBGeo+lz11iqHZ+Yc0
         uQGu9ULWLPXDUW8KSfizFRAc5r9Iy7ZBSYmabKS6s/JZRbhWOcGic62P2jvSWk/Z7u
         wUAKavp2GUq2RrZBDFGau084wYVQJu5B2ecEvD7E=
Date:   Mon, 13 Feb 2023 15:55:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-convert-isolate_movable_page-to-use-folios.patch removed from -mm tree
Message-Id: <20230213235536.AE7B4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: convert isolate_movable_page() to use folios
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-isolate_movable_page-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/migrate: convert isolate_movable_page() to use folios
Date: Mon, 30 Jan 2023 13:43:51 -0800

Removes 6 calls to compound_head() and prepares the function to take in a
folio instead of page argument.

Link: https://lkml.kernel.org/r/20230130214352.40538-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-convert-isolate_movable_page-to-use-folios
+++ a/mm/migrate.c
@@ -60,6 +60,7 @@
 
 int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
+	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
 
 	/*
@@ -71,11 +72,11 @@ int isolate_movable_page(struct page *pa
 	 * the put_page() at the end of this block will take care of
 	 * release this page, thus avoiding a nasty leakage.
 	 */
-	if (unlikely(!get_page_unless_zero(page)))
+	if (!folio)
 		goto out;
 
-	if (unlikely(PageSlab(page)))
-		goto out_putpage;
+	if (unlikely(folio_test_slab(folio)))
+		goto out_putfolio;
 	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
 	smp_rmb();
 	/*
@@ -83,12 +84,12 @@ int isolate_movable_page(struct page *pa
 	 * we use non-atomic bitops on newly allocated page flags so
 	 * unconditionally grabbing the lock ruins page's owner side.
 	 */
-	if (unlikely(!__PageMovable(page)))
-		goto out_putpage;
+	if (unlikely(!__folio_test_movable(folio)))
+		goto out_putfolio;
 	/* Pairs with smp_wmb() in slab allocation, e.g. SLUB's alloc_slab_page() */
 	smp_rmb();
-	if (unlikely(PageSlab(page)))
-		goto out_putpage;
+	if (unlikely(folio_test_slab(folio)))
+		goto out_putfolio;
 
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
@@ -101,29 +102,29 @@ int isolate_movable_page(struct page *pa
 	 * lets be sure we have the page lock
 	 * before proceeding with the movable page isolation steps.
 	 */
-	if (unlikely(!trylock_page(page)))
-		goto out_putpage;
+	if (unlikely(!folio_trylock(folio)))
+		goto out_putfolio;
 
-	if (!PageMovable(page) || PageIsolated(page))
+	if (!folio_test_movable(folio) || folio_test_isolated(folio))
 		goto out_no_isolated;
 
-	mops = page_movable_ops(page);
-	VM_BUG_ON_PAGE(!mops, page);
+	mops = folio_movable_ops(folio);
+	VM_BUG_ON_FOLIO(!mops, folio);
 
-	if (!mops->isolate_page(page, mode))
+	if (!mops->isolate_page(&folio->page, mode))
 		goto out_no_isolated;
 
 	/* Driver shouldn't use PG_isolated bit of page->flags */
-	WARN_ON_ONCE(PageIsolated(page));
-	SetPageIsolated(page);
-	unlock_page(page);
+	WARN_ON_ONCE(folio_test_isolated(folio));
+	folio_set_isolated(folio);
+	folio_unlock(folio);
 
 	return 0;
 
 out_no_isolated:
-	unlock_page(page);
-out_putpage:
-	put_page(page);
+	folio_unlock(folio);
+out_putfolio:
+	folio_put(folio);
 out:
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


