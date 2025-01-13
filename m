Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0B13C8F3
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737468; cv=none; b=f/UVD8yn5ElZXbQp1BfRrh5Da2MMm6pgVHIDL6+zjFcq6VnwRmJT/fuiQDLeCfTrIYUWtZLYKsDuw9URq+tI/zqbFOYlsOti34Sjl90ONk6HkBTROuI7qXyjgz96fBNdbLdKNn22oi53HWm1stCVvnR5D/+Pjxn//IYkTc5xHWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737468; c=relaxed/simple;
	bh=0vWmC9VbB+Bv0QJ8OmpYwM0o9diZBsGmRXGnYCfeEn4=;
	h=Date:To:From:Subject:Message-Id; b=cvFaR/K54mpkRMc0UU62NQo3Vd6wn1z6FreZll3nXkr/Rcs8ZkajXF0nHIRstQrlXKB4ky4E4P4SFd3Zq5pCV+29hxg4aA95wXU61xkSp2NkqYCn+HPioMrb5TROXOYfalG3tw5Ojc9LOV0KB+xae/zXkT6oUd+ycqS3zYZn57w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FjVTtAr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FjVTtAr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF4BC4CEDF;
	Mon, 13 Jan 2025 03:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737467;
	bh=0vWmC9VbB+Bv0QJ8OmpYwM0o9diZBsGmRXGnYCfeEn4=;
	h=Date:To:From:Subject:From;
	b=FjVTtAr051DDosairck1SvosirgaQDXrfPBE9B7W3CxqnzqlOEk5rUZQORKxZOcoT
	 wL0+UhUpjLLg9dabtI4+u3lOylLWwvs+ieNq0AnKRf4n5JZD4gW7Un2y189FZcQMiq
	 w4Rw2K/ESwQIy9su7rnYUbV16QPXVBpGBubBUbaQ=
Date: Sun, 12 Jan 2025 19:04:26 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-assertion-in-folio_end_read.patch removed from -mm tree
Message-Id: <20250113030427.5DF4BC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix assertion in folio_end_read()
has been removed from the -mm tree.  Its filename was
     mm-fix-assertion-in-folio_end_read.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
squashfs-convert-squashfs_fill_page-to-take-a-folio-fix.patch

