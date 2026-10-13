Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5FD480DFC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865997; cv=none; b=QjCtfFovt7RosAy74s40+qjJgvehCgl+GcHnl7FYnqIq/Sr5B8gTppABqiLBWPVxgFGL+lXpMaditM6rRTSwPfKbgKNU8jVPsl9kaJfDVrTI2hLxwtnjHRjde945D5MpJUINBXgOwSBUXsAF3Nm/Af54FiNzwFeqN2AJPpH54Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865997; c=relaxed/simple;
	bh=6bm5lH/u4iNlTFDO6Ct809deag59uPM1ygppJiQ5vFI=;
	h=Date:To:From:Subject:Message-Id; b=NGzKAx0zgNx3/6iy3+UZopj4X6Z7kW306Z5JSmRZO1dsAN+wvC5NOFxrAz6jXLEDfw0hLWvsmiONV+FKxAFCKrZ8PvEUWwBU+PU3lGtRkqufQCqL7vT+AYYMPaZgyiUiQL1kRfOiy0o1lEnKlWajP2sd+D2vqmeAVREZVblQG8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lzf8/jHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lzf8/jHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43A11F000FF;
	Tue, 13 Oct 2026 04:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865996;
	bh=J9i81bHkc+rEZp7SOHVBtP7yWS4LGRZArLTm8HDgvPA=;
	h=Date:To:From:Subject;
	b=Lzf8/jHyf/3v1Fm0OLX16G0yV0V5LiNzHT2qtAAwiLtZc1bBSxQ0hgr2gnoH4O8Da
	 kw9asOivHHs/kh8MhAvdKCmF7gDGqKz32GznA8dL58L1bdilO2X9amH91S5ANdGyhD
	 xQdENhaEsEigBySpTeFeSt/QTg7ruEVlKg1z2zXg=
Date: Mon, 12 Oct 2026 21:33:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch removed from -mm tree
Message-Id: <20261013043315.E43A11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


