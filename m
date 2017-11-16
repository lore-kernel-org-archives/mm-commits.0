From: akpm@linux-foundation.org
Subject: [patch 055/131] btrfs: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:34:37 -0800
Message-ID: <20171116013437.YRev0LQFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dsterba@suse.com, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
