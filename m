Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41AC370AD8
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067217; cv=none; b=RNH7/3XkbTy8v02He0a+gVGRWrvx4W6TeMJlLgXNWXAjH3SWiGvVZwlalCbnIPShGwWemjMZoeYwlka9lktZA1/4c2zty7jrnyUR/t+R6pBOn22tq7TVt2gUQhYxjvp/sh8SLcN5dYTrKoVcq676qz/HRicMsBeCgs2zLJ+fQY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067217; c=relaxed/simple;
	bh=rsqABSMAWpWjuZsBasuftQUOHbjDOKvJ9xNSl3V7hf4=;
	h=Date:To:From:Subject:Message-Id; b=ZDd8b9D1wETXTTqqeTkCI73Q/oaxW4uSU8sWyBln32L3SdGj9FOrLmA5QJVC5Jb4ueBfBrj8ip09edEabdJDU+3D95NvZIAoGGxQTBnrugifVb26oulmti9V65/PEKVoHpTx32LdUnlGBy9GJWZtIiNLmtLmhLI6RE73LatHS1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcG7NUct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcG7NUct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92891F00A3A;
	Sun, 21 Jun 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067215;
	bh=39x/XzPNXHFoKr40XrOzrM1IARsbH3eH3+uTavG4XJk=;
	h=Date:To:From:Subject;
	b=mcG7NUctkqSKsALP8T91i8ReQUPTNL4/vb9geEvlYunDyjLPP3rMwSiqCoDETNKSJ
	 d5eQ2Wansjba8Y0HVxK/s0F5SBQhR/davKUeGHGwKVAyksakHcrgQqlu9PjOZFg0E0
	 att88cRHnCSBH5lN9Z2b0Do+UuQJL70etakiIA6o=
Date: Sun, 21 Jun 2026 11:40:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,osalvador@kernel.org,muchun.song@linux.dev,mhocko@suse.com,liushixin2@huawei.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch removed from -mm tree
Message-Id: <20260621184015.C92891F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_isolation: avoid unsafe folio reads while scanning compound pages
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm: page_isolation: avoid unsafe folio reads while scanning compound pages
Date: Tue, 2 Jun 2026 21:07:55 +0800

page_is_unmovable() can inspect compound pages without holding a folio
reference or any lock.  The folio can therefore be freed, split or reused
while the scanner is still looking at it.

The existing HugeTLB handling already avoids folio_hstate() for this
reason, but it still derives the hstate from folio_size() and later
derives the scan step from folio_nr_pages() and folio_page_idx().  These
helpers rely on the folio still being a valid folio head.  If the folio
changed concurrently, the scanner can read inconsistent folio metadata and
compute a wrong step.  In the worst case, folio_nr_pages() can return 1
for what used to be a tail page and the subtraction from folio_page_idx()
can underflow.

There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
expects a valid folio.  If the previously observed head page has been
reused as a tail page of another compound page, the folio flag checks can
trigger VM_BUG_ON_PGFLAGS().

Read the compound order once with compound_order(), reject obviously bogus
orders, and derive the hstate and scan step from that order instead of
querying folio size information again.  Also use PageLRU(page), which is
safe for the page being scanned, instead of folio_test_lru() on a
potentially stale folio pointer.

Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
to skip over an unstable HugeTLB folio.

Link: https://lore.kernel.org/20260602130755.38794-1-kaitao.cheng@linux.dev
Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages
+++ a/mm/page_isolation.c
@@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone
 	 * We need not scan over tail pages because we don't
 	 * handle each tail page individually in migration.
 	 */
-	if (PageHuge(page) || PageCompound(page)) {
+	if (PageCompound(page)) {
 		struct folio *folio = page_folio(page);
+		unsigned long nr_pages, pfn;
+		unsigned int order;
+
+		order = compound_order(&folio->page);
+		if (order > MAX_FOLIO_ORDER)
+			return true;
 
 		if (folio_test_hugetlb(folio)) {
 			struct hstate *h;
@@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone
 			 * The huge page may be freed so can not
 			 * use folio_hstate() directly.
 			 */
-			h = size_to_hstate(folio_size(folio));
-			if (h && !hugepage_migration_supported(h))
+			h = size_to_hstate(PAGE_SIZE << order);
+			if (!h || !hugepage_migration_supported(h))
 				return true;
-
-		} else if (!folio_test_lru(folio)) {
+		} else if (!PageLRU(page)) {
 			return true;
 		}
 
-		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+		nr_pages = 1UL << order;
+		pfn = page_to_pfn(page);
+		*step = (pfn | (nr_pages - 1)) + 1 - pfn;
 		return false;
 	}
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


