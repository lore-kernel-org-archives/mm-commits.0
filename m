Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5C1DB943
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 04:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734754057; cv=none; b=BITjaEJ4dwK6ctoViPedWood1vT4eLHEqA+mPq1fJARNx9X4xZEel1BhRokLEqsvCpaZ/WrZL9IrKZC8Rf9LaVqwmF/YqhBXh8Odf/3vKrC0D/iWBW0/XuVukamq7U1a5WwCa4i1Lw7DrHzeO9KrfAfmGHMWgy7ikcDTbHFQ5qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734754057; c=relaxed/simple;
	bh=K3Oq2696wCwgZDg6guzDMeLlF3H91zClZHMggkxZIEw=;
	h=Date:To:From:Subject:Message-Id; b=mEbeUFWKmt3uoT3zu8VPtAzQDPTgJAKbj5NgYzgsiN/SRfiwXU9rOYON/M7FNEacfOcBPI79WvG3/y9Sf7ojSQRoa21nzriWTrf7/+QQFHXdfn5r+pWrTb5oeB4cS2a8F0gBOP5RmdbF79Bn7b87c6I7anw1SwVUnFtdzyQ9WxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4WU4LPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4WU4LPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C3EC4CECE;
	Sat, 21 Dec 2024 04:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734754057;
	bh=K3Oq2696wCwgZDg6guzDMeLlF3H91zClZHMggkxZIEw=;
	h=Date:To:From:Subject:From;
	b=P4WU4LPb34nVtPpASIoDgB46gB2Gpk93Yo8vclW3UkPKCRRDH+L9lZniQ7TI0IdBl
	 nojjtPrgPD6zweG7ZApf9Hfv85icP2N8ILQklxZI20HorqSuChDnA+WU0NdeG3uKwb
	 1R2pG2dMQbBewIhfAUILeDTj0t8bmWDDppYxn0Qs=
Date: Fri, 20 Dec 2024 20:07:36 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch added to mm-nonmm-unstable branch
Message-Id: <20241221040737.72C3EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: pass a folio to squashfs_readpage_fragment()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch

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
Subject: squashfs: pass a folio to squashfs_readpage_fragment()
Date: Fri, 20 Dec 2024 22:46:25 +0000

Remove an access to page->mapping.

Link: https://lkml.kernel.org/r/20241220224634.723899-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-pass-a-folio-to-squashfs_readpage_fragment
+++ a/fs/squashfs/file.c
@@ -417,9 +417,9 @@ skip_page:
 }
 
 /* Read datablock stored packed inside a fragment (tail-end packed block) */
-static int squashfs_readpage_fragment(struct page *page, int expected)
+static int squashfs_readpage_fragment(struct folio *folio, int expected)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
@@ -430,7 +430,7 @@ static int squashfs_readpage_fragment(st
 			squashfs_i(inode)->fragment_block,
 			squashfs_i(inode)->fragment_size);
 	else
-		squashfs_copy_cache(page, buffer, expected,
+		squashfs_copy_cache(&folio->page, buffer, expected,
 			squashfs_i(inode)->fragment_offset);
 
 	squashfs_cache_put(buffer);
@@ -474,7 +474,7 @@ static int squashfs_read_folio(struct fi
 		else
 			res = squashfs_readpage_block(&folio->page, block, res, expected);
 	} else
-		res = squashfs_readpage_fragment(&folio->page, expected);
+		res = squashfs_readpage_fragment(folio, expected);
 
 	if (!res)
 		return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch
iov_iter-remove-setting-of-page-index.patch
squashfs-use-a-folio-throughout-squashfs_read_folio.patch
squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch
squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch
squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch
squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

