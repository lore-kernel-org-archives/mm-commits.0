From: akpm@linux-foundation.org
Subject: + fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
 added to -mm tree
Date: Wed, 26 Jul 2017 15:17:58 -0700
Message-ID: <59791516.wk/3qZPjEgAktb53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWR7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use pagevec_lookup_range() in page_cache_seek_hole_data()
has been added to the -mm tree.  Its filename is
     fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
