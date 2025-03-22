Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B421012F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619831; cv=none; b=Yx/w8223rTq4iKsWttDH2txLWcjpNYDbaB4RVAWxUpcAnmUS119nsVFYSuthR8Md2UHBpwuN5XrZB/igebiqg26ZzxHl0ahcxlFJLId5Pxau0dLSqnimG7AeWfm30WxQBII2tJQlDto34kPn+oEdF8uk3ynXJ0H9bhzc2GEahtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619831; c=relaxed/simple;
	bh=nCMnhAddUhBT2m1uqebQs4gfXN7k1ZiattkPIkS0VH4=;
	h=Date:To:From:Subject:Message-Id; b=QKK7cGU7+KwN6dPuprrg0n4vcOuDk8nd00ubbJajZtvLnb5SR3vmk/sVGSw8fjPWE6pZWS3ay7KjxCIl3nFsgN4hIRo8+1Az3uZsv18LoWoYsPrjRUGqpCx9pPiRm5b9LsGZfKYznOXhelCBhs/abvDZi9vmhdA1gxkCOegQq3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PNJkNoRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PNJkNoRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78165C4CEDD;
	Sat, 22 Mar 2025 05:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619831;
	bh=nCMnhAddUhBT2m1uqebQs4gfXN7k1ZiattkPIkS0VH4=;
	h=Date:To:From:Subject:From;
	b=PNJkNoRaVI9q8p9nNq1f9H9Nzur6r7L+cvt7Apy3IamoTToUft3iGnSA1Bg/Qh/YS
	 T51KodFXC5pqf5QuSSrXgSVif8zOYEZVhS39jQLCMnhJav9+cePuieEF5r9BbJUFq3
	 FRRZTvnqLEudEkdGHgUVPWAOBP0bFFQUteYuk14M=
Date: Fri, 21 Mar 2025 22:03:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-split_page_memcg.patch removed from -mm tree
Message-Id: <20250322050351.78165C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-simplify-split_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify split_page_memcg()
Date: Fri, 14 Mar 2025 13:36:12 +0000

The last argument to split_page_memcg() is now always 0, so remove it,
effectively reverting commit b8791381d7ed.

Link: https://lkml.kernel.org/r/20250314133617.138071-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   15 +++++++--------
 mm/page_alloc.c            |    4 ++--
 3 files changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-simplify-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1038,7 +1038,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *head, int old_order, int new_order);
+void split_page_memcg(struct page *first, unsigned order);
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 		unsigned new_order);
 
@@ -1461,7 +1461,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head, int old_order, int new_order)
+static inline void split_page_memcg(struct page *first, unsigned order)
 {
 }
 
--- a/mm/memcontrol.c~mm-simplify-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3066,22 +3066,21 @@ void __memcg_slab_free_hook(struct kmem_
 }
 
 /*
- * Because folio_memcg(head) is not set on tails, set it now.
+ * The objcg is only set on the first page, so transfer it to all the
+ * other pages.
  */
-void split_page_memcg(struct page *head, int old_order, int new_order)
+void split_page_memcg(struct page *first, unsigned order)
 {
-	struct folio *folio = page_folio(head);
-	int i;
-	unsigned int old_nr = 1 << old_order;
-	unsigned int new_nr = 1 << new_order;
+	struct folio *folio = page_folio(first);
+	unsigned int i, nr = 1 << order;
 
 	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
 
-	for (i = new_nr; i < old_nr; i += new_nr)
+	for (i = 1; i < nr; i++)
 		folio_page(folio, i)->memcg_data = folio->memcg_data;
 
-	obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
+	obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
 }
 
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
--- a/mm/page_alloc.c~mm-simplify-split_page_memcg
+++ a/mm/page_alloc.c
@@ -2778,7 +2778,7 @@ void split_page(struct page *page, unsig
 		set_page_refcounted(page + i);
 	split_page_owner(page, order, 0);
 	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order, 0);
+	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -4992,7 +4992,7 @@ static void *make_alloc_exact(unsigned l
 
 		split_page_owner(page, order, 0);
 		pgalloc_tag_split(page_folio(page), order, 0);
-		split_page_memcg(page, order, 0);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from willy@infradead.org are


