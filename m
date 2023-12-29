Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696B134A3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2/mwXZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A4C433C9;
	Fri, 29 Dec 2023 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879968;
	bh=BNl4VM6ig5i9b8Yc6xZClSR8eHgbMfoCAuKKdkOQ4x4=;
	h=Date:To:From:Subject:From;
	b=p2/mwXZA4ELG/Er4RKnvHKfBoGB7UWFjSCnDkPXGgjIZtScREQiVL9oVUeKs5+xGZ
	 z7ND3x2U1xM9LzCxt6XJFhBJ14r0fkyrJFjLkq4EBFq6bqeFngDqTFiRKUGRAXuboI
	 CGDjoNgoNRIWCux2sFkEAaOXFqOeJ6wDyzAiPwN8=
Date: Fri, 29 Dec 2023 11:59:27 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-cast-block-to-loff_t-before-shifting-it.patch removed from -mm tree
Message-Id: <20231229195928.528A4C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: cast block to loff_t before shifting it
has been removed from the -mm tree.  Its filename was
     buffer-cast-block-to-loff_t-before-shifting-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: cast block to loff_t before shifting it
Date: Thu, 9 Nov 2023 21:06:05 +0000

While sector_t is always defined as a u64 today, that hasn't always been
the case and it might not always be the same size as loff_t in the future.

Link: https://lkml.kernel.org/r/20231109210608.2252323-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-cast-block-to-loff_t-before-shifting-it
+++ a/fs/buffer.c
@@ -2008,7 +2008,7 @@ static int
 iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 		const struct iomap *iomap)
 {
-	loff_t offset = block << inode->i_blkbits;
+	loff_t offset = (loff_t)block << inode->i_blkbits;
 
 	bh->b_bdev = iomap->bdev;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

