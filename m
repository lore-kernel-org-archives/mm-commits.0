Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22535134AA
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKc6E8lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919BDC433C7;
	Fri, 29 Dec 2023 19:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879966;
	bh=hHrcQyCACXX6Dga5SDcp4GwYFNg2kLjacBsZW9sEBRs=;
	h=Date:To:From:Subject:From;
	b=GKc6E8lJtpFIbZqdK2Iqa+p2nek8Ze85KhOeqTE+inUoSt0ohDOVb5Q3rmvJOS6zB
	 mhPn471+qdWA4VdnruyRM8voPASl7cJiWhqHTCMtv9ZaU1D5Ow2tg95L0jr0OpGh9s
	 GVwQ6/MgVP1VzzLae9CPxk321Gsi+xZcpth7KxLA=
Date: Fri, 29 Dec 2023 11:59:26 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,nathan@kernel.org,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-fix-grow_buffers-for-block-size-page_size.patch removed from -mm tree
Message-Id: <20231229195926.919BDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: fix grow_buffers() for block size > PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     buffer-fix-grow_buffers-for-block-size-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: fix grow_buffers() for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:04 +0000

We must not shift by a negative number so work in terms of a byte offset
to avoid the awkward shift left-or-right-depending-on-sign option.  This
means we need to use check_mul_overflow() to ensure that a large block
number does not result in a wrap.

Link: https://lkml.kernel.org/r/20231109210608.2252323-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
[nathan@kernel.org: add cast in grow_buffers() to avoid a multiplication libcall]
  Link: https://lkml.kernel.org/r/20231128-avoid-muloti4-grow_buffers-v1-1-bc3d0f0ec483@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/fs/buffer.c~buffer-fix-grow_buffers-for-block-size-page_size
+++ a/fs/buffer.c
@@ -1085,26 +1085,21 @@ unlock:
 static bool grow_buffers(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp)
 {
-	pgoff_t index;
-	int sizebits;
-
-	sizebits = PAGE_SHIFT - __ffs(size);
-	index = block >> sizebits;
+	loff_t pos;
 
 	/*
-	 * Check for a block which wants to lie outside our maximum possible
-	 * pagecache index.  (this comparison is done using sector_t types).
+	 * Check for a block which lies outside our maximum possible
+	 * pagecache index.
 	 */
-	if (unlikely(index != block >> sizebits)) {
-		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-			"device %pg\n",
+	if (check_mul_overflow(block, (sector_t)size, &pos) || pos > MAX_LFS_FILESIZE) {
+		printk(KERN_ERR "%s: requested out-of-range block %llu for device %pg\n",
 			__func__, (unsigned long long)block,
 			bdev);
 		return false;
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, index, size, gfp);
+	return grow_dev_folio(bdev, block, pos / PAGE_SIZE, size, gfp);
 }
 
 static struct buffer_head *
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

