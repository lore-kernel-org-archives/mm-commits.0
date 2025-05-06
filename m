Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CDC3507F0
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 00:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746493194; cv=none; b=f3wRAFuL5PHEuU09ckzHlD73yKHkJxmvMJKaFC3XpYtpP/fNSRJvaB0GNkVGGrXUMon/U/4LnELV0kw7JPw6t7ff43zQOA/m5FXgpLdrhpC8zYz2jMSfHyT+2r/XE6/oCpEJMBi3vbVljgaY1GeYtBjQ1Kqxq+h6Ommw1e2CiRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746493194; c=relaxed/simple;
	bh=iQ5g45mcROboevTkr1f3IEgB+qUuS2dKQqHHZtWZnKo=;
	h=Date:To:From:Subject:Message-Id; b=RGYiqslDt8lGIezwKRiZeyxBjLWb8yEVMaRwrOYjsxEL53juHN80uLL17HGBvqvmBJLANCdbydWozxTzOINfx/+zS/21OLa1PXyNM8uXooXEpL5BDVVVHkot4aPi66Dwq7MRSjUAY2mjoC1aEF13EdvPQJbBtCb+FdWJZ5RmBQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baXZ94/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baXZ94/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD64FC4CEEE;
	Tue,  6 May 2025 00:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746493193;
	bh=iQ5g45mcROboevTkr1f3IEgB+qUuS2dKQqHHZtWZnKo=;
	h=Date:To:From:Subject:From;
	b=baXZ94/N/3MQVt6bthg9qnVERnb8WdPtzsW0s7zx+5dFlXgneXJH/cT29jOjnwMna
	 z3lzv3L+jGOMSd+hLbK9yos16CtZqPedl/t66bxmJKKMjMlr1o7/O1Ej0z0AyI+4IJ
	 zj/b/3nTJCcRR5ipKOdyHK5svU3wn3E2afta3/kc=
Date: Mon, 05 May 2025 17:59:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250506005953.BD64FC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: move tag retrieval back upfront in __free_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Wang <00107082@163.com>
Subject: mm/codetag: move tag retrieval back upfront in __free_pages()
Date: Tue, 6 May 2025 03:30:34 +0800

Commit 51ff4d7486f0 ("mm: avoid extra mem_alloc_profiling_enabled()
 checks") introduces a possible use-after-free scenario, when page
is non-compound, page[0] could be released by other thread right
after put_page_testzero failed in current thread, pgalloc_tag_sub_pages
afterwards would manipulate an invalid page for accounting remaining
pages:

[timeline]   [thread1]                     [thread2]
  |          alloc_page non-compound
  V
  |                                        get_page, rf counter inc
  V
  |          in ___free_pages
  |          put_page_testzero fails
  V
  |                                        put_page, page released
  V
  |          in ___free_pages,
  |          pgalloc_tag_sub_pages
  |          manipulate an invalid page
  V

Restore __free_pages() to its state before, retrieve alloc tag
beforehand.

Link: https://lkml.kernel.org/r/20250505193034.91682-1-00107082@163.com
Fixes: 51ff4d7486f0 ("mm: avoid extra mem_alloc_profiling_enabled() checks")
Signed-off-by: David Wang <00107082@163.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |    8 ++++++++
 mm/page_alloc.c             |   15 ++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/include/linux/pgalloc_tag.h~mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages
+++ a/include/linux/pgalloc_tag.h
@@ -188,6 +188,13 @@ static inline struct alloc_tag *__pgallo
 	return tag;
 }
 
+static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
+{
+	if (mem_alloc_profiling_enabled())
+		return __pgalloc_tag_get(page);
+	return NULL;
+}
+
 void pgalloc_tag_split(struct folio *folio, int old_order, int new_order);
 void pgalloc_tag_swap(struct folio *new, struct folio *old);
 
@@ -199,6 +206,7 @@ static inline void clear_page_tag_ref(st
 static inline void alloc_tag_sec_init(void) {}
 static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order) {}
 static inline void pgalloc_tag_swap(struct folio *new, struct folio *old) {}
+static inline struct alloc_tag *pgalloc_tag_get(struct page *page) { return NULL; }
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/mm/page_alloc.c~mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages
+++ a/mm/page_alloc.c
@@ -1151,14 +1151,9 @@ static inline void pgalloc_tag_sub(struc
 		__pgalloc_tag_sub(page, nr);
 }
 
-static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr)
+/* When tag is not NULL, assuming mem_alloc_profiling_enabled */
+static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 {
-	struct alloc_tag *tag;
-
-	if (!mem_alloc_profiling_enabled())
-		return;
-
-	tag = __pgalloc_tag_get(page);
 	if (tag)
 		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
 }
@@ -1168,7 +1163,7 @@ static inline void pgalloc_tag_sub_pages
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
-static inline void pgalloc_tag_sub_pages(struct page *page, unsigned int nr) {}
+static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
@@ -5073,11 +5068,13 @@ static void ___free_pages(struct page *p
 {
 	/* get PageHead before we drop reference */
 	int head = PageHead(page);
+	/* get alloc tag in case the page is released by others */
+	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
 		__free_frozen_pages(page, order, fpi_flags);
 	else if (!head) {
-		pgalloc_tag_sub_pages(page, (1 << order) - 1);
+		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0)
 			__free_frozen_pages(page + (1 << order), order,
 					    fpi_flags);
_

Patches currently in -mm which might be from 00107082@163.com are

mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch

