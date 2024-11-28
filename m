Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A299134BD;
	Thu, 28 Nov 2024 01:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732756362; cv=none; b=NcK/XrM2pxcycFtwn39CVHkkYDskEfojSdvbrykVi7ZjKdf1H+1WcVhoS8tlUieaL997rPDcTzmT90G8g7UrbfISWfnQO0HMIf9BWh9qumjV/kx0MViGhwIX4dwLcka+skxdT1UmIHWivUtwxg2l/3L/HlC1ZreM3e3YttFZN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732756362; c=relaxed/simple;
	bh=+PKh6bt+NBvt/sJanrrordvYqXf3FiwWF41hM3LqVpk=;
	h=Date:To:From:Subject:Message-Id; b=urPi1+iM57H2vvgw7liCAYxKe7xubL8ZO9z5rsPzqr4djx8szWR9fKKrXg61bG4KcbZ4fldb63uD0EsAQEv9mbLdn/ZG0LzY14K+LOfjNi+gxZqeIzudbiNw8eF6gXqOspiye5AakadMlEzy0G3v/6eUMYqgXpKlhSs27yzUJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wq6VzWp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wq6VzWp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60FCC4CECC;
	Thu, 28 Nov 2024 01:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732756361;
	bh=+PKh6bt+NBvt/sJanrrordvYqXf3FiwWF41hM3LqVpk=;
	h=Date:To:From:Subject:From;
	b=wq6VzWp5lBB77WCLKHpQzbkj5YU70D+P+xrWJyhPNsp21bwvvoReCBvih8MvhOPMR
	 64P7UBzg9M0UPLBV/17YrlPKMgdeesj88JtbEeofB5VSRgBbU9H0x7zlIhslkmtVsg
	 mVCKil0YSoCb7CRnYReB4GcUawgMdljooaHwJ1i8=
Date: Wed, 27 Nov 2024 17:12:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128011241.A60FCC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: open-code PageTail in folio_flags() and const_folio_flags()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch

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
Cc: <stable@vger.kernel.org>
Cc: Kees Cook <kees@kernel.org>
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

mm-open-code-pagetail-in-folio_flags-and-const_folio_flags.patch
mm-open-code-page_folio-in-dump_page.patch
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

