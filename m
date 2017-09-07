From: akpm@linux-foundation.org
Subject: [merged]
 fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch removed from
 -mm tree
Date: Thu, 07 Sep 2017 11:39:07 -0700
Message-ID: <20170907183907.DlZQzSxbu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755671AbdIGSjI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use pagevec_lookup_range() in page_cache_seek_hole_data()
has been removed from the -mm tree.  Its filename was
     fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs: use pagevec_lookup_range() in page_cache_seek_hole_data()

We want only pages from given range in page_cache_seek_hole_data().  Use
pagevec_lookup_range() instead of pagevec_lookup() and remove unnecessary
code.  Note that the check for getting less pages than desired can be
removed because index gets updated by pagevec_lookup_range().

Link: http://lkml.kernel.org/r/20170726114704.7626-9-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/buffer.c~fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data fs/buffer.c
--- a/fs/buffer.c~fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data
+++ a/fs/buffer.c
@@ -3549,11 +3549,10 @@ page_cache_seek_hole_data(struct inode *
 	pagevec_init(&pvec, 0);
 
 	do {
-		unsigned want, nr_pages, i;
+		unsigned nr_pages, i;
 
-		want = min_t(unsigned, end - index, PAGEVEC_SIZE);
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
-					  want);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
+						end - 1, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
@@ -3574,10 +3573,6 @@ page_cache_seek_hole_data(struct inode *
 			    lastoff < page_offset(page))
 				goto check_range;
 
-			/* Searching done if the page index is out of range. */
-			if (page->index >= end)
-				goto not_found;
-
 			lock_page(page);
 			if (likely(page->mapping == inode->i_mapping) &&
 			    page_has_buffers(page)) {
@@ -3590,11 +3585,6 @@ page_cache_seek_hole_data(struct inode *
 			unlock_page(page);
 			lastoff = page_offset(page) + PAGE_SIZE;
 		}
-
-		/* Searching done if fewer pages returned than wanted. */
-		if (nr_pages < want)
-			break;
