Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042111353FE
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053866; cv=none; b=ma4Ws3M/rSmhcKTNWceUEnJLz1206MNhO3dqDeeNHAKRvYaeQDZryr5+rbEVhgfWEW5fntCkWAhVNSBpX2kJfb28ZQrIgse5dUB8fxMYyHOzR4fAaKNxtzhomAv/WBYV8pDN0DvbX6oXFFiM4nhXbFnMWzuQ4y7YTdaKS1YVqr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053866; c=relaxed/simple;
	bh=4Hr6Wo48UugRQz/JcrZ0K8tWZl+tBfBKvX0CKfjL4RI=;
	h=Date:To:From:Subject:Message-Id; b=essmXVm2hAhsYlG/LEf/kRYI6z9d87DLU+O0VS9NvgLIho9wUh9tAh0v6VhjJz0HmO/UH2wEzncDyQvc3E5X4n1XtK3kJhMHTXBhvq7BT8xN2ooyxcDexktJxAign3tGE50OJcNnPNpirrvgfGjrzmSDXFCIB3gSCwTrgm8j3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PZwvtjzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PZwvtjzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9985C43390;
	Thu, 21 Mar 2024 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053865;
	bh=4Hr6Wo48UugRQz/JcrZ0K8tWZl+tBfBKvX0CKfjL4RI=;
	h=Date:To:From:Subject:From;
	b=PZwvtjzHSdNtdncSExO9WsmxTufPG7uHerwpYFrAd0Lfw34GJupwiZMhKD8nRlprs
	 RWKictVsQZUsBz1cO96qfvoQiC0DU+LRe5Ux7MZB7j/cDcGgY1/apk8QX11tqdS/4h
	 A2SNh3EFcXQZVvYT1s2EQOXqKOS9AjEnFS7FugHU=
Date: Thu, 21 Mar 2024 13:44:25 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch added to mm-unstable branch
Message-Id: <20240321204425.C9985C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: codetag: debug: skip objext checking when it's for objext itself
has been added to the -mm mm-unstable branch.  Its filename is
     codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch

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
Subject: codetag: debug: skip objext checking when it's for objext itself
Date: Thu, 21 Mar 2024 09:36:55 -0700

objext objects are created with __GFP_NO_OBJ_EXT flag and therefore have
no corresponding objext themselves (otherwise we would get an infinite
recursion). When freeing these objects their codetag will be empty and
when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled this will lead to false
warnings. Introduce CODETAG_EMPTY special codetag value to mark
allocations which intentionally lack codetag to avoid these warnings.
Set objext codetags to CODETAG_EMPTY before freeing to indicate that
the codetag is expected to be empty.

Link: https://lkml.kernel.org/r/20240321163705.3067592-34-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   26 ++++++++++++++++++++++++++
 mm/slub.c                 |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

--- a/include/linux/alloc_tag.h~codetag-debug-skip-objext-checking-when-its-for-objext-itself
+++ a/include/linux/alloc_tag.h
@@ -28,6 +28,27 @@ struct alloc_tag {
 	struct alloc_tag_counters __percpu	*counters;
 } __aligned(8);
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+
+#define CODETAG_EMPTY	((void *)1)
+
+static inline bool is_codetag_empty(union codetag_ref *ref)
+{
+	return ref->ct == CODETAG_EMPTY;
+}
+
+static inline void set_codetag_empty(union codetag_ref *ref)
+{
+	if (ref)
+		ref->ct = CODETAG_EMPTY;
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
+static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
 struct codetag_bytes {
@@ -140,6 +161,11 @@ static inline void alloc_tag_sub(union c
 	if (!ref || !ref->ct)
 		return;
 
+	if (is_codetag_empty(ref)) {
+		ref->ct = NULL;
+		return;
+	}
+
 	tag = ct_to_alloc_tag(ref->ct);
 
 	this_cpu_sub(tag->counters->bytes, bytes);
--- a/mm/slub.c~codetag-debug-skip-objext-checking-when-its-for-objext-itself
+++ a/mm/slub.c
@@ -1873,6 +1873,30 @@ static inline enum node_stat_item cache_
 
 #ifdef CONFIG_SLAB_OBJ_EXT
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+
+static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
+{
+	struct slabobj_ext *slab_exts;
+	struct slab *obj_exts_slab;
+
+	obj_exts_slab = virt_to_slab(obj_exts);
+	slab_exts = slab_obj_exts(obj_exts_slab);
+	if (slab_exts) {
+		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
+						 obj_exts_slab, obj_exts);
+		/* codetag should be NULL */
+		WARN_ON(slab_exts[offs].ref.ct);
+		set_codetag_empty(&slab_exts[offs].ref);
+	}
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
+static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 /*
  * The allocated objcg pointers array is not accounted directly.
  * Moreover, it should not come from DMA buffer and is not readily
@@ -1913,6 +1937,7 @@ static int alloc_slab_obj_exts(struct sl
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
+		mark_objexts_empty(vec);
 		kfree(vec);
 		return 0;
 	}
@@ -1929,6 +1954,14 @@ static inline void free_slab_obj_exts(st
 	if (!obj_exts)
 		return;
 
+	/*
+	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
+	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
+	 * warning if slab has extensions but the extension of an object is
+	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
+	 * the extension for obj_exts is expected to be NULL.
+	 */
+	mark_objexts_empty(obj_exts);
 	kfree(obj_exts);
 	slab->obj_exts = 0;
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

