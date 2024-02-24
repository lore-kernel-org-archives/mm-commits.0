Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2674A3C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739374; cv=none; b=uBBkfl7bVWAv3bOHGEksICwSRUGPTuNG7xeFn3e2RPKnw7w5cyPsEbe/83I7WWJCuGJvbgfbppZsFGnCxdGUKk5bePs+yHsQsrBXCQbx4vk9QDwvG05d9wir+JgN/Egi+Gyk7QrTUQQ+qGnQKWZWxPc7b0wXUeKxeu10siva6RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739374; c=relaxed/simple;
	bh=mZewUPduSwP2Q7NdnL9gyS9PNqsCoumHLFbVt66/rE0=;
	h=Date:To:From:Subject:Message-Id; b=qmAuk2xpC+rtlfQWe9Zkso0hrIVbncG6ELYQAIoxaAR86bNL/PwRdekyvRXbLeIfPKev95ARHpNTyMaTZtq+srbKPj6fWwSGEETxHIIb4qAEtXmVT4b00IpS6FjleGiWeG6hPmr1FFSoNV6X4gADEdycksmYy7DlRelZt8csjIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=At+L0duM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="At+L0duM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213BFC433C7;
	Sat, 24 Feb 2024 01:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739374;
	bh=mZewUPduSwP2Q7NdnL9gyS9PNqsCoumHLFbVt66/rE0=;
	h=Date:To:From:Subject:From;
	b=At+L0duMSDFhF5fe8I8uKV4PiTz3KS0dva5BSSoxSwadf8HMN647BudMjCTBg4n86
	 Se50uZtqoGLBv9fvEIL87xMFplZ927sBDjgAb5nGgLfaV9wtb48M3MAVw8uJk0j00N
	 GluBerNZTDm67h7qafXj7Pd4Uug7XGF57tpWh9UA=
Date: Fri, 23 Feb 2024 17:49:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch removed from -mm tree
Message-Id: <20240224014934.213BFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: remove global purge_vmap_area_root rb-tree
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: remove global purge_vmap_area_root rb-tree
Date: Tue, 2 Jan 2024 19:46:28 +0100

Similar to busy VA, lazily-freed area is stored to a node it belongs to. 
Such approach does not require any global locking primitive, instead an
access becomes scalable what mitigates a contention.

This patch removes a global purge-lock, global purge-tree and global purge
list.

Link: https://lkml.kernel.org/r/20240102184633.748113-7-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  135 +++++++++++++++++++++++++++++--------------------
 1 file changed, 82 insertions(+), 53 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree
+++ a/mm/vmalloc.c
@@ -731,10 +731,6 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 static DEFINE_SPINLOCK(free_vmap_area_lock);
 static bool vmap_initialized __read_mostly;
 
-static struct rb_root purge_vmap_area_root = RB_ROOT;
-static LIST_HEAD(purge_vmap_area_list);
-static DEFINE_SPINLOCK(purge_vmap_area_lock);
-
 /*
  * This kmem_cache is used for vmap_area objects. Instead of
  * allocating from slab we reuse an object from this cache to
@@ -782,6 +778,12 @@ struct rb_list {
 static struct vmap_node {
 	/* Bookkeeping data of this node. */
 	struct rb_list busy;
+	struct rb_list lazy;
+
+	/*
+	 * Ready-to-free areas.
+	 */
+	struct list_head purge_list;
 } single;
 
 static struct vmap_node *vmap_nodes = &single;
@@ -1766,40 +1768,22 @@ static DEFINE_MUTEX(vmap_purge_lock);
 
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
+static cpumask_t purge_nodes;
 
 /*
  * Purges all lazily-freed vmap areas.
  */
-static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
+static unsigned long
+purge_vmap_node(struct vmap_node *vn)
 {
-	unsigned long resched_threshold;
-	unsigned int num_purged_areas = 0;
-	struct list_head local_purge_list;
+	unsigned long num_purged_areas = 0;
 	struct vmap_area *va, *n_va;
 
-	lockdep_assert_held(&vmap_purge_lock);
-
-	spin_lock(&purge_vmap_area_lock);
-	purge_vmap_area_root = RB_ROOT;
-	list_replace_init(&purge_vmap_area_list, &local_purge_list);
-	spin_unlock(&purge_vmap_area_lock);
-
-	if (unlikely(list_empty(&local_purge_list)))
-		goto out;
-
-	start = min(start,
-		list_first_entry(&local_purge_list,
-			struct vmap_area, list)->va_start);
-
-	end = max(end,
-		list_last_entry(&local_purge_list,
-			struct vmap_area, list)->va_end);
-
-	flush_tlb_kernel_range(start, end);
-	resched_threshold = lazy_max_pages() << 1;
+	if (list_empty(&vn->purge_list))
+		return 0;
 
 	spin_lock(&free_vmap_area_lock);
-	list_for_each_entry_safe(va, n_va, &local_purge_list, list) {
+	list_for_each_entry_safe(va, n_va, &vn->purge_list, list) {
 		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
 		unsigned long orig_start = va->va_start;
 		unsigned long orig_end = va->va_end;
@@ -1821,13 +1805,55 @@ static bool __purge_vmap_area_lazy(unsig
 
 		atomic_long_sub(nr, &vmap_lazy_nr);
 		num_purged_areas++;
-
-		if (atomic_long_read(&vmap_lazy_nr) < resched_threshold)
-			cond_resched_lock(&free_vmap_area_lock);
 	}
 	spin_unlock(&free_vmap_area_lock);
 
-out:
+	return num_purged_areas;
+}
+
+/*
+ * Purges all lazily-freed vmap areas.
+ */
+static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
+{
+	unsigned long num_purged_areas = 0;
+	struct vmap_node *vn;
+	int i;
+
+	lockdep_assert_held(&vmap_purge_lock);
+	purge_nodes = CPU_MASK_NONE;
+
+	for (i = 0; i < nr_vmap_nodes; i++) {
+		vn = &vmap_nodes[i];
+
+		INIT_LIST_HEAD(&vn->purge_list);
+
+		if (RB_EMPTY_ROOT(&vn->lazy.root))
+			continue;
+
+		spin_lock(&vn->lazy.lock);
+		WRITE_ONCE(vn->lazy.root.rb_node, NULL);
+		list_replace_init(&vn->lazy.head, &vn->purge_list);
+		spin_unlock(&vn->lazy.lock);
+
+		start = min(start, list_first_entry(&vn->purge_list,
+			struct vmap_area, list)->va_start);
+
+		end = max(end, list_last_entry(&vn->purge_list,
+			struct vmap_area, list)->va_end);
+
+		cpumask_set_cpu(i, &purge_nodes);
+	}
+
+	if (cpumask_weight(&purge_nodes) > 0) {
+		flush_tlb_kernel_range(start, end);
+
+		for_each_cpu(i, &purge_nodes) {
+			vn = &nodes[i];
+			num_purged_areas += purge_vmap_node(vn);
+		}
+	}
+
 	trace_purge_vmap_area_lazy(start, end, num_purged_areas);
 	return num_purged_areas > 0;
 }
@@ -1846,16 +1872,9 @@ static void reclaim_and_purge_vmap_areas
 
 static void drain_vmap_area_work(struct work_struct *work)
 {
-	unsigned long nr_lazy;
-
-	do {
-		mutex_lock(&vmap_purge_lock);
-		__purge_vmap_area_lazy(ULONG_MAX, 0);
-		mutex_unlock(&vmap_purge_lock);
-
-		/* Recheck if further work is required. */
-		nr_lazy = atomic_long_read(&vmap_lazy_nr);
-	} while (nr_lazy > lazy_max_pages());
+	mutex_lock(&vmap_purge_lock);
+	__purge_vmap_area_lazy(ULONG_MAX, 0);
+	mutex_unlock(&vmap_purge_lock);
 }
 
 /*
@@ -1865,6 +1884,7 @@ static void drain_vmap_area_work(struct
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
+	struct vmap_node *vn = addr_to_node(va->va_start);
 	unsigned long nr_lazy_max = lazy_max_pages();
 	unsigned long va_start = va->va_start;
 	unsigned long nr_lazy;
@@ -1878,10 +1898,9 @@ static void free_vmap_area_noflush(struc
 	/*
 	 * Merge or place it to the purge tree/list.
 	 */
-	spin_lock(&purge_vmap_area_lock);
-	merge_or_add_vmap_area(va,
-		&purge_vmap_area_root, &purge_vmap_area_list);
-	spin_unlock(&purge_vmap_area_lock);
+	spin_lock(&vn->lazy.lock);
+	merge_or_add_vmap_area(va, &vn->lazy.root, &vn->lazy.head);
+	spin_unlock(&vn->lazy.lock);
 
 	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
 
@@ -4411,15 +4430,21 @@ static void show_numa_info(struct seq_fi
 
 static void show_purge_info(struct seq_file *m)
 {
+	struct vmap_node *vn;
 	struct vmap_area *va;
+	int i;
 
-	spin_lock(&purge_vmap_area_lock);
-	list_for_each_entry(va, &purge_vmap_area_list, list) {
-		seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
-			(void *)va->va_start, (void *)va->va_end,
-			va->va_end - va->va_start);
+	for (i = 0; i < nr_vmap_nodes; i++) {
+		vn = &vmap_nodes[i];
+
+		spin_lock(&vn->lazy.lock);
+		list_for_each_entry(va, &vn->lazy.head, list) {
+			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
+				(void *)va->va_start, (void *)va->va_end,
+				va->va_end - va->va_start);
+		}
+		spin_unlock(&vn->lazy.lock);
 	}
-	spin_unlock(&purge_vmap_area_lock);
 }
 
 static int s_show(struct seq_file *m, void *p)
@@ -4558,6 +4583,10 @@ static void vmap_init_nodes(void)
 		vn->busy.root = RB_ROOT;
 		INIT_LIST_HEAD(&vn->busy.head);
 		spin_lock_init(&vn->busy.lock);
+
+		vn->lazy.root = RB_ROOT;
+		INIT_LIST_HEAD(&vn->lazy.head);
+		spin_lock_init(&vn->lazy.lock);
 	}
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are


