Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C5813AD1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mORQ0WRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD5BC433C9;
	Fri, 29 Dec 2023 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880029;
	bh=b/HRubji7+GHZ1hs5VXc6PWjI9WMiW8yA/0icRLZCPY=;
	h=Date:To:From:Subject:From;
	b=mORQ0WRH7/kUm0tlG+5pYeeRXVu7qiZc0Id7zSRkwsb3byW6/S7R9gKCHZv3X1vue
	 8a6zDhhXslzZXQVAXQ+VWRRwzfL+XirIqs8KOfLROnMoxMbxmE+tePghZutkzPxbYg
	 rnCGZ2W2iZNnfrXoSoG7VjG/xkj1oiDCtGiLi2is=
Date: Fri, 29 Dec 2023 12:00:28 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-remove-writepage-implementation.patch removed from -mm tree
Message-Id: <20231229200028.EFD5BC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove writepage implementation
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-writepage-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:41 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c        |   15 ++++++---------
 fs/ocfs2/ocfs2_trace.h |    2 --
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-remove-writepage-implementation
+++ a/fs/ocfs2/aops.c
@@ -389,21 +389,18 @@ out_unlock:
 /* Note: Because we don't support holes, our allocation has
  * already happened (allocation writes zeros to the file data)
  * so we don't have to worry about ordered writes in
- * ocfs2_writepage.
+ * ocfs2_writepages.
  *
- * ->writepage is called during the process of invalidating the page cache
+ * ->writepages is called during the process of invalidating the page cache
  * during blocked lock processing.  It can't block on any cluster locks
  * to during block mapping.  It's relying on the fact that the block
  * mapping can't have disappeared under the dirty pages that it is
  * being asked to write back.
  */
-static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
+static int ocfs2_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	trace_ocfs2_writepage(
-		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
-		page->index);
-
-	return block_write_full_page(page, ocfs2_get_block, wbc);
+	return mpage_writepages(mapping, wbc, ocfs2_get_block);
 }
 
 /* Taken from ext3. We don't necessarily need the full blown
@@ -2471,7 +2468,7 @@ const struct address_space_operations oc
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
 	.readahead		= ocfs2_readahead,
-	.writepage		= ocfs2_writepage,
+	.writepages		= ocfs2_writepages,
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-remove-writepage-implementation
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1157,8 +1157,6 @@ DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_get_blo
 
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_readpage);
 
-DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_writepage);
-
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_bmap);
 
 TRACE_EVENT(ocfs2_try_to_write_inline_data,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

