Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E213AC0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tgOqDtom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03996C433C9;
	Fri, 29 Dec 2023 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880028;
	bh=BRuqWFqCOzI7myW4pIr0EqnuJQK+VtUB4HrALKKhqys=;
	h=Date:To:From:Subject:From;
	b=tgOqDtomr+8BRjPOZazgFzaF36rWfIv9+DKKhRAz+6/RKWqS8NmmBZAKWO+W9UcZa
	 zotZz5MAbQ3qpmcnyVUFykIK1koh/9mfh+S17Jahal1OYJcYdOVeDXDyj7vjm5/THp
	 nJFiRNkUMzMCxZ1L9KlN+3FAX51O+vfYiOCr9Zeo=
Date: Fri, 29 Dec 2023 12:00:27 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] minix-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200028.03996C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minix: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     minix-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: minix: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:40 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/minix/inode.c~minix-remove-writepage-implementation
+++ a/fs/minix/inode.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/highuid.h>
+#include <linux/mpage.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 
@@ -397,9 +398,10 @@ static int minix_get_block(struct inode
 		return V2_minix_get_block(inode, block, bh_result, create);
 }
 
-static int minix_writepage(struct page *page, struct writeback_control *wbc)
+static int minix_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page, minix_get_block, wbc);
+	return mpage_writepages(mapping, wbc, minix_get_block);
 }
 
 static int minix_read_folio(struct file *file, struct folio *folio)
@@ -444,9 +446,10 @@ static const struct address_space_operat
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio = minix_read_folio,
-	.writepage = minix_writepage,
+	.writepages = minix_writepages,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
+	.migrate_folio = buffer_migrate_folio,
 	.bmap = minix_bmap,
 	.direct_IO = noop_direct_IO
 };
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

