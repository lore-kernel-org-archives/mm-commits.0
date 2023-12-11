Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89960BA45
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ioWa/6Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5306BC433C8;
	Mon, 11 Dec 2023 01:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257846;
	bh=RN89UUKGrDXraPxfVMEKrdbD2q8/YFvBNHPyuYoO7oo=;
	h=Date:To:From:Subject:From;
	b=ioWa/6VkH90LdSSHQnvkncqcTBOB3ya5v3/DcT70OLXl/Z9sY/2sNSpf4u7PaHOBN
	 P8OCFtWmVhq0avIye2Jswao5VLRx1/yYxCPDa/p0Iawf44BC16EleH4YhdMVxKlx1b
	 u4v+bAoJRHDLIBD+gQ1GVkW3Odj6r+vpVhMfxSVs=
Date: Sun, 10 Dec 2023 17:24:05 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-page_address-from-nilfs_delete_entry.patch removed from -mm tree
Message-Id: <20231211012406.5306BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove page_address() from nilfs_delete_entry
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-page_address-from-nilfs_delete_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove page_address() from nilfs_delete_entry
Date: Mon, 27 Nov 2023 23:30:24 +0900

In preparation for removing kmap from directory handling, mask the
directory entry pointer to discover the start address of the page. 
Matches ext2.

Link: https://lkml.kernel.org/r/20231127143036.2425-6-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-remove-page_address-from-nilfs_delete_entry
+++ a/fs/nilfs2/dir.c
@@ -531,7 +531,7 @@ int nilfs_delete_entry(struct nilfs_dir_
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	char *kaddr = page_address(page);
+	char *kaddr = (char *)((unsigned long)dir & PAGE_MASK);
 	unsigned int from, to;
 	struct nilfs_dir_entry *de, *pde = NULL;
 	int err;
@@ -551,7 +551,7 @@ int nilfs_delete_entry(struct nilfs_dir_
 		de = nilfs_next_entry(de);
 	}
 	if (pde)
-		from = (char *)pde - (char *)page_address(page);
+		from = (char *)pde - kaddr;
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
 	BUG_ON(err);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

