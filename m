Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFAE484222
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865993; cv=none; b=N1M0Ga6aUBWyZsuOB7zMy7JbEQQ0D13Z4nHrON+v38aj0Qd7p1VY6tBjP/hklHKuMq33oa/cimv4ktrNg3WYEMmCFMmGXulFoAdeeaBuBsNj754NERyBItOheUUBxfAC7c/48buFVf4FffkfTMiy+eQbWs8G0nvZ1/DiJihwS6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865993; c=relaxed/simple;
	bh=eh8h7zUJcVL1EH0COInWw8I1J/2rBWgEz4OA+i7OB74=;
	h=Date:To:From:Subject:Message-Id; b=YH95XwLSAGW+Rmm5d4kpmpkHfpipZoVgskF+2iQ3N5538EfkeextudodhRX4wwqZGpqzidoy1ozV3q+88IO72pVRLfpMZyVarH/0eHkLJMqzogPD7+9PJXw1RBg1hI0KrzLRWYchkteNgZGNN1Dp1Qj+NdD+gMGH2Kot6l7h4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0tsCFqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0tsCFqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66621F00893;
	Tue, 13 Oct 2026 04:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865991;
	bh=PHWftHkeb8OV5xSK2sC+PCCg6ssOqpiidIB+tOiOs/Q=;
	h=Date:To:From:Subject;
	b=n0tsCFqTyfeNFls0uAwkE1/MQO/6jBekm/UFgvgbAEGnCBasG7I3DCBtVDH+RcxLX
	 Xd2eeQvwVw+I4PVrY3aE09HWYAoaWjcsI1ulMSqYf+LFluiqh8y9VYC+y7Nj+ytDDr
	 +9t1fTI4r9bupv5/jcNayRgj8z4SRGjIk8aoNFRQ=
Date: Mon, 12 Oct 2026 21:33:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch removed from -mm tree
Message-Id: <20261013043311.A66621F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: remove unnecessary inlines in function definitions
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove unnecessary inlines in function definitions
Date: Fri, 18 Sep 2026 08:33:13 -0700

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compiler
can make that decision by itself.  Cleanup these definitions.

No change in the resulting binary file size with gcc v15.2.0.  No
functional change intended.

[akpm@linux-foundation.org: fix CONFIG_NUMA=y && CONFIG_PROC_PAGE_MONITOR=n]
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
+#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
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


