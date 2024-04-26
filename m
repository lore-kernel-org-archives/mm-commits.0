Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C227A140
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103903; cv=none; b=iQDWRiJzFHmCKJGiI8/ucDWIkWDg0haBVmqqWJVco4iYp7x7CAig5sAFmnXPi1huaqxbf4fIYIEO9ho8DiCu2Pqtjdg/rYxkAnfjXx0iI+34Rxxh5p0kH82oHlq6ywxq8gxCbe0AKoPFgUmF7ppXCL49D+WcI4CPGRNdUePkA/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103903; c=relaxed/simple;
	bh=OMOt4JbizltKyQcVT259ww9IM0DGWCaF3PZ0Y6s67YE=;
	h=Date:To:From:Subject:Message-Id; b=qQvBq9WUjzy3lLe5IT5008A56tRUPv/L2RusEXmyoNBF11qeorjcfWQTNl/a2lBKMi1eVTpRjyofHSRmBVdrTrKBsmX3SZdeClVBA0wRH7+xO48Q5FMiqfHzZD6G+UugjeKB+ZWw/ed6DuEd57cC1fWj4M2R7ru/ND4dr3cJzDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZnzFteyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZnzFteyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC52EC113CD;
	Fri, 26 Apr 2024 03:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103903;
	bh=OMOt4JbizltKyQcVT259ww9IM0DGWCaF3PZ0Y6s67YE=;
	h=Date:To:From:Subject:From;
	b=ZnzFteyTk8C7Yb55+9AKo+VrBl4TgEuRAIyXaFELku8dMBwawfBI6PpVKiP0vgooC
	 +PcCz3a0GUsgvgE2gG6S6ME79pgY0TXriJpaqrglww7FcB27+rFLlAPd1/wlgHVqlV
	 0o0FAZwodcXlOp8aK1VbO1nW6I0SiR2uZyYjiycE=
Date: Thu, 25 Apr 2024 20:58:22 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-create-new-codetag-references-during-page-splitting.patch removed from -mm tree
Message-Id: <20240426035822.EC52EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: create new codetag references during page splitting
has been removed from the -mm tree.  Its filename was
     mm-create-new-codetag-references-during-page-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: create new codetag references during page splitting
Date: Thu, 21 Mar 2024 09:36:41 -0700

When a high-order page is split into smaller ones, each newly split page
should get its codetag.  After the split each split page will be
referencing the original codetag.  The codetag's "bytes" counter remains
the same because the amount of allocated memory has not changed, however
the "calls" counter gets increased to keep the counter correct when these
individual pages get freed.

Link: https://lkml.kernel.org/r/20240321163705.3067592-20-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h   |    9 +++++++++
 include/linux/pgalloc_tag.h |   30 ++++++++++++++++++++++++++++++
 mm/huge_memory.c            |    2 ++
 mm/page_alloc.c             |    2 ++
 4 files changed, 43 insertions(+)

--- a/include/linux/alloc_tag.h~mm-create-new-codetag-references-during-page-splitting
+++ a/include/linux/alloc_tag.h
@@ -117,6 +117,15 @@ static inline void __alloc_tag_ref_set(u
 	this_cpu_inc(tag->counters->calls);
 }
 
+static inline void alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *tag)
+{
+	alloc_tag_add_check(ref, tag);
+	if (!ref || !tag)
+		return;
+
+	__alloc_tag_ref_set(ref, tag);
+}
+
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
 {
 	alloc_tag_add_check(ref, tag);
--- a/include/linux/pgalloc_tag.h~mm-create-new-codetag-references-during-page-splitting
+++ a/include/linux/pgalloc_tag.h
@@ -67,11 +67,41 @@ static inline void pgalloc_tag_sub(struc
 	}
 }
 
+static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
+{
+	int i;
+	struct page_ext *page_ext;
+	union codetag_ref *ref;
+	struct alloc_tag *tag;
+
+	if (!mem_alloc_profiling_enabled())
+		return;
+
+	page_ext = page_ext_get(page);
+	if (unlikely(!page_ext))
+		return;
+
+	ref = codetag_ref_from_page_ext(page_ext);
+	if (!ref->ct)
+		goto out;
+
+	tag = ct_to_alloc_tag(ref->ct);
+	page_ext = page_ext_next(page_ext);
+	for (i = 1; i < nr; i++) {
+		/* Set new reference to point to the original tag */
+		alloc_tag_ref_set(codetag_ref_from_page_ext(page_ext), tag);
+		page_ext = page_ext_next(page_ext);
+	}
+out:
+	page_ext_put(page_ext);
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
+static inline void pgalloc_tag_split(struct page *page, unsigned int nr) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/mm/huge_memory.c~mm-create-new-codetag-references-during-page-splitting
+++ a/mm/huge_memory.c
@@ -38,6 +38,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/compat.h>
+#include <linux/pgalloc_tag.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2946,6 +2947,7 @@ static void __split_huge_page(struct pag
 	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, order, new_order);
+	pgalloc_tag_split(head, 1 << order);
 
 	/* See comment in __split_huge_page_tail() */
 	if (folio_test_anon(folio)) {
--- a/mm/page_alloc.c~mm-create-new-codetag-references-during-page-splitting
+++ a/mm/page_alloc.c
@@ -2630,6 +2630,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, order, 0);
+	pgalloc_tag_split(page, 1 << order);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4827,6 +4828,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, order, 0);
+		pgalloc_tag_split(page, 1 << order);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

