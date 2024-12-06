Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D6A18CBFE;
	Fri,  6 Dec 2024 03:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457324; cv=none; b=B/izobFR3NvahbN10s/ygjZjU9oyWkCMywYt2q0JmevffInWPpy6bD8WSPXUyfkF8n5Q3QyNOcos/JRPpZKTL/BmDHqCnssWFs8qGxcYADmB8esIA35kucDszpbFPGnKiNm9J4QsDQTdsDtuSV5iUzH5O13iMzdGyDpB4//9jnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457324; c=relaxed/simple;
	bh=c01U4WsbZxLxKhCI3p4j+SlqT/p4U01YHHPoMLpTAZE=;
	h=Date:To:From:Subject:Message-Id; b=XUgnnFf6OM3LwsvlaMc+f8V33fDilCYmxU+cfh5WNpE9fkNvCP8f3v4phKx4D9s8fzSE/T9GcFff/MT07MFlzSqLVjxxljq4QggsDw+i0hlyIhR+zYYG47PEUX0JjeWp6w0EY2bIKZNUihiSaEXb+v87wk5CPKwL1ExprezJN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zimsDDKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zimsDDKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7118EC4CED2;
	Fri,  6 Dec 2024 03:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457324;
	bh=c01U4WsbZxLxKhCI3p4j+SlqT/p4U01YHHPoMLpTAZE=;
	h=Date:To:From:Subject:From;
	b=zimsDDKmq617l/Nr3H0GQzDmCet1i8nzXQGyF7IDiWvDFXJ+UUzaFUCxa3Abu5MUa
	 1l3J+Bq+Hevj8aZ1YAKB41NV4KiKoOuxHpTGNT6sO/5JmhMFetBAbt+7biTVtv4nVi
	 I6sBF6REGYEvCYO9dlIZ+SbSS5adv1yeSfnhbk68=
Date: Thu, 05 Dec 2024 19:55:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch removed from -mm tree
Message-Id: <20241206035524.7118EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: open-code PageTail in folio_flags() and const_folio_flags()
has been removed from the -mm tree.  Its filename was
     mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: open-code PageTail in folio_flags() and const_folio_flags()
Date: Mon, 25 Nov 2024 20:17:18 +0000

It is unsafe to call PageTail() in dump_page() as page_is_fake_head() will
almost certainly return true when called on a head page that is copied to
the stack.  That will cause the VM_BUG_ON_PGFLAGS() in const_folio_flags()
to trigger when it shouldn't.  Fortunately, we don't need to call
PageTail() here; it's fine to have a pointer to a virtual alias of the
page's flag word rather than the real page's flag word.

Link: https://lkml.kernel.org/r/20241125201721.2963278-1-willy@infradead.org
Fixes: fae7d834c43c ("mm: add __dump_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-open-code-pagetail-in-folio_flags-and-const_folio_flags
+++ a/include/linux/page-flags.h
@@ -306,7 +306,7 @@ static const unsigned long *const_folio_
 {
 	const struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
 	return &page[n].flags;
 }
@@ -315,7 +315,7 @@ static unsigned long *folio_flags(struct
 {
 	struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
 	return &page[n].flags;
 }
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

