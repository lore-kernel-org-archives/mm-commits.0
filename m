Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC0EC742A7
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCGVmk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjCGVmh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:42:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29056A6BE2
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F55461538
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F68C433EF;
        Tue,  7 Mar 2023 21:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678225350;
        bh=TPcWYJi2RUrSzHBvJLJdVYTsCL38OHX1qKd1AHGdus4=;
        h=Date:To:From:Subject:From;
        b=MSYxndyXiTzQEmwCHVFeZs9kUu3sm3IXHGVtMQh9HJ0cWxHCz1VvXF/FB3VMBk5sI
         9oHj/St91tRzspFqAYRdqPRf7BRiVipDEo7tPPKB4ExyJ3qxLJ1u2eSL7G1CHyKhZH
         sd4y1FIOY0IS+rqv6oohhrFbZQoGFN4NAIdwD//s=
Date:   Tue, 07 Mar 2023 13:42:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-remove-shmem_get_partial_folio.patch added to mm-unstable branch
Message-Id: <20230307214230.06F68C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove shmem_get_partial_folio
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-remove-shmem_get_partial_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-remove-shmem_get_partial_folio.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: shmem: remove shmem_get_partial_folio
Date: Tue, 7 Mar 2023 15:34:07 +0100

Add a new SGP_FIND mode for shmem_get_partial_folio that works like
SGP_READ, but does not check i_size.  Use that instead of open coding the
page cache lookup in shmem_get_partial_folio.  Note that this is a
behavior change in that it reads in swap cache entries for offsets outside
i_size, possibly causing a little bit of extra work.

Link: https://lkml.kernel.org/r/20230307143410.28031-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |   46 +++++++++++--------------------------
 2 files changed, 15 insertions(+), 32 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-remove-shmem_get_partial_folio
+++ a/include/linux/shmem_fs.h
@@ -105,6 +105,7 @@ enum sgp_type {
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
+	SGP_FIND,	/* like SGP_READ, but also read outside i_size */
 };
 
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
--- a/mm/shmem.c~shmem-remove-shmem_get_partial_folio
+++ a/mm/shmem.c
@@ -880,27 +880,6 @@ void shmem_unlock_mapping(struct address
 	}
 }
 
-static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
-{
-	struct folio *folio;
-
-	/*
-	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated pages as holes.
-	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-					FGP_ENTRY | FGP_LOCK, 0);
-	if (!xa_is_value(folio))
-		return folio;
-	/*
-	 * But read a page back from swap if any of it is within i_size
-	 * (although in some cases this is just a waste of time).
-	 */
-	folio = NULL;
-	shmem_get_folio(inode, index, &folio, SGP_READ);
-	return folio;
-}
-
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
@@ -960,7 +939,8 @@ static void shmem_undo_range(struct inod
 		goto whole_folios;
 
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
-	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
+	folio = NULL;
+	shmem_get_folio(inode, lstart >> PAGE_SHIFT, &folio, SGP_FIND);
 	if (folio) {
 		same_folio = lend < folio_pos(folio) + folio_size(folio);
 		folio_mark_dirty(folio);
@@ -974,14 +954,16 @@ static void shmem_undo_range(struct inod
 		folio = NULL;
 	}
 
-	if (!same_folio)
-		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
-	if (folio) {
-		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend))
-			end = folio->index;
-		folio_unlock(folio);
-		folio_put(folio);
+	if (!same_folio) {
+		folio = NULL;
+		shmem_get_folio(inode, lend >> PAGE_SHIFT, &folio, SGP_FIND);
+		if (folio) {
+			folio_mark_dirty(folio);
+			if (!truncate_inode_partial_folio(folio, lstart, lend))
+				end = folio->index;
+			folio_unlock(folio);
+			folio_put(folio);
+		}
 	}
 
 whole_folios:
@@ -1903,7 +1885,7 @@ repeat:
 		if (folio_test_uptodate(folio))
 			goto out;
 		/* fallocated folio */
-		if (sgp != SGP_READ)
+		if (sgp != SGP_READ && sgp != SGP_FIND)
 			goto clear;
 		folio_unlock(folio);
 		folio_put(folio);
@@ -1914,7 +1896,7 @@ repeat:
 	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
 	 */
 	*foliop = NULL;
-	if (sgp == SGP_READ)
+	if (sgp == SGP_READ || sgp == SGP_FIND)
 		return 0;
 	if (sgp == SGP_NOALLOC)
 		return -ENOENT;
_

Patches currently in -mm which might be from hch@lst.de are

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch
mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-remove-shmem_get_partial_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch

