Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38C151C4D
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059689; cv=none; b=JHEvYcW1HYXWgwWLZWx1gQovZrV9r2M9zt0YMmhpNAfCcSHMWK3z4EKGfLbUFJHPB+e1KU/un7KZPAMDsa+33Y88DLWy7CXYS/OorLcrc+1mP125Pz72drPlTAAUe75wJE1l1l7/gu7RQ4VZ8EWrk83rQiGXh8+Ceht5OzdQMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059689; c=relaxed/simple;
	bh=+vL/xUYDIAcgBuIqTpQhteoogZ4sycsWgOTd7TWEXlo=;
	h=Date:To:From:Subject:Message-Id; b=vEwoEiAiqWPfCei+6IHi04ixYfEAGPAF7ZbwIDHp/lYa/fSv+5FWGtPfURnNyu/hKcZAhz9jAbktSzYpMcZtuXxNOkRnBIPXvmk58rj5jqFXriFF2fcdTHhlfHISOn62gbmyXRMFOFlTj++XaeEmKhKP3qg4vVt4s44IEha0J6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3WzIYNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3WzIYNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1880C43390;
	Tue, 27 Feb 2024 18:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059688;
	bh=+vL/xUYDIAcgBuIqTpQhteoogZ4sycsWgOTd7TWEXlo=;
	h=Date:To:From:Subject:From;
	b=m3WzIYNn9A6hSKTvL6MrtDrWukL4UCJ1Povy4u/ihv7tz+4o+26ov1sv50kg/1SGg
	 QM1T2t0GCsK5+JxQ9zSYCVWIzZl1EOCdDuqfPlP16HwWoDgI/zMoR3PTkOF3Ci4eYm
	 md6KEFeD6YS8C1aQS7J5kc99h/P4dU/848ZLF1jw=
Date: Tue, 27 Feb 2024 10:48:08 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-free_unref_page_list.patch added to mm-unstable branch
Message-Id: <20240227184808.A1880C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove free_unref_page_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-free_unref_page_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-free_unref_page_list.patch

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
Subject: mm: remove free_unref_page_list()
Date: Tue, 27 Feb 2024 17:42:48 +0000

All callers now use free_unref_folios() so we can delete this function.

Link: https://lkml.kernel.org/r/20240227174254.710559-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 -
 mm/page_alloc.c |   18 ------------------
 2 files changed, 19 deletions(-)

--- a/mm/internal.h~mm-remove-free_unref_page_list
+++ a/mm/internal.h
@@ -543,7 +543,6 @@ extern int user_min_free_kbytes;
 
 void free_unref_page(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
-void free_unref_page_list(struct list_head *list);
 
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
--- a/mm/page_alloc.c~mm-remove-free_unref_page_list
+++ a/mm/page_alloc.c
@@ -2605,24 +2605,6 @@ void free_unref_folios(struct folio_batc
 	folio_batch_reinit(folios);
 }
 
-void free_unref_page_list(struct list_head *list)
-{
-	struct folio_batch fbatch;
-
-	folio_batch_init(&fbatch);
-	while (!list_empty(list)) {
-		struct folio *folio = list_first_entry(list, struct folio, lru);
-
-		list_del(&folio->lru);
-		if (folio_batch_add(&fbatch, folio) > 0)
-			continue;
-		free_unref_folios(&fbatch);
-	}
-
-	if (fbatch.nr)
-		free_unref_folios(&fbatch);
-}
-
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
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

