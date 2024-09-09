Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C1118E34F;
	Mon,  9 Sep 2024 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925328; cv=none; b=KaM9YUGwSHJ/EwuR32FBiEp8KeXPPCMk5YN2eJnu6W5DE0Vfmv3O4HlAqT6fluPu3X2rSTCIvUgtPUKl1WDrAwGu5edJ/dmvoIMQC4hIGjGKfeBOmgFU7C/05mbGoLvd1lLyigVofcGRxZD6bJ2XQIxzRTpKep98lEtGttw4fkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925328; c=relaxed/simple;
	bh=vA5uwzkGoXQcnd6cgnG1EUTZSPqy4VTag6OXIdt5mx0=;
	h=Date:To:From:Subject:Message-Id; b=ZNIr+QZG+2ccUG2JnJjuh1wx3sEcjDTXIqFXj2qPpIgvy9HE2/mcL9cxXTrntRzrVfo1obe0jCn6E3N2ilNI0eI7kKsbJ2SwZd1ZAsp5F1pInAY6tglsFlLQiu3aRJpAaa6Fo5srhrcriz1Qj+j8XD//T4tPRvSHSkq/gqxgqpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9jH09XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9jH09XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C67C4CEC5;
	Mon,  9 Sep 2024 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925327;
	bh=vA5uwzkGoXQcnd6cgnG1EUTZSPqy4VTag6OXIdt5mx0=;
	h=Date:To:From:Subject:From;
	b=l9jH09XH21Kp1QzdZKjZNRJn16CU3dyOD0BZPyI76m+CdXLsCa57XdhnCwNgVu/BB
	 M/h5nNbv6yDd3kbE8K9d3snWRHMlLBXWYnfVyy6vjG7SOS3C1JTmMjpF8NF1gMzmXC
	 oGE6PfGmOyNyrZGVxyCnBkgvomBT0bTbX/sTlVhk=
Date: Mon, 09 Sep 2024 16:42:07 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-codetag-fix-pgalloc_tag_split.patch removed from -mm tree
Message-Id: <20240909234207.C4C67C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: fix pgalloc_tag_split()
has been removed from the -mm tree.  Its filename was
     mm-codetag-fix-pgalloc_tag_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/codetag: fix pgalloc_tag_split()
Date: Thu, 5 Sep 2024 22:21:07 -0600

The current assumption is that a large folio can only be split into
order-0 folios.  That is not the case for hugeTLB demotion, nor for THP
split: see commit c010d47f107f ("mm: thp: split huge page to any lower
order pages").

When a large folio is split into ones of a lower non-zero order, only the
new head pages should be tagged.  Tagging tail pages can cause imbalanced
"calls" counters, since only head pages are untagged by pgalloc_tag_sub()
and the "calls" counts on tail pages are leaked, e.g.,

  # echo 2048kB >/sys/kernel/mm/hugepages/hugepages-1048576kB/demote_size
  # echo 700 >/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
  # time echo 700 >/sys/kernel/mm/hugepages/hugepages-1048576kB/demote
  # echo 0 >/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
  # grep alloc_gigantic_folio /proc/allocinfo

Before this patch:
  0  549427200  mm/hugetlb.c:1549 func:alloc_gigantic_folio

  real  0m2.057s
  user  0m0.000s
  sys   0m2.051s

After this patch:
  0          0  mm/hugetlb.c:1549 func:alloc_gigantic_folio

  real  0m1.711s
  user  0m0.000s
  sys   0m1.704s

Not tagging tail pages also improves the splitting time, e.g., by about
15% when demoting 1GB hugeTLB folios to 2MB ones, as shown above.

Link: https://lkml.kernel.org/r/20240906042108.1150526-2-yuzhao@google.com
Fixes: be25d1d4e822 ("mm: create new codetag references during page splitting")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h          |   30 ++++++++++++++++++++++++++++++
 include/linux/pgalloc_tag.h |   31 -------------------------------
 mm/huge_memory.c            |    2 +-
 mm/hugetlb.c                |    2 +-
 mm/page_alloc.c             |    4 ++--
 5 files changed, 34 insertions(+), 35 deletions(-)

--- a/include/linux/mm.h~mm-codetag-fix-pgalloc_tag_split
+++ a/include/linux/mm.h
@@ -4084,4 +4084,34 @@ void vma_pgtable_walk_end(struct vm_area
 
 int reserve_mem_find_by_name(const char *name, phys_addr_t *start, phys_addr_t *size);
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
+{
+	int i;
+	struct alloc_tag *tag;
+	unsigned int nr_pages = 1 << new_order;
+
+	if (!mem_alloc_profiling_enabled())
+		return;
+
+	tag = pgalloc_tag_get(&folio->page);
+	if (!tag)
+		return;
+
+	for (i = nr_pages; i < (1 << old_order); i += nr_pages) {
+		union codetag_ref *ref = get_page_tag_ref(folio_page(folio, i));
+
+		if (ref) {
+			/* Set new reference to point to the original tag */
+			alloc_tag_ref_set(ref, tag);
+			put_page_tag_ref(ref);
+		}
+	}
+}
+#else /* !CONFIG_MEM_ALLOC_PROFILING */
+static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
+{
+}
+#endif /* CONFIG_MEM_ALLOC_PROFILING */
+
 #endif /* _LINUX_MM_H */
--- a/include/linux/pgalloc_tag.h~mm-codetag-fix-pgalloc_tag_split
+++ a/include/linux/pgalloc_tag.h
@@ -80,36 +80,6 @@ static inline void pgalloc_tag_sub(struc
 	}
 }
 
-static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
-{
-	int i;
-	struct page_ext *first_page_ext;
-	struct page_ext *page_ext;
-	union codetag_ref *ref;
-	struct alloc_tag *tag;
-
-	if (!mem_alloc_profiling_enabled())
-		return;
-
-	first_page_ext = page_ext = page_ext_get(page);
-	if (unlikely(!page_ext))
-		return;
-
-	ref = codetag_ref_from_page_ext(page_ext);
-	if (!ref->ct)
-		goto out;
-
-	tag = ct_to_alloc_tag(ref->ct);
-	page_ext = page_ext_next(page_ext);
-	for (i = 1; i < nr; i++) {
-		/* Set new reference to point to the original tag */
-		alloc_tag_ref_set(codetag_ref_from_page_ext(page_ext), tag);
-		page_ext = page_ext_next(page_ext);
-	}
-out:
-	page_ext_put(first_page_ext);
-}
-
 static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
 {
 	struct alloc_tag *tag = NULL;
@@ -142,7 +112,6 @@ static inline void clear_page_tag_ref(st
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
-static inline void pgalloc_tag_split(struct page *page, unsigned int nr) {}
 static inline struct alloc_tag *pgalloc_tag_get(struct page *page) { return NULL; }
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
--- a/mm/huge_memory.c~mm-codetag-fix-pgalloc_tag_split
+++ a/mm/huge_memory.c
@@ -3226,7 +3226,7 @@ static void __split_huge_page(struct pag
 	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, order, new_order);
-	pgalloc_tag_split(head, 1 << order);
+	pgalloc_tag_split(folio, order, new_order);
 
 	/* See comment in __split_huge_page_tail() */
 	if (folio_test_anon(folio)) {
--- a/mm/hugetlb.c~mm-codetag-fix-pgalloc_tag_split
+++ a/mm/hugetlb.c
@@ -3778,7 +3778,7 @@ static long demote_free_hugetlb_folios(s
 		list_del(&folio->lru);
 
 		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
-		pgalloc_tag_split(&folio->page, 1 <<  huge_page_order(src));
+		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
--- a/mm/page_alloc.c~mm-codetag-fix-pgalloc_tag_split
+++ a/mm/page_alloc.c
@@ -2776,7 +2776,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page, 1 << order);
+	pgalloc_tag_split(page_folio(page), order, 0);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4974,7 +4974,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, order, 0);
-		pgalloc_tag_split(page, 1 << order);
+		pgalloc_tag_split(page_folio(page), order, 0);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
_

Patches currently in -mm which might be from yuzhao@google.com are


