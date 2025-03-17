Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E502153E0;
	Mon, 17 Mar 2025 05:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188253; cv=none; b=m7hbO1FlSb/jj2VewzOC5L8LdUx5q6ZmSjJ0ymi5zkfIDjL4kahKbnQSSM978/MsGqc1L54dIu813op9rHfaj+FknVc1vgjoALFXoUtSt5u74IeZL6V0aAswytgQ255RA03f46PdRzKTUg5WplS2/SUQzzzy/RgtFa60D5JitBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188253; c=relaxed/simple;
	bh=7sKPFPzhCga8+NVmOp1XCjN3BlcVNT0iIpYH468R12g=;
	h=Date:To:From:Subject:Message-Id; b=GOo5AdD+cCEtT3q9hx/5p2h9cI7hhbsKPWnj7SZ1XqnAGiSL55eOf6FZOuGzpWBqDcLs/qfRh6m8+aMstEHZmBwmIy7Qs9kh/7B6Ma4Q1/Sc0qHHEcBKmCqvqZBeFjAF4dfYOI2gOLVxOOr27KANCYD/my51BluItoBmw1fhzns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IO9yIDSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IO9yIDSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F39AC4CEEC;
	Mon, 17 Mar 2025 05:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188253;
	bh=7sKPFPzhCga8+NVmOp1XCjN3BlcVNT0iIpYH468R12g=;
	h=Date:To:From:Subject:From;
	b=IO9yIDSru2JvFYOEx0VNn11tBEefJNIfDZkMgtXASGRc/v+Cfvqrxsq/J7L6c/Lqh
	 0oUNkeGTHLV5R15gjRhz2lb+L67NTOL2p5jXUIoBwOP/rJ80hGxQuRu41XXS5lXqqG
	 BKe9qyHpRnsEekdNrQuHe7ffHtTNlufXGXsi/VBg=
Date: Sun, 16 Mar 2025 22:10:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch removed from -mm tree
Message-Id: <20250317051053.3F39AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops: have damon_get_folio return folio even for tail pages
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -26,7 +26,7 @@ struct folio *damon_get_folio(unsigned l
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
 
-	if (!page || PageTail(page))
+	if (!page)
 		return NULL;
 
 	folio = page_folio(page);
--- a/mm/damon/paddr.c~mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages
+++ a/mm/damon/paddr.c
@@ -277,11 +277,14 @@ static unsigned long damon_pa_pageout(st
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
@@ -297,6 +300,7 @@ static unsigned long damon_pa_pageout(st
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -312,11 +316,14 @@ static inline unsigned long damon_pa_mar
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
@@ -329,6 +336,7 @@ static inline unsigned long damon_pa_mar
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -475,11 +483,14 @@ static unsigned long damon_pa_migrate(st
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
@@ -490,6 +501,7 @@ static unsigned long damon_pa_migrate(st
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


