Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C3FDDBC
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457093; cv=none; b=S6ZqaI7p5Ka3B/5yZPuJucBxIlOyW1MEaiMQ76kfs/6oioy46Z6OAYQBE+LgOTEQd+OJYvNiWCzOtxlo2/sk5zgsnHjsuuDgctsOOIrAktz7iW8mDgFYof0mKDj/I+dPdyZMHy9wzI/DhSbU7XiEC/R0CdIueJ5fc6ZYiaoYIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457093; c=relaxed/simple;
	bh=b34UCsg7ufB1v1NDCCwkJ04G4ZNrJot9sOicWr/ZFZU=;
	h=Date:To:From:Subject:Message-Id; b=m0X6mmlKVbZ+IqtkqrZrTBldbXM3xgA345ZUoJg/zN2cNcYXsteTM09jqzPOsWuOf8wYfaO7GaeqaLjEXBfK+PelDVoH80MXAHNPZJ7zrvcff7yq8dTY440PzuLotTAvo/RFerF44mE9IqiqaIQcn+o/FwBPUK5jESms9nv7RPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fvi3R8sN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fvi3R8sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71AC4CEE3;
	Mon, 31 Mar 2025 21:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743457092;
	bh=b34UCsg7ufB1v1NDCCwkJ04G4ZNrJot9sOicWr/ZFZU=;
	h=Date:To:From:Subject:From;
	b=fvi3R8sN6xN0bCW9EOwcw6pCAmYZdsPSeXQ0XeNQg5AyDAt/ScKd0vBkymJ/4k4Ix
	 9JtQnhd2FO+gfhFjSA5uD5Sls5sAR353SK9he4UBWsTeBawPH/WPcoi9xwzftI7kp8
	 7KJxLzKgrGT2fh4lf5He9v/jKw0rp3vlCYcU1/fo=
Date: Mon, 31 Mar 2025 14:38:12 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,x86@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch added to mm-new branch
Message-Id: <20250331213812.BA71AC4CEE3@smtp.kernel.org>
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
Date: Mon, 31 Mar 2025 16:13:24 +0800

In the current kernel, only pud huge page is supported in some
architectures.  P4d and pgd huge pages haven't been supported yet.  And in
mm/gup.c, there's no pgd huge page handling in the follow_page_mask() code
path.  Hence it doesn't make sense to have gup_fast_pgd_leaf() in gup_fast
code path.

Here remove gup_fast_pgd_leaf() and clean up the relevant codes.

Link: https://lkml.kernel.org/r/20250331081327.256412-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: <x86@kernel.org>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   49 +++----------------------------------------------
 1 file changed, 3 insertions(+), 46 deletions(-)

--- a/mm/gup.c~mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes
+++ a/mm/gup.c
@@ -3163,46 +3163,6 @@ static int gup_fast_pud_leaf(pud_t orig,
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
@@ -3297,12 +3257,9 @@ static void gup_fast_pgd_range(unsigned
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

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

