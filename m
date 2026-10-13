Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9964483BFF
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865995; cv=none; b=MYHDYVSwoKZ6bscj+ktexr1Ccmk7TFbcHCnxfYXAPGiNX1wcfnXLoMvm6+Y13qcXE5iIUGJxhdJbfO7OY399iUogc+oJtEZvCA0qvNY6zBmfjlL7lbWXk72L35aXpMAHvQwC/YkR3pAKkwGxCg9mqIDUr+SDZTSHbDQTIkIG71Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865995; c=relaxed/simple;
	bh=DdP8x/MNppoFZ+OwmrCJXVyb9QsE4TpZlQb9/+XWTv4=;
	h=Date:To:From:Subject:Message-Id; b=CxpVbhScGkRKEqtPVtFQ4mY65vdPM0iTRA7J02ism05CFeUszhKQyL1T+/jc2uvUw7l8HqeTpusp9AuAA9woPzZaw1Lvq66JOIwZ3xayZCwy52YeKcAMQzCMJw7w1Nk1ouCnOc8B6P4iXBR6CpAovlEkFML5S5S99cYC0zgDODk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m79I4inu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m79I4inu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F46B1F000FF;
	Tue, 13 Oct 2026 04:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865994;
	bh=cIrtI0FKpLTjeDWHLUY6oD1WtMOIBw+XL1W8siW6p8g=;
	h=Date:To:From:Subject;
	b=m79I4inuUDyP1biJxU8kmkS8nyjYP9EyezKrXtR85wlWilK14mUsrbeX1krnkw5Aq
	 k15m7MTIe26RTaikt7sINosrkPPdb/DwKhCAVFxBabZZEcX8WE77rvqcpwAgb4hXN/
	 aOYr1RmVdUa9gUsCeaEu+7T07gE5Q+tuxSP8oBwI=
Date: Mon, 12 Oct 2026 21:33:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch removed from -mm tree
Message-Id: <20261013043314.7F46B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: remove special-casing of smap_gather_stats() start parameter
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: remove special-casing of smap_gather_stats() start parameter
Date: Fri, 18 Sep 2026 08:33:15 -0700

smap_gather_stats() interprets its start parameter to mean vma->vm_start
when it's set to 0.  Eliminate this special interpretation and provide two
separate functions for a partial and complete VMA walk.

Since smap_gather_stats() operates within a single VMA, we can replace
walk_page_vma()/walk_page_range() calls with walk_page_range_vma() which
is simpler and also can be called while holding per-VMA lock.

No functional change intended.

Link: https://lore.kernel.org/20260918153318.758387-5-surenb@google.com
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
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

 fs/proc/task_mmu.c |   52 ++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter
+++ a/fs/proc/task_mmu.c
@@ -1250,20 +1250,26 @@ get_smaps_shmem_walk_ops(struct proc_map
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
@@ -1282,20 +1288,31 @@ static void smap_gather_stats(struct pro
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
 
@@ -1346,7 +1363,7 @@ static int show_smap(struct seq_file *m,
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss);
 
 	show_map_vma(m, vma);
 
@@ -1399,7 +1416,7 @@ static int show_smaps_rollup(struct seq_
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1458,14 +1475,15 @@ static int show_smaps_rollup(struct seq_
 
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


