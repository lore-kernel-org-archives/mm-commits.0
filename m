From: akpm@linux-foundation.org
Subject: + fs-fix-performance-regression-in-clean_bdev_aliases.patch added to -mm tree
Date: Wed, 26 Jul 2017 15:17:50 -0700
Message-ID: <5979150e.Fau0zgNEo8qLj7Kt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWRv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, axboe@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fix performance regression in clean_bdev_aliases()
has been added to the -mm tree.  Its filename is
     fs-fix-performance-regression-in-clean_bdev_aliases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fix-performance-regression-in-clean_bdev_aliases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fix-performance-regression-in-clean_bdev_aliases.patch

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
Subject: fs: fix performance regression in clean_bdev_aliases()

e64855c6cfaa ("fs: Add helper to clean bdev aliases under a bh and use
it") added a wrapper for clean_bdev_aliases() that invalidates bdev
aliases underlying a single buffer head.  However this has caused a
performance regression for bonnie++ benchmark on ext4 filesystem when
delayed allocation is turned off (ext3 mode) - average of 3 runs:

Hmean SeqOut Char  164787.55 (  0.00%) 107189.06 (-34.95%)
Hmean SeqOut Block 219883.89 (  0.00%) 168870.32 (-23.20%)

The reason for this regression is that clean_bdev_aliases() is slower
when called for a single block because pagevec_lookup() it uses will end
up iterating through the radix tree until it finds a page (which may
take a while) but we are only interested whether there's a page at a
particular index.

Fix the problem by using pagevec_lookup_range() instead which avoids the
needless iteration.

Fixes: e64855c6cfaa ("fs: Add helper to clean bdev aliases under a bh and use it")
Link: http://lkml.kernel.org/r/20170726114704.7626-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/buffer.c~fs-fix-performance-regression-in-clean_bdev_aliases fs/buffer.c
--- a/fs/buffer.c~fs-fix-performance-regression-in-clean_bdev_aliases
+++ a/fs/buffer.c
@@ -1627,19 +1627,18 @@ void clean_bdev_aliases(struct block_dev
 	struct pagevec pvec;
 	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pgoff_t end;
-	int i;
+	int i, count;
 	struct buffer_head *bh;
 	struct buffer_head *head;
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pagevec_init(&pvec, 0);
-	while (index <= end && pagevec_lookup(&pvec, bd_mapping, &index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
+	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end,
+				    PAGEVEC_SIZE)) {
+		count = pagevec_count(&pvec);
+		for (i = 0; i < count; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			if (!page_has_buffers(page))
 				continue;
 			/*
@@ -1669,6 +1668,9 @@ unlock_page:
 		}
 		pagevec_release(&pvec);
 		cond_resched();
+		/* End of range already reached? */
+		if (index > end || !index)
+			break;
 	}
 }
 EXPORT_SYMBOL(clean_bdev_aliases);
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

