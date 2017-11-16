From: akpm@linux-foundation.org
Subject: [merged] ext4-use-pagevec_lookup_range_tag.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:01:35 -0800
Message-ID: <20171116200135.Xhxoc0KA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUBg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, tytso@mit.edu


The patch titled
     Subject: ext4: use pagevec_lookup_range_tag()
has been removed from the -mm tree.  Its filename was
     ext4-use-pagevec_lookup_range_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ext4: use pagevec_lookup_range_tag()

We want only pages from given range in ext4_writepages().  Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN fs/ext4/inode.c~ext4-use-pagevec_lookup_range_tag fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-use-pagevec_lookup_range_tag
+++ a/fs/ext4/inode.c
@@ -2620,8 +2620,8 @@ static int mpage_prepare_extent_to_map(s
 	mpd->map.m_len = 0;
 	mpd->next_page = index;
 	while (index <= end) {
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			goto out;
 
@@ -2629,16 +2629,6 @@ static int mpage_prepare_extent_to_map(s
 			struct page *page = pvec.pages[i];
 
 			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or
-			 * even swizzled back from swapper_space to tmpfs file
-			 * mapping. However, page->index will not change
-			 * because we have a reference on the page.
-			 */
-			if (page->index > end)
-				goto out;
