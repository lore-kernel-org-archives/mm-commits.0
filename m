From: akpm@linux-foundation.org
Subject: + ext4-use-pagevec_lookup_range-in-writeback-code.patch added to
 -mm tree
Date: Wed, 26 Jul 2017 15:17:54 -0700
Message-ID: <59791512.SFANpyihMQhDNGaU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWRz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use pagevec_lookup_range() in writeback code
has been added to the -mm tree.  Its filename is
     ext4-use-pagevec_lookup_range-in-writeback-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-use-pagevec_lookup_range-in-writeback-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-use-pagevec_lookup_range-in-writeback-code.patch

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
Subject: ext4: use pagevec_lookup_range() in writeback code

Both occurences of pagevec_lookup() actually want only pages from a given
range.  Use pagevec_lookup_range() for the lookup.

Link: http://lkml.kernel.org/r/20170726114704.7626-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/ext4/inode.c~ext4-use-pagevec_lookup_range-in-writeback-code fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-use-pagevec_lookup_range-in-writeback-code
+++ a/fs/ext4/inode.c
@@ -1676,13 +1676,13 @@ static void mpage_release_unused_pages(s
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, &index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end,
+						PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			if (page->index > end)
-				break;
+
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 			if (invalidate) {
@@ -2303,15 +2303,13 @@ static int mpage_map_and_submit_buffers(
 
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &start,
-					  PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+						&start, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			bh = head = page_buffers(page);
 			do {
 				if (lblk < mpd->map.m_lblk)
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

