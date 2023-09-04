Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC441C83F3E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbjIDTyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbjIDTyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B78E5C
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3305BB80EF3
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EB1C433C7;
        Mon,  4 Sep 2023 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857244;
        bh=BPqh229F+8hGEN3SbSWUJBmx/fLR7Z41yGSrdWvbv2w=;
        h=Date:To:From:Subject:From;
        b=CDpXE4N7plxCQfR51WcioEmUsrKVjGmr+0LKdOCS0DfuTYaLfjyMsWGJOQl2cSuNp
         8JA4Jg46OwtUt4fRLRXHCSKqaJ5/jC/90Rd03fXxqXUAmxhH/tn94Y0bftKP0OYhn9
         +UxXv6OVEBQ3XpxucjbtOyd7Cz7ER3Vh1tUvgNjI=
Date:   Mon, 04 Sep 2023 12:54:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch added to mm-unstable branch
Message-Id: <20230904195403.D9EB1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: remove global purge_vmap_area_root rb-tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: remove global purge_vmap_area_root rb-tree
Date: Tue, 29 Aug 2023 10:11:38 +0200

Similar to busy VA, lazily-freed area is stored to a node it belongs to. 
Such approach does not require any global locking primitive, instead an
access becomes scalable what mitigates a contention.

This patch removes a global purge-lock, global purge-tree and global purge
list.

Link: https://lkml.kernel.org/r/20230829081142.3619-6-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
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
@@ -733,10 +733,6 @@ static DEFINE_SPINLOCK(free_vmap_area_lo
 LIST_HEAD(vmap_area_list);
 static bool vmap_initialized __read_mostly;
 
-static struct rb_root purge_vmap_area_root = RB_ROOT;
-static LIST_HEAD(purge_vmap_area_list);
-static DEFINE_SPINLOCK(purge_vmap_area_lock);
-
 /*
  * This kmem_cache is used for vmap_area objects. Instead of
  * allocating from slab we reuse an object from this cache to
@@ -784,6 +780,12 @@ struct rb_list {
 struct vmap_node {
 	/* Bookkeeping data of this node. */
 	struct rb_list busy;
+	struct rb_list lazy;
+
+	/*
+	 * Ready-to-free areas.
+	 */
+	struct list_head purge_list;
 };
 
 static struct vmap_node *nodes, snode;
@@ -1768,40 +1770,22 @@ static DEFINE_MUTEX(vmap_purge_lock);
 
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
@@ -1823,13 +1807,55 @@ static bool __purge_vmap_area_lazy(unsig
 
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
+	for (i = 0; i < nr_nodes; i++) {
+		vn = &nodes[i];
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
@@ -1848,16 +1874,9 @@ static void reclaim_and_purge_vmap_areas
 
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
@@ -1867,6 +1886,7 @@ static void drain_vmap_area_work(struct
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
+	struct vmap_node *vn = addr_to_node(va->va_start);
 	unsigned long nr_lazy_max = lazy_max_pages();
 	unsigned long va_start = va->va_start;
 	unsigned long nr_lazy;
@@ -1880,10 +1900,9 @@ static void free_vmap_area_noflush(struc
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
 
@@ -4412,15 +4431,21 @@ static void show_numa_info(struct seq_fi
 
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
+	for (i = 0; i < nr_nodes; i++) {
+		vn = &nodes[i];
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
@@ -4567,6 +4592,10 @@ static void vmap_init_nodes(void)
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

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

