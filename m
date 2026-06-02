Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295238CFEF
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780420254; cv=none; b=mVeGPlqXypoMzh5jZuFPBuT/wma1fSXrJMA009VaCznS9s7lEPVUetUd/KWDhEwUoxnS+zA0l4PQ5VHtaM+B6KMaHD6QlYxv0Jafw2euIQDPY06K5FGApr8cADHfOEcwcua89K2O89FMYboVIaCMkO3g9G/wSjlNkHfqVFQXwpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780420254; c=relaxed/simple;
	bh=wMCXU5DIy4Dm3kMqdL/KQV2JIF/ESETBHCSW9f1B9zg=;
	h=Date:To:From:Subject:Message-Id; b=YOHg+hLSf7hW6fm5g7SOYM6R5hnPVPzKfQ1hUvRV/VNG7dK2r87UKL0G1efCcl+czLJZsJT0pUwy4aSH6f/B8L4u2OEh8MGOE2On5M+G/Orxo/48ep866L1fbNy2y+SNW8FGIxWZgagtcbhVMN8+jSStPRqWEkAGMqPjatmdSsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2sqoy0e1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2sqoy0e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D021F00893;
	Tue,  2 Jun 2026 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780420253;
	bh=L0D7UJsCf+JWbqbq8WkSiirDWCy5CfUP0z3NpOtzYYU=;
	h=Date:To:From:Subject;
	b=2sqoy0e1pDsDLwVp0HJdhbxRwN5GFGSm4COy1V5ETuJEZvt4GwelsdmUtkwTialZe
	 EMmcTmkC691jhLGVv8FW6WzHAAPIHZxvQ0w6kFC0p4+2duRBIP+zlYOZDG5IAe3oqK
	 37ZujXV6GThOp3CtfC3iUOusm5Cf0PsL/UrfiV04=
Date: Tue, 02 Jun 2026 10:10:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,liushixin2@huawei.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch added to mm-new branch
Message-Id: <20260602171052.E4D021F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_isolation: avoid unsafe folio reads while scanning compound pages
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch
mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch
mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

