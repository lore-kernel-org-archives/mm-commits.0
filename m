Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5AB1A01C6;
	Fri,  7 Feb 2025 23:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738971950; cv=none; b=jFUestoCHImDjYB8XbjOesUYt5/gOqX9+pWPlKq/XPJtk3pON1cVQvzwVZjcaofGPTDWxvMinuB6Wm6hVryHSnDheS/nb1UpZdFPZZaAlgzfSiW/QbO67u7+A24MqYb7eGb1zp5UwQbXP46RHsuTurwcQKVOcDTvhyKQhEB7YmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738971950; c=relaxed/simple;
	bh=pXzOhhbg8B/FWc1dCRVjAUJEBNwpecP00gZ6sIA36dQ=;
	h=Date:To:From:Subject:Message-Id; b=tTXz7Q2lT+H+nXxDbSVHCocxMP6Amzg07HJi2JC1cwisni80RXb1GeLgzfD8/UxEK9CRoad56jgb+hXx8DzWzk0FEEeaFFgijTrqFBmWdUhc0jSsU8lPzThsJKEr5TqTOTvfh+wZbSL3wVH4xrHNW6nT+uCgEvT44Pf1ndYEi20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGE/j3r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGE/j3r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A254C4CED1;
	Fri,  7 Feb 2025 23:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738971949;
	bh=pXzOhhbg8B/FWc1dCRVjAUJEBNwpecP00gZ6sIA36dQ=;
	h=Date:To:From:Subject:From;
	b=UGE/j3r/zWcsbBdAowioEYXZEJz9UI/QlhvoqaMJIvOZQaRKYerwgnIIBV9Xg/jUK
	 cGY4KyKVAt6YR4qrX49dYn5H2puDZOVdj5kxr4u1BBFYTrk/e5PdFuto/6jeIjZl7f
	 kbouvC8Gy8pH3J6DHPRjKKHDCRJAiyZJ8YFnEYA4=
Date: Fri, 07 Feb 2025 15:45:48 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch added to mm-unstable branch
Message-Id: <20250207234549.6A254C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops: have damon_get_folio return folio even for tail pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/damon/ops: have damon_get_folio return folio even for tail pages
Date: Fri, 7 Feb 2025 13:20:32 -0800

Patch series "mm/damon/paddr: fix large folios access and schemes handling".

DAMON operations set for physical address space, namely 'paddr', treats
tail pages as unaccessed always.  It can also apply DAMOS action to a
large folio multiple times within single DAMOS' regions walking.  As a
result, the monitoring output has poor quality and DAMOS works in
unexpected ways when large folios are being used.  Fix those.

The patches were parts of Usama's hugepage_size DAMOS filter patch
series[1].  The first fix has collected from there with a slight commit
message change for the subject prefix.  The second fix is re-written by SJ
and posted as an RFC before this series.  The second one also got a slight
commit message change for the subject prefix.

[1] https://lore.kernel.org/20250203225604.44742-1-usamaarif642@gmail.com
[2] https://lore.kernel.org/20250206231103.38298-1-sj@kernel.org


This patch (of 2):

This effectively adds support for large folios in damon for paddr, as
damon_pa_mkold/young won't get a null folio from this function and won't
ignore it, hence access will be checked and reported.  This also means
that larger folios will be considered for different DAMOS actions like
pageout, prioritization and migration.  As these DAMOS actions will
consider larger folios, iterate through the region at folio_size and not
PAGE_SIZE intervals.  This should not have an affect on vaddr, as
damon_young_pmd_entry considers pmd entries.

Link: https://lkml.kernel.org/r/20250207212033.45269-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250207212033.45269-2-sj@kernel.org
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 mm/damon/paddr.c      |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages
+++ a/mm/damon/ops-common.c
@@ -24,7 +24,7 @@ struct folio *damon_get_folio(unsigned l
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
 
-	if (!page || PageTail(page))
+	if (!page)
 		return NULL;
 
 	folio = page_folio(page);
--- a/mm/damon/paddr.c~mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages
+++ a/mm/damon/paddr.c
@@ -266,11 +266,14 @@ static unsigned long damon_pa_pageout(st
 		damos_add_filter(s, filter);
 	}
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -286,6 +289,7 @@ static unsigned long damon_pa_pageout(st
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -301,11 +305,14 @@ static inline unsigned long damon_pa_mar
 {
 	unsigned long addr, applied = 0;
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -318,6 +325,7 @@ static inline unsigned long damon_pa_mar
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -464,11 +472,14 @@ static unsigned long damon_pa_migrate(st
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -479,6 +490,7 @@ static unsigned long damon_pa_migrate(st
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch

