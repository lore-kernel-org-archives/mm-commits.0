Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D6C16F915
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714670039; cv=none; b=PMX1YXj2Gm/xPjMwW+rQbA18cW09JXLUgeIMR8y9FXahBfbzYCtPGvPNutnLAjdyMyUyTrlraxm8wO6JQvOkv/c1995Ve2BZ5tIjSO+cOys0zp3kPEBSG4c/oxZfAEEOazrkVuRRr2pWGpiHzCrH3q+v70jtr4bCgeWnkm/OWAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714670039; c=relaxed/simple;
	bh=tJA4KnEwNeawCiY+Xv7v69x/+JYvDJAQb6c9i74VvaE=;
	h=Date:To:From:Subject:Message-Id; b=CR0CdZvYYh8uDWCchVY/QOgoeO0mQRypna4m67lbeb+9lAXqCxr+jprJUgvykRMRULn3QeOWszQMgYWHMjmfaS+JX4NPPKCoYvsbmJVhIlz62i924ta8HEs6mbEW7pEH2WHX/YnwC6YMka+nkRvpF3wXWkHCiCiKgdnG1OCvWsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rOHJC4V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rOHJC4V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158CAC116B1;
	Thu,  2 May 2024 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714670039;
	bh=tJA4KnEwNeawCiY+Xv7v69x/+JYvDJAQb6c9i74VvaE=;
	h=Date:To:From:Subject:From;
	b=rOHJC4V1hVDW2wEC00CBv1lT7NeEH52OwOXehmZzsx2uskipHJFX0EMX5gGAV9+b2
	 GQd6ppUeQxUwUUSPpd9/Pg4oLCySHMm0EdSG6D8UNFCwVwWlBK0OczSO2dK6DycQLo
	 9vQ2uphWtY9wS6D8tMWQJuSYe0R0xnSYUmyd0khI=
Date: Thu, 02 May 2024 10:13:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch added to mm-unstable branch
Message-Id: <20240502171359.158CAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: do page level access check for pageout DAMOS action on its own
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: do page level access check for pageout DAMOS action on its own
Date: Mon, 29 Apr 2024 15:44:49 -0700

'pageout' DAMOS action implementation of 'paddr' DAMON operations set asks
reclaim_pages() to do page level access check if the user is not asking
DAMOS to do that on its own.  Simplify the logic by making the check
always be done by 'paddr'.

Link: https://lkml.kernel.org/r/20240429224451.67081-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own
+++ a/mm/damon/paddr.c
@@ -244,16 +244,22 @@ static unsigned long damon_pa_pageout(st
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
-	bool ignore_references = false;
+	bool install_young_filter = true;
 	struct damos_filter *filter;
 
-	/* respect user's page level reference check handling request */
+	/* check access in page level again by default */
 	damos_for_each_filter(filter, s) {
 		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
-			ignore_references = true;
+			install_young_filter = false;
 			break;
 		}
 	}
+	if (install_young_filter) {
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true);
+		if (!filter)
+			return 0;
+		damos_add_filter(s, filter);
+	}
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
@@ -275,7 +281,9 @@ static unsigned long damon_pa_pageout(st
 put_folio:
 		folio_put(folio);
 	}
-	applied = reclaim_pages(&folio_list, ignore_references);
+	if (install_young_filter)
+		damos_destroy_filter(filter);
+	applied = reclaim_pages(&folio_list, true);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch

