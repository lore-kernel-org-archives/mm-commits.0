Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF247BB0F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103926; cv=none; b=TMvLgRkNQDBZoxmsXmKdRL5xboe3j3aVebn/ZZexSvy5N18oiKhUErepfhLCUKwzEUTRWo/PsE2vY8LoQL0cH23Up8TsKNEwW8MEI63g6DW1lmZlBzWOCHhoBddE5+irJjKZ7gj0PtBOpdcNyzN/1XLeI2iZbjwzN5FK0wtIaiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103926; c=relaxed/simple;
	bh=t76f0aQ3XI2tnPxnRloOuBIXN59wJStr6GbdLsBw8Gg=;
	h=Date:To:From:Subject:Message-Id; b=l/Q4wprtICL//XMadyNj0HcnMXH5BPr3F0H8mPSJ3aF5tGAIfma348J6rLJN9X9YMax2wQd91yc2jeCd9iJNHV1kGBEor+3je0k84emrk1wbwfX+rPJ6hN8owdlt1ves8WhY+c8o5Jd9U63ARvKcbI07CBv5E19QZaPv8jsHiIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CqLZfhaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CqLZfhaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83B4C113CD;
	Fri, 26 Apr 2024 03:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103926;
	bh=t76f0aQ3XI2tnPxnRloOuBIXN59wJStr6GbdLsBw8Gg=;
	h=Date:To:From:Subject:From;
	b=CqLZfhaEO/aJvWumw4NJtnxAMZF3WsY00vsYz0EZOr0QqjqO6GwCYl/jhT1bg60jR
	 gd61CS9I4HnkyEhk4ZkDcnUeF06PUA8hwycShPOvij6IW8pj2DsOshsPEEPrNdZD3A
	 UUJ5owR3AFwtHBUlZ8grwZGQ+RtKjQAEoroJC6ek=
Date: Thu, 25 Apr 2024 20:58:45 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch removed from -mm tree
Message-Id: <20240426035845.E83B4C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: codetag: debug: mark codetags for reserved pages as empty
has been removed from the -mm tree.  Its filename was
     codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -47,6 +47,7 @@ static inline void set_codetag_empty(uni
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
@@ -3134,6 +3135,14 @@ extern void reserve_bootmem_region(phys_
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
@@ -2567,7 +2567,6 @@ void __init set_dma_reserve(unsigned lon
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
-
 	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
 		int nid = early_pfn_to_nid(pfn);
 
@@ -2579,6 +2578,17 @@ void __init memblock_free_pages(struct p
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

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

