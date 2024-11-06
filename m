Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27C57DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854871; cv=none; b=pKZd0KfZmKKjKPIeOrCo3R58j7mngv1e+5cWcVpsmzrJUD+S9JLDb93f9tMMv+Kyo8ZvDRdAl4jy6xIHoTnK4INbffgNgTcTp3Thv+GyGmBAuB1AwxReOX+hMuZ1Pa57Dwrx1fcy+rk58XbkDKr6l320bPclnIIXudM1+VCeT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854871; c=relaxed/simple;
	bh=/TsR1f+VDjXYCPZ9Jxus/EQzssjGGmtnP7jxK18HC8k=;
	h=Date:To:From:Subject:Message-Id; b=UPeDB+YHNkq7c0W3uBI1myFBL8pFQtiZ61d6jUdGyDekhElezRqt8XY1MILNKfaR0L0mCbcbEiMx6i8GisDz3HoIO87hFZavfaJ/Ts4BKM/6vQlHa/UblYZAg3KaRfaDaCNak28Yg/PqfTfj12NNEOd6RRA663azdBgYhj+P38k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hNyNhBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hNyNhBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7420BC4CECF;
	Wed,  6 Nov 2024 01:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854871;
	bh=/TsR1f+VDjXYCPZ9Jxus/EQzssjGGmtnP7jxK18HC8k=;
	h=Date:To:From:Subject:From;
	b=0hNyNhBI18rvPeysjLKI+Zo5YClLUaPZa/n7Fe67K9Aq1aXgCHIE9IWvWSCpIvSLC
	 v5XfGlPJp9OHPW9iEQ2ySP8mDvBinuVRuDMbhE8SCn07YH1nfZLOq/HNY75GwB0cAr
	 a18Cznt/IIFxD+4d0YAh6+QZ8aEUtKpH2qST7yHY=
Date: Tue, 05 Nov 2024 17:01:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,akpm@linux-foundation.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch removed from -mm tree
Message-Id: <20241106010111.7420BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: uninline and move pgalloc_tag_copy and pgalloc_tag_split
has been removed from the -mm tree.  Its filename was
     mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/codetag: uninline and move pgalloc_tag_copy and pgalloc_tag_split
Date: Thu, 24 Oct 2024 09:23:18 -0700

pgalloc_tag_copy() and pgalloc_tag_split() are sizable and outside of any
performance-critical paths, so it should be fine to uninline them.  Also
move their declarations into pgalloc_tag.h which seems like a more
appropriate place for them.  No functional changes other than uninlining.

Link: https://lkml.kernel.org/r/20241024162318.1640781-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h          |   58 ----------------------------------
 include/linux/pgalloc_tag.h |    5 ++
 lib/alloc_tag.c             |   48 ++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 58 deletions(-)

--- a/include/linux/mm.h~mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split
+++ a/include/linux/mm.h
@@ -4166,62 +4166,4 @@ static inline int do_mseal(unsigned long
 }
 #endif
 
-#ifdef CONFIG_MEM_ALLOC_PROFILING
-static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
-{
-	int i;
-	struct alloc_tag *tag;
-	unsigned int nr_pages = 1 << new_order;
-
-	if (!mem_alloc_profiling_enabled())
-		return;
-
-	tag = pgalloc_tag_get(&folio->page);
-	if (!tag)
-		return;
-
-	for (i = nr_pages; i < (1 << old_order); i += nr_pages) {
-		union pgtag_ref_handle handle;
-		union codetag_ref ref;
-
-		if (get_page_tag_ref(folio_page(folio, i), &ref, &handle)) {
-			/* Set new reference to point to the original tag */
-			alloc_tag_ref_set(&ref, tag);
-			update_page_tag_ref(handle, &ref);
-			put_page_tag_ref(handle);
-		}
-	}
-}
-
-static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
-{
-	union pgtag_ref_handle handle;
-	union codetag_ref ref;
-	struct alloc_tag *tag;
-
-	tag = pgalloc_tag_get(&old->page);
-	if (!tag)
-		return;
-
-	if (!get_page_tag_ref(&new->page, &ref, &handle))
-		return;
-
-	/* Clear the old ref to the original allocation tag. */
-	clear_page_tag_ref(&old->page);
-	/* Decrement the counters of the tag on get_new_folio. */
-	alloc_tag_sub(&ref, folio_size(new));
-	__alloc_tag_ref_set(&ref, tag);
-	update_page_tag_ref(handle, &ref);
-	put_page_tag_ref(handle);
-}
-#else /* !CONFIG_MEM_ALLOC_PROFILING */
-static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
-{
-}
-
-static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
-{
-}
-#endif /* CONFIG_MEM_ALLOC_PROFILING */
-
 #endif /* _LINUX_MM_H */
--- a/include/linux/pgalloc_tag.h~mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split
+++ a/include/linux/pgalloc_tag.h
@@ -230,6 +230,9 @@ static inline void pgalloc_tag_sub_pages
 		this_cpu_sub(tag->counters->bytes, PAGE_SIZE * nr);
 }
 
+void pgalloc_tag_split(struct folio *folio, int old_order, int new_order);
+void pgalloc_tag_copy(struct folio *new, struct folio *old);
+
 void __init alloc_tag_sec_init(void);
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
@@ -241,6 +244,8 @@ static inline void pgalloc_tag_sub(struc
 static inline struct alloc_tag *pgalloc_tag_get(struct page *page) { return NULL; }
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 static inline void alloc_tag_sec_init(void) {}
+static inline void pgalloc_tag_split(struct folio *folio, int old_order, int new_order) {}
+static inline void pgalloc_tag_copy(struct folio *new, struct folio *old) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/lib/alloc_tag.c~mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split
+++ a/lib/alloc_tag.c
@@ -163,6 +163,54 @@ size_t alloc_tag_top_users(struct codeta
 	return nr;
 }
 
+void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
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
+		union pgtag_ref_handle handle;
+		union codetag_ref ref;
+
+		if (get_page_tag_ref(folio_page(folio, i), &ref, &handle)) {
+			/* Set new reference to point to the original tag */
+			alloc_tag_ref_set(&ref, tag);
+			update_page_tag_ref(handle, &ref);
+			put_page_tag_ref(handle);
+		}
+	}
+}
+
+void pgalloc_tag_copy(struct folio *new, struct folio *old)
+{
+	union pgtag_ref_handle handle;
+	union codetag_ref ref;
+	struct alloc_tag *tag;
+
+	tag = pgalloc_tag_get(&old->page);
+	if (!tag)
+		return;
+
+	if (!get_page_tag_ref(&new->page, &ref, &handle))
+		return;
+
+	/* Clear the old ref to the original allocation tag. */
+	clear_page_tag_ref(&old->page);
+	/* Decrement the counters of the tag on get_new_folio. */
+	alloc_tag_sub(&ref, folio_size(new));
+	__alloc_tag_ref_set(&ref, tag);
+	update_page_tag_ref(handle, &ref);
+	put_page_tag_ref(handle);
+}
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
_

Patches currently in -mm which might be from surenb@google.com are

mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

