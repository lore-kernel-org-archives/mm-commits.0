Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7283613FE0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FnPDOlk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C97C433C8;
	Fri, 29 Dec 2023 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880031;
	bh=Y5yZNj+hlKmFgytJvw5BK1X7jgSemYiOkW543tIEXuA=;
	h=Date:To:From:Subject:From;
	b=FnPDOlk2/mok9RaIH0WZ/17MhDhHnvgnHBfC/04VZFBEbcqZ1pnOxcXVoqFe/5SUO
	 uazMLs1N4coy3IJ44rm9+E+/hHJpLGAFp0ie3T5Blwwd5HfJWIvQGPcOid3bEAHOeK
	 qxxLq9hKMLHScF3/uMHBk2CbV2n3hqbB3KBQYgBk=
Date: Fri, 29 Dec 2023 12:00:30 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200030.E0C97C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ufs: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     ufs-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ufs: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:43 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ufs/inode.c~ufs-remove-writepage-implementation
+++ a/fs/ufs/inode.c
@@ -35,6 +35,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/buffer_head.h>
+#include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/iversion.h>
 
@@ -390,7 +391,7 @@ out:
 
 /**
  * ufs_getfrag_block() - `get_block_t' function, interface between UFS and
- * read_folio, writepage and so on
+ * read_folio, writepages and so on
  */
 
 static int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head *bh_result, int create)
@@ -467,9 +468,10 @@ done:
 	return 0;
 }
 
-static int ufs_writepage(struct page *page, struct writeback_control *wbc)
+static int ufs_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page,ufs_getfrag_block,wbc);
+	return mpage_writepages(mapping, wbc, ufs_getfrag_block);
 }
 
 static int ufs_read_folio(struct file *file, struct folio *folio)
@@ -528,9 +530,10 @@ const struct address_space_operations uf
 	.dirty_folio = block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio = ufs_read_folio,
-	.writepage = ufs_writepage,
+	.writepages = ufs_writepages,
 	.write_begin = ufs_write_begin,
 	.write_end = ufs_write_end,
+	.migrate_folio = buffer_migrate_folio,
 	.bmap = ufs_bmap
 };
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

