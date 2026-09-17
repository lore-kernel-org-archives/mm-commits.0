Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058764D795F
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662176; cv=none; b=g+jlQrRisuOZ5Y4hUNCd0puDnKFnl8y2MfR1Rn28EZUoYGpe8KygWeb0QhQVoTaDGVJ5RhRwaEaAaoTKxnlytnBBOSDQc4HHV2SHj5GpDlMsTvB0qIUlsZJpEd9rRIzbgHs7DmmGtfHKDRHQvO1u5rv0jWInhpHlb4HLC3S7pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662176; c=relaxed/simple;
	bh=PZCr9UnEMqe5hwao9/6t810zoNg+SRNbPl/dOFiu9No=;
	h=Date:To:From:Subject:Message-Id; b=rnpGr+t1bt75PP1rZMxRivm/NMqvNqUFTdSpKhI6WAg3bHihIeoITeIygcXDiA3R7ZleaFKLqO+HysaGlmiDQBtJCUb6PQGp5KEJ4cC5da5F4kgZw8hFkolSPdwkzydiFHeKjxHWovGkPViFSLQW03ySdPhlVbteztY+m/jRITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=06/+iF+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="06/+iF+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525BB1F00899;
	Thu, 17 Sep 2026 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662173;
	bh=Y9QYzVGP0AzAIvUP/b2AaRjXL7FNg+ZdT1H6jOZeJdY=;
	h=Date:To:From:Subject;
	b=06/+iF+zCcWbXjI/pBqbavCFB/CmSYozQbCCKIIILp1TtiiPsp23Dcq2tgFdbgHWl
	 wSRYNzfBP2ezFoz4Mi0N8nBdGIocVzULaDFJa6RXPQXDOVDklvfAj8SzUBvyf0n/Mn
	 ZeIA6BLo1EdW5BuDe5EbmDD2bxJHsEgb4DvsC25o=
Date: Thu, 17 Sep 2026 09:22:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch removed from -mm tree
Message-Id: <20260917162253.525BB1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: remove unnecessary inlines in function definitions
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove unnecessary inlines in function definitions
Date: Fri, 11 Sep 2026 12:41:40 -0700

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compile can
make that decision by itself.  Cleanup these definitions.

No change in the resulting binary file size with gcc v15.2.0.  No
functional change intended.

Link: https://lore.kernel.org/20260911194145.1781926-3-surenb@google.com
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

 fs/proc/task_mmu.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions
+++ a/fs/proc/task_mmu.c
@@ -130,7 +130,7 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct pro
 	return ret;
 }
 
-static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
@@ -177,8 +177,8 @@ static struct vm_area_struct *get_next_v
 	return vma;
 }
 
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
+static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
+		loff_t pos)
 {
 	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
 
@@ -194,7 +194,7 @@ static inline bool fallback_to_mmap_lock
 	return true;
 }
 
-static inline void drop_rcu(struct proc_maps_private *priv)
+static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +202,7 @@ static inline void drop_rcu(struct proc_
 	rcu_read_unlock();
 }
 
-static inline void reacquire_rcu(struct proc_maps_private *priv)
+static void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -1230,7 +1230,7 @@ static const struct mm_walk_ops smaps_sh
 	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1238,7 +1238,7 @@ get_smaps_walk_ops(struct proc_maps_priv
 	return &smaps_walk_vma_lock_ops;
 }
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1572,7 +1572,7 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
 
@@ -1588,8 +1588,8 @@ static inline bool pte_is_pinned(struct
 	return folio_maybe_dma_pinned(folio);
 }
 
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
+static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1620,7 +1620,7 @@ static inline void clear_soft_dirty(stru
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
@@ -1646,7 +1646,7 @@ static inline void clear_soft_dirty_pmd(
 	}
 }
 #else
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 }
@@ -1848,7 +1848,7 @@ struct pagemapread {
 
 #define PM_END_OF_BUFFER    1
 
-static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
+static pagemap_entry_t make_pme(u64 frame, u64 flags)
 {
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
@@ -3390,7 +3390,7 @@ static const struct mm_walk_ops show_num
 	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_show_numa_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

