Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03431B813;
	Sun,  8 Sep 2024 03:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725765519; cv=none; b=VUc2LltbLlJT65gj7Wyawdgt2U+hxtiLYPHJrQPyh2WFubOCUG6P7EFNQNHmvWxm6bgMwrs+iAmNyZb5ps9d7NwhKnIybGxyfQHznlKkfO4Iy04nXpJBtGY4jsptWylnsmpGDI/gFsbrFGfZLwuSTFkJMyd4FVYQW+zPwo/bYAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725765519; c=relaxed/simple;
	bh=iEdRwVarYvvWd/IqB67Bhti1Tdv/iFdcnwfQu76hpOI=;
	h=Date:To:From:Subject:Message-Id; b=SiwJy0thRyZNEi7/v2Fbe8+97vt0EXDaLO39iVBlgMy63cFpzU+rzXnJcxm93IJkYFgkjryCylLvrMDTzJFb2ErxF2jGuhJBcbssebwOe7RTT4izSye3z/tjmG3mfYWp9w4ZP6fU98Z9A+nteSxu8eOa7v397MxkhSg9kNSF4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1J7Chgsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1J7Chgsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12546C4CEC4;
	Sun,  8 Sep 2024 03:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725765519;
	bh=iEdRwVarYvvWd/IqB67Bhti1Tdv/iFdcnwfQu76hpOI=;
	h=Date:To:From:Subject:From;
	b=1J7ChgsqhQl0xC0v6WVYvhlzFr7aR7bXNl7VGnNcarce7YSWTWltC5H2c5laMCk3W
	 eGkMeHyCMrK9WzwdD/SUUTHzFkPNJ57HVEpZZ15Z1PPtfRneoaLtNjNVITKrWC70vq
	 VN0VmZwa1H4YHZ8zDEQ9Zfxx36RMSBYTdAMdLi/c=
Date: Sat, 07 Sep 2024 20:18:38 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-fix-pgalloc_tag_split.patch added to mm-unstable branch
Message-Id: <20240908031839.12546C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: fix pgalloc_tag_split()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-fix-pgalloc_tag_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-fix-pgalloc_tag_split.patch

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
Cc: <stable@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
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
@@ -4137,4 +4137,34 @@ void vma_pgtable_walk_end(struct vm_area
 
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
@@ -3242,7 +3242,7 @@ static void __split_huge_page(struct pag
 	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, order, new_order);
-	pgalloc_tag_split(head, 1 << order);
+	pgalloc_tag_split(folio, order, new_order);
 
 	/* See comment in __split_huge_page_tail() */
 	if (folio_test_anon(folio)) {
--- a/mm/hugetlb.c~mm-codetag-fix-pgalloc_tag_split
+++ a/mm/hugetlb.c
@@ -3795,7 +3795,7 @@ static long demote_free_hugetlb_folios(s
 		list_del(&folio->lru);
 
 		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
-		pgalloc_tag_split(&folio->page, 1 <<  huge_page_order(src));
+		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
--- a/mm/page_alloc.c~mm-codetag-fix-pgalloc_tag_split
+++ a/mm/page_alloc.c
@@ -2783,7 +2783,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page, 1 << order);
+	pgalloc_tag_split(page_folio(page), order, 0);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4981,7 +4981,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, order, 0);
-		pgalloc_tag_split(page, 1 << order);
+		pgalloc_tag_split(page_folio(page), order, 0);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch
mm-codetag-fix-a-typo.patch
mm-codetag-fix-pgalloc_tag_split.patch
mm-codetag-add-pgalloc_tag_copy.patch

