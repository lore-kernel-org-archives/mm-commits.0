Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA58B1CEE98
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729898818; cv=none; b=P9mjzLZxzgRuX1r41+L8+rcx4plf/7gTUORavAZJ/q+/nRzCGPEJGg7kpTLAtPn1o5V+vl5YOSIHm9gRcTr1GFdhIwFatSaN3eMY+qTXwc6h7inEavq4eQnGb7ogCOCzW69I6EJLsSFA7i5IW9ct8Q0WfVu3CXJXa79UJCaqbeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729898818; c=relaxed/simple;
	bh=vaE0SLAg8m1kVId/rJhGE3y169Ed8NEsdfNmRGE5Lkc=;
	h=Date:To:From:Subject:Message-Id; b=iJUPkepoxvyoIwBvcT8UiGHKh2px/IwQH/onyFc65nxIz4WSgwdLcptu1cr8SB3M/cWFp5HRXg7MMCvjMFXFBKQsomQrend95MbEGvorkwgeNfAWTQGLcTC5467tGPRcTs4XwkF5aKmBrwiixK1bvgBcvmtLVrIBS3Zrx2AoTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGXCgS9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGXCgS9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E09C4CEC3;
	Fri, 25 Oct 2024 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729898818;
	bh=vaE0SLAg8m1kVId/rJhGE3y169Ed8NEsdfNmRGE5Lkc=;
	h=Date:To:From:Subject:From;
	b=UGXCgS9H2JZoPMT+H8f5AhKTUwqBJbD85whw0BhGXyhp2VsNCK+9vlKmab4Qq5qjt
	 m1BNoOdEFWwKoH+cH21mEXsFwZJ/p9CPk5A1tjutl1uVcRFIDaC/RYThRRYyi7plSX
	 lA3YL8Z7S6lB38M/XsdeEgkoybAajaOyRokqEMyw=
Date: Fri, 25 Oct 2024 16:26:57 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,akpm@linux-foundation.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch added to mm-unstable branch
Message-Id: <20241025232658.40E09C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: uninline and move pgalloc_tag_copy and pgalloc_tag_split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h          |   58 ----------------------------------
 include/linux/pgalloc_tag.h |    5 ++
 lib/alloc_tag.c             |   48 ++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 58 deletions(-)

--- a/include/linux/mm.h~mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split
+++ a/include/linux/mm.h
@@ -4165,62 +4165,4 @@ static inline int do_mseal(unsigned long
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

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch
mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

