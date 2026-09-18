Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E550AC3B
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746306; cv=none; b=dY8NcPOBnB9PrNzqT8tDOPyTmbF2vG/5Ra1Psr7nfUmmUMFdNVz6wOX0It66+SEDrtIzEMB2A+tRw31z5Xj+nnxGIgeu/hcjythrT0cIwnTroeioFTmFne0YAqJ+ha+5NKeIZ/bJDIrAVbFsQQzliI++caucUHdxGmvDJsMyVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746306; c=relaxed/simple;
	bh=xsLAednY6XABMjdIx8yTM4K1UUZJKNU3dupHS+cilLE=;
	h=Date:To:From:Subject:Message-Id; b=BUVZ+U+ZZbYzveu7q3JeyqpuDkhH5OM9UGb9F/zPo7HPr5nKR24KR9BWyqhIyIAKjp+DvZe0GX529kNWOpSyouA5yLR9b6DOvDdK/q9Cm6fDoq8p3nUwlj0vTQ0QFJ48Xppjc8I0pyIyTi6t0CDlGWIHbu64CEETGuKTpkyNViQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7Hj6/8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7Hj6/8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B841F000FF;
	Fri, 18 Sep 2026 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789746304;
	bh=3cwGeH0ELM369WDAHyteVRQyjkk4OtHPCIPzrB+EtPg=;
	h=Date:To:From:Subject;
	b=B7Hj6/8lwSuz84rPazWwZ6OqL+pqnVhSIQcNg0yb4SU8QEM2NCfcvm98m5BPWZ8pZ
	 vj2PGqSmYWreBrbHZOrXVfK0jEUlcxM4QK57qXY9M0ZVIfRUqN5BL//A5TVhzBtuko
	 k9956NOS5hBnsEP1J7TJLeKIomP7aK9D4l0HPcr4=
Date: Fri, 18 Sep 2026 08:45:04 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch added to mm-new branch
Message-Id: <20260918154504.A1B841F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch

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
Subject: proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
Date: Fri, 18 Sep 2026 08:33:16 -0700

proc_get_vma() returning gate VMA at the end is desirable for the its
current m_start/m_next callers, as they need to report a gate VMA at the
end of the address space.  This behavior is very specific to these callers
and makes proc_get_vma() hard to use for other purposes.

Move this usage-specific behavior into the callers themselves so that
proc_get_vma() returns either a valid VMA, an error or a NULL when no more
VMAs are available.  This makes it more generic, simpler and usable in the
later patches.

Link: https://lore.kernel.org/20260918153318.758387-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end
+++ a/fs/proc/task_mmu.c
@@ -240,9 +240,6 @@ retry:
 		 * found the extended vma with the same vm_start.
 		 */
 		*ppos = vma->vm_end;
-	} else {
-		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -252,6 +249,7 @@ static void *m_start(struct seq_file *m,
 {
 	struct proc_maps_private *priv = m->private;
 	struct proc_maps_locking_ctx *lock_ctx;
+	struct vm_area_struct *vma;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -281,19 +279,39 @@ static void *m_start(struct seq_file *m,
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
+	/*
+	 * If seq_file had to flush its collected data right after m_next() set
+	 * position to SENTINEL_VMA_GATE, m_start() will get that sentinel and
+	 * should return gate_vma without calling proc_get_vma().
+	 */
 	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(mm);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma;
+
 	if (*ppos == SENTINEL_VMA_GATE) {
 		*ppos = SENTINEL_VMA_END;
 		return NULL;
 	}
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(priv->lock_ctx.mm);
 }
 
 static void m_stop(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-remove-unnecessary-helpers.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

