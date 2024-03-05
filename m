Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A11FC09
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600545; cv=none; b=BtywQ6guYvCxHGDmal5Ot5NnFFigdqIjF/rNWuN7jBu2eiv/oUfGjiMAdV5xi8LfCm1Y90638uJZSe0BaTCIYeZX/NrqNhho+6ZvAYmeJB5DjG6U7uu14o/g255YtO2JrAPUf1ajLQy7xk8BBBTTxmw8sKSWZpJdIUD3y/LY8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600545; c=relaxed/simple;
	bh=N/m0di0bxw+EocwPu84vEPLXqNwH+rNraYV6djoxW88=;
	h=Date:To:From:Subject:Message-Id; b=B8MTYFl5vVO5JKsxIwObBgL6wuR4pLHrE+1jW6hKifHxQWqxeTPgHX7EWMDhT//yjGkcx/zbRooa93y01JwsLlvve9ZxJBP6M3teTcenoQIiS0bvuO+uqBLwg1pgvGvtN7LGqc3U6B3bzzPE5Ivd8zwjbCNeTtt29qMjFSo1k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhH3wjxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhH3wjxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC15CC433F1;
	Tue,  5 Mar 2024 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600544;
	bh=N/m0di0bxw+EocwPu84vEPLXqNwH+rNraYV6djoxW88=;
	h=Date:To:From:Subject:From;
	b=yhH3wjxditFlUvkdDEpoyvkFV0VDBmxTkVNvlDQSiBBxyFBAk6lFo/p466ma0zAmk
	 t88kDEOOlJBeJvX9lyos+wXYqBBCgF2fn4eyfTioYww9cQk2j2XGXGqUr0z6OP519b
	 PdWMofcKFWiUldTb89d+gW5z0dNNnKDHPINnqQZ8=
Date: Mon, 04 Mar 2024 17:02:24 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch removed from -mm tree
Message-Id: <20240305010224.AC15CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: use order instead of nr in split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 
@@ -4802,7 +4802,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, 1 << order);
-		split_page_memcg(page, 1 << order);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


