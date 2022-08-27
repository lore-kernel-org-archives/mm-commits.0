Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82448ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbiH0D3O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345153AbiH0D24 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:28:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87A7A721E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C09B83392
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9D0C433D6;
        Sat, 27 Aug 2022 03:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570932;
        bh=BVI7+U75kWzPgXjNcOCj2V8YVRC5fHCz4VpjNoSo4lc=;
        h=Date:To:From:Subject:From;
        b=ygA22keyPa4Dan5Yuo5UkeD+KF+pPefCPK5nSxiLqDf3rd8Oh0yygu/0WW3bw558G
         uxIajEN2ZyGe9pyTD9s8T49iCIvHlQSy/kxUCTh12auqHCUvsd1fLYgLiuNpBTKHWA
         EQ5maqEdl2fA6b60DHZFjGzJ1BZ9gniY9ToCBcSs=
Date:   Fri, 26 Aug 2022 20:28:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-find_get_pages_contig.patch added to mm-unstable branch
Message-Id: <20220827032852.1A9D0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove find_get_pages_contig()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-find_get_pages_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-find_get_pages_contig.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2262,66 +2262,6 @@ out:
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

filemap-add-filemap_get_folios_contig.patch
btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch
btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch
btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch
nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch
ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch
filemap-remove-find_get_pages_contig.patch

