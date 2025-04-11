Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3BB674
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343148; cv=none; b=T2QR8bXBUEO0TkmfwGut5Hi779Xf7F27tcgy3F/XT31BBrH7kvP2oL8B82UcLuVTNXt+bNe9NbQxoHrd8gj4rHT3+gjehM+ybIOxKYUxWDbMgdSoR50FNtu5gqKDbcWTK3bDzd0Z9KGtThnIdQtMkMyH6nuirOE4ga7WWJ5oDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343148; c=relaxed/simple;
	bh=vd6mnWSSaKQ3uvS7EY8NHpqEzCQ5xejRfhkha6eqrd8=;
	h=Date:To:From:Subject:Message-Id; b=V94hfrayJ+xLpOdXBTZ3nrJgN2w2AhNtERAE8RRUtr4oxYMHUyEoqof4p2lKxKEaoYoj7pm7R2EZgrCWMQeMn/i7QOH1o93D10n0EWBlyK7IijRLJXqoDB96zarMwgqxSa+96TF2bVBrt7quYPtRfBKXXst0dOnWr9wDXpIZv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ncec/d5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ncec/d5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E212C4CEE2;
	Fri, 11 Apr 2025 03:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343148;
	bh=vd6mnWSSaKQ3uvS7EY8NHpqEzCQ5xejRfhkha6eqrd8=;
	h=Date:To:From:Subject:From;
	b=Ncec/d5daaV6CyKTxI74+O+QplJZnr+qXxuporD/9A+y7yOJoJz8kMt32MuIGZFdR
	 xDFIjPGsB8dTh6s84fHqFGGrVndkM4C4D6tgNZ2HQew3Rs1Q+llsQpBsmK5QVHjCro
	 g7zL9lORbSDNr0aPGfPMe1rlXGL+SSN2UcZpDq3I=
Date: Thu, 10 Apr 2025 20:45:47 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch added to mm-new branch
Message-Id: <20250411034548.0E212C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove gup_fast_pgd_leaf() and clean up the relevant codes
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch

This patch will later appear in the mm-new branch at
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

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

