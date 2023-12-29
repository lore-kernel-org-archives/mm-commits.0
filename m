Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41411134C8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UFuZQLam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF03C433CB;
	Fri, 29 Dec 2023 20:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880024;
	bh=Y0TyoQ4PTqQAFeYJn0fchfCJo0Tl1habtdrahZS72PQ=;
	h=Date:To:From:Subject:From;
	b=UFuZQLamTjL5X/3xdkZv4DbxtXMyJo/0X3uPzoGFVT5Mp6v+8kJb8WOax+7AfImYC
	 YAmWCMkt6jOTzWDqM52Swf3x7McZlJ9sdvyLZ+fN9qC2jWHzqgw9dVaJo9xOa2p/nb
	 cMaSBsb6GsjdDJjE8JYpQSuDEJ5gtZMrZjjGxwRQ=
Date: Fri, 29 Dec 2023 12:00:23 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] adfs-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200024.0EF03C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: adfs: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     adfs-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: adfs: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:36 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/adfs/inode.c~adfs-remove-writepage-implementation
+++ a/fs/adfs/inode.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 1997-1999 Russell King
  */
 #include <linux/buffer_head.h>
+#include <linux/mpage.h>
 #include <linux/writeback.h>
 #include "adfs.h"
 
@@ -33,9 +34,10 @@ abort_toobig:
 	return 0;
 }
 
-static int adfs_writepage(struct page *page, struct writeback_control *wbc)
+static int adfs_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page, adfs_get_block, wbc);
+	return mpage_writepages(mapping, wbc, adfs_get_block);
 }
 
 static int adfs_read_folio(struct file *file, struct folio *folio)
@@ -76,10 +78,11 @@ static const struct address_space_operat
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= adfs_read_folio,
-	.writepage	= adfs_writepage,
+	.writepages	= adfs_writepages,
 	.write_begin	= adfs_write_begin,
 	.write_end	= generic_write_end,
-	.bmap		= _adfs_bmap
+	.migrate_folio	= buffer_migrate_folio,
+	.bmap		= _adfs_bmap,
 };
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

