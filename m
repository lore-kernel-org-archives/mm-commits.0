From: akpm@linux-foundation.org
Subject: +
 ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch added to
 -mm tree
Date: Wed, 26 Jul 2017 15:17:52 -0700
Message-ID: <59791510.6tOv+Zmif0OJJTgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWRx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use pagevec_lookup_range() in ext4_find_unwritten_pgoff()
has been added to the -mm tree.  Its filename is
     ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch

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
Subject: ext4: use pagevec_lookup_range() in ext4_find_unwritten_pgoff()

Use pagevec_lookup_range() in ext4_find_unwritten_pgoff() since we are
interested only in pages in the given range.  Simplify the logic as a
result of not getting pages out of range and index getting automatically
advanced.

Link: http://lkml.kernel.org/r/20170726114704.7626-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/ext4/file.c~ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff
+++ a/fs/ext4/file.c
@@ -464,12 +464,11 @@ static int ext4_find_unwritten_pgoff(str
 
 	pagevec_init(&pvec, 0);
 	do {
-		int i, num;
+		int i;
 		unsigned long nr_pages;
 
-		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
-					  (pgoff_t)num);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+					&index, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
@@ -488,9 +487,6 @@ static int ext4_find_unwritten_pgoff(str
 				goto out;
 			}
 
-			if (page->index > end)
-				goto out;
-
 			lock_page(page);
 
 			if (unlikely(page->mapping != inode->i_mapping)) {
@@ -530,12 +526,10 @@ static int ext4_find_unwritten_pgoff(str
 			unlock_page(page);
 		}
 
-		/* The no. of pages is less than our desired, we are done. */
-		if (nr_pages < num)
-			break;
 		pagevec_release(&pvec);
 	} while (index <= end);
 
+	/* There are no pages upto endoff - that would be a hole in there. */
 	if (whence == SEEK_HOLE && lastoff < endoff) {
 		found = 1;
 		*offset = lastoff;
_

Patches currently in -mm which might be from jack@suse.cz are

fscache-remove-unused-now_uncached-callback.patch
mm-make-pagevec_lookup-update-index.patch
mm-implement-find_get_pages_range.patch
fs-fix-performance-regression-in-clean_bdev_aliases.patch
ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch
ext4-use-pagevec_lookup_range-in-writeback-code.patch
hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch
fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
mm-use-find_get_pages_range-in-filemap_range_has_page.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range.patch

