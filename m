From: akpm@linux-foundation.org
Subject: [patch 062/131] nilfs2: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:35:02 -0800
Message-ID: <20171116013502.L52IhySpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932317AbdKPBfD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: nilfs2: use pagevec_lookup_range_tag()

We want only pages from given range in nilfs_lookup_dirty_data_buffers(). 
Use pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-10-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-use-pagevec_lookup_range_tag fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-use-pagevec_lookup_range_tag
+++ a/fs/nilfs2/segment.c
@@ -711,18 +711,14 @@ static size_t nilfs_lookup_dirty_data_bu
 	pagevec_init(&pvec, 0);
  repeat:
 	if (unlikely(index > last) ||
-	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				min_t(pgoff_t, last - index,
-				      PAGEVEC_SIZE - 1) + 1))
+	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))
 		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
 		struct page *page = pvec.pages[i];
 
-		if (unlikely(page->index > last))
-			break;
