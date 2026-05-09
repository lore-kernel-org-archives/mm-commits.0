Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789127478
	for <mm-commits@vger.kernel.org>; Sat,  9 May 2026 00:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778285464; cv=none; b=JLWNffh7XcPk1ISfoVDGkXztgPSVKDZReMiOIClxiwOSt0HHQzhREwm9cwo96JysSDglNIK2SE5x+ZdI8F32V+IlIat1NkWk7azC2STGQxx92ChskJ35S857r3acu2DcTnCodcxpdHKZSjIUDiQpIbAiUmtJ/zeCkBU1uotiHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778285464; c=relaxed/simple;
	bh=9EJ+hCE36Ny7ZHSI9/wuTmV8uPJF/j9FTIdNJu13GPY=;
	h=Date:To:From:Subject:Message-Id; b=ZI1LA13Dqg3OfOWOmqIrX6Ys3TJ7mTU6Z0ThxoaCBaXEatV7oXlmgSc0CL2MOwtgkfcMCnEzAqqqx/xZjAq7xYQfGygPwghnITcpYzF4mBZ3q3udjljsdm6fZWqsvOjJRRpRJi2TUshqVgh41nY6mT7DnnE9A4h98hZGxTgi8II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ITSrDQEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ITSrDQEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94498C2BCB0;
	Sat,  9 May 2026 00:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778285463;
	bh=9EJ+hCE36Ny7ZHSI9/wuTmV8uPJF/j9FTIdNJu13GPY=;
	h=Date:To:From:Subject:From;
	b=ITSrDQEbiU4aI7LHGY8K9GokVno6eUI3FITMGum9nrleMEdFt8O0gVK1LfsJOhWoF
	 xCSszgZ0Ib8lI9DldA0bhERi1fNTgDfNKiGmZjxQgjjdZgVwUh1AqDwYS43YbZCp/T
	 FIaAuVtB8dCiSeQFEZditJvheVYVe6BDXGWew5ZA=
Date: Fri, 08 May 2026 17:11:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,kent.overstreet@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch added to mm-new branch
Message-Id: <20260509001103.94498C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
has been added to the -mm mm-new branch.  Its filename is
     mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Wed, 6 May 2026 10:22:56 +0800

Pages allocated before page_ext is available have their codetag left
uninitialized.  Track these early PFNs and clear their codetag in
clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" warnings
when they are freed later.

Currently a fixed-size array of 8192 entries is used, with a warning if
the limit is exceeded.  However, the number of early allocations depends
on the number of CPUs and can be larger than 8192.

Replace the fixed-size array with a dynamically allocated linked list of
pfn_pool structs.  Each node is allocated via alloc_page() and mapped to a
pfn_pool containing a next pointer, an atomic slot counter, and a PFN
array that fills the remainder of the page.

The tracking pages themselves are allocated via alloc_page(), which would
trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
can skip recording allocations that carry this flag.

Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    4 
 lib/alloc_tag.c           |  145 +++++++++++++++++++++++-------------
 mm/page_alloc.c           |   12 +-
 3 files changed, 102 insertions(+), 59 deletions(-)

--- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/include/linux/alloc_tag.h
@@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
 {
 	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
 }
-void alloc_tag_add_early_pfn(unsigned long pfn);
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
 #else
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
-static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
+static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
 #endif
 
 /* Caller should verify both ref and tag to be valid */
--- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/lib/alloc_tag.c
@@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
  * their codetag uninitialized. Track these early PFNs so we can clear
  * their codetag refs later to avoid warnings when they are freed.
  *
- * Early allocations include:
- *   - Base allocations independent of CPU count
- *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
- *     such as trace ring buffers, scheduler per-cpu data)
- *
- * For simplicity, we fix the size to 8192.
- * If insufficient, a warning will be triggered to alert the user.
+ * Each page is cast to a pfn_pool: the first few bytes hold metadata
+ * (next pointer and slot count), the remainder stores PFNs.
+ */
+struct pfn_pool {
+	struct pfn_pool *next;
+	atomic_t count;
+	unsigned long pfns[];
+};
+
+#define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
+					 sizeof(unsigned long))
+
+/*
+ * Skip early PFN recording for a page allocation.  Reuses the
+ * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
+ * recursion when allocating pages for the early PFN tracking list
+ * itself.
  *
- * TODO: Replace fixed-size array with dynamic allocation using
- * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
+ * Codetags of the pages allocated with __GFP_NO_CODETAG should be
+ * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
+ * alloc_tag_sub_check() from triggering a warning.
  */
-#define EARLY_ALLOC_PFN_MAX		8192
+#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
 
-static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
-static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+static struct pfn_pool *current_pfn_pool __initdata;
 
-static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
-	int old_idx, new_idx;
+	struct pfn_pool *pool;
+	int idx;
 
 	do {
-		old_idx = atomic_read(&early_pfn_count);
-		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
-			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
-				      EARLY_ALLOC_PFN_MAX);
-			return;
+		pool = READ_ONCE(current_pfn_pool);
+		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
+			gfp_t gfp = gfp_flags & ~(__GFP_DIRECT_RECLAIM | GFP_ZONEMASK);
+			struct page *new_page = alloc_page(gfp | __GFP_NO_CODETAG);
+			struct pfn_pool *new;
+
+			if (!new_page) {
+				pr_warn_once("early PFN tracking page allocation failed\n");
+				return;
+			}
+			new = page_address(new_page);
+			new->next = pool;
+			atomic_set(&new->count, 0);
+			if (cmpxchg(&current_pfn_pool, pool, new) != pool) {
+				clear_page_tag_ref(new_page);
+				__free_page(new_page);
+				continue;
+			}
+			pool = new;
 		}
-		new_idx = old_idx + 1;
-	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+		idx = atomic_read(&pool->count);
+		if (idx >= PFN_POOL_SIZE)
+			continue;
+		if (atomic_cmpxchg(&pool->count, idx, idx + 1) == idx)
+			break;
+	} while (1);
 
-	early_pfns[old_idx] = pfn;
+	pool->pfns[idx] = pfn;
 }
 
-typedef void alloc_tag_add_func(unsigned long pfn);
+typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn)
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
 
+	/* Skip allocations for the tracking list itself to avoid recursion. */
+	if (gfp_flags & __GFP_NO_CODETAG)
+		return;
+
 	rcu_read_lock();
 	alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
 	if (alloc_tag_add)
-		alloc_tag_add(pfn);
+		alloc_tag_add(pfn, gfp_flags);
 	rcu_read_unlock();
 }
 
 static void __init clear_early_alloc_pfn_tag_refs(void)
 {
-	unsigned int i;
+	struct pfn_pool *pool, *next;
+	struct page *page;
+	int i;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
@@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
 	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
 	synchronize_rcu();
 
-	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
-		unsigned long pfn = early_pfns[i];
+	for (pool = current_pfn_pool; pool; pool = next) {
+		int nr_pfns = atomic_read(&pool->count);
+
+		for (i = 0; i < nr_pfns; i++) {
+			unsigned long pfn = pool->pfns[i];
 
-		if (pfn_valid(pfn)) {
-			struct page *page = pfn_to_page(pfn);
-			union pgtag_ref_handle handle;
-			union codetag_ref ref;
-
-			if (get_page_tag_ref(page, &ref, &handle)) {
-				/*
-				 * An early-allocated page could be freed and reallocated
-				 * after its page_ext is initialized but before we clear it.
-				 * In that case, it already has a valid tag set.
-				 * We should not overwrite that valid tag with CODETAG_EMPTY.
-				 *
-				 * Note: there is still a small race window between checking
-				 * ref.ct and calling set_codetag_empty(). We accept this
-				 * race as it's unlikely and the extra complexity of atomic
-				 * cmpxchg is not worth it for this debug-only code path.
-				 */
-				if (ref.ct) {
+			if (pfn_valid(pfn)) {
+				union pgtag_ref_handle handle;
+				union codetag_ref ref;
+
+				if (get_page_tag_ref(pfn_to_page(pfn), &ref, &handle)) {
+					/*
+					 * An early-allocated page could be freed and reallocated
+					 * after its page_ext is initialized but before we clear it.
+					 * In that case, it already has a valid tag set.
+					 * We should not overwrite that valid tag
+					 * with CODETAG_EMPTY.
+					 *
+					 * Note: there is still a small race window between checking
+					 * ref.ct and calling set_codetag_empty(). We accept this
+					 * race as it's unlikely and the extra complexity of atomic
+					 * cmpxchg is not worth it for this debug-only code path.
+					 */
+					if (ref.ct) {
+						put_page_tag_ref(handle);
+						continue;
+					}
+
+					set_codetag_empty(&ref);
+					update_page_tag_ref(handle, &ref);
 					put_page_tag_ref(handle);
-					continue;
 				}
-
-				set_codetag_empty(&ref);
-				update_page_tag_ref(handle, &ref);
-				put_page_tag_ref(handle);
 			}
 		}
 
+		next = pool->next;
+		page = virt_to_page(pool);
+		clear_page_tag_ref(page);
+		__free_page(page);
 	}
 }
 #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
--- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/mm/page_alloc.c
@@ -1237,7 +1237,7 @@ void __clear_page_tag_ref(struct page *p
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline
 void __pgalloc_tag_add(struct page *page, struct task_struct *task,
-		       unsigned int nr)
+		       unsigned int nr, gfp_t gfp_flags)
 {
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
@@ -1251,17 +1251,17 @@ void __pgalloc_tag_add(struct page *page
 		 * page_ext is not available yet, record the pfn so we can
 		 * clear the tag ref later when page_ext is initialized.
 		 */
-		alloc_tag_add_early_pfn(page_to_pfn(page));
+		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
 		if (task->alloc_tag)
 			alloc_tag_set_inaccurate(task->alloc_tag);
 	}
 }
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr)
+				   unsigned int nr, gfp_t gfp_flags)
 {
 	if (mem_alloc_profiling_enabled())
-		__pgalloc_tag_add(page, task, nr);
+		__pgalloc_tag_add(page, task, nr, gfp_flags);
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -1294,7 +1294,7 @@ static inline void pgalloc_tag_sub_pages
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
+				   unsigned int nr, gfp_t gfp_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
@@ -1857,7 +1857,7 @@ inline void post_alloc_hook(struct page
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order);
+	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch
mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch

