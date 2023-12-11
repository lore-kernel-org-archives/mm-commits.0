Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DD2BE66
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A4Q4I71f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476F7C433C9;
	Mon, 11 Dec 2023 01:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257848;
	bh=+gVmHatNa7LuSSCctVgTP2vS98HpC0xSkCXMSRKqBbw=;
	h=Date:To:From:Subject:From;
	b=A4Q4I71foeBtFkgzrLFTCZOvn0y6aopqlouWuN2SvUzjNc3XtKRs+H83BoWzhCQ7S
	 +hmphoowVlOBEWDNxYjS1KQYbWsn5Bwx8VjSKaKdTNsr7+Wd/3teDuutGVsM7TAM8l
	 JXEmyQ8CEOTnV8IZyfxw36eAmps2CVseFvuED9ok=
Date: Sun, 10 Dec 2023 17:24:07 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-pass-the-mapped-address-to-nilfs_check_page.patch removed from -mm tree
Message-Id: <20231211012408.476F7C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: pass the mapped address to nilfs_check_page()
has been removed from the -mm tree.  Its filename was
     nilfs2-pass-the-mapped-address-to-nilfs_check_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: pass the mapped address to nilfs_check_page()
Date: Mon, 27 Nov 2023 23:30:26 +0900

Remove another use of page_address() as part of preparing for the kmap to
kmap_local transition.

Link: https://lkml.kernel.org/r/20231127143036.2425-8-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-pass-the-mapped-address-to-nilfs_check_page
+++ a/fs/nilfs2/dir.c
@@ -107,12 +107,11 @@ static void nilfs_commit_chunk(struct pa
 	unlock_page(page);
 }
 
-static bool nilfs_check_page(struct page *page)
+static bool nilfs_check_page(struct page *page, char *kaddr)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned int chunk_size = nilfs_chunk_size(dir);
-	char *kaddr = page_address(page);
 	unsigned int offs, rec_len;
 	unsigned int limit = PAGE_SIZE;
 	struct nilfs_dir_entry *p;
@@ -192,7 +191,7 @@ static void *nilfs_get_page(struct inode
 
 	kaddr = kmap(page);
 	if (unlikely(!PageChecked(page))) {
-		if (!nilfs_check_page(page))
+		if (!nilfs_check_page(page, kaddr))
 			goto fail;
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

