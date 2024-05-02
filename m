Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE116FF52
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714670037; cv=none; b=NL6DHy0ifjpn8Txkyk//ZKowzQ3fdUsAapKlnwlWmMUtp6hxGc7xCX8RVvEkoeUn8xQ86sb9gxY7VAv0SRSBHhq0vqTpk01zktEbp2HlucYor4gIF4dMGr75Jf7XPmgYwz3cE3T6KYFdOU0owrbw3S5fznaZMH6bnBdrSmcA7bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714670037; c=relaxed/simple;
	bh=3c9hWPN3ZnJIS8XGl+WfZMZE5TgAnckyLzEBf39sk8U=;
	h=Date:To:From:Subject:Message-Id; b=tJoSBC9Irq++g3EzAQ7VT766RGTbtpOom8YNPsJPniMw1c07kFkmq20/OmSmV+YiWwD6OWOBYOdovVUnqSP9MgYdIR90Vn66sQecYfu7ehxXDop7XRqfRPoLT42V8G2rtZRI9Z3rr+EYCjFBznoaNxowh81gD2sxj49ez39etJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/aCbarz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/aCbarz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2ADC113CC;
	Thu,  2 May 2024 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714670036;
	bh=3c9hWPN3ZnJIS8XGl+WfZMZE5TgAnckyLzEBf39sk8U=;
	h=Date:To:From:Subject:From;
	b=A/aCbarzmVxWmFETfWB2WBYgg9ic1vjew6RqBcIhbVOIubokNI6nc5UQYA0hQ+wmE
	 3Sses0Q2fPg4Cuo2Pf2Fxb2PtJmY+P4kAN2XMRN+qqraLHHXT34tTxPfoGrQGk0wh+
	 ZsdMGER4go2JwmK5tYnO0QZl9E9DiRBQmyBfEAV0=
Date: Thu, 02 May 2024 10:13:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch added to mm-unstable branch
Message-Id: <20240502171356.8F2ADC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: avoid unnecessary page level access check for pageout DAMOS action
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch

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
Subject: mm/damon/paddr: avoid unnecessary page level access check for pageout DAMOS action
Date: Mon, 29 Apr 2024 15:44:48 -0700

Patch series "mm/damon/paddr: simplify page level access re-check for
pageout.

The 'pageout' DAMOS action implementation of 'paddr' asks reclaim_pages()
to do page level access check again.  But the user can ask 'paddr' to do
the page level access check on its own, using DAMOS filter of 'young page'
type.  Meanwhile, 'paddr' is the only user of reclaim_pages() that asks
the page level access check.

Make 'paddr' does the page level access check on its own always, and
simplify reclaim_pages() by removing the page level access check request
handling logic.  As a result of the change for reclaim_pages(),
reclaim_folio_list(), which is called by reclaim_pages(), also no more
need to do the page level access check.  Simplify the function, too.


This patch (of 4):

'pageout' DAMOS action implementation of 'paddr' asks reclaim_pages() to
do the page level access check.  User could ask DAMOS to do the page level
access check on its own using 'young page' type DAMOS filter.  In the
case, pageout DAMOS action unnecessarily asks reclaim_pages() to do the
check again.  Ask the page level access check only if the scheme is not
having the filter.

Link: https://lkml.kernel.org/r/20240429224451.67081-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240429224451.67081-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action
+++ a/mm/damon/paddr.c
@@ -244,6 +244,16 @@ static unsigned long damon_pa_pageout(st
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
+	bool ignore_references = false;
+	struct damos_filter *filter;
+
+	/* respect user's page level reference check handling request */
+	damos_for_each_filter(filter, s) {
+		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
+			ignore_references = true;
+			break;
+		}
+	}
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
@@ -265,7 +275,7 @@ static unsigned long damon_pa_pageout(st
 put_folio:
 		folio_put(folio);
 	}
-	applied = reclaim_pages(&folio_list, false);
+	applied = reclaim_pages(&folio_list, ignore_references);
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

