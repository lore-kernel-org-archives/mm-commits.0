Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548B3CDBD3
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746300; cv=none; b=NW5BS0GTwHb4yI6nDufKsAIBoXoNsgR7o+jbw18gVy3sbaA6d2SGJvub4g4yUjw0iN6OnRyD2w2NFzxnnYAaOc0M7fr5f1EIYJWGdG33H/OM69lw8JvXlWMxpcz8KFD0PUsT5xbNoOzVSfAd7L0yxTjwVwD9rQmT9KeGl8MLQnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746300; c=relaxed/simple;
	bh=ueRO+seJUPI7VBQVKogp8COjbmdpkKA0a9uDqu2gT1E=;
	h=Date:To:From:Subject:Message-Id; b=I4RKwIhfB/mRxCSEdjZVzkAmRipNK4kOW8HQnOpt0SuX5gHAYTT3dGH9A65LuMaQP+6ab2OXWZaF8aM00IAX8uivdzzrGIF4/cLXwMLTTX3mZW0k2stUjmXyyX7r/j/ao+SvVdln7MNSbPsvd1GqhkOxWc8QOoUdFdBiTt/LF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rddgaKaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rddgaKaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8831F000FF;
	Fri, 18 Sep 2026 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789746298;
	bh=AP+2MjRgToL8FC5osWbhf/V9jGHr8mk9hJcMw6HJlhE=;
	h=Date:To:From:Subject;
	b=rddgaKaznpsX16DNqMk00aoLSgnOdsZiS4FxyElctInMCX2M6sCXaaSDDKGMrtUem
	 I93KCpFziO/XmR2fCkdGGT38/CvC8GXqUDxXTCgW4zAwR3glUIcE8uT0FbF4Nw2IIt
	 mXrIkWPTimJFFFV8M4bBF63Z3WjU45yZ+gccp07w=
Date: Fri, 18 Sep 2026 08:44:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch added to mm-new branch
Message-Id: <20260918154458.2E8831F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: remove unnecessary inlines in function definitions
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove unnecessary inlines in function definitions
Date: Fri, 18 Sep 2026 08:33:13 -0700

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compiler
can make that decision by itself.  Cleanup these definitions.

No change in the resulting binary file size with gcc v15.2.0.  No
functional change intended.

Link: https://lore.kernel.org/20260918153318.758387-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions
+++ a/fs/proc/task_mmu.c
@@ -130,7 +130,8 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+#ifdef CONFIG_PROC_PAGE_MONITOR
+static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -139,8 +140,9 @@ static inline int lock_ctx_mm(struct pro
 
 	return ret;
 }
+#endif
 
-static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
@@ -177,8 +179,8 @@ static struct vm_area_struct *get_next_v
 	return vma;
 }
 
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
+static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
+		loff_t pos)
 {
 	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
 
@@ -194,7 +196,8 @@ static inline bool fallback_to_mmap_lock
 	return true;
 }
 
-static inline void drop_rcu(struct proc_maps_private *priv)
+#ifdef CONFIG_PROC_PAGE_MONITOR
+static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +205,7 @@ static inline void drop_rcu(struct proc_
 	rcu_read_unlock();
 }
 
-static inline void reacquire_rcu(struct proc_maps_private *priv)
+static void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -211,6 +214,7 @@ static inline void reacquire_rcu(struct
 	/* Reinitialize the iterator. */
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
+#endif
 
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {
@@ -1230,7 +1234,7 @@ static const struct mm_walk_ops smaps_sh
 	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1238,7 +1242,7 @@ get_smaps_walk_ops(struct proc_maps_priv
 	return &smaps_walk_vma_lock_ops;
 }
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1572,7 +1576,7 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
 
@@ -1588,8 +1592,8 @@ static inline bool pte_is_pinned(struct
 	return folio_maybe_dma_pinned(folio);
 }
 
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
+static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1620,7 +1624,7 @@ static inline void clear_soft_dirty(stru
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
@@ -1646,7 +1650,7 @@ static inline void clear_soft_dirty_pmd(
 	}
 }
 #else
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 }
@@ -1848,7 +1852,7 @@ struct pagemapread {
 
 #define PM_END_OF_BUFFER    1
 
-static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
+static pagemap_entry_t make_pme(u64 frame, u64 flags)
 {
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
@@ -3390,7 +3394,7 @@ static const struct mm_walk_ops show_num
 	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_show_numa_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-remove-unnecessary-helpers.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

