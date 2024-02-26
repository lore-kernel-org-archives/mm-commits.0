Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BD8132C00
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708986328; cv=none; b=Q+lKuUqCxtdaroLgiX34FPvd7GdD0MSYPg8RuVsVgJZlFBnXZLrsE7PE8FHgUXxWI2kN/LNtiO+t9w6eyJ/1x0WKrsnYLDa8wV5n+WfsEbxB4zJDGRJfNqmom1TMPhmz/JFffRe2OUqeFlde7gVNz6eMdYIQgGrKAgSwQ9qtzr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708986328; c=relaxed/simple;
	bh=SMrsfdMn8boULD5FEkfk0OLUCxS/acuRWaW09wgG7nY=;
	h=Date:To:From:Subject:Message-Id; b=uErOY/DG1rytCHT12u6jobLgYwh2H6+p+g8fWrKPppsrmJ3pdtkKUskKlukL35Y8wf3Nk0492/kuoX9q6Bkk2BcmXn4NHBpo/ERBIff5pSYe4OrIfnrV2GD+k5K694mJt5hQOSmSHJDmhLEz/mJVcm2IcbxzXz/iEszQgfiIm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3RvMLjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3RvMLjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B79C43394;
	Mon, 26 Feb 2024 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708986327;
	bh=SMrsfdMn8boULD5FEkfk0OLUCxS/acuRWaW09wgG7nY=;
	h=Date:To:From:Subject:From;
	b=T3RvMLjCwf5KPnjTM7Lve2nz9uRgSTxMnpwjN3xNslBpzEooHVYdQhCc+XAAuKO/5
	 2APXGRfwbjj9FBZHzLqXt6jB0moSSU1ND7f41P9h8sHX0augvf3k4jVPJJjhbF2+xG
	 30jMdMHA5Ve6c4lvU8rycGhttdhOLnBJyPM5SC4w=
Date: Mon, 26 Feb 2024 14:25:27 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch added to mm-unstable branch
Message-Id: <20240226222527.B6B79C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: use order instead of nr in split_page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/memcg: use order instead of nr in split_page_memcg()
Date: Mon, 26 Feb 2024 15:55:29 -0500

We do not have non power of two pages, using nr is error prone if nr is
not power-of-two.  Use page order instead.

Link: https://lkml.kernel.org/r/20240226205534.1603748-4-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/huge_memory.c           |    5 +++--
 mm/memcontrol.c            |    3 ++-
 mm/page_alloc.c            |    4 ++--
 4 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1163,7 +1163,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *head, unsigned int nr);
+void split_page_memcg(struct page *head, int order);
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
@@ -1621,7 +1621,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head, unsigned int nr)
+static inline void split_page_memcg(struct page *head, int order)
 {
 }
 
--- a/mm/huge_memory.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/huge_memory.c
@@ -2889,11 +2889,12 @@ static void __split_huge_page(struct pag
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
-	unsigned int nr = thp_nr_pages(head);
 	int i, nr_dropped = 0;
+	int order = folio_order(folio);
+	unsigned int nr = 1 << order;
 
 	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, nr);
+	split_page_memcg(head, order);
 
 	if (folio_test_anon(folio) && folio_test_swapcache(folio)) {
 		offset = swp_offset(folio->swap);
--- a/mm/memcontrol.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3606,11 +3606,12 @@ void obj_cgroup_uncharge(struct obj_cgro
 /*
  * Because page_memcg(head) is not set on tails, set it now.
  */
-void split_page_memcg(struct page *head, unsigned int nr)
+void split_page_memcg(struct page *head, int order)
 {
 	struct folio *folio = page_folio(head);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	int i;
+	unsigned int nr = 1 << order;
 
 	if (mem_cgroup_disabled() || !memcg)
 		return;
--- a/mm/page_alloc.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/page_alloc.c
@@ -2617,7 +2617,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
-	split_page_memcg(page, 1 << order);
+	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -4804,7 +4804,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, 1 << order);
-		split_page_memcg(page, 1 << order);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch
mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch

