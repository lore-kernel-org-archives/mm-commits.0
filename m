From: akpm@linux-foundation.org
Subject: [merged] btrfs-use-pagevec_lookup_range_tag.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:01:28 -0800
Message-ID: <20171116200128.nvff8Yhkv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUBa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dsterba@suse.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use pagevec_lookup_range_tag()
has been removed from the -mm tree.  Its filename was
     btrfs-use-pagevec_lookup_range_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: btrfs: use pagevec_lookup_range_tag()

We want only pages from given range in btree_write_cache_pages() and
extent_write_cache_pages().  Use pagevec_lookup_range_tag() instead of
pagevec_lookup_tag() and remove unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN fs/btrfs/extent_io.c~btrfs-use-pagevec_lookup_range_tag fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~btrfs-use-pagevec_lookup_range_tag
+++ a/fs/btrfs/extent_io.c
@@ -3814,8 +3814,8 @@ retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		tag_pages_for_writeback(mapping, index, end);
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+			tag, PAGEVEC_SIZE))) {
 		unsigned i;
 
 		scanned = 1;
@@ -3825,11 +3825,6 @@ retry:
 			if (!PagePrivate(page))
 				continue;
 
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				break;
-			}
-
 			spin_lock(&mapping->private_lock);
 			if (!PagePrivate(page)) {
 				spin_unlock(&mapping->private_lock);
@@ -3961,8 +3956,8 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+			tag, PAGEVEC_SIZE))) {
 		unsigned i;
 
 		scanned = 1;
@@ -3986,12 +3981,6 @@ retry:
 				unlock_page(page);
 				continue;
 			}
