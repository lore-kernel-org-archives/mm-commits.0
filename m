Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E733845AC
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662180; cv=none; b=gy6BFgYZkCIjuuHbCn7EZWJbSP1vqYmQi75jsr7a/QH7TYAFzpA148gFF3b6A4hdemB9dlN8wvj02RyRG1ryFw5Zjfv468ojZoSvQrwKniZCaWziv3fcA8e6GKg1TSy5+abvLVKb68TzmpH6lXdIDp+c5srBTonc7xLZTJVayy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662180; c=relaxed/simple;
	bh=MdSqWGMik8w9Pot9uVB0ZnteJQh6N1/o67nxCD4dc3g=;
	h=Date:To:From:Subject:Message-Id; b=o0mzoqm9S0BfeEHwLh3Ii7O86UnUCzezbk70pMK5tXpTim00Zy08RRF/1GdQJEycqQUlnhyS6jyqwBohgNFJeodNWgI2SkgOpo1Rkc/6nua7xRPNpOKT47fiY5V0PTmlyg7W/KRmBTJA6TCu1mEI07Mxt3kUnpIWYc0jFUPgHFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0gkuz0z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0gkuz0z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267481F0089A;
	Thu, 17 Sep 2026 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662178;
	bh=MuxQyn9rajjkY4GJjwdiDT7GiE5tfCx5kVL8fFbBu0M=;
	h=Date:To:From:Subject;
	b=0gkuz0z/9dxbt38FmQsFwdZOaGQ/pH4JOXdVMAFrOSLvCCVgu8b4qsJ4Ty/rV/DAO
	 tz0CVYdYsA+CgBtjwyaBfA/GzyXzrgcJhANl4xxMUnwmXsRvFEhlEjYfzAaBXRKf0Q
	 fMew7VxXxNhKmDuiaTVZBgmYVoLZP/rabQgW/B7s=
Date: Thu, 17 Sep 2026 09:22:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch removed from -mm tree
Message-Id: <20260917162258.267481F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
Date: Fri, 11 Sep 2026 12:41:43 -0700

proc_get_vma() returning gate VMA at the end is desirable for the its
current m_start/m_next callers, as they need to report a gate VMA at the
end of the address space.  This behavior is very specific to these callers
and makes proc_get_vma() hard to use for other purposes.

Move this usage-specific behavior into the callers themselves so that
proc_get_vma() returns either a valid VMA, an error or a NULL when no more
VMAs are available.  This makes it more generic, simpler and usable in the
later patches.

Link: https://lore.kernel.org/20260911194145.1781926-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
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
@@ -238,9 +238,6 @@ retry:
 		 * found the extended vma with the same vm_start.
 		 */
 		*ppos = vma->vm_end;
-	} else {
-		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -250,6 +247,7 @@ static void *m_start(struct seq_file *m,
 {
 	struct proc_maps_private *priv = m->private;
 	struct proc_maps_locking_ctx *lock_ctx;
+	struct vm_area_struct *vma;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -279,19 +277,39 @@ static void *m_start(struct seq_file *m,
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

proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

