Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0657493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQTGFpbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551C6C433C9;
	Mon, 11 Dec 2023 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257773;
	bh=nTt/j+fMqgwECXbK7VjuzB8UXGnfz0NYNfF+HBBinO4=;
	h=Date:To:From:Subject:From;
	b=BQTGFpbnIe7fbJl/OkioSO/BeSqh5hL5JR/papoEBN+H9tFKjYR6dCyWGK6fDuGtQ
	 HFZFsd0hHwqdItX9MGg+X02Gcm9rUQIGYG1aAPraT8ZpzA2BIRyBi9YraCGZNs/8M7
	 lbUExsQP0BlJaAGgE9A+Y8ZNfw31OpB1+2kMDL0w=
Date: Sun, 10 Dec 2023 17:22:52 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012253.551C6C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_create_block to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_create_block to use a folio
Date: Tue, 14 Nov 2023 17:44:31 +0900

Saves two calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-16-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -64,8 +64,8 @@ nilfs_btnode_create_block(struct address
 	set_buffer_mapped(bh);
 	set_buffer_uptodate(bh);
 
-	unlock_page(bh->b_page);
-	put_page(bh->b_page);
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
 	return bh;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

