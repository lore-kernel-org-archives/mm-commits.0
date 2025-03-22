Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6181312F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619830; cv=none; b=Ad3GyAuZGrfIf0czvYNBe216qPSkC9IZ19BiXbhQoEyInABVQTmNnKu745Bbi4uq+ggy5ky5DJ/lCFUglO22evtV+lxkfjnEIeOI6ML7VENcXhUO+ElOvmKjwbv++/IdqHltXj92MRYN6MSMF1fNP+ZjInhjGp2yeAa8Jljq3cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619830; c=relaxed/simple;
	bh=mkHV1B9ZOWewxYULoxMPrp7tR5PaYCFLrwxj3GHZ1oI=;
	h=Date:To:From:Subject:Message-Id; b=uF/qg0XvrtbAdGw3Cz0JhXA+gEJc+jxXI1tnQz5KELC8wxkUvMVYSbGri4X6g8ugETNaRHLhUvelK6AbvUtxXugZJWhew2YGyVmkPUojECcQFsyjnSrQcDN9K03mgZDDlMVXwwtgva2QzjGUkcdwf+v+a20GzTI3ukDRcpu728M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q2ff1Lyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q2ff1Lyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C136C4CEDD;
	Sat, 22 Mar 2025 05:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619830;
	bh=mkHV1B9ZOWewxYULoxMPrp7tR5PaYCFLrwxj3GHZ1oI=;
	h=Date:To:From:Subject:From;
	b=Q2ff1LylVSuN5HP9wxvXkr9ZAEd5ogHSSBT4KGQOFAtAcn3iGKF3ciRRVS9kCAACo
	 UZXvkoPwrXipuP+qfr0rhtkQPgRPBKt9/4LbGzgyBiva5sAbJ5LYDCL1c+2H2lyLkK
	 fKZ5BHVtUM63Bwql+di090bZwvCBV7wz+Mc+9Tqs=
Date: Fri, 21 Mar 2025 22:03:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch removed from -mm tree
Message-Id: <20250322050350.2C136C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: separate folio_split_memcg_refs() from split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: separate folio_split_memcg_refs() from split_page_memcg()
Date: Fri, 14 Mar 2025 13:36:11 +0000

Patch series "Minor memcg cleanups & prep for memdescs", v2.

Separate the handling of accounted folios and GFP_ACCOUNT pages for easier
to understand code.  For more detail, see
https://lore.kernel.org/linux-mm/Z9LwTOudOlCGny3f@casper.infradead.org/


This patch (of 5):

Folios always use memcg_data to refer to the mem_cgroup while pages
allocated with GFP_ACCOUNT have a pointer to the obj_cgroup.  Since the
caller already knows what it has, split the function into two and then we
don't need to check.

Move the assignment of split folio memcg_data to the point where we set up
the other parts of the new folio.  That leaves folio_split_memcg_refs()
just handling the memcg accounting.

Link: https://lkml.kernel.org/r/20250314133617.138071-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250314133617.138071-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/huge_memory.c           |   16 ++++------------
 mm/memcontrol.c            |   17 +++++++++++++----
 3 files changed, 24 insertions(+), 16 deletions(-)

--- a/include/linux/memcontrol.h~mm-separate-folio_split_memcg_refs-from-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1039,6 +1039,8 @@ static inline void memcg_memory_event_mm
 }
 
 void split_page_memcg(struct page *head, int old_order, int new_order);
+void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
+		unsigned new_order);
 
 static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 {
@@ -1463,6 +1465,11 @@ static inline void split_page_memcg(stru
 {
 }
 
+static inline void folio_split_memcg_refs(struct folio *folio,
+		unsigned old_order, unsigned new_order)
+{
+}
+
 static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 {
 	return 0;
--- a/mm/huge_memory.c~mm-separate-folio_split_memcg_refs-from-split_page_memcg
+++ a/mm/huge_memory.c
@@ -3394,6 +3394,9 @@ static void __split_folio_to_order(struc
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))
 			folio_set_idle(new_folio);
+#ifdef CONFIG_MEMCG
+		new_folio->memcg_data = folio->memcg_data;
+#endif
 
 		folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 	}
@@ -3525,18 +3528,7 @@ static int __split_unmapped_folio(struct
 			}
 		}
 
-		/*
-		 * Reset any memcg data overlay in the tail pages.
-		 * folio_nr_pages() is unreliable until prep_compound_page()
-		 * was called again.
-		 */
-#ifdef NR_PAGES_IN_LARGE_FOLIO
-		folio->_nr_pages = 0;
-#endif
-
-
-		/* complete memcg works before add pages to LRU */
-		split_page_memcg(&folio->page, old_order, split_order);
+		folio_split_memcg_refs(folio, old_order, split_order);
 		split_page_owner(&folio->page, old_order, split_order);
 		pgalloc_tag_split(folio, old_order, split_order);
 
--- a/mm/memcontrol.c~mm-separate-folio_split_memcg_refs-from-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3081,10 +3081,19 @@ void split_page_memcg(struct page *head,
 	for (i = new_nr; i < old_nr; i += new_nr)
 		folio_page(folio, i)->memcg_data = folio->memcg_data;
 
-	if (folio_memcg_kmem(folio))
-		obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
-	else
-		css_get_many(&folio_memcg(folio)->css, old_nr / new_nr - 1);
+	obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
+}
+
+void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
+		unsigned new_order)
+{
+	unsigned new_refs;
+
+	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
+		return;
+
+	new_refs = (1 << (old_order - new_order)) - 1;
+	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
_

Patches currently in -mm which might be from willy@infradead.org are


