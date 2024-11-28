Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419318E25;
	Thu, 28 Nov 2024 01:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732756364; cv=none; b=J0nFvyDeRmfborc/CKP4MslMqC/XHZLe2DP2d0tRSakM/AIQ91zs/y1tgfT214Dl1PL7nK0qN8RsUMS7pw3JzfOg/wQDjTk6QuLlR2WByk7q91hhM+9y9M81lDxxHT6n+wAqiaREfHeVDQR1Lb1Ux1zut6ehriHuLtAN35WvqQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732756364; c=relaxed/simple;
	bh=5SLgCbLqDxaVXDdo0U3BpIVt9JOS5aWINvrsqNaOEnw=;
	h=Date:To:From:Subject:Message-Id; b=XcXs9oyZNlwg+F/IMycHnM0F+wYU+yUr9XrRKrQXLTx2qrZp3JDsRrJLKvnxXZLxMhcCRliM6DoFOR1/93x/f4Pi47qwBl4yU39G3SeLlYEb6rFblgR2tTHL+Gd16rOH6rPMCj8pVs7Cs+D5Vbwd1ljec4y9GMNhMta5tckPluE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+z/3PzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+z/3PzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D96EC4CECC;
	Thu, 28 Nov 2024 01:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732756363;
	bh=5SLgCbLqDxaVXDdo0U3BpIVt9JOS5aWINvrsqNaOEnw=;
	h=Date:To:From:Subject:From;
	b=u+z/3PzN8NdDkfxunRlB3KJf0sDXGh6FyXTfYmd5Xpvpwtj4Ot7Jw6Qfk/Hbo3zOi
	 dfbjCXfB1tE1UMQASQ08ruS1N/uP4LcCTOKGo20QrIPbM7JWNRKYaJ7mqkYrdVWKN7
	 ebl8s/ZWLzxfjTHTAMjSINpwlEupZz2UFIKfgRZA=
Date: Wed, 27 Nov 2024 17:12:43 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-open-code-page_folio-in-dump_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128011243.8D96EC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: open-code page_folio() in dump_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-open-code-page_folio-in-dump_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-open-code-page_folio-in-dump_page.patch

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
Subject: mm: open-code page_folio() in dump_page()
Date: Mon, 25 Nov 2024 20:17:19 +0000

page_folio() calls page_fixed_fake_head() which will misidentify this page
as being a fake head and load off the end of 'precise'.  We may have a
pointer to a fake head, but that's OK because it contains the right
information for dump_page().

gcc-15 is smart enough to catch this with -Warray-bounds:

In function 'page_fixed_fake_head',
    inlined from '_compound_head' at ../include/linux/page-flags.h:251:24,
    inlined from '__dump_page' at ../mm/debug.c:123:11:
../include/asm-generic/rwonce.h:44:26: warning: array subscript 9 is outside
+array bounds of 'struct page[1]' [-Warray-bounds=]

Link: https://lkml.kernel.org/r/20241125201721.2963278-2-willy@infradead.org
Fixes: fae7d834c43c ("mm: add __dump_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/debug.c~mm-open-code-page_folio-in-dump_page
+++ a/mm/debug.c
@@ -124,19 +124,22 @@ static void __dump_page(const struct pag
 {
 	struct folio *foliop, folio;
 	struct page precise;
+	unsigned long head;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long idx, nr_pages = 1;
 	int loops = 5;
 
 again:
 	memcpy(&precise, page, sizeof(*page));
-	foliop = page_folio(&precise);
-	if (foliop == (struct folio *)&precise) {
+	head = precise.compound_head;
+	if ((head & 1) == 0) {
+		foliop = (struct folio *)&precise;
 		idx = 0;
 		if (!folio_test_large(foliop))
 			goto dump;
 		foliop = (struct folio *)page;
 	} else {
+		foliop = (struct folio *)(head - 1);
 		idx = folio_page_idx(foliop, page);
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

