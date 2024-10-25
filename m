Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496261925AB
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885080; cv=none; b=pzHtP13MQmWUcVti8j6i5X4KYi0OFPVhvVmMPGkiBp/Ieg4ZmmtywuoRutkpwvbGRKX7I52S1rCA2eGk3XtQ3jG0tavzGB67/DX1ArobNiVjsvGPLpLUPpmVBpaylaEDUCZgit4/nwWJ4n859+XrGuTnz7xLdioLQM9M2Y8/uJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885080; c=relaxed/simple;
	bh=gbRVeVdoiYvCLdEqmfjbwJOsAaa9EY07Y5X/Ngs2cAU=;
	h=Date:To:From:Subject:Message-Id; b=RnH/Alsk02D07nA4RNP+ENZPGAvjaZUOi4tWjv3zMO1IpZH7rX1Hvm5BckVvxSDr8gSbfyRtfCmK+BMi6xS8rpIPBJo0r5PiL9vZgKIz+05zZp++2xkGtA7e3tvjDUze5xs9hcMcZNfkNx8lwXdq7CJOyg4Ao3eA+dObuPUgODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DACuxNO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DACuxNO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129CCC4CEC3;
	Fri, 25 Oct 2024 19:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885080;
	bh=gbRVeVdoiYvCLdEqmfjbwJOsAaa9EY07Y5X/Ngs2cAU=;
	h=Date:To:From:Subject:From;
	b=DACuxNO+lk1bAwPtaMauFNBqJ6nqoErqkbliVvgvuVpzyw9gWRJifH3674N1OmXv8
	 jud0mvxwHfZ9A0R4SqLZlsyv3bWARIL8/pJL4ZPXGJ94hYZr+FSS52esod+JduDOd5
	 LSNThfZE5uYfYrUefz+QwOb0een+yNBMPC73kgh0=
Date: Fri, 25 Oct 2024 12:37:59 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193800.129CCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert nilfs_page_count_clean_buffers() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -420,14 +420,14 @@ void nilfs_clear_folio_dirty(struct foli
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

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

