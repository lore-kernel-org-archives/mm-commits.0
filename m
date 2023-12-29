Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F919134C7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ahxrgAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE52C433C7;
	Fri, 29 Dec 2023 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880025;
	bh=/gbvQnLtg3TH9Jt5y8xwoIC5o52GXQGFFcZoRsS73Jo=;
	h=Date:To:From:Subject:From;
	b=1ahxrgAheCy5qieIj0TLeJ618fsfBNJHGvvYsyiKR23oDe1kk2nLOjcjAplo2EFsB
	 2lw5GEkCqAytLl4qTL4wK8Limr5Jhe0YihysZzYLIIyf4h+XRLC3wdSV9o9ws+dCxK
	 fK1ZpeUlioh0/TaYVsP21QnOmR8pZZfyTSlOSkZg=
Date: Fri, 29 Dec 2023 12:00:24 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bfs-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200025.1AE52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bfs: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     bfs-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: bfs: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:37 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/file.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/bfs/file.c~bfs-remove-writepage-implementation
+++ a/fs/bfs/file.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mpage.h>
 #include <linux/buffer_head.h>
 #include "bfs.h"
 
@@ -150,9 +151,10 @@ out:
 	return err;
 }
 
-static int bfs_writepage(struct page *page, struct writeback_control *wbc)
+static int bfs_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page, bfs_get_block, wbc);
+	return mpage_writepages(mapping, wbc, bfs_get_block);
 }
 
 static int bfs_read_folio(struct file *file, struct folio *folio)
@@ -190,9 +192,10 @@ const struct address_space_operations bf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= bfs_read_folio,
-	.writepage	= bfs_writepage,
+	.writepages	= bfs_writepages,
 	.write_begin	= bfs_write_begin,
 	.write_end	= generic_write_end,
+	.migrate_folio	= buffer_migrate_folio,
 	.bmap		= bfs_bmap,
 };
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

