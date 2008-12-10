From: akpm@linux-foundation.org
Subject: - do_mpage_readpage-remove-first_logical_block-parameter-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2008 12:29:14 -0800
Message-ID: <200812102029.mBAKTEWT028458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbYLJU3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 15:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vagabon.xyz@gmail.com, mikevs@xs4all.net, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     do_mpage_readpage-remove-first_logical_block-parameter-fix
has been removed from the -mm tree.  Its filename was
     do_mpage_readpage-remove-first_logical_block-parameter-fix.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_mpage_readpage-remove-first_logical_block-parameter-fix
From: Franck Bui-Huu <vagabon.xyz@gmail.com>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/mpage.c~do_mpage_readpage-remove-first_logical_block-parameter-fix fs/mpage.c
--- a/fs/mpage.c~do_mpage_readpage-remove-first_logical_block-parameter-fix
+++ a/fs/mpage.c
@@ -157,6 +157,19 @@ map_buffer_to_page(struct page *page, st
 }
 
 /*
+ * Since get_block() can map a range of pages, for all these pages the
+ * BH_Boundary flag will be set.  But we only need to push what I/O we
+ * have accumulated at the last block of this range.
+*/
+static int last_mapped_page(struct buffer_head *map_bh, struct page *page)
+{
+	pgoff_t map_index = map_bh->b_page->index;
+
+	return buffer_boundary(map_bh) &&
+		page->index >= map_index + (map_bh->b_size>>PAGE_CACHE_SHIFT);
+}
+
+/*
  * This is the worker routine which does all the work of mapping the disk
  * blocks and constructs largest possible bios, submits them for IO if the
  * blocks are not contiguous on the disk.
@@ -312,10 +325,7 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	relative_block = block_in_file - *first_logical_block;
-	nblocks = map_bh->b_size >> blkbits;
-	if ((buffer_boundary(map_bh) && relative_block == nblocks) ||
-	    (first_hole != blocks_per_page))
+	if (last_mapped_page(map_bh, page) || first_hole != blocks_per_page)
 		bio = mpage_bio_submit(READ, bio);
 	else
 		*last_block_in_bio = blocks[blocks_per_page - 1];
_

Patches currently in -mm which might be from vagabon.xyz@gmail.com are

do_mpage_readpage-remove-first_logical_block-parameter-fix.patch

