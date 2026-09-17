Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFD44FE2D9
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662181; cv=none; b=OTI44C2i2AsYBqRK07IF52I2b1IL2V8MEZWQ4xn4vQ/QqNsLm6a+PYlhhi0JCnTomWIm6HLxE8UPYFUTfDR+gDZAFD8JPByPNeD+P1zBiD3Fm+qx+GTPTFzEHL9/DnPTubGbyccIzVfhPcRjnlKujOS59EuO56AKre2CgHBaXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662181; c=relaxed/simple;
	bh=i2NceSJ+vhsFGHnXOeKspA2DAykcGRLFyrAJ6ZDiQGM=;
	h=Date:To:From:Subject:Message-Id; b=Go5kY6+hXx1b0mRnhmbIsoE1c5A/g2+H7n2P2eTVKRBVyrUMfKzVFMyU/YK1GlWBCR8TpzYao0KhIJDBhJWOLWgkM1KXqku1a1hoSKMmqM2xfuVrncwkuzmdvuDwPGadEXNRoxOedPxpW1Mj5y1mpFKHCI9Rd7lFN7yb7SI2CK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDfnn4JM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDfnn4JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F111F000FF;
	Thu, 17 Sep 2026 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662179;
	bh=KY2oEIWuWp0bwbPHqzB/g3tQFK0yUdkk/3kDGpM67E8=;
	h=Date:To:From:Subject;
	b=NDfnn4JM18rIXu9J8S/dEzciXLza+TF/+931uiROOaw/D5RlZ9oCmhIKUiEuyRiEu
	 5oA0ye2m2pTRLFbNo4w4h0e0SM9+qagRbI0FnnOScbQb+JAsiP28S9Z7SEh8S99sOm
	 SspYJ1NLdvyl10GbD82qVJG76InLjUWQbzkBal+Y=
Date: Thu, 17 Sep 2026 09:22:59 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch removed from -mm tree
Message-Id: <20260917162259.85F111F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
Date: Fri, 11 Sep 2026 12:41:44 -0700

proc/pid/smaps_rollup can be read using the combination of RCU and VMA
read locks, similar to proc/pid/{maps|smaps|numa_maps}.  RCU is required
to safely traverse the VMA tree and VMA lock stabilizes the VMA being
processed and the pagetable walk.  Note that we have to keep the logic to
drop mmap_lock on contention because even when using per-VMA locks we
might have to fall back to holding the mmap_lock.

Running Paul's contention benchmark [1] shows considerable improvement
both in median and in the worst case latencies:

Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
--busyduration 2 --procfile smaps_rollup

Baseline:
   Median   Minimum   Maximum
    0.174     0.161     2.553
    0.174     0.164     2.663
    0.174     0.165     2.664
    0.174     0.166     2.679
    0.174     0.167     2.691
    0.174     0.168     2.704
    0.174     0.169     2.729
    0.174     0.172     2.741
    0.174     0.174     2.745
    0.174     0.174     2.755
    0.174     0.175     2.790
    0.174     0.177     2.809
    0.174     0.179     3.096
    0.174     0.183     3.144
    0.174     0.184     3.158
    0.174     0.185     3.175
    0.174     0.185     4.568
    0.174     0.198     4.821
    0.174     0.214     5.143
    0.174     0.251     5.220

Patched:
   Median   Minimum   Maximum
    0.007     0.007     1.952
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.957
    0.007     0.007     1.969
    0.007     0.007     2.065
    0.007     0.007     2.075
    0.007     0.007     2.146
    0.007     0.007     2.195
    0.007     0.007     2.223
    0.007     0.007     2.259
    0.007     0.007     2.488
    0.007     0.007     2.562
    0.007     0.007     2.599
    0.007     0.007     2.697
    0.007     0.007     3.030
    0.007     0.007     3.075
    0.007     0.007     3.145
    0.007     0.007     3.225

Remove now unused lock_ctx_mm() and move unlock_ctx_vma() next to
unlock_ctx_mm() as they are logically related.

Remove a long comment about 4 cases that we handle when dropping the mmap
lock in the middle of VMA walk due to contention.  The first 3 cases
explained there are handled naturally and only case 4 needs to be handled
in a special way, which is done in smap_gather_stats() by gathering stats
from the portion of the VMA that has not yet been processed.  For
posterity, moving this comment here:

After dropping the lock, there are four cases to consider.  See the
following example for explanation.

  +------+------+-----------+
  | VMA1 | VMA2 | VMA3      |
  +------+------+-----------+
  |      |      |           |
 4k     8k     16k         400k

Suppose we drop the lock after reading VMA2 due to contention, then we
get:

	last_vma_end = 16k

1) VMA2 is freed, but VMA3 exists:

   vma_next(vmi) will return VMA3.
   In this case, just continue from VMA3.

2) VMA2 still exists:

   vma_next(vmi) will return VMA3.
   In this case, just continue from VMA3.

3) No more VMAs can be found:

   vma_next(vmi) will return NULL.
   No more things to do, just break.

4) (last_vma_end - 1) is the middle of a vma (VMA'):

   vma_next(vmi) will return VMA' whose range
   contains last_vma_end.
   Iterate VMA' from last_vma_end.

Link: https://lore.kernel.org/20260911194145.1781926-7-surenb@google.com
Link: https://github.com/paulmckrcu/proc-mmap_sem-test [1]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |  157 +++++++++++++++++--------------------------
 1 file changed, 63 insertions(+), 94 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock
+++ a/fs/proc/task_mmu.c
@@ -130,28 +130,12 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
-{
-	int ret = mmap_read_lock_killable(lock_ctx->mm);
-
-	if (!ret)
-		lock_ctx->mmap_locked = true;
-
-	return ret;
-}
-
 static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
 }
 
-static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
-{
-	lock_ctx->locked_vma = NULL;
-	lock_ctx->mmap_locked = false;
-}
-
 static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
 	if (lock_ctx->locked_vma) {
@@ -160,6 +144,12 @@ static void unlock_ctx_vma(struct proc_m
 	}
 }
 
+static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
+{
+	lock_ctx->locked_vma = NULL;
+	lock_ctx->mmap_locked = false;
+}
+
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
@@ -1404,12 +1394,14 @@ static int show_smap(struct seq_file *m,
 static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
+	struct mm_struct *mm = lock_ctx->mm;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->lock_ctx.mm;
+	unsigned long last_vma_end = 0;
+	unsigned long vma_start = 0;
 	struct vm_area_struct *vma;
-	unsigned long vma_start = 0, last_vma_end = 0;
+	loff_t pos = 0;
 	int ret = 0;
-	VMA_ITERATOR(vmi, mm, 0);
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
@@ -1420,90 +1412,63 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_task;
 	}
 
-	ret = lock_ctx_mm(&priv->lock_ctx);
-	if (ret)
-		goto out_put_mm;
-
 	hold_task_mempolicy(priv);
-	vma = vma_next(&vmi);
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 
+	vma_iter_init(&priv->iter, mm, 0);
+	vma = proc_get_vma(m, &pos);
 	if (unlikely(!vma))
 		goto empty_set;
 
-	vma_start = vma->vm_start;
-	do {
-		smap_gather_stats(priv, vma, &mss);
+	if (!IS_ERR(vma))
+		vma_start = vma->vm_start;
+
+	while (vma) {
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto out_unlock;
+		}
+
+		if (vma->vm_start < last_vma_end) {
+			/*
+			 * After retaking the lock, already reported VMA grew
+			 * or got merged with the next one and we found it
+			 * again. Gather stats for the remaining portion by
+			 * starting at last_vma_end.
+			 */
+			smap_gather_stats_range(priv, vma, &mss, last_vma_end);
+		} else {
+			/* Found next unreported VMA, start from its beginning */
+			smap_gather_stats(priv, vma, &mss);
+		}
 		last_vma_end = vma->vm_end;
 
 		/*
-		 * Release mmap_lock temporarily if someone wants to
-		 * access it for write request.
+		 * If the VMA lock is not taken, we hold the often contended
+		 * mmap lock. This can happen if we had to fall back to the
+		 * mmap lock.
+		 *
+		 * To relieve pressure, check if it is indeed contended, then
+		 * temporarily release it.
 		 */
-		if (mmap_lock_is_contended(mm)) {
-			vma_iter_invalidate(&vmi);
-			unlock_ctx_mm(&priv->lock_ctx);
-			ret = lock_ctx_mm(&priv->lock_ctx);
-			if (ret) {
-				release_task_mempolicy(priv);
-				goto out_put_mm;
-			}
-
+		if (lock_ctx->mmap_locked &&
+		    mmap_lock_is_contended(lock_ctx->mm)) {
+			unlock_ctx_mm(lock_ctx);
 			/*
-			 * After dropping the lock, there are four cases to
-			 * consider. See the following example for explanation.
-			 *
-			 *   +------+------+-----------+
-			 *   | VMA1 | VMA2 | VMA3      |
-			 *   +------+------+-----------+
-			 *   |      |      |           |
-			 *  4k     8k     16k         400k
-			 *
-			 * Suppose we drop the lock after reading VMA2 due to
-			 * contention, then we get:
-			 *
-			 *	last_vma_end = 16k
-			 *
-			 * 1) VMA2 is freed, but VMA3 exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 2) VMA2 still exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 3) No more VMAs can be found:
-			 *
-			 *    vma_next(vmi) will return NULL.
-			 *    No more things to do, just break.
-			 *
-			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
-			 *
-			 *    vma_next(vmi) will return VMA' whose range
-			 *    contains last_vma_end.
-			 *    Iterate VMA' from last_vma_end.
+			 * Even though we previously fell back to mmap lock,
+			 * we try taking VMA lock for the next VMA, since it
+			 * might not be under modification. In the worst case
+			 * we will fall back to mmap lock again.
 			 */
-			vma = vma_next(&vmi);
-			/* Case 3 above */
-			if (!vma)
-				break;
-
-			/* Case 1 and 2 above */
-			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss);
-				last_vma_end = vma->vm_end;
-				continue;
-			}
-
-			/* Case 4 above */
-			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats_range(priv, vma, &mss,
-							last_vma_end);
-				last_vma_end = vma->vm_end;
-			}
+			rcu_read_lock();
+			reset_lock_ctx(lock_ctx);
+			/* Resume from the last position. */
+			pos = last_vma_end;
+			vma_iter_init(&priv->iter, mm, pos);
 		}
-	} for_each_vma(vmi, vma);
+		vma = proc_get_vma(m, &pos);
+	}
 
 empty_set:
 	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
@@ -1512,10 +1477,14 @@ empty_set:
 
 	__show_smap(m, &mss, true);
 
+out_unlock:
+	if (lock_ctx->mmap_locked) {
+		unlock_ctx_mm(lock_ctx);
+	} else {
+		unlock_ctx_vma(lock_ctx);
+		rcu_read_unlock();
+	}
 	release_task_mempolicy(priv);
-	unlock_ctx_mm(&priv->lock_ctx);
-
-out_put_mm:
 	mmput(mm);
 out_put_task:
 	put_task_struct(priv->task);
_

Patches currently in -mm which might be from surenb@google.com are

selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

