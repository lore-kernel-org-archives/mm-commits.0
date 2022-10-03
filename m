Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70347C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJCVGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38591928B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64686611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C93C433C1;
        Mon,  3 Oct 2022 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831114;
        bh=vHmi6jxahwyj3UfclvvzE7ND7uLwMT8ra/LPAUy1foE=;
        h=Date:To:From:Subject:From;
        b=dCyz6KJ+RyBi/CE6gmCmrYVXcqVdg8Ol5DbUpDQIJtDQknz0y3d94H6eNrfOfJr15
         zd/8SBo0P7YGrcjbYkizMIYsF8kgVWyLUojgNVMFBy+8l1VZwAnqOnl/AEYlZQ7c1v
         X6+vXswTde5E23Y4Bhh+1GiuoUZMQyFs+SR6OYjY=
Date:   Mon, 03 Oct 2022 14:05:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swapfile-convert-try_to_unuse-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210514.B3C93C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swapfile: convert try_to_unuse() to use a folio
has been removed from the -mm tree.  Its filename was
     swapfile-convert-try_to_unuse-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swapfile: convert try_to_unuse() to use a folio
Date: Fri, 2 Sep 2022 20:46:30 +0100

Saves five calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-35-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~swapfile-convert-try_to_unuse-to-use-a-folio
+++ a/mm/swapfile.c
@@ -2032,7 +2032,7 @@ static int try_to_unuse(unsigned int typ
 	struct list_head *p;
 	int retval = 0;
 	struct swap_info_struct *si = swap_info[type];
-	struct page *page;
+	struct folio *folio;
 	swp_entry_t entry;
 	unsigned int i;
 
@@ -2082,21 +2082,21 @@ retry:
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
-		page = find_get_page(swap_address_space(entry), i);
-		if (!page)
+		folio = filemap_get_folio(swap_address_space(entry), i);
+		if (!folio)
 			continue;
 
 		/*
-		 * It is conceivable that a racing task removed this page from
-		 * swap cache just before we acquired the page lock. The page
+		 * It is conceivable that a racing task removed this folio from
+		 * swap cache just before we acquired the page lock. The folio
 		 * might even be back in swap cache on another swap area. But
-		 * that is okay, try_to_free_swap() only removes stale pages.
+		 * that is okay, folio_free_swap() only removes stale folios.
 		 */
-		lock_page(page);
-		wait_on_page_writeback(page);
-		try_to_free_swap(page);
-		unlock_page(page);
-		put_page(page);
+		folio_lock(folio);
+		folio_wait_writeback(folio);
+		folio_free_swap(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are


