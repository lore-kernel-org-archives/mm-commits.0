Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF74348896
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963809; cv=none; b=V73LOLMp9HEMoZCqGqCVUpzUIOiPBHMpXN3sJk7yUSXgD+A8VMvfvWL+nzpk5v4wrUWhEVbr6HwLQ0Jg9Y4I1ehIYv7f3PffGPYrcYSwkCPBfVZTjYLACMpQYUQafHQCA00UsHv5PsFrbZ7WS8UvKlTlQX0YrfQiSbWoCKAihWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963809; c=relaxed/simple;
	bh=IbNsHLD0oZwfunE4krM4d7YU/H0Z64Y3Riqx9g3za34=;
	h=Date:To:From:Subject:Message-Id; b=pD5HfkQuA8kJgqg05veA0fYom/x9NfWiz9BpzbZKNSihhcpJcf0BieTPZMOmfbo/BW8DEghI6ciUKmoJeD6454ZT+eVu9DlwT3G+DxdSgtfTSbEbZUod5+oORycOZmzxhdrOinLON/74Xqgh5vC5rfoXKQ3bszDHChIEyBboRfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWnfioi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWnfioi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA281F000FF;
	Mon, 21 Sep 2026 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963808;
	bh=b/tzvY6dt1MpagAxtYirWdR/7eVDA0aZfPXYwIwFGXw=;
	h=Date:To:From:Subject;
	b=GWnfioi3+KL4lqYSOJmpI1A/KZvd1nMvIadngv/Em2c5Fva2yG530wB0Z8ALrp26H
	 InE1Dk5bPbwgFrw6aaNEfP33TUmDabFsLsj3MCOsYlilFEFQ9SAWKdmuD3Cx4oetJM
	 FVTrWXmlZ/sduyWyF6X4UIwKerARILESp5dM9w64=
Date: Sun, 20 Sep 2026 21:10:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + md-use-folio_alloc_buffers.patch added to mm-unstable branch
Message-Id: <20260921041008.2BA281F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: md: use folio_alloc_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     md-use-folio_alloc_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/md-use-folio_alloc_buffers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

md-use-folio_alloc_buffers.patch
md-use-folio-apis-in-free_page.patch
md-remove-the-last-use-of-page_buffers.patch

