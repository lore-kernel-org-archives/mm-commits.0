Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FCD50A68
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059687; cv=none; b=CnXtDEiJBcN3AhbTJ9VeCPdQ8WueLm7ozNl8aOkxacqkhO56rLLEcKoBTWVv098dgknZNns0MTR0vMkqzgEOWNEKf55zD1GwduJ8X1UZceqlW0TWr1VbkNzymgxm1QY3/m/1P3LQRUm5lvP3zejj8nShLPbBr77IiqaR0PkZjrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059687; c=relaxed/simple;
	bh=qfirKJoKyB/igMR2CYQ/UCxHHwnb7ezfGMuEaSdhBbY=;
	h=Date:To:From:Subject:Message-Id; b=TGQNiyKvs9AA1anvF6w5PhNCyJpFGOYHnej+J7IxvxKox9JIikI0b8vel9LwrWW7R1ffCP0EkUgNaZByBqOW8iddGHrFR5xg3/ydd29scKqvvjuYrT3rVxur+JV3fOW/cwER2J+ZS9UqaNwRq5awL4E5nWgBkn/hy5H0sBFYh3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JP2ip9IS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JP2ip9IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AFBC43394;
	Tue, 27 Feb 2024 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059687;
	bh=qfirKJoKyB/igMR2CYQ/UCxHHwnb7ezfGMuEaSdhBbY=;
	h=Date:To:From:Subject:From;
	b=JP2ip9ISTjb4InEf4KY04kjm7C+RfVxuwN+7rvtBc3zSeQ2rCyRyafpyy/EV1FBox
	 YgFvN6PzjIHqNaxb+/QGV5LmTksQY9Km3xG1JwqhJJjn69H0CWILKpJoi/ZbAh1Rps
	 FY2oa4GWwoUkZx979yxTCEXtdW4xJ5s1qJZOdnDs=
Date: Tue, 27 Feb 2024 10:48:06 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-mem_cgroup_uncharge_list.patch added to mm-unstable branch
Message-Id: <20240227184807.44AFBC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove mem_cgroup_uncharge_list()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-mem_cgroup_uncharge_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-mem_cgroup_uncharge_list.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: remove mem_cgroup_uncharge_list()
Date: Tue, 27 Feb 2024 17:42:47 +0000

All users have been converted to mem_cgroup_uncharge_folios() so we can
remove this API.

Link: https://lkml.kernel.org/r/20240227174254.710559-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ------------
 mm/memcontrol.c            |   19 -------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_uncharge_list
+++ a/include/linux/memcontrol.h
@@ -713,14 +713,6 @@ static inline void mem_cgroup_uncharge(s
 	__mem_cgroup_uncharge(folio);
 }
 
-void __mem_cgroup_uncharge_list(struct list_head *page_list);
-static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-	if (mem_cgroup_disabled())
-		return;
-	__mem_cgroup_uncharge_list(page_list);
-}
-
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1301,10 +1293,6 @@ static inline void mem_cgroup_uncharge(s
 {
 }
 
-static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-}
-
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 }
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_uncharge_list
+++ a/mm/memcontrol.c
@@ -7513,25 +7513,6 @@ void __mem_cgroup_uncharge(struct folio
 	uncharge_batch(&ug);
 }
 
-/**
- * __mem_cgroup_uncharge_list - uncharge a list of page
- * @page_list: list of pages to uncharge
- *
- * Uncharge a list of pages previously charged with
- * __mem_cgroup_charge().
- */
-void __mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-	struct uncharge_gather ug;
-	struct folio *folio;
-
-	uncharge_gather_clear(&ug);
-	list_for_each_entry(folio, page_list, lru)
-		uncharge_folio(folio, &ug);
-	if (ug.memcg)
-		uncharge_batch(&ug);
-}
-
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 	struct uncharge_gather ug;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

