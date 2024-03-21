Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615021386A6
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053868; cv=none; b=osp+EoEbk1CClkV38Jujh4dYt+uywvzG6rAq6AT4AnAFPLCJqSAjeCeOPeUH8m0f3qlGx6VvD+ZRfCf3KlGUkvtVbUIAdJm7b1E6RBTg2uUxg6dxQJld36wNl5qro34PtYILLmZPyqATLK5PzndKZZFlU9X7sWL6tZ8dDtDaJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053868; c=relaxed/simple;
	bh=v9ajee4zyuJBTtCF9mYlbb8jPlznMydiCc1JyaRXLkU=;
	h=Date:To:From:Subject:Message-Id; b=GUzSYte2axNrjAtix3B7UKVV9bNDy3nTWfwDI08i+osuf3XiUhcDsylaRq4I4FlEd8rN0/z3LffGEoqh7fIWOPjdVaW1zOM9NcB4ePS+Bes1mviGn2PbLOXzGoeZI0P3Lqx0Nb5u1yF9+ux9hgWuoIkL8NKPcZVHwmFWKM/uesU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MeTLa/ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MeTLa/ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D4EC433F1;
	Thu, 21 Mar 2024 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053868;
	bh=v9ajee4zyuJBTtCF9mYlbb8jPlznMydiCc1JyaRXLkU=;
	h=Date:To:From:Subject:From;
	b=MeTLa/ruB31WuJatvaKc4piLOp6jee04Kseji4TriJh82bpvZ4yG4ACkXN+M9J7I7
	 34PrZF9B8K17UWBv2RnS374/4I0SBLWWVe9Ei6FFURU3xB+/5kHjg8NdZmpZ7DFyab
	 01gOZudBvHQ110LIHt3s6P7F52DyWhUwsxXVAJe0=
Date: Thu, 21 Mar 2024 13:44:27 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch added to mm-unstable branch
Message-Id: <20240321204428.34D4EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: codetag: debug: mark codetags for reserved pages as empty
has been added to the -mm mm-unstable branch.  Its filename is
     codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch

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
Subject: codetag: debug: mark codetags for reserved pages as empty
Date: Thu, 21 Mar 2024 09:36:56 -0700

To avoid debug warnings while freeing reserved pages which were not
allocated with usual allocators, mark their codetags as empty before
freeing.

Link: https://lkml.kernel.org/r/20240321163705.3067592-35-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h   |    1 +
 include/linux/mm.h          |    9 +++++++++
 include/linux/pgalloc_tag.h |    2 ++
 mm/mm_init.c                |   12 +++++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~codetag-debug-mark-codetags-for-reserved-pages-as-empty
+++ a/include/linux/alloc_tag.h
@@ -46,6 +46,7 @@ static inline void set_codetag_empty(uni
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
+static inline void set_codetag_empty(union codetag_ref *ref) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
--- a/include/linux/mm.h~codetag-debug-mark-codetags-for-reserved-pages-as-empty
+++ a/include/linux/mm.h
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/bug.h>
 #include <linux/list.h>
 #include <linux/mmzone.h>
@@ -3132,6 +3133,14 @@ extern void reserve_bootmem_region(phys_
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void free_reserved_page(struct page *page)
 {
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
--- a/include/linux/pgalloc_tag.h~codetag-debug-mark-codetags-for-reserved-pages-as-empty
+++ a/include/linux/pgalloc_tag.h
@@ -120,6 +120,8 @@ static inline void pgalloc_tag_sub_pages
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
+static inline union codetag_ref *get_page_tag_ref(struct page *page) { return NULL; }
+static inline void put_page_tag_ref(union codetag_ref *ref) {}
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
--- a/mm/mm_init.c~codetag-debug-mark-codetags-for-reserved-pages-as-empty
+++ a/mm/mm_init.c
@@ -2510,7 +2510,6 @@ void *__init alloc_large_system_hash(con
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
-
 	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
 		int nid = early_pfn_to_nid(pfn);
 
@@ -2522,6 +2521,17 @@ void __init memblock_free_pages(struct p
 		/* KMSAN will take care of these pages. */
 		return;
 	}
+
+	/* pages were reserved and not allocated */
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
+
 	__free_pages_core(page, order);
 }
 
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

