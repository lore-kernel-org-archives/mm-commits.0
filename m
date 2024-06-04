Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BA114D71C
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544300; cv=none; b=I83wGac/hqHCKT9U6gOECxo/r54YNwc8gJlBf4tRmTW75m3kFVSs8h8nFHSDs5f9DAbMjEkGLKhiADpTYy17ll81ijYaswj5WLqCl1IxgID9mFfPBBPl9lNmZzRL4Bz0Zv5d2IiJeGu6EJgzncelm7yhTzJdhNs6puyLut/QkPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544300; c=relaxed/simple;
	bh=G84pbXNFpmv++rvzWaJZn0alYM3nXMsvvi+Y3bP8bp0=;
	h=Date:To:From:Subject:Message-Id; b=kYFw8MP+hfAlq18gUlzSRE8XyaW6ysOnB03dM5GucIpcCOPxr3YdGk938YdJSJ9CS3Vd4WXMvuFjmkDHjO8RfSfZfhVEdpcR8IVG+PwY9uV5Do1h2C/0N2oKY5nQsOqKNM8n77ozd+kg70ENpk8vE64UakwNkEBbhk97qagj0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bPnPuCqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPnPuCqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CE6C2BBFC;
	Tue,  4 Jun 2024 23:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717544299;
	bh=G84pbXNFpmv++rvzWaJZn0alYM3nXMsvvi+Y3bP8bp0=;
	h=Date:To:From:Subject:From;
	b=bPnPuCqDzWXydU3DFDXjoEcCrtMlXF7/IiMOlO4j2IuOKkYgWoXqeuivABiQ7WSNj
	 27Taj6HJZAQQ+yIb7j2qw3/9cMS4GEKnuki9Pf06lvAbZyddSES2/+Lj3toc2ZGYaA
	 /aVMA2vOH9S5kv+1IAEWhSLauqIX9kJRxLLQgzTU=
Date: Tue, 04 Jun 2024 16:38:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_maybe_dma_pinned.patch added to mm-unstable branch
Message-Id: <20240604233819.D6CE6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_maybe_dma_pinned()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_maybe_dma_pinned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_maybe_dma_pinned.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove page_maybe_dma_pinned()
Date: Tue, 4 Jun 2024 19:48:20 +0800

After the last user of page_maybe_dma_pinned() is converted to
folio_maybe_dma_pinned(), remove page_maybe_dma_pinned() and update the
document and comment.

Link: https://lkml.kernel.org/r/20240604114822.2089819-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   10 +++++-----
 include/linux/mm.h                        |    9 ++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_maybe_dma_pinned
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -196,20 +196,20 @@ INCORRECT (uses FOLL_GET calls):
     write to the data within the pages
     put_page()
 
-page_maybe_dma_pinned(): the whole point of pinning
+folio_maybe_dma_pinned(): the whole point of pinning
 ===================================================
 
-The whole point of marking pages as "DMA-pinned" or "gup-pinned" is to be able
-to query, "is this page DMA-pinned?" That allows code such as page_mkclean()
+The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
+to query, "is this folio DMA-pinned?" That allows code such as page_mkclean()
 (and file system writeback code in general) to make informed decisions about
-what to do when a page cannot be unmapped due to such pins.
+what to do when a folio cannot be unmapped due to such pins.
 
 What to do in those cases is the subject of a years-long series of discussions
 and debates (see the References at the end of this document). It's a TODO item
 here: fill in the details once that's worked out. Meanwhile, it's safe to say
 that having this available: ::
 
-        static inline bool page_maybe_dma_pinned(struct page *page)
+        static inline bool folio_maybe_dma_pinned(struct folio *folio)
 
 ...is a prerequisite to solving the long-running gup+DMA problem.
 
--- a/include/linux/mm.h~mm-remove-page_maybe_dma_pinned
+++ a/include/linux/mm.h
@@ -1940,8 +1940,8 @@ static inline struct folio *pfn_folio(un
  *
  * For more information, please see Documentation/core-api/pin_user_pages.rst.
  *
- * Return: True, if it is likely that the page has been "dma-pinned".
- * False, if the page is definitely not dma-pinned.
+ * Return: True, if it is likely that the folio has been "dma-pinned".
+ * False, if the folio is definitely not dma-pinned.
  */
 static inline bool folio_maybe_dma_pinned(struct folio *folio)
 {
@@ -1960,11 +1960,6 @@ static inline bool folio_maybe_dma_pinne
 		GUP_PIN_COUNTING_BIAS;
 }
 
-static inline bool page_maybe_dma_pinned(struct page *page)
-{
-	return folio_maybe_dma_pinned(page_folio(page));
-}
-
 /*
  * This should most likely only be called during fork() to see whether we
  * should break the cow immediately for an anon page on the src mm.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch

