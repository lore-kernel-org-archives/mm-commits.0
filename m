Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622CEC6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiILDeB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiILDcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06E91E3EC
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D6AB80C75
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E563C433C1;
        Mon, 12 Sep 2022 03:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953407;
        bh=r0d1B7rsIdfoPLk6eZVKzhkwsK5Wokt8Gxviv3j9GCM=;
        h=Date:To:From:Subject:From;
        b=ixDSzgtlcQGs/FlRf3MPB9gRVuaU0qVXkruuX9i9ECNu+QKUzIXCUPQw2QznlVs99
         nC5M6C19SM/4PH9pCwhBO72ACeswnuBBcx48nxXqhd7QZJiFOYnYC/yajw4QxBh37x
         6Cth1zEOuv/Y6dFUTCmFFADSIGyTQ22azqbnlzLQ=
Date:   Sun, 11 Sep 2022 20:30:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-find_get_pages_contig.patch removed from -mm tree
Message-Id: <20220912033007.9E563C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: remove find_get_pages_contig()
has been removed from the -mm tree.  Its filename was
     filemap-remove-find_get_pages_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: remove find_get_pages_contig()
Date: Tue, 23 Aug 2022 17:40:23 -0700

All callers of find_get_pages_contig() have been removed, so it is no
longer needed.

Link: https://lkml.kernel.org/r/20220824004023.77310-8-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: David Sterba <dsterb@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 -
 mm/filemap.c            |   60 --------------------------------------
 2 files changed, 62 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-find_get_pages_contig
+++ a/include/linux/pagemap.h
@@ -720,8 +720,6 @@ unsigned filemap_get_folios(struct addre
 		pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
-unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
-			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
 			pgoff_t end, xa_mark_t tag, unsigned int nr_pages,
 			struct page **pages);
--- a/mm/filemap.c~filemap-remove-find_get_pages_contig
+++ a/mm/filemap.c
@@ -2270,66 +2270,6 @@ out:
 EXPORT_SYMBOL(filemap_get_folios_contig);
 
 /**
- * find_get_pages_contig - gang contiguous pagecache lookup
- * @mapping:	The address_space to search
- * @index:	The starting page index
- * @nr_pages:	The maximum number of pages
- * @pages:	Where the resulting pages are placed
- *
- * find_get_pages_contig() works exactly like find_get_pages_range(),
- * except that the returned number of pages are guaranteed to be
- * contiguous.
- *
- * Return: the number of pages which were found.
- */
-unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
-			       unsigned int nr_pages, struct page **pages)
-{
-	XA_STATE(xas, &mapping->i_pages, index);
-	struct folio *folio;
-	unsigned int ret = 0;
-
-	if (unlikely(!nr_pages))
-		return 0;
-
-	rcu_read_lock();
-	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
-		if (xas_retry(&xas, folio))
-			continue;
-		/*
-		 * If the entry has been swapped out, we can stop looking.
-		 * No current caller is looking for DAX entries.
-		 */
-		if (xa_is_value(folio))
-			break;
-
-		if (!folio_try_get_rcu(folio))
-			goto retry;
-
-		if (unlikely(folio != xas_reload(&xas)))
-			goto put_page;
-
-again:
-		pages[ret] = folio_file_page(folio, xas.xa_index);
-		if (++ret == nr_pages)
-			break;
-		if (folio_more_pages(folio, xas.xa_index, ULONG_MAX)) {
-			xas.xa_index++;
-			folio_ref_inc(folio);
-			goto again;
-		}
-		continue;
-put_page:
-		folio_put(folio);
-retry:
-		xas_reset(&xas);
-	}
-	rcu_read_unlock();
-	return ret;
-}
-EXPORT_SYMBOL(find_get_pages_contig);
-
-/**
  * find_get_pages_range_tag - Find and return head pages matching @tag.
  * @mapping:	the address_space to search
  * @index:	the starting page index
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-filemap_range_has_writeback-to-use-folios.patch

