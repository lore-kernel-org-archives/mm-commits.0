Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A297A184523
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855664; cv=none; b=MJ7riMgPh7nARsw286T6HBKFkh7Zc8pnAPwcKKYJo8HIqmhj8XI/xor8qZ3nApjA/57RR1S+gBEfDP3evJ/YNIm9TtL9JWDwbB1HaHascSmmhyadVStTMp/3e/KgnAYZivYkF362+OqXgKs0h7T+lFI3MuSg1W9hZjhLGG83B6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855664; c=relaxed/simple;
	bh=RvlXaLLGHD4NRYwUm+0ulNicFZB1grkHJOHdQjKUHt4=;
	h=Date:To:From:Subject:Message-Id; b=mLsjxPbaX4nInbk0f8fGJDMRXKiR38omwjA+Cr5vysY5VawwRxO4e9Pbx18mFX/74ONkkSqbqL3DM55grnKb8IyuWMAaB/4M9OHiqBTZwORF/WWASZZazdztcQmmR13phh6eLAfM6AvTCmzJSPT8Oky3pTzCHerem9FsKdlT1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mqBFzbKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mqBFzbKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717DBC4CECF;
	Wed,  6 Nov 2024 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855664;
	bh=RvlXaLLGHD4NRYwUm+0ulNicFZB1grkHJOHdQjKUHt4=;
	h=Date:To:From:Subject:From;
	b=mqBFzbKjR5a/6803FYkHAKPXoKtuOxQIBEu3Qy+3JfOfQE05kJmslMELv9xGmDS/Q
	 1qIMtNlUR/Q7xT/8LPLtIh9ZrvWJ/o9jIQXUNcKRIN8XtlXU0tDK9tQazGBhqGTnnn
	 w+XUHgY7zijHdeLSg7evoZAC/YWzeM040KfUz2iA=
Date: Tue, 05 Nov 2024 17:14:23 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch removed from -mm tree
Message-Id: <20241106011424.717DBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_page_count_clean_buffers() to take a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_page_count_clean_buffers() to take a folio
Date: Thu, 24 Oct 2024 18:25:44 +0900

Both callers have a folio, so pass it in and use it directly.

[konishi.ryusuke@gmail.com: fixed a checkpatch warning about function declaration]
Link: https://lkml.kernel.org/r/20241002150036.1339475-3-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-11-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/inode.c |    2 +-
 fs/nilfs2/page.c  |    4 ++--
 fs/nilfs2/page.h  |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio
+++ a/fs/nilfs2/dir.c
@@ -95,7 +95,7 @@ static void nilfs_commit_chunk(struct fo
 	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(&folio->page, from, to);
+	nr_dirty = nilfs_page_count_clean_buffers(folio, from, to);
 	copied = block_write_end(NULL, mapping, pos, len, len, folio, NULL);
 	if (pos + copied > dir->i_size)
 		i_size_write(dir, pos + copied);
--- a/fs/nilfs2/inode.c~nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio
+++ a/fs/nilfs2/inode.c
@@ -242,7 +242,7 @@ static int nilfs_write_end(struct file *
 	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(&folio->page, start,
+	nr_dirty = nilfs_page_count_clean_buffers(folio, start,
 						  start + copied);
 	copied = generic_write_end(file, mapping, pos, len, copied, folio,
 				   fsdata);
--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio
+++ a/fs/nilfs2/page.c
@@ -422,14 +422,14 @@ void nilfs_clear_folio_dirty(struct foli
 	__nilfs_clear_folio_dirty(folio);
 }
 
-unsigned int nilfs_page_count_clean_buffers(struct page *page,
+unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
 					    unsigned int from, unsigned int to)
 {
 	unsigned int block_start, block_end;
 	struct buffer_head *bh, *head;
 	unsigned int nc = 0;
 
-	for (bh = head = page_buffers(page), block_start = 0;
+	for (bh = head = folio_buffers(folio), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + bh->b_size;
--- a/fs/nilfs2/page.h~nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio
+++ a/fs/nilfs2/page.h
@@ -43,8 +43,8 @@ int nilfs_copy_dirty_pages(struct addres
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_folio_dirty(struct folio *folio);
 void nilfs_clear_dirty_pages(struct address_space *mapping);
-unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
-					    unsigned int);
+unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
+		unsigned int from, unsigned int to);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

