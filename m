Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22757C46CA1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjJRVhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbjJRVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5283D199
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CADC4339A;
        Wed, 18 Oct 2023 21:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664932;
        bh=Ue+0JPjOUorDIpeEA+Mb9N+V48x/rPZAUbecK5iWaTU=;
        h=Date:To:From:Subject:From;
        b=bFLptoWmgunU+lVHcP4qkHa7ac8lQUaenqGtHH1Yb3Y+XFwZpXFXpvVOZrMc9/Yuw
         qt650V0L5mFpjcC6tyYjLSACsUM13ZUN0Gz3Cfvws1ejby4vVV6zK42iRrDdgrviCe
         iC+LVDnmn3T5ljx/4jpZwB88SlkDKduYVRx9rsfk=
Date:   Wed, 18 Oct 2023 14:35:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-call-filemap_get_folios_tag-from-filemap_get_folios.patch removed from -mm tree
Message-Id: <20231018213532.43CADC4339A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: call filemap_get_folios_tag() from filemap_get_folios()
has been removed from the -mm tree.  Its filename was
     filemap-call-filemap_get_folios_tag-from-filemap_get_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: filemap: call filemap_get_folios_tag() from filemap_get_folios()
Date: Fri, 6 Oct 2023 13:01:20 +0200

filemap_get_folios() is filemap_get_folios_tag() with XA_PRESENT as the
tag that is being matched.  Return filemap_get_folios_tag() with
XA_PRESENT as the tag instead of duplicating the code in
filemap_get_folios().

No functional changes.

Link: https://lkml.kernel.org/r/20231006110120.136809-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   45 ++++++++-------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

--- a/mm/filemap.c~filemap-call-filemap_get_folios_tag-from-filemap_get_folios
+++ a/mm/filemap.c
@@ -2120,48 +2120,13 @@ put:
  * index @start and up to index @end (inclusive).  The folios are returned
  * in @fbatch with an elevated reference count.
  *
- * The first folio may start before @start; if it does, it will contain
- * @start.  The final folio may extend beyond @end; if it does, it will
- * contain @end.  The folios have ascending indices.  There may be gaps
- * between the folios if there are indices which have no folio in the
- * page cache.  If folios are added to or removed from the page cache
- * while this is running, they may or may not be found by this call.
- *
  * Return: The number of folios which were found.
  * We also update @start to index the next folio for the traversal.
  */
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch)
 {
-	XA_STATE(xas, &mapping->i_pages, *start);
-	struct folio *folio;
-
-	rcu_read_lock();
-	while ((folio = find_get_entry(&xas, end, XA_PRESENT)) != NULL) {
-		/* Skip over shadow, swap and DAX entries */
-		if (xa_is_value(folio))
-			continue;
-		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
-			goto out;
-		}
-	}
-
-	/*
-	 * We come here when there is no page beyond @end. We take care to not
-	 * overflow the index @start as it confuses some of the callers. This
-	 * breaks the iteration when there is a page at index -1 but that is
-	 * already broken anyway.
-	 */
-	if (end == (pgoff_t)-1)
-		*start = (pgoff_t)-1;
-	else
-		*start = end + 1;
-out:
-	rcu_read_unlock();
-
-	return folio_batch_count(fbatch);
+	return filemap_get_folios_tag(mapping, start, end, XA_PRESENT, fbatch);
 }
 EXPORT_SYMBOL(filemap_get_folios);
 
@@ -2240,7 +2205,13 @@ EXPORT_SYMBOL(filemap_get_folios_contig)
  * @tag:        The tag index
  * @fbatch:     The batch to fill
  *
- * Same as filemap_get_folios(), but only returning folios tagged with @tag.
+ * The first folio may start before @start; if it does, it will contain
+ * @start.  The final folio may extend beyond @end; if it does, it will
+ * contain @end.  The folios have ascending indices.  There may be gaps
+ * between the folios if there are indices which have no folio in the
+ * page cache.  If folios are added to or removed from the page cache
+ * while this is running, they may or may not be found by this call.
+ * Only returns folios that are tagged with @tag.
  *
  * Return: The number of folios found.
  * Also update @start to index the next folio for traversal.
_

Patches currently in -mm which might be from p.raghav@samsung.com are


