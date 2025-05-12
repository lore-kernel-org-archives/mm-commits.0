Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B474040
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009614; cv=none; b=Kltyox1vPsk323xF/mR3PmFByIEmKsSMpYE5fGyywesEpvODMHf05MCeTHKQuIgcZAiFEzW3CMqIaEjgcdgfMwiRIESdNx8MzpcRUubuLN5W+i7nUimOsprxurhh1i7QVy/tU86AL2yIchxBpeJzwWUkkG6GLHKaxMPsWwygtT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009614; c=relaxed/simple;
	bh=vhDkEAQJznyF3tY8dq/skjt7tYN1qDhgHg33sEpumyA=;
	h=Date:To:From:Subject:Message-Id; b=BGYVGQP5kqYxkH0doY/gL2zGHLpiZQ5CGiCPOJAXv0vPqMRFotjitxv5OrhK0/ktz2LNysyzf84s9ipSclcS3draz735FUGse6G2DuSO2Cvdcl9qnBN0pATbj6fMuqicQmslnrCFtYN77d6BojAvQb008O3WEOoOfnyKltofzH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nahaMb4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nahaMb4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D156C4CEE4;
	Mon, 12 May 2025 00:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009613;
	bh=vhDkEAQJznyF3tY8dq/skjt7tYN1qDhgHg33sEpumyA=;
	h=Date:To:From:Subject:From;
	b=nahaMb4FhKo4EfowpPVsEe7Xe0s4a1ueHsQi7ysCwZsccQh2wOaoHyvSMrMV6Dfa6
	 SaQxyv7oAcp5qBxMDdzUMHS0ja+ABvbvmUpTXhEwPDRzw6i7/uRRLB20vz42tsYdvA
	 bcX21PeE0IgTY59INfQkcj8y7MCmhkYfPp2xLrMA=
Date: Sun, 11 May 2025 17:26:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch removed from -mm tree
Message-Id: <20250512002653.4D156C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: move tag retrieval back upfront in __free_pages()
has been removed from the -mm tree.  Its filename was
     mm-codetag-move-tag-retrieval-back-upfront-in-__free_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
 
@@ -5065,11 +5060,13 @@ static void ___free_pages(struct page *p
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


