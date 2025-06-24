Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE702550D3
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 20:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795689; cv=none; b=YR5tQlvkQr98W6eIDq6nXAAKhfWFcHCAv2E8C2GJNMvTSjEtBg7i7S8CDgtnxpvG+KHsMtbHZWNSmK47sCM5gO9oN3wjiHG9NJhGIC981AqTLTLFoJjnnZq+ExjmFkZUUnYXJM+H+/cGCUH06EXqXqz26FUwhiif41q/cp9Ii2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795689; c=relaxed/simple;
	bh=5C/yVsk3xUZa3E8Qrkvo32CR3BJbGKpdfZnvbcHusl4=;
	h=Date:To:From:Subject:Message-Id; b=oYeH2d6dpFib7EVWmRcgwf2Me3VAe9Qul2O+v2RGaUKgPZieQRS9N6o/hrz4cDlgMgsEpYts2ZqHzid8e9R5A8vylFBLqzKBF1iU8oKtxIqUzKlyafKt8vpKxdnAyJBuMfozLFR37d0lyj3JjcFYk1IVkicmUZ1Kk07o/9uzoAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QMZOOOvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QMZOOOvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B9DC4CEE3;
	Tue, 24 Jun 2025 20:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750795689;
	bh=5C/yVsk3xUZa3E8Qrkvo32CR3BJbGKpdfZnvbcHusl4=;
	h=Date:To:From:Subject:From;
	b=QMZOOOvJALr51XYaAjC0qYA5htTYTbj31kyYB3gXE+vQ/HQQkXXP8udDAYx8gGKCV
	 8r6l2Otj5Ad6ajU/dRI+zK1OF2+SXM+VZC2UkuSa1Em5cleOc3CNM7L4JZBjYgSQgF
	 GfYCK6pizglaetkFTN4Acb4GDRxNMqVEwJgceoYM=
Date: Tue, 24 Jun 2025 13:08:08 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-maps-read-proc-pid-maps-under-per-vma-lock.patch added to mm-new branch
Message-Id: <20250624200809.54B9DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/maps: read proc/pid/maps under per-vma lock
has been added to the -mm mm-new branch.  Its filename is
     mm-maps-read-proc-pid-maps-under-per-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-maps-read-proc-pid-maps-under-per-vma-lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/maps: read proc/pid/maps under per-vma lock
Date: Tue, 24 Jun 2025 12:33:58 -0700

With maple_tree supporting vma tree traversal under RCU and per-vma
locks, /proc/pid/maps can be read while holding individual vma locks
instead of locking the entire address space.

Completely lockless approach (walking vma tree under RCU) would be quite
complex with the main issue being get_vma_name() using callbacks which
might not work correctly with a stable vma copy, requiring original
(unstable) vma - see special_mapping_name() for an example.

When per-vma lock acquisition fails, we take the mmap_lock for reading,
lock the vma, release the mmap_lock and continue.  This fallback to mmap
read lock guarantees the reader to make forward progress even during lock
contention.  This will interfere with the writer but for a very short time
while we are acquiring the per-vma lock and only when there was contention
on the vma reader is interested in.  We shouldn't see a repeated fallback
to mmap read locks in practice, as this require a very unlikely series of
lock contentions (for instance due to repeated vma split operations). 
However even if this did somehow happen, we would still progress.

One case requiring special handling is when vma changes between the time
it was found and the time it got locked.  A problematic case would be if
vma got shrunk so that it's start moved higher in the address space and a
new vma was installed at the beginning:

reader found:               |--------VMA A--------|
VMA is modified:            |-VMA B-|----VMA A----|
reader locks modified VMA A
reader reports VMA A:       |  gap  |----VMA A----|

This would result in reporting a gap in the address space that does not
exist.  To prevent this we retry the lookup after locking the vma, however
we do that only when we identify a gap and detect that the address space
was changed after we found the vma.

This change is designed to reduce mmap_lock contention and prevent a
process reading /proc/pid/maps files (often a low priority task, such as
monitoring/data collection services) from blocking address space updates. 
Note that this change has a userspace visible disadvantage: it allows for
sub-page data tearing as opposed to the previous mechanism where data
tearing could happen only between pages of generated output data.  Since
current userspace considers data tearing between pages to be acceptable,
we assume is will be able to handle sub-page data tearing as well.

Link: https://lkml.kernel.org/r/20250624193359.3865351-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h        |    5 +
 fs/proc/task_mmu.c        |  123 +++++++++++++++++++++++++++++++++---
 include/linux/mmap_lock.h |   11 +++
 mm/mmap_lock.c            |   88 +++++++++++++++++++++++++
 4 files changed, 217 insertions(+), 10 deletions(-)

--- a/fs/proc/internal.h~mm-maps-read-proc-pid-maps-under-per-vma-lock
+++ a/fs/proc/internal.h
@@ -384,6 +384,11 @@ struct proc_maps_private {
 	struct task_struct *task;
 	struct mm_struct *mm;
 	struct vma_iterator iter;
+	loff_t last_pos;
+#ifdef CONFIG_PER_VMA_LOCK
+	bool mmap_locked;
+	struct vm_area_struct *locked_vma;
+#endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
--- a/fs/proc/task_mmu.c~mm-maps-read-proc-pid-maps-under-per-vma-lock
+++ a/fs/proc/task_mmu.c
@@ -127,21 +127,118 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
-						loff_t *ppos)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static void unlock_vma(struct proc_maps_private *priv)
+{
+	if (priv->locked_vma) {
+		vma_end_read(priv->locked_vma);
+		priv->locked_vma = NULL;
+	}
+}
+
+static const struct seq_operations proc_pid_maps_op;
+
+static inline bool lock_vma_range(struct seq_file *m,
+				  struct proc_maps_private *priv)
 {
-	struct vm_area_struct *vma = vma_next(&priv->iter);
+	/*
+	 * smaps and numa_maps perform page table walk, therefore require
+	 * mmap_lock but maps can be read with locking just the vma.
+	 */
+	if (m->op != &proc_pid_maps_op) {
+		if (mmap_read_lock_killable(priv->mm))
+			return false;
+
+		priv->mmap_locked = true;
+	} else {
+		rcu_read_lock();
+		priv->locked_vma = NULL;
+		priv->mmap_locked = false;
+	}
+
+	return true;
+}
 
+static inline void unlock_vma_range(struct proc_maps_private *priv)
+{
+	if (priv->mmap_locked) {
+		mmap_read_unlock(priv->mm);
+	} else {
+		unlock_vma(priv);
+		rcu_read_unlock();
+	}
+}
+
+static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
+					   loff_t last_pos)
+{
+	struct vm_area_struct *vma;
+
+	if (priv->mmap_locked)
+		return vma_next(&priv->iter);
+
+	unlock_vma(priv);
+	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
+	if (!IS_ERR_OR_NULL(vma))
+		priv->locked_vma = vma;
+
+	return vma;
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static inline bool lock_vma_range(struct seq_file *m,
+				  struct proc_maps_private *priv)
+{
+	return mmap_read_lock_killable(priv->mm) == 0;
+}
+
+static inline void unlock_vma_range(struct proc_maps_private *priv)
+{
+	mmap_read_unlock(priv->mm);
+}
+
+static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
+					   loff_t last_pos)
+{
+	return vma_next(&priv->iter);
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
+{
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma;
+
+	vma = get_next_vma(priv, *ppos);
+	/* EINTR is possible */
+	if (IS_ERR(vma))
+		return vma;
+
+	/* Store previous position to be able to restart if needed */
+	priv->last_pos = *ppos;
 	if (vma) {
-		*ppos = vma->vm_start;
+		/*
+		 * Track the end of the reported vma to ensure position changes
+		 * even if previous vma was merged with the next vma and we
+		 * found the extended vma with the same vm_start.
+		 */
+		*ppos = vma->vm_end;
 	} else {
-		*ppos = -2UL;
+		*ppos = -2UL; /* -2 indicates gate vma */
 		vma = get_gate_vma(priv->mm);
 	}
 
 	return vma;
 }
 
+static inline bool is_sentinel_pos(unsigned long pos)
+{
+	return pos == -1UL || pos == -2UL;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
@@ -163,28 +260,34 @@ static void *m_start(struct seq_file *m,
 		return NULL;
 	}
 
-	if (mmap_read_lock_killable(mm)) {
+	if (!lock_vma_range(m, priv)) {
 		mmput(mm);
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return ERR_PTR(-EINTR);
 	}
 
+	/*
+	 * Reset current position if last_addr was set before
+	 * and it's not a sentinel.
+	 */
+	if (last_addr > 0 && !is_sentinel_pos(last_addr))
+		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, last_addr);
 	hold_task_mempolicy(priv);
 	if (last_addr == -2UL)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(priv, ppos);
+	return proc_get_vma(m, ppos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
 	if (*ppos == -2UL) {
-		*ppos = -1UL;
+		*ppos = -1UL; /* -1 indicates no more vmas */
 		return NULL;
 	}
-	return proc_get_vma(m->private, ppos);
+	return proc_get_vma(m, ppos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -196,7 +299,7 @@ static void m_stop(struct seq_file *m, v
 		return;
 
 	release_task_mempolicy(priv);
-	mmap_read_unlock(mm);
+	unlock_vma_range(priv);
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
--- a/include/linux/mmap_lock.h~mm-maps-read-proc-pid-maps-under-per-vma-lock
+++ a/include/linux/mmap_lock.h
@@ -309,6 +309,17 @@ void vma_mark_detached(struct vm_area_st
 struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 					  unsigned long address);
 
+/*
+ * Locks next vma pointed by the iterator. Confirms the locked vma has not
+ * been modified and will retry under mmap_lock protection if modification
+ * was detected. Should be called from read RCU section.
+ * Returns either a valid locked VMA, NULL if no more VMAs or -EINTR if the
+ * process was interrupted.
+ */
+struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
+				     struct vma_iterator *iter,
+				     unsigned long address);
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
--- a/mm/mmap_lock.c~mm-maps-read-proc-pid-maps-under-per-vma-lock
+++ a/mm/mmap_lock.c
@@ -178,6 +178,94 @@ inval:
 	count_vm_vma_lock_event(VMA_LOCK_ABORT);
 	return NULL;
 }
+
+static struct vm_area_struct *lock_vma_under_mmap_lock(struct mm_struct *mm,
+						       struct vma_iterator *iter,
+						       unsigned long address)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	ret = mmap_read_lock_killable(mm);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Lookup the vma at the last position again under mmap_read_lock */
+	vma_iter_init(iter, mm, address);
+	vma = vma_next(iter);
+	if (vma)
+		vma_start_read_locked(vma);
+
+	mmap_read_unlock(mm);
+
+	return vma;
+}
+
+struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
+				     struct vma_iterator *iter,
+				     unsigned long address)
+{
+	struct vm_area_struct *vma;
+	unsigned int mm_wr_seq;
+	bool mmap_unlocked;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu read lock held");
+retry:
+	/* Start mmap_lock speculation in case we need to verify the vma later */
+	mmap_unlocked = mmap_lock_speculate_try_begin(mm, &mm_wr_seq);
+	vma = vma_next(iter);
+	if (!vma)
+		return NULL;
+
+	vma = vma_start_read(mm, vma);
+
+	if (IS_ERR_OR_NULL(vma)) {
+		/*
+		 * Retry immediately if the vma gets detached from under us.
+		 * Infinite loop should not happen because the vma we find will
+		 * have to be constantly knocked out from under us.
+		 */
+		if (PTR_ERR(vma) == -EAGAIN) {
+			vma_iter_init(iter, mm, address);
+			goto retry;
+		}
+
+		goto out;
+	}
+
+	/*
+	 * Verify the vma we locked belongs to the same address space and it's
+	 * not behind of the last search position.
+	 */
+	if (unlikely(vma->vm_mm != mm || address >= vma->vm_end))
+		goto out_unlock;
+
+	/*
+	 * vma can be ahead of the last search position but we need to verify
+	 * it was not shrunk after we found it and another vma has not been
+	 * installed ahead of it. Otherwise we might observe a gap that should
+	 * not be there.
+	 */
+	if (address < vma->vm_start) {
+		/* Verify only if the address space might have changed since vma lookup. */
+		if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr_seq)) {
+			vma_iter_init(iter, mm, address);
+			if (vma != vma_next(iter))
+				goto out_unlock;
+		}
+	}
+
+	return vma;
+
+out_unlock:
+	vma_end_read(vma);
+out:
+	rcu_read_unlock();
+	vma = lock_vma_under_mmap_lock(mm, iter, address);
+	rcu_read_lock();
+
+	return vma;
+}
 #endif /* CONFIG_PER_VMA_LOCK */
 
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
_

Patches currently in -mm which might be from surenb@google.com are

selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
selftests-proc-add-verbose-more-for-tests-to-facilitate-debugging.patch
mm-maps-read-proc-pid-maps-under-per-vma-lock.patch
mm-maps-execute-procmap_query-ioctl-under-per-vma-locks.patch

