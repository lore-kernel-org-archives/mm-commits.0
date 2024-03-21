Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC791350D6
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053828; cv=none; b=UXjhkJYhctX2te3TEWXck3k4CTsA8p5DFZ0+dcxJNZ+gwXYQY9RrCGJqr6axnd8nOacRPlkeFvLY/RYEe6uI84KEhw0ejXTPv/NzYEnzgeDbXKEHdJ7k0w553gTV0vNA4wsmTek0X57E3FnsF/xeBQ6Wpc65Om8bFHD5GjyfIUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053828; c=relaxed/simple;
	bh=vj7oj4fGjMVKNaZ3HfVN4oUa1Nj54R/ijltjaX+pIGM=;
	h=Date:To:From:Subject:Message-Id; b=ZhYM1hzBrZGcMs3RVTIZx6o3ElpQ2xJ6hkqx4DYOL2EtHWy2nrTJbeNADGdQcmD3Yf+FCG6Xl1Wkui9YPbk3wD4oaqzfPjDa/rPLmcYfo7LtEBLyFgg33ps5AtJAYztFmM7T5i6hBh7i1dDagDSbrChD5fFgdYEj3TKUF3m5Yco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNf0FSH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNf0FSH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A427C43390;
	Thu, 21 Mar 2024 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053827;
	bh=vj7oj4fGjMVKNaZ3HfVN4oUa1Nj54R/ijltjaX+pIGM=;
	h=Date:To:From:Subject:From;
	b=sNf0FSH1/l6c++vzQu6O4cor5T4FMpOE82ia0D2fOOjFOGLwZ3NomKaow3wd0w+/a
	 ai4nyN9BnjhbpLJRuqNJcOHA5vusoAKweJUByhQm1NxwjEcKEu/Zpj0GSTtk61eoU6
	 nzhI6g1gqzLy9EceIS1k+3pM/kdYViWat6+qiYK8=
Date: Thu, 21 Mar 2024 13:43:47 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-create-new-codetag-references-during-page-splitting.patch added to mm-unstable branch
Message-Id: <20240321204347.8A427C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: create new codetag references during page splitting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-create-new-codetag-references-during-page-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-create-new-codetag-references-during-page-splitting.patch

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
Cc: Kees Cook <keescook@chromium.org>
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
@@ -106,6 +106,15 @@ static inline void __alloc_tag_ref_set(u
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
@@ -2924,6 +2925,7 @@ static void __split_huge_page(struct pag
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

mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

