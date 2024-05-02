Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F916F915
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714670045; cv=none; b=QyYyCGWTibYrSeRGQNNtrJEL/xGQIeybF0ULwCKXqfJ74NiFfhLiEgxFYq5UVxi9Aq6WnLod5igPnDaO2AjQMU6R6VQRuhrkEEwJiysZRX6EMwfP9qIPkjLOT8M9Izbic9G41koUmj6OzyMP2ytKDObFQmutFzO20CGO4JdE9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714670045; c=relaxed/simple;
	bh=rdVU+8SkPDSk/KwvuWXkO/cfar6lldgp42afu4np0p4=;
	h=Date:To:From:Subject:Message-Id; b=LyrpMg1gT0XsWjww6NPW389UNfFwHoifQgYtbBAxAn7q0SBM5sDodjEZ0NecQdmaCJUZR+e1Sm9JzTDXiSWyO5ZMtgb5Z7BArTGVaKQpOc2109nCzUT+k0VB9uW92X/N3vImzjo7Wz3CZj7rNNAQXslUXg1/xud7TkTBQXYNYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yqM6Sr/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yqM6Sr/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBEFC113CC;
	Thu,  2 May 2024 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714670045;
	bh=rdVU+8SkPDSk/KwvuWXkO/cfar6lldgp42afu4np0p4=;
	h=Date:To:From:Subject:From;
	b=yqM6Sr/sEUIR9g/f4tMbN8u7J6coDYVee6EtdwLqOBeEDoFB/MM26oYypI6seHZbO
	 GmWf+lTUnT0rVnnCM831Ef3SBs9dNV9LjORfWy/tI8QiM68GTYTqzBOKfNVV/JiP9f
	 hDBlOE/9Me0UDLXpuSVzWoLWDPikATTq4176lSWo=
Date: Thu, 02 May 2024 10:14:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch added to mm-unstable branch
Message-Id: <20240502171404.EBBEFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: remove ignore_references argument of reclaim_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch

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
Subject: mm/vmscan: remove ignore_references argument of reclaim_folio_list()
Date: Mon, 29 Apr 2024 15:44:51 -0700

All reclaim_folio_list() callers are passing 'true' for
'ignore_references' parameter.  In other words, the parameter is not
really being used.  Simplify the code by removing the parameter.

Link: https://lkml.kernel.org/r/20240429224451.67081-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list
+++ a/mm/vmscan.c
@@ -2109,8 +2109,7 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
-				      struct pglist_data *pgdat,
-				      bool ignore_references)
+				      struct pglist_data *pgdat)
 {
 	struct reclaim_stat dummy_stat;
 	unsigned int nr_reclaimed;
@@ -2123,7 +2122,7 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, ignore_references);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, true);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -2155,12 +2154,11 @@ unsigned long reclaim_pages(struct list_
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid),
-						   true);
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), true);
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
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

