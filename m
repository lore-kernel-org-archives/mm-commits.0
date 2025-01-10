Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FA221D5A2
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736551562; cv=none; b=md+R0NZ86VuHdKoMSjNGjNdc8WeaT40gLKjKD3CNDvYwqOh+o9SRY0kN/r+gqAc9jbLho95YkBWYyoVEGfY+lbhOgBTEFTwedy9uuW6LISBEFZKWz3vZiSvcoRkYbV3P2tFMViyipuT35vo90U75SVdQgJzp0Tz9bRDk91GRgns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736551562; c=relaxed/simple;
	bh=dUtPIfb+zpysgyv8ft6fPUPuN0tGPMmOZnMtrj+uc54=;
	h=Date:To:From:Subject:Message-Id; b=PgV/Fgww7xGNZzTGHFgRNM9i/devr66eGxDb0UIDwAFycMOHlZGXx5yurldm4UOQeXtlTcGrE5r+JLtt/wEY25dQLymt1zsREfQW+vYLww+u+yFN3CulineFj0ryN8dukJ9DHPaoL2609NNbXTD/62CDLhhN0N85P2j8fqVKf+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShQGZmmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShQGZmmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE47C4CED6;
	Fri, 10 Jan 2025 23:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736551561;
	bh=dUtPIfb+zpysgyv8ft6fPUPuN0tGPMmOZnMtrj+uc54=;
	h=Date:To:From:Subject:From;
	b=ShQGZmmTj7CmkIBiaU1py7DXtfOm773gXDR10DkagFZV2zjkdnCgHqwe+6lGt0IEG
	 Ah3xr4GZzWKFjeSbCHxoQwybEmQlpmt6jlx0cTm1JC7SVszs5GisU1XrbCIOyj5YZL
	 5Oj03yY1vxaBwTwNtX9VooFx0+gO0BD4U8ZSVlqg=
Date: Fri, 10 Jan 2025 15:26:01 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-assertion-in-folio_end_read.patch added to mm-hotfixes-unstable branch
Message-Id: <20250110232601.CBE47C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix assertion in folio_end_read()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-assertion-in-folio_end_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-assertion-in-folio_end_read.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: fix assertion in folio_end_read()
Date: Fri, 10 Jan 2025 16:32:57 +0000

We only need to assert that the uptodate flag is clear if we're going to
set it.  This hasn't been a problem before now because we have only used
folio_end_read() when completing with an error, but it's convenient to use
it in squashfs if we discover the folio is already uptodate.

Link: https://lkml.kernel.org/r/20250110163300.3346321-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-fix-assertion-in-folio_end_read
+++ a/mm/filemap.c
@@ -1523,7 +1523,7 @@ void folio_end_read(struct folio *folio,
 	/* Must be in bottom byte for x86 to work */
 	BUILD_BUG_ON(PG_uptodate > 7);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
+	VM_BUG_ON_FOLIO(success && folio_test_uptodate(folio), folio);
 
 	if (likely(success))
 		mask |= 1 << PG_uptodate;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-assertion-in-folio_end_read.patch
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
mm-remove-pagetranstail.patch
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

