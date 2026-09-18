Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BBE3CDBD3
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746297; cv=none; b=TCcSuUi6aBvGOnHIowhhgHNcNGDayxEIax6V4B7VLtVY+Z86pPTVpLeDjd3jDuhsV/MbwOORA/TVZz6yCdY3Px9ps6XHGwkqng0SlaOnhYe3YG1LSbT1uzMzFIbQ89HoO7oGh4d94CZhLuHA3+s2IJFN8IYfHwRtHjNq9ckf97g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746297; c=relaxed/simple;
	bh=cLIJje9/hV2s91ONlg/3aGfMqQlncb0aPteZcAdGfzg=;
	h=Date:To:From:Subject:Message-Id; b=oJPtThK8l0e4IkXA4Ad2kRTHdTgcw48OiHu16deGPB+2KTbSJ8Nz4jPWXREwhuXqUgVuIDbkoYGgb+rQhWsCxxtsBpHqi3T8gW1yzCAMcLwVD00IhKuxC8qTOlZ+k0uywxRTyxQarRhqwxVDENOyEk7bb11HbqGbxBz80e0nEc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T6X5uTyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T6X5uTyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2BA1F000FF;
	Fri, 18 Sep 2026 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789746296;
	bh=7unLB0Jy0YPqHcyEEZh9077078meJ78SpxOSx/mF2fk=;
	h=Date:To:From:Subject;
	b=T6X5uTyBGA2B0Fj6ovVx0Bjkde9n9NRp2MSKvX6U/VcisoJv7Lj2CLH8qYdgWmpXL
	 YMVcnrhQDi4LVZ6uIU0rMQzoQNgzuUA8b/STcOBiU/8kUWuuNBOGWwqE3UNVzeMh4V
	 ExFSnN0EJw3o9+ZzqKuIL5V7XWKhK3/C8uJLNtD8=
Date: Fri, 18 Sep 2026 08:44:55 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-remove-unnecessary-helpers.patch added to mm-new branch
Message-Id: <20260918154456.1B2BA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: remove unnecessary helpers
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-remove-unnecessary-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-remove-unnecessary-helpers.patch

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
Subject: proc/task_mmu: remove unnecessary helpers
Date: Fri, 18 Sep 2026 08:33:12 -0700

Patch series "read proc/pid/smaps_rollup under per-vma lock", v5.

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

Link: https://lore.kernel.org/20260918153318.758387-1-surenb@google.com
Link: https://lore.kernel.org/20260918153318.758387-2-surenb@google.com
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

proc-task_mmu-remove-unnecessary-helpers.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

