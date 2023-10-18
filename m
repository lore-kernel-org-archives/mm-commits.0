Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85397CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjJRVfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJRVfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC1D47
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF14FC4339A;
        Wed, 18 Oct 2023 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664900;
        bh=frAUvHaxPymfEzZXC67FmtjsAdI4TpeKAB7iwp8AvVc=;
        h=Date:To:From:Subject:From;
        b=BuC5Vv67W9Wrjbr+tppbX4lqnTWdQtSrxg8PDQvXd+Hg88igXd5XF9vGdOnG9nSV0
         6gMDEAh/7b4JbZ7Uofz/A5A6ybdNtMs0lhngJ7SB5pBnc0WoWze+525yvT5zZon7HE
         rxgDdEz20zJKQv7TOyadi2iiUIqp49e2tjpbzDgE=
Date:   Wed, 18 Oct 2023 14:34:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        hch@lst.de, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch removed from -mm tree
Message-Id: <20231018213459.EF14FC4339A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap: clarify filemap_fault() comments for not uptodate case
has been removed from the -mm tree.  Its filename was
     mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/filemap: clarify filemap_fault() comments for not uptodate case
Date: Sun, 1 Oct 2023 00:10:29 +0100

The existing comments in filemap_fault() suggest that, after either a
minor fault has occurred and filemap_get_folio() found a folio in the page
cache, or a major fault arose and __filemap_get_folio(FGP_CREATE...) did
the job (having relied on do_sync_mmap_readahead() or filemap_read_folio()
to read in the folio), the only possible reason it could not be uptodate
is because of an error.

This is not so, as if, for instance, the fault occurred within a VMA which
had the VM_RAND_READ flag set (via madvise() with the MADV_RANDOM flag
specified), this would cause even synchronous readahead to fail to read in
the folio.

I confirmed this by dropping page caches and faulting in memory
madvise()'d this way, observing that this code path was reached on each
occasion.

Clarify the comments to include this case, and additionally update the
comment recently added around the invalidate lock logic to make it clear
the comment explicitly refers to the minor fault case.

In addition, while we're here, refer to folios rather than pages.

[lstoakes@gmail.com: correct identation as per Christopher's feedback]
  Link: https://lkml.kernel.org/r/2c7014c0-6343-4e76-8697-3f84f54350bd@lucifer.local
Link: https://lkml.kernel.org/r/20230930231029.88196-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case
+++ a/mm/filemap.c
@@ -3307,21 +3307,28 @@ retry_find:
 	VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
 
 	/*
-	 * We have a locked page in the page cache, now we need to check
-	 * that it's up-to-date. If not, it is going to be due to an error.
+	 * We have a locked folio in the page cache, now we need to check
+	 * that it's up-to-date. If not, it is going to be due to an error,
+	 * or because readahead was otherwise unable to retrieve it.
 	 */
 	if (unlikely(!folio_test_uptodate(folio))) {
 		/*
-		 * The page was in cache and uptodate and now it is not.
-		 * Strange but possible since we didn't hold the page lock all
-		 * the time. Let's drop everything get the invalidate lock and
-		 * try again.
+		 * If the invalidate lock is not held, the folio was in cache
+		 * and uptodate and now it is not. Strange but possible since we
+		 * didn't hold the page lock all the time. Let's drop
+		 * everything, get the invalidate lock and try again.
 		 */
 		if (!mapping_locked) {
 			folio_unlock(folio);
 			folio_put(folio);
 			goto retry_find;
 		}
+
+		/*
+		 * OK, the folio is really not uptodate. This can be because the
+		 * VMA has the VM_RAND_READ flag set, or because an error
+		 * arose. Let's read it in directly.
+		 */
 		goto page_not_uptodate;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are


