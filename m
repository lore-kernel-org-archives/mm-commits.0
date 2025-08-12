Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7497F13B284
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958118; cv=none; b=Y46v2okJrRkp+eri0KntS0gxZUqX7PHv4n6/qBGSbBnarlLS3e/wSUzTjesVFbd9qVDKaQTtM+jS/ZoTVzW5dE8YgbPDrxRbetvx94kMJq3apA7HxwhiA+hoUdMu8rCxpfjSM9oc2+sUqNdKQuEzW4GKP0oS8ZWiyPSHFcVjn8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958118; c=relaxed/simple;
	bh=8qI5ksGfm85g8GVIrw6BGyps2ZpxVT8hju5qvWepoW0=;
	h=Date:To:From:Subject:Message-Id; b=rUSuyT8pXUfYMVMKvvn+MpKCjfUAkfWoEPCrTmhaQ7SNxrzCJsBcgR74PNbejaAZfmM9CSBaSzKYwfairb3AmC3gJYfHllpBVpVeqaoWGYU5UTgEhGQz/tYgXUyk4FQrRQJJg2IsV38joMc2vtTLari7DAIBRYNS9FlCSGAqpOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dAqlXOHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dAqlXOHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA639C4CEED;
	Tue, 12 Aug 2025 00:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754958117;
	bh=8qI5ksGfm85g8GVIrw6BGyps2ZpxVT8hju5qvWepoW0=;
	h=Date:To:From:Subject:From;
	b=dAqlXOHsUXrC/FT8ossqDukl63SnB3NtZg3ls+yk1fWxz1h/es2gY1YBvrhpr55a4
	 2NqBDNl06Abb7fCI5a8Dl9GixJWkoRj59KeFn6sotIYnSaAAarEWT5PWQGAisKSwZ/
	 jfd6SQa6E9mzyhJMmWPQ83KipONz6UVrpEoqw+G0=
Date: Mon, 11 Aug 2025 17:21:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch added to mm-unstable branch
Message-Id: <20250812002157.DA639C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

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
Subject: fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks
Date: Fri, 8 Aug 2025 08:28:49 -0700

Utilize per-vma locks to stabilize vma after lookup without taking
mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
contended, we fall back to mmap_lock but take it only momentarily
to lock the vma and release the mmap_lock. In a very unlikely case
of vm_refcnt overflow, this fall back path will fail and ioctl is
done under mmap_lock protection.

This change is designed to reduce mmap_lock contention and prevent
PROCMAP_QUERY ioctl calls from blocking address space updates.

Link: https://lkml.kernel.org/r/20250808152850.2580887-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  103 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 18 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks
+++ a/fs/proc/task_mmu.c
@@ -132,6 +132,12 @@ static void release_task_mempolicy(struc
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
+{
+	lock_ctx->locked_vma = NULL;
+	lock_ctx->mmap_locked = false;
+}
+
 static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
 	if (lock_ctx->locked_vma) {
@@ -157,8 +163,7 @@ static inline bool lock_vma_range(struct
 		lock_ctx->mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		lock_ctx->locked_vma = NULL;
-		lock_ctx->mmap_locked = false;
+		reset_lock_ctx(lock_ctx);
 	}
 
 	return true;
@@ -522,28 +527,90 @@ static int pid_maps_open(struct inode *i
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct mm_struct *mm)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 {
-	return mmap_read_lock_killable(mm);
+	reset_lock_ctx(lock_ctx);
+
+	return 0;
 }
 
-static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
 {
-	mmap_read_unlock(mm);
+	if (lock_ctx->mmap_locked) {
+		mmap_read_unlock(lock_ctx->mm);
+		lock_ctx->mmap_locked = false;
+	} else {
+		unlock_ctx_vma(lock_ctx);
+	}
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
 {
-	return find_vma(mm, addr);
+	struct mm_struct *mm = lock_ctx->mm;
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	if (lock_ctx->mmap_locked)
+		return find_vma(mm, addr);
+
+	/* Unlock previously locked VMA and find the next one under RCU */
+	unlock_ctx_vma(lock_ctx);
+	rcu_read_lock();
+	vma_iter_init(&vmi, mm, addr);
+	vma = lock_next_vma(mm, &vmi, addr);
+	rcu_read_unlock();
+
+	if (!vma)
+		return NULL;
+
+	if (!IS_ERR(vma)) {
+		lock_ctx->locked_vma = vma;
+		return vma;
+	}
+
+	if (PTR_ERR(vma) == -EAGAIN) {
+		/* Fallback to mmap_lock on vma->vm_refcnt overflow */
+		mmap_read_lock(mm);
+		vma = find_vma(mm, addr);
+		lock_ctx->mmap_locked = true;
+	}
+
+	return vma;
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
+{
+	return mmap_read_lock_killable(lock_ctx->mm);
+}
+
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
+{
+	mmap_read_unlock(lock_ctx->mm);
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
+{
+	return find_vma(lock_ctx->mm, addr);
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
+#endif  /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *lock_ctx,
 						 unsigned long addr, u32 flags)
 {
 	struct vm_area_struct *vma;
 
 next_vma:
-	vma = query_vma_find_by_addr(mm, addr);
+	vma = query_vma_find_by_addr(lock_ctx, addr);
+	if (IS_ERR(vma))
+		return vma;
+
 	if (!vma)
 		goto no_vma;
 
@@ -584,11 +651,11 @@ no_vma:
 	return ERR_PTR(-ENOENT);
 }
 
-static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
+static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 {
+	struct proc_maps_locking_ctx lock_ctx = { .mm = mm };
 	struct procmap_query karg;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
 	const char *name = NULL;
 	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
@@ -615,17 +682,16 @@ static int do_procmap_query(struct proc_
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(mm);
+	err = query_vma_setup(&lock_ctx);
 	if (err) {
 		mmput(mm);
 		return err;
 	}
 
-	vma = query_matching_vma(mm, karg.query_addr, karg.query_flags);
+	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
 		vma = NULL;
@@ -710,7 +776,7 @@ static int do_procmap_query(struct proc_
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -730,7 +796,7 @@ static int do_procmap_query(struct proc_
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
@@ -743,7 +809,8 @@ static long procfs_procmap_ioctl(struct
 
 	switch (cmd) {
 	case PROCMAP_QUERY:
-		return do_procmap_query(priv, (void __user *)arg);
+		/* priv->lock_ctx.mm is set during file open operation */
+		return do_procmap_query(priv->lock_ctx.mm, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch
userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch
mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

