Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089AE16F91E
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714670042; cv=none; b=CwqtIMDOfVQzjYsL+nZEViH0g/V/wH2QfqnplSuNU2NvcC8yCmH8GCWGRTxXpCRsauF4VnTqzhxDKFSCFeliomg5Exf6ebzYLv7vxD08r737qlyeDsZ9gybwaju3Kl17VygzHzhEQ2g9AApns1TXtyXfsUGnKW2ZJjPWIUL2DcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714670042; c=relaxed/simple;
	bh=VwZcLZm21g6ZgGbbp49GipZirT0AJFkmyYyqlwPKTMw=;
	h=Date:To:From:Subject:Message-Id; b=P5m0Fg7FYV8I15UE3vu6grM2cxabNmKmtq6TlI80vcXfJlDksMhDVfzu8eytUGH+/J+D/Ueq4c0lQxLeYDTUU7Pqiaz4YThA6iGlFp1WvxNMg8k7Wge4ctwyDn+nCmHdAPuKbtIasSUwTfe5iDyNoLP3VFHsX2l9jt13+zIvnS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jCdmCHvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jCdmCHvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C4C113CC;
	Thu,  2 May 2024 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714670041;
	bh=VwZcLZm21g6ZgGbbp49GipZirT0AJFkmyYyqlwPKTMw=;
	h=Date:To:From:Subject:From;
	b=jCdmCHvDYqIusIs6Lek+DkBGnwHBXRgficigdHZ8JqLUBRWOmxuekbhOjyMtDObHD
	 cvcnn1hQE/xPVJr/TpXGrYrTLEeD9fGIQuLTEby2p6JarWcA84F6JGvxDqWdMk09/f
	 W6q9xbwWLjRl5g1r6cLi7BbD/R3ApWWPO4iVmPeE=
Date: Thu, 02 May 2024 10:14:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch added to mm-unstable branch
Message-Id: <20240502171401.A56C4C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: remove ignore_references argument of reclaim_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch

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
Subject: mm/vmscan: remove ignore_references argument of reclaim_pages()
Date: Mon, 29 Apr 2024 15:44:50 -0700

All reclaim_pages() callers are setting 'ignore_references' parameter
'true'.  In other words, the parameter is not really being used.  Remove
the argument to make it simple.

Link: https://lkml.kernel.org/r/20240429224451.67081-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 mm/internal.h    |    2 +-
 mm/madvise.c     |    4 ++--
 mm/vmscan.c      |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/paddr.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/damon/paddr.c
@@ -283,7 +283,7 @@ put_folio:
 	}
 	if (install_young_filter)
 		damos_destroy_filter(filter);
-	applied = reclaim_pages(&folio_list, true);
+	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
--- a/mm/internal.h~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/internal.h
@@ -1052,7 +1052,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references);
+unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
--- a/mm/madvise.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/madvise.c
@@ -423,7 +423,7 @@ static int madvise_cold_or_pageout_pte_r
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
-			reclaim_pages(&folio_list, true);
+			reclaim_pages(&folio_list);
 		return 0;
 	}
 
@@ -547,7 +547,7 @@ restart:
 		pte_unmap_unlock(start_pte, ptl);
 	}
 	if (pageout)
-		reclaim_pages(&folio_list, true);
+		reclaim_pages(&folio_list);
 	cond_resched();
 
 	return 0;
--- a/mm/vmscan.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/vmscan.c
@@ -2133,7 +2133,7 @@ static unsigned int reclaim_folio_list(s
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references)
+unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
 	unsigned int nr_reclaimed = 0;
@@ -2156,11 +2156,11 @@ unsigned long reclaim_pages(struct list_
 		}
 
 		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid),
-						   ignore_references);
+						   true);
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), ignore_references);
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), true);
 
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

