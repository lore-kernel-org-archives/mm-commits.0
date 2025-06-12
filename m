Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22551192584
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769338; cv=none; b=b8Ga+EAUz4tgkAvMOtUQ2zTSabS15KZsQZP+Xa5gRqSIlI3lXKfFQql1mOgvakYu1fdIRVQBe+LCe1NOdST2dF9gUBU2atLpYaNJ7wNtmJuGem9yu+8cm8HVzy2IWztqgEXqCy5NZT6+ikXWNg+/3q/CzP2xCHwwDkAVpasjWQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769338; c=relaxed/simple;
	bh=yKWlS/4UpdudmZqoNBZHTy06ZHLTsdQnUmUPxqP1hd0=;
	h=Date:To:From:Subject:Message-Id; b=PcVrLt/WS6jUo6x78ikjyQEajasYHfqsnwVpNvMyDILBnfD49WR4cxf7afRLPpSmomWAlS7KnobjKE40PbtD77C8lEruBS4/zXJ/V3x+GAqUkItiUf0r0Z6RcRTAtG4BsJZ6yd6RO+q++JlfKhdT0lQ4ngxI/sN4McaS7L2DWmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjOthQyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjOthQyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1C1C4CEEA;
	Thu, 12 Jun 2025 23:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769337;
	bh=yKWlS/4UpdudmZqoNBZHTy06ZHLTsdQnUmUPxqP1hd0=;
	h=Date:To:From:Subject:From;
	b=GjOthQyfuEVEF5B3EUyM8+uos+vRHFMJDYa5NsyXC3zbCTpxM3t0xP83twx3e5kpS
	 lfiVOakjeCHreL4r57i3omWZ31iJzCnINC86B4nZsAFGILlxa4JsXDMZ9l8wJGQGsD
	 9skdnlJ7eQiBUPLW7UheNXda+WEMTWcSWWx3VK1Y=
Date: Thu, 12 Jun 2025 16:02:16 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch added to mm-new branch
Message-Id: <20250612230217.8D1C1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: convert ceph_zero_partial_page() to use a folio
has been added to the -mm mm-new branch.  Its filename is
     ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: ceph: convert ceph_zero_partial_page() to use a folio
Date: Thu, 12 Jun 2025 15:34:40 +0100

Retrieve a folio from the pagecache instead of a page and operate on it. 
Removes several hidden calls to compound_head() along with calls to
deprecated functions like wait_on_page_writeback() and find_lock_page().

Link: https://lkml.kernel.org/r/20250612143443.2848197-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/fs/ceph/file.c~ceph-convert-ceph_zero_partial_page-to-use-a-folio
+++ a/fs/ceph/file.c
@@ -2530,18 +2530,17 @@ static loff_t ceph_llseek(struct file *f
 	return generic_file_llseek(file, offset, whence);
 }
 
-static inline void ceph_zero_partial_page(
-	struct inode *inode, loff_t offset, unsigned size)
+static inline void ceph_zero_partial_page(struct inode *inode,
+		loff_t offset, size_t size)
 {
-	struct page *page;
-	pgoff_t index = offset >> PAGE_SHIFT;
+	struct folio *folio;
 
-	page = find_lock_page(inode->i_mapping, index);
-	if (page) {
-		wait_on_page_writeback(page);
-		zero_user(page, offset & (PAGE_SIZE - 1), size);
-		unlock_page(page);
-		put_page(page);
+	folio = filemap_lock_folio(inode->i_mapping, offset >> PAGE_SHIFT);
+	if (folio) {
+		folio_wait_writeback(folio);
+		folio_zero_range(folio, offset_in_folio(folio, offset), size);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

