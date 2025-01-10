Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D232594B4
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736469291; cv=none; b=YrYr2Rz9ReFpyBZ2vIMcSJkwJ2KWG6BAABsB1WzEB7hLOdKNUnAPu3PDIp9YNPaQ7m+o6rmCvj+qCdU4I177rdjgupd+2HtDO+7xVc8+i8Ytlwp8TzJOaiUuRQOTGC2TfariFKBQ2uiSybBzXPei87VOt6esbOBLOHaPV1HGff4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736469291; c=relaxed/simple;
	bh=bAj0yv75/n6ck6uQeZ46UA5/XSW6QCJEy6BAG/rus5s=;
	h=Date:To:From:Subject:Message-Id; b=DGzczhgYk1FYjxsQxHm46yRxsn9VoMrqKgPmlqO9s/cW4+TT3YNe6BlADPreRu4idqVamoxNsJ/VgA7izPJkIueamTDPAMuMsmdrWRlm//pTCZaBRkN8gAhG+4KoEfQiptnBpfG0SOQRoHaDZXlhP84CkQjBtGVfd3I9ZCh/kQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0o21Jet6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0o21Jet6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3C2C4CED2;
	Fri, 10 Jan 2025 00:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736469291;
	bh=bAj0yv75/n6ck6uQeZ46UA5/XSW6QCJEy6BAG/rus5s=;
	h=Date:To:From:Subject:From;
	b=0o21Jet66uuNn4EJ3TVVAk1exijWJ+O/7VyKuh5kpcMqXsx6B2MBnLP+qbM9jCnXN
	 AvAOrMJ+uzk6zLZl6vQVa6tu4COR4PoKF1thYBLdYuFnG+8lNKJDTE1pVYUbCaH33O
	 JnyLe+Ve/GShKHSXkTRQ7xt/dre4lVLBeHnxD5kI=
Date: Thu, 09 Jan 2025 16:34:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagetranstail.patch added to mm-unstable branch
Message-Id: <20250110003451.3E3C2C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageTransTail()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pagetranstail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagetranstail.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: remove PageTransTail()
Date: Thu, 9 Jan 2025 15:22:21 +0000

The last caller was removed in October.  Also remove the FALSE definition
of PageTransCompoundMap(); the normal definition was removed a few years
ago.

Link: https://lkml.kernel.org/r/20250109152245.1591914-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagetranstail
+++ a/include/linux/page-flags.h
@@ -936,21 +936,9 @@ static inline int PageTransCompound(cons
 {
 	return PageCompound(page);
 }
-
-/*
- * PageTransTail returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransTail(const struct page *page)
-{
-	return PageTail(page);
-}
 #else
 TESTPAGEFLAG_FALSE(TransHuge, transhuge)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-TESTPAGEFLAG_FALSE(TransCompoundMap, transcompoundmap)
-TESTPAGEFLAG_FALSE(TransTail, transtail)
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
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

