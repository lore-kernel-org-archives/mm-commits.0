From: akpm@linux-foundation.org
Subject: + btrfs-use-pagevec_lookup_range_tag.patch added to -mm tree
Date: Tue, 10 Oct 2017 14:00:40 -0700
Message-ID: <59dd34f8.TE5mInSDmrzTTQq1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756721AbdJJVAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, dsterba@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use pagevec_lookup_range_tag()
has been added to the -mm tree.  Its filename is
     btrfs-use-pagevec_lookup_range_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/btrfs-use-pagevec_lookup_range_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/btrfs-use-pagevec_lookup_range_tag.patch

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
@@ -3818,8 +3818,8 @@ retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		tag_pages_for_writeback(mapping, index, end);
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+			tag, PAGEVEC_SIZE))) {
 		unsigned i;
 
 		scanned = 1;
@@ -3829,11 +3829,6 @@ retry:
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
@@ -3965,8 +3960,8 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+			tag, PAGEVEC_SIZE))) {
 		unsigned i;
 
 		scanned = 1;
@@ -3990,12 +3985,6 @@ retry:
 				unlock_page(page);
 				continue;
 			}
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				unlock_page(page);
-				continue;
-			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page))
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch

