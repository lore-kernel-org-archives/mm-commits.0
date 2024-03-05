Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B41BFC09
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600548; cv=none; b=VCo4PN2F5Ha6aA9uDXgN58vRUYurRpuHtCxzGQ9bXcxOWouq16K3i6YNlQxcVagAkmROzAg+1BlPHVdgqWG+u9ffGqDO1b0Q5q9rGnkKkno8CklJtl+GLPuozXtxiVlpG4FicE02Zpxe5Q2UAtGAu8hmraIXiJMOjaxFFMjKRZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600548; c=relaxed/simple;
	bh=ebAa2nlWV8hRF5knnRFdxoK/V3rD65voUmVPCswFlcI=;
	h=Date:To:From:Subject:Message-Id; b=bL06oEdnsD6+u3jvHevn2HFbA75j9gJ8zXqDLMOhKfQT3gQwVos5g0LxeUHG8nhLApf6KMVPwATRMbVR2OGXOSl6whA87aobTSZIAQDQufCScCeKjoEMC32YSG3dWf8Dw9qsxzRDnelBh6tOWS9LtGyOo8Cfd4ysukuwYgZA1+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYiALdcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYiALdcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F331C433C7;
	Tue,  5 Mar 2024 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600548;
	bh=ebAa2nlWV8hRF5knnRFdxoK/V3rD65voUmVPCswFlcI=;
	h=Date:To:From:Subject:From;
	b=BYiALdcxlulTRnJds+IWrSbO9qWkkXPQspL3qqPKeu8hv/q90b6hzHvuOM5dTUHtB
	 ihvHyTEEmINUmKbBimWSlIS9+DODuHKL1Sds5IEbkFQ2LCFmEs/yfIX5WPLzBcQ0z7
	 ZASZIH44Cp1jM3V/v6uCV3h96ah4WSlRMUuaqIGA=
Date: Mon, 04 Mar 2024 17:02:27 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch removed from -mm tree
Message-Id: <20240305010228.1F331C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: make memcg huge page split support any order split
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: memcg: make memcg huge page split support any order split
Date: Mon, 26 Feb 2024 15:55:31 -0500

It sets memcg information for the pages after the split.  A new parameter
new_order is added to tell the order of subpages in the new page, always 0
for now.  It prepares for upcoming changes to support split huge page to
any lower order.

Link: https://lkml.kernel.org/r/20240226205534.1603748-6-zi.yan@sent.com
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
 mm/huge_memory.c           |    2 +-
 mm/memcontrol.c            |   11 ++++++-----
 mm/page_alloc.c            |    4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-make-memcg-huge-page-split-support-any-order-split
+++ a/include/linux/memcontrol.h
@@ -1163,7 +1163,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *head, int order);
+void split_page_memcg(struct page *head, int old_order, int new_order);
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
@@ -1621,7 +1621,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head, int order)
+static inline void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 }
 
--- a/mm/huge_memory.c~mm-memcg-make-memcg-huge-page-split-support-any-order-split
+++ a/mm/huge_memory.c
@@ -2894,7 +2894,7 @@ static void __split_huge_page(struct pag
 	unsigned int nr = 1 << order;
 
 	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, order);
+	split_page_memcg(head, order, 0);
 
 	if (folio_test_anon(folio) && folio_test_swapcache(folio)) {
 		offset = swp_offset(folio->swap);
--- a/mm/memcontrol.c~mm-memcg-make-memcg-huge-page-split-support-any-order-split
+++ a/mm/memcontrol.c
@@ -3606,23 +3606,24 @@ void obj_cgroup_uncharge(struct obj_cgro
 /*
  * Because page_memcg(head) is not set on tails, set it now.
  */
-void split_page_memcg(struct page *head, int order)
+void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 	struct folio *folio = page_folio(head);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	int i;
-	unsigned int nr = 1 << order;
+	unsigned int old_nr = 1 << old_order;
+	unsigned int new_nr = 1 << new_order;
 
 	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < nr; i++)
+	for (i = new_nr; i < old_nr; i += new_nr)
 		folio_page(folio, i)->memcg_data = folio->memcg_data;
 
 	if (folio_memcg_kmem(folio))
-		obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
+		obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
 	else
-		css_get_many(&memcg->css, nr - 1);
+		css_get_many(&memcg->css, old_nr / new_nr - 1);
 }
 
 #ifdef CONFIG_SWAP
--- a/mm/page_alloc.c~mm-memcg-make-memcg-huge-page-split-support-any-order-split
+++ a/mm/page_alloc.c
@@ -2617,7 +2617,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, order);
-	split_page_memcg(page, order);
+	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -4802,7 +4802,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, order);
-		split_page_memcg(page, order);
+		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


