Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4F1C001DC
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjFXAAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjFXAAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9016B2724
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E37861582
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86488C433C9;
        Sat, 24 Jun 2023 00:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564826;
        bh=G20BvccHTwhY8fV98JS1Qt2NDB6VrA3udPPDJV572io=;
        h=Date:To:From:Subject:From;
        b=Xgx6EFu8jMgMTZJHaM1b82Lq9PRvYMMPVJJVj1r+4DR7vr1KOTGi8PV3C+H4s8zvA
         klP2WSrtQB4ezCb30Lt4LKT/4OKNy/qPvYYMEg5YkCDJIjQF8FzwdUKnSbWpS39NrI
         +2b2kOinkphVqGjsCt0fA4jWQJdE29gyGCq5HdPY=
Date:   Fri, 23 Jun 2023 17:00:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch removed from -mm tree
Message-Id: <20230624000026.86488C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rename invalidate_mapping_pagevec to mapping_try_invalidate
has been removed from the -mm tree.  Its filename was
     mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: rename invalidate_mapping_pagevec to mapping_try_invalidate
Date: Wed, 21 Jun 2023 17:45:55 +0100

We don't use pagevecs for the LRU cache any more, and we don't know that
the failed invalidations were due to the folio being in an LRU cache.  So
rename it to be more accurate.

Link: https://lkml.kernel.org/r/20230621164557.3510324-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c  |   16 +++++++---------
 mm/internal.h |    4 ++--
 mm/truncate.c |   25 ++++++++++++-------------
 3 files changed, 21 insertions(+), 24 deletions(-)

--- a/mm/fadvise.c~mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate
+++ a/mm/fadvise.c
@@ -143,7 +143,7 @@ int generic_fadvise(struct file *file, l
 		}
 
 		if (end_index >= start_index) {
-			unsigned long nr_pagevec = 0;
+			unsigned long nr_failed = 0;
 
 			/*
 			 * It's common to FADV_DONTNEED right after
@@ -156,17 +156,15 @@ int generic_fadvise(struct file *file, l
 			 */
 			lru_add_drain();
 
-			invalidate_mapping_pagevec(mapping,
-						start_index, end_index,
-						&nr_pagevec);
+			mapping_try_invalidate(mapping, start_index, end_index,
+					&nr_failed);
 
 			/*
-			 * If fewer pages were invalidated than expected then
-			 * it is possible that some of the pages were on
-			 * a per-cpu pagevec for a remote CPU. Drain all
-			 * pagevecs and try again.
+			 * The failures may be due to the folio being
+			 * in the LRU cache of a remote CPU. Drain all
+			 * caches and try again.
 			 */
-			if (nr_pagevec) {
+			if (nr_failed) {
 				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
--- a/mm/internal.h~mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate
+++ a/mm/internal.h
@@ -133,8 +133,8 @@ int truncate_inode_folio(struct address_
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long invalidate_inode_page(struct page *page);
-unsigned long invalidate_mapping_pagevec(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec);
+unsigned long mapping_try_invalidate(struct address_space *mapping,
+		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
 
 /**
  * folio_evictable - Test whether a folio is evictable.
--- a/mm/truncate.c~mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate
+++ a/mm/truncate.c
@@ -486,18 +486,17 @@ void truncate_inode_pages_final(struct a
 EXPORT_SYMBOL(truncate_inode_pages_final);
 
 /**
- * invalidate_mapping_pagevec - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
+ * mapping_try_invalidate - Invalidate all the evictable folios of one inode
+ * @mapping: the address_space which holds the folios to invalidate
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
- * @nr_pagevec: invalidate failed page number for caller
+ * @nr_failed: How many folio invalidations failed
  *
- * This helper is similar to invalidate_mapping_pages(), except that it accounts
- * for pages that are likely on a pagevec and counts them in @nr_pagevec, which
- * will be used by the caller.
+ * This function is similar to invalidate_mapping_pages(), except that it
+ * returns the number of folios which could not be evicted in @nr_failed.
  */
-unsigned long invalidate_mapping_pagevec(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
+unsigned long mapping_try_invalidate(struct address_space *mapping,
+		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
 {
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct folio_batch fbatch;
@@ -527,9 +526,9 @@ unsigned long invalidate_mapping_pagevec
 			 */
 			if (!ret) {
 				deactivate_file_folio(folio);
-				/* It is likely on the pagevec of a remote CPU */
-				if (nr_pagevec)
-					(*nr_pagevec)++;
+				/* Likely in the lru cache of a remote CPU */
+				if (nr_failed)
+					(*nr_failed)++;
 			}
 			count += ret;
 		}
@@ -552,12 +551,12 @@ unsigned long invalidate_mapping_pagevec
  * If you want to remove all the pages of one inode, regardless of
  * their use and writeback state, use truncate_inode_pages().
  *
- * Return: the number of the cache entries that were invalidated
+ * Return: The number of indices that had their contents invalidated
  */
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end)
 {
-	return invalidate_mapping_pagevec(mapping, start, end, NULL);
+	return mapping_try_invalidate(mapping, start, end, NULL);
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
_

Patches currently in -mm which might be from willy@infradead.org are


