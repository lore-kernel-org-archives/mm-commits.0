Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE20134A0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRGZhW9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E070C433C8;
	Fri, 29 Dec 2023 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879970;
	bh=TCP71FwWDGS50tWP+0Hs23/VouFEzsbxujRCF8bxrKY=;
	h=Date:To:From:Subject:From;
	b=MRGZhW9Ch0onwh17PuZSGet3VTklNf2HA5WYsD4KSR693sDUn/G/ngsfMUmn9UPgb
	 uui7ImSS8MjHE3udKscLIMZB1W/3YPTzgX68i5BuiRupNkPDIr45/T6Nh1uwO5Bdtj
	 UtQ0yxzUKOt270JIyYgyVo96z24UWHy5oXMkm06Q=
Date: Fri, 29 Dec 2023 11:59:29 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-handle-large-folios-in-__block_write_begin_int.patch removed from -mm tree
Message-Id: <20231229195930.7E070C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: handle large folios in __block_write_begin_int()
has been removed from the -mm tree.  Its filename was
     buffer-handle-large-folios-in-__block_write_begin_int.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: handle large folios in __block_write_begin_int()
Date: Thu, 9 Nov 2023 21:06:07 +0000

When __block_write_begin_int() was converted to support folios, we did not
expect large folios to be passed to it.  With the current work to support
large block size storage devices, this will no longer be true so change
the checks on 'from' and 'to' to be related to the size of the folio
instead of PAGE_SIZE.  Also remove an assumption that the block size is
smaller than PAGE_SIZE.

Link: https://lkml.kernel.org/r/20231109210608.2252323-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/fs/buffer.c~buffer-handle-large-folios-in-__block_write_begin_int
+++ a/fs/buffer.c
@@ -2075,27 +2075,24 @@ iomap_to_bh(struct inode *inode, sector_
 int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block, const struct iomap *iomap)
 {
-	unsigned from = pos & (PAGE_SIZE - 1);
-	unsigned to = from + len;
+	size_t from = offset_in_folio(folio, pos);
+	size_t to = from + len;
 	struct inode *inode = folio->mapping->host;
-	unsigned block_start, block_end;
+	size_t block_start, block_end;
 	sector_t block;
 	int err = 0;
-	unsigned blocksize, bbits;
+	size_t blocksize;
 	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
 
 	BUG_ON(!folio_test_locked(folio));
-	BUG_ON(from > PAGE_SIZE);
-	BUG_ON(to > PAGE_SIZE);
+	BUG_ON(to > folio_size(folio));
 	BUG_ON(from > to);
 
 	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
-	bbits = block_size_bits(blocksize);
+	block = div_u64(folio_pos(folio), blocksize);
 
-	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-
-	for(bh = head, block_start = 0; bh != head || !block_start;
+	for (bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start=block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

