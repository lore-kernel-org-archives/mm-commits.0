Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7BC13AEC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e8BAqZ6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F1AC433C8;
	Fri, 29 Dec 2023 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880030;
	bh=zp3UJpPT6Cg5EifO/q7TQRaj/ZN5FwelXzN7h1e/HSw=;
	h=Date:To:From:Subject:From;
	b=e8BAqZ6JFSBne32hNBcV7n6vNyhv7kbZIC9g4/N8PmpbrW9tifs5DHjFqfAGfcGgY
	 nJREfouYHsGhqA4+FFSJZ3q1ecoQnMMtTuNvbdzTAe0FkbJOguIn7jz4osHmxumaH7
	 mK5+5EQkm9GrZaJ9fPkGOcq1QjhkTO7DiMwD5vYc=
Date: Fri, 29 Dec 2023 12:00:29 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sysv-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200029.E8F1AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysv: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     sysv-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: sysv: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:42 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/itree.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/sysv/itree.c~sysv-remove-writepage-implementation
+++ a/fs/sysv/itree.c
@@ -8,6 +8,7 @@
 
 #include <linux/buffer_head.h>
 #include <linux/mount.h>
+#include <linux/mpage.h>
 #include <linux/string.h>
 #include "sysv.h"
 
@@ -456,9 +457,10 @@ int sysv_getattr(struct mnt_idmap *idmap
 	return 0;
 }
 
-static int sysv_writepage(struct page *page, struct writeback_control *wbc)
+static int sysv_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	return block_write_full_page(page,get_block,wbc);
+	return mpage_writepages(mapping, wbc, get_block);
 }
 
 static int sysv_read_folio(struct file *file, struct folio *folio)
@@ -503,8 +505,9 @@ const struct address_space_operations sy
 	.dirty_folio = block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio = sysv_read_folio,
-	.writepage = sysv_writepage,
+	.writepages = sysv_writepages,
 	.write_begin = sysv_write_begin,
 	.write_end = generic_write_end,
+	.migrate_folio = buffer_migrate_folio,
 	.bmap = sysv_bmap
 };
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

