Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B839021A
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662178; cv=none; b=CRs6sH3RAjsqvtFsp5Qns4WVxHjvoiTZSUvaf6qHnsO5za/nEh+ny4hc1Oqyabc5e8CcNFrhr2I0nM+53soXPl4GjOQkmX4xM3bWJdKVnD2Dv54wjEPzSKhKj4I2rvdHRdtzBK9/bx/6qNtTUsOqmFETFLrrnLYjCoTDw7hkh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662178; c=relaxed/simple;
	bh=9EDuJIXNh6q5FH0IleU+4OHT6CZ8niMoTcqHMeHuKDA=;
	h=Date:To:From:Subject:Message-Id; b=VhOYsWpmivJkjSAxi4nCQgQpbPOYC0hyk9OVtKYsJOD/W5Co9Pgu69jJJNBiccB/9ZwfqeNug0Ziz7FEXDXrgWPlgruK+gRZosxERROcjdCKB4DRb7+mAyZDe/pBTBQ5YksHpaZzy2jZTwCh272c4hd3c26JSGuqNjrv6nFZcg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGHHU60u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGHHU60u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28521F00898;
	Thu, 17 Sep 2026 16:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662177;
	bh=VhylFVi1M8/Ba4ikqFSEvcJWyufUYI6NJjofce9W5U0=;
	h=Date:To:From:Subject;
	b=vGHHU60uJ7NcQNMWCLskFXjbBZqpCHCRXU8dtx8k8bsWYMKfC9CcVslDlZKtKs7l9
	 fJU4wK5ZmCAs7hkvmPxd/FC7KEo1UrYvzI4qeqztciyfNsOZRchfczeQeWafub7ksF
	 kD7E7Vsk8NZuTDZJ31IfPCUEuah4ZhHrMrSiFB6A=
Date: Thu, 17 Sep 2026 09:22:56 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch removed from -mm tree
Message-Id: <20260917162256.E28521F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: remove special-casing of smap_gather_stats() start parameter
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove special-casing of smap_gather_stats() start parameter
Date: Fri, 11 Sep 2026 12:41:42 -0700

smap_gather_stats() interprets its start parameter to mean vma->vm_start
when it's set to 0.  Eliminate this special interpretation and provide two
separate functions for a partial and complete VMA walk.

Since smap_gather_stats() operates within a single VMA, we can replace
walk_page_vma()/walk_page_range() calls with walk_page_range_vma() which
is simpler and also can be called while holding per-VMA lock.

No functional change intended.

Link: https://lore.kernel.org/20260911194145.1781926-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested by: Lorenzo Stoakes <ljs@kernel.org>
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

 fs/proc/task_mmu.c |   52 ++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter
+++ a/fs/proc/task_mmu.c
@@ -1248,20 +1248,26 @@ get_smaps_shmem_walk_ops(struct proc_map
 	return &smaps_shmem_walk_vma_lock_ops;
 }
 
-/*
- * Gather mem stats from @vma with the indicated beginning
- * address @start, and keep them in @mss.
+/**
+ * smap_gather_stats_range() - Gather mem stats from a portion of the @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA to gather stats for.
+ * @mss: The accumulated stats.
+ * @start: The address from which to start.
  *
- * Use vm_start of @vma as the beginning address if @start is 0.
+ * This gathers stats for the portion of the VMA starting at the @start
+ * address.
  */
-static void smap_gather_stats(struct proc_maps_private *priv,
-			      struct vm_area_struct *vma,
-			      struct mem_size_stats *mss, unsigned long start)
+static void smap_gather_stats_range(struct proc_maps_private *priv,
+		struct vm_area_struct *vma,
+		struct mem_size_stats *mss,
+		unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	const bool is_partial = start > vma->vm_start;
 
 	/* Invalid start */
-	if (start >= vma->vm_end)
+	if (start < vma->vm_start || start >= vma->vm_end)
 		return;
 
 	if (vma == get_gate_vma(priv->lock_ctx.mm))
@@ -1280,20 +1286,31 @@ static void smap_gather_stats(struct pro
 		const unsigned long shmem_swapped = shmem_swap_usage(vma);
 		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (start || (shmem_swapped && is_cow))
+		if (is_partial || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
 		else
 			mss->swap += shmem_swapped;
 	}
 
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
 
 	reacquire_rcu(priv);
 }
 
+/**
+ * smap_gather_stats() - Gather mem stats from the entire @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA to gather stats for.
+ * @mss: The accumulated stats.
+ *
+ * This gathers stats for the whole of the VMA.
+ */
+static void smap_gather_stats(struct proc_maps_private *priv,
+		struct vm_area_struct *vma, struct mem_size_stats *mss)
+{
+	smap_gather_stats_range(priv, vma, mss, vma->vm_start);
+}
+
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
 
@@ -1344,7 +1361,7 @@ static int show_smap(struct seq_file *m,
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss);
 
 	show_map_vma(m, vma);
 
@@ -1397,7 +1414,7 @@ static int show_smaps_rollup(struct seq_
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1456,14 +1473,15 @@ static int show_smaps_rollup(struct seq_
 
 			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, 0);
+				smap_gather_stats(priv, vma, &mss);
 				last_vma_end = vma->vm_end;
 				continue;
 			}
 
 			/* Case 4 above */
 			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, last_vma_end);
+				smap_gather_stats_range(priv, vma, &mss,
+							last_vma_end);
 				last_vma_end = vma->vm_end;
 			}
 		}
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

