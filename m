Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF2EC0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjJYXsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D656D199
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F441C433CA;
        Wed, 25 Oct 2023 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277679;
        bh=V/4Mtvx5QHCcOzV9YCCvSnIL5GLaCMxiFtS9Pue6oRs=;
        h=Date:To:From:Subject:From;
        b=IWrWoiuEua8oqvXU2oUyQFHFxWqlj8dtw0IBStkP/Ntb05XPzKlYpvmqIw1SEXKGo
         UHIysg4EtoCVeANGUfGKPVNqep6UTCnu393FNxy32mR1qKOWpasmtCQIveZ5uQfUuI
         MZ/Yi4C1Z/oqcyB0yy2TWiRZr+K4qwAiGIl6t1L4=
Date:   Wed, 25 Oct 2023 16:47:58 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch removed from -mm tree
Message-Id: <20231025234759.6F441C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_copy_page() to nilfs_copy_folio()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_copy_page() to nilfs_copy_folio()
Date: Mon, 16 Oct 2023 21:10:59 +0100

Both callers already have a folio, so pass it in and use it directly. 
Removes a lot of hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   50 +++++++++++++++++++++++----------------------
 mm/util.c        |    1 
 2 files changed, 27 insertions(+), 24 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio
+++ a/fs/nilfs2/page.c
@@ -184,30 +184,32 @@ void nilfs_page_bug(struct page *page)
 }
 
 /**
- * nilfs_copy_page -- copy the page with buffers
- * @dst: destination page
- * @src: source page
- * @copy_dirty: flag whether to copy dirty states on the page's buffer heads.
+ * nilfs_copy_folio -- copy the folio with buffers
+ * @dst: destination folio
+ * @src: source folio
+ * @copy_dirty: flag whether to copy dirty states on the folio's buffer heads.
  *
- * This function is for both data pages and btnode pages.  The dirty flag
- * should be treated by caller.  The page must not be under i/o.
- * Both src and dst page must be locked
+ * This function is for both data folios and btnode folios.  The dirty flag
+ * should be treated by caller.  The folio must not be under i/o.
+ * Both src and dst folio must be locked
  */
-static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
+static void nilfs_copy_folio(struct folio *dst, struct folio *src,
+		bool copy_dirty)
 {
 	struct buffer_head *dbh, *dbufs, *sbh;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
-	BUG_ON(PageWriteback(dst));
+	BUG_ON(folio_test_writeback(dst));
 
-	sbh = page_buffers(src);
-	if (!page_has_buffers(dst))
-		create_empty_buffers(dst, sbh->b_size, 0);
+	sbh = folio_buffers(src);
+	dbh = folio_buffers(dst);
+	if (!dbh)
+		dbh = folio_create_empty_buffers(dst, sbh->b_size, 0);
 
 	if (copy_dirty)
 		mask |= BIT(BH_Dirty);
 
-	dbh = dbufs = page_buffers(dst);
+	dbufs = dbh;
 	do {
 		lock_buffer(sbh);
 		lock_buffer(dbh);
@@ -218,16 +220,16 @@ static void nilfs_copy_page(struct page
 		dbh = dbh->b_this_page;
 	} while (dbh != dbufs);
 
-	copy_highpage(dst, src);
+	folio_copy(dst, src);
 
-	if (PageUptodate(src) && !PageUptodate(dst))
-		SetPageUptodate(dst);
-	else if (!PageUptodate(src) && PageUptodate(dst))
-		ClearPageUptodate(dst);
-	if (PageMappedToDisk(src) && !PageMappedToDisk(dst))
-		SetPageMappedToDisk(dst);
-	else if (!PageMappedToDisk(src) && PageMappedToDisk(dst))
-		ClearPageMappedToDisk(dst);
+	if (folio_test_uptodate(src) && !folio_test_uptodate(dst))
+		folio_mark_uptodate(dst);
+	else if (!folio_test_uptodate(src) && folio_test_uptodate(dst))
+		folio_clear_uptodate(dst);
+	if (folio_test_mappedtodisk(src) && !folio_test_mappedtodisk(dst))
+		folio_set_mappedtodisk(dst);
+	else if (!folio_test_mappedtodisk(src) && folio_test_mappedtodisk(dst))
+		folio_clear_mappedtodisk(dst);
 
 	do {
 		unlock_buffer(sbh);
@@ -269,7 +271,7 @@ repeat:
 			NILFS_PAGE_BUG(&folio->page,
 				       "found empty page in dat page cache");
 
-		nilfs_copy_page(&dfolio->page, &folio->page, 1);
+		nilfs_copy_folio(dfolio, folio, true);
 		filemap_dirty_folio(folio_mapping(dfolio), dfolio);
 
 		folio_unlock(dfolio);
@@ -314,7 +316,7 @@ repeat:
 		if (!IS_ERR(dfolio)) {
 			/* overwrite existing folio in the destination cache */
 			WARN_ON(folio_test_dirty(dfolio));
-			nilfs_copy_page(&dfolio->page, &folio->page, 0);
+			nilfs_copy_folio(dfolio, folio, false);
 			folio_unlock(dfolio);
 			folio_put(dfolio);
 			/* Do we not need to remove folio from smap here? */
--- a/mm/util.c~nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio
+++ a/mm/util.c
@@ -799,6 +799,7 @@ void folio_copy(struct folio *dst, struc
 		cond_resched();
 	}
 }
+EXPORT_SYMBOL(folio_copy);
 
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 int sysctl_overcommit_ratio __read_mostly = 50;
_

Patches currently in -mm which might be from willy@infradead.org are


