Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3C5C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011132; cv=none; b=Bda8ov8483PFnV+DlWjsOIR8hDDvEXS5Bx91VrdwZK3GSIzWGqIWUaBtsxsP3k4lyeDb5N99hTgUUejkrEPX7wQ/cvJtynTmtygbE1+i3xd0HlThay4RQcKKis+/kQaCF7tsiMW0zfyjME+Hem9tmt6ScLZEwkliyH5C28vun0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011132; c=relaxed/simple;
	bh=hu20mYTyIlqy2HRFGkZLuDIciDKjnlSPfOCu/cjYsJU=;
	h=Date:To:From:Subject:Message-Id; b=UqbkE3nYcolZri+P9Wr3hOzdf8efhnLCvq1ErZhs5UCpTALjc8CD+3xym2afDFzpZKa/wavXf2nZYztq9VfnyincJ3FYAiKYZs23GwNmNlzVRgRptMaEKFTsXd8XcyqGjHQ9QgLi9cfRHg++3j232qKtliFdo9kW2WVTbAjPMJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jBTerxan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jBTerxan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3493C4CEE4;
	Mon, 12 May 2025 00:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011132;
	bh=hu20mYTyIlqy2HRFGkZLuDIciDKjnlSPfOCu/cjYsJU=;
	h=Date:To:From:Subject:From;
	b=jBTerxanZsqWEYGHzgqOOQmalsKm9DU1DqgoK7QrzBrwiHOiEGNiWJ024gVWlZasM
	 0zJ7BuRt+FLaGKWqlZl1g+o3S+9G/bJjppHm7mth7YfFY4HXuBSGlYMM5oOZwJvR5h
	 0VU0xplS2ADXvnETqqHiufKph9SEp6fSaIgaZ21U=
Date: Sun, 11 May 2025 17:52:12 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch removed from -mm tree
Message-Id: <20250512005212.A3493C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove gup_fast_pgd_leaf() and clean up the relevant codes
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: remove gup_fast_pgd_leaf() and clean up the relevant codes
Date: Thu, 10 Apr 2025 11:57:16 +0800

In the current kernel, only pud huge page is supported in some
architectures.  P4d and pgd huge pages haven't been supported yet.  And in
mm/gup.c, there's no pgd huge page handling in the follow_page_mask() code
path.  Hence it doesn't make sense to only have gup_fast_pgd_leaf() in
gup_fast code path.

Here remove gup_fast_pgd_leaf() and clean up the relevant codes.

Link: https://lkml.kernel.org/r/20250410035717.473207-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   49 +++----------------------------------------------
 1 file changed, 3 insertions(+), 46 deletions(-)

--- a/mm/gup.c~mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes
+++ a/mm/gup.c
@@ -3172,46 +3172,6 @@ static int gup_fast_pud_leaf(pud_t orig,
 	return 1;
 }
 
-static int gup_fast_pgd_leaf(pgd_t orig, pgd_t *pgdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
-{
-	int refs;
-	struct page *page;
-	struct folio *folio;
-
-	if (!pgd_access_permitted(orig, flags & FOLL_WRITE))
-		return 0;
-
-	BUILD_BUG_ON(pgd_devmap(orig));
-
-	page = pgd_page(orig);
-	refs = record_subpages(page, PGDIR_SIZE, addr, end, pages + *nr);
-
-	folio = try_grab_folio_fast(page, refs, flags);
-	if (!folio)
-		return 0;
-
-	if (unlikely(pgd_val(orig) != pgd_val(*pgdp))) {
-		gup_put_folio(folio, refs, flags);
-		return 0;
-	}
-
-	if (!pgd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
-		gup_put_folio(folio, refs, flags);
-		return 0;
-	}
-
-	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
-		return 0;
-	}
-
-	*nr += refs;
-	folio_set_referenced(folio);
-	return 1;
-}
-
 static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 		unsigned long end, unsigned int flags, struct page **pages,
 		int *nr)
@@ -3306,12 +3266,9 @@ static void gup_fast_pgd_range(unsigned
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			return;
-		if (unlikely(pgd_leaf(pgd))) {
-			if (!gup_fast_pgd_leaf(pgd, pgdp, addr, next, flags,
-					       pages, nr))
-				return;
-		} else if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
-					       pages, nr))
+		BUILD_BUG_ON(pgd_leaf(pgd));
+		if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
+					pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

