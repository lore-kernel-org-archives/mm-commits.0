Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AC4C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJCVFQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJCVEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6269FDA
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC76A611D9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3BAC433D7;
        Mon,  3 Oct 2022 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831084;
        bh=dMg/xiP/Pv3pEoNtCeX/mqhUTD4Nc4BGi5hL4imxeuI=;
        h=Date:To:From:Subject:From;
        b=F0l+jZhE6cZcTgudddIvTW+dYHLh3W30oGh4ijWT86hL+458IRSr61Zj7+twnJTzl
         CTL6l9uQHOpzJH4pgrMB98MDWlIY1GHxZHYKEIn97ZuIF7Cvj7OTEQooQOeFinJDs0
         1BRZ1J2cgMAMx/DUcvflltXL5CHodzlT3BC1WzEQ=
Date:   Mon, 03 Oct 2022 14:04:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch removed from -mm tree
Message-Id: <20221003210444.0E3BAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_delete_from_page_cache() to take a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_delete_from_page_cache() to take a folio
Date: Fri, 2 Sep 2022 20:46:03 +0100

Remove the assertion that the page is not Compound as this function now
handles large folios correctly.

Link: https://lkml.kernel.org/r/20220902194653.1739778-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_delete_from_page_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -763,23 +763,22 @@ error:
 }
 
 /*
- * Like delete_from_page_cache, but substitutes swap for page.
+ * Like delete_from_page_cache, but substitutes swap for @folio.
  */
-static void shmem_delete_from_page_cache(struct page *page, void *radswap)
+static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
+	long nr = folio_nr_pages(folio);
 	int error;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
-
 	xa_lock_irq(&mapping->i_pages);
-	error = shmem_replace_entry(mapping, page->index, page, radswap);
-	page->mapping = NULL;
-	mapping->nrpages--;
-	__dec_lruvec_page_state(page, NR_FILE_PAGES);
-	__dec_lruvec_page_state(page, NR_SHMEM);
+	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
+	folio->mapping = NULL;
+	mapping->nrpages -= nr;
+	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
+	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 	xa_unlock_irq(&mapping->i_pages);
-	put_page(page);
+	folio_put(folio);
 	BUG_ON(error);
 }
 
@@ -1416,7 +1415,7 @@ static int shmem_writepage(struct page *
 		spin_unlock_irq(&info->lock);
 
 		swap_shmem_alloc(swap);
-		shmem_delete_from_page_cache(&folio->page, swp_to_radix_entry(swap));
+		shmem_delete_from_page_cache(folio, swp_to_radix_entry(swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
_

Patches currently in -mm which might be from willy@infradead.org are


