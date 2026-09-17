Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5654F96DA
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662174; cv=none; b=iSK4Nn1IQwK3yQZxFour5o2JEOW+mES+9aKM0ULHMkmsxhsz+icAZt2Qsx2MBj8QYxmNwZ7cR/b4IRM9SGAKyMFEbU83vPvnIpkw9K3xpcl9INpOTprhmEqyiTIe+bBDM4pc16XkOD3+utM/BP3IUbwT7uJS8qxA3C9cpzElxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662174; c=relaxed/simple;
	bh=R44IC1qDH6NDbHXMOX4aSDtlIMm/SKt5GxET1WNJL0M=;
	h=Date:To:From:Subject:Message-Id; b=lENpre3d/LfEP3vhjmqNxzBtTcPtZHNDpeIS9hH8uXF+vHqLhs0Wc4pf+kLdpwj8nCM02PihQxdV5Ga0BAoEjhIiF3H/l8MYEg9jwyRobPOMliXldPKfJ+Qvwbiin/4yOZUVYz6MHTxLUklH+1qlnAQGa/GeymMCl6rY0Dz/kvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHYJpl4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHYJpl4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C131F00898;
	Thu, 17 Sep 2026 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662172;
	bh=hWXlfIKdMRo6scyuoN5MjtFCNKcXpDlVOoXmvGnkOS8=;
	h=Date:To:From:Subject;
	b=eHYJpl4AH2dv8zvkUe5AmNhgTbBzwNuUit/CMubPOVzdL/medAW51WD4XiZgtZcz4
	 LZ34Dyrwp2B/zg60qUBDtDsIxhILJoTWwPxBG2mvS4w6oWVDZUAJQufozIgNIhHEtx
	 tI75yEgiiePjxTIPUpySwAQMrHocjcAlLvq4GQxQ=
Date: Thu, 17 Sep 2026 09:22:51 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-remove-unnecessary-helpers.patch removed from -mm tree
Message-Id: <20260917162252.30C131F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: remove unnecessary helpers
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-helpers.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove unnecessary helpers
Date: Fri, 11 Sep 2026 12:41:39 -0700

Patch series "read proc/pid/smaps_rollup under per-vma lock", v4.

proc/pid/smaps_rollup can be read using the combination of RCU and VMA
read locks, similar to proc/pid/{maps|smaps|numa_maps}.  RCU is required
to safely traverse the VMA tree and VMA lock stabilizes the VMA being
processed and the pagetable walk.  Note that we have to keep the logic to
drop mmap_lock on contention because even when using per-VMA locks we
might have to fall back to holding the mmap_lock.

The first 5 patches are cleanups making later change simpler.  The main
change is in patch 6.  Patch 7 extends existing proc-maps-race tearing
test to verify smaps_rollup content.


This patch (of 7):

When per-vma locks were behind a config option, a number of helper
functions were needed to simplify the locking code.  Now that these locks
are universally available, we can do a little cleanup.  Remove
lock_vma_range(), unlock_vma_range(), query_vma_setup(),
query_vma_teardown() helpers.

No functional change intended.

Link: https://lore.kernel.org/20260911194145.1781926-1-surenb@google.com
Link: https://lore.kernel.org/20260911194145.1781926-2-surenb@google.com
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

 fs/proc/task_mmu.c |   67 ++++++++++---------------------------------
 1 file changed, 17 insertions(+), 50 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-helpers
+++ a/fs/proc/task_mmu.c
@@ -160,25 +160,6 @@ static void unlock_ctx_vma(struct proc_m
 	}
 }
 
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
-{
-	rcu_read_lock();
-	reset_lock_ctx(lock_ctx);
-
-	return true;
-}
-
-static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked) {
-		unlock_ctx_mm(lock_ctx);
-	} else {
-		unlock_ctx_vma(lock_ctx);
-		rcu_read_unlock();
-	}
-}
-
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
@@ -286,13 +267,8 @@ static void *m_start(struct seq_file *m,
 		return NULL;
 	}
 
-	if (!lock_vma_range(m, lock_ctx)) {
-		mmput(mm);
-		put_task_struct(priv->task);
-		priv->task = NULL;
-		return ERR_PTR(-EINTR);
-	}
-
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 	/*
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
@@ -325,7 +301,12 @@ static void m_stop(struct seq_file *m, v
 		return;
 
 	release_task_mempolicy(priv);
-	unlock_vma_range(&priv->lock_ctx);
+	if (priv->lock_ctx.mmap_locked) {
+		unlock_ctx_mm(&priv->lock_ctx);
+	} else {
+		unlock_ctx_vma(&priv->lock_ctx);
+		rcu_read_unlock();
+	}
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -518,21 +499,6 @@ static int pid_maps_open(struct inode *i
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
-{
-	reset_lock_ctx(lock_ctx);
-
-	return 0;
-}
-
-static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked)
-		unlock_ctx_mm(lock_ctx);
-	else
-		unlock_ctx_vma(lock_ctx);
-}
-
 static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
 						     unsigned long addr)
 {
@@ -653,12 +619,7 @@ static int do_procmap_query(struct mm_st
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(&lock_ctx);
-	if (err) {
-		mmput(mm);
-		return err;
-	}
-
+	reset_lock_ctx(&lock_ctx);
 	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
@@ -732,7 +693,10 @@ static int do_procmap_query(struct mm_st
 		vm_file = get_file(vma->vm_file);
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 
 	if (karg.build_id_size) {
@@ -773,7 +737,10 @@ static int do_procmap_query(struct mm_st
 	return 0;
 
 out:
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 out_file:
 	if (vm_file)
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

