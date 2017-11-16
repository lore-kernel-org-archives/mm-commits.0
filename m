From: akpm@linux-foundation.org
Subject: [patch 057/131] ext4: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:34:44 -0800
Message-ID: <20171116013444.TplqRZcgC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933599AbdKPBeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, tytso@mit.edu

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
