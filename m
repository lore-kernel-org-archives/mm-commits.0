Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF63D415F12
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525595; cv=none; b=DIa+dSwuxUDY13GiO0zuk0y6E/+c7n//GDMK+4ij7d5+AQxVsSG2tk5GTOhxZv/muL4iEDaskxws4UB4ydbW4v+X81dVLhxQXflYW75MXbZcmPO1qboeRPs/xac0RGUdRaeWrG7pFSOnC3LszHXSnS6bTIxLkLwjkz1npu15ct8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525595; c=relaxed/simple;
	bh=wouwC+LNYdk4DpFvs/e9Q3fkR53MFeoG2GvQ9tGDmq4=;
	h=Date:To:From:Subject:Message-Id; b=KBnfBQyMNhWnSKK60n+8KmskLTd/PrvNumE6sNxkKBHNXBtX30r0mcVy514mfJP76V49MA1XjNzXmCiGZxSj4vCtW0ZubmPNujRkSZBej+fDTF/LinC/ByXTm10PrnRl0jZBbCXspg3R4qW8RpzX4CXgoV97Nar8vjpWCiaDlLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtNvbDVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtNvbDVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8D21F00898;
	Fri,  9 Oct 2026 05:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525585;
	bh=WEkkz2+MrEdUrtYUu84jwXU1GEeg8JjjUW9WJGUMqEQ=;
	h=Date:To:From:Subject;
	b=wtNvbDVat6y5bK6mIWUoRvgQuirV+wYRiS2chL/my1lUDysGcp4V3vBkKjBzE4Crv
	 EHIMMX2fsobDcz+PSd60OA0fzg6NqaRqVNm3NXGXXlhvjo11TxKGh5xtR6fw0+U8V7
	 JqHyadcJ6Cil9lH+/IhLnZIXQkSATJ/pjshu2ldg=
Date: Thu, 08 Oct 2026 22:59:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] md-use-folio_alloc_buffers.patch removed from -mm tree
Message-Id: <20261009055945.8F8D21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: md: use folio_alloc_buffers()
has been removed from the -mm tree.  Its filename was
     md-use-folio_alloc_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: md: use folio_alloc_buffers()
Date: Sun, 20 Sep 2026 22:28:09 -0400

Remove the last user of alloc_page_buffers().  Use folio_alloc_buffers()
instead, since alloc_page_buffers() is a wrap over it.  Although the pages
used in md-bitmap are not folios, as they are not mapped into userspace
nor enter the page cache, but they still have buffer heads attached. 
Cleaning up the code to not use buffer heads is future work.

[ziy@nvidia.com: reword commit message]
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-13-bb68b6a21869@nvidia.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---

 drivers/md/md-bitmap.c      |    5 +++--
 fs/buffer.c                 |    8 --------
 include/linux/buffer_head.h |    1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/md/md-bitmap.c~md-use-folio_alloc_buffers
+++ a/drivers/md/md-bitmap.c
@@ -560,6 +560,7 @@ static int read_file_page(struct file *f
 {
 	int ret = 0;
 	struct inode *inode = file_inode(file);
+	struct folio *folio = page_folio(page);
 	struct buffer_head *bh;
 	sector_t block, blk_cur;
 	unsigned long blocksize = i_blocksize(inode);
@@ -567,12 +568,12 @@ static int read_file_page(struct file *f
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, blocksize);
+	bh = folio_alloc_buffers(folio, blocksize, GFP_NOFS | __GFP_ACCOUNT);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_private(page, bh);
+	folio_attach_private(folio, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
--- a/fs/buffer.c~md-use-folio_alloc_buffers
+++ a/fs/buffer.c
@@ -773,14 +773,6 @@ no_grow:
 }
 EXPORT_SYMBOL_GPL(folio_alloc_buffers);
 
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size)
-{
-	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
-
-	return folio_alloc_buffers(page_folio(page), size, gfp);
-}
-EXPORT_SYMBOL_GPL(alloc_page_buffers);
-
 static inline void link_dev_buffers(struct folio *folio,
 		struct buffer_head *head)
 {
--- a/include/linux/buffer_head.h~md-use-folio_alloc_buffers
+++ a/include/linux/buffer_head.h
@@ -197,7 +197,6 @@ void folio_set_bh(struct buffer_head *bh
 		  unsigned long offset);
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 					gfp_t gfp);
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size);
 struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
_

Patches currently in -mm which might be from willy@infradead.org are


