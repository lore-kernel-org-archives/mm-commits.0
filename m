Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDD8C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C9C22510
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgLODLO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbgLODKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:10:45 -0500
Date:   Mon, 14 Dec 2020 19:08:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001730;
        bh=VADDM4Jsio08GSjwtCVgT/Cn3GfUa01zkDT1U8cHB7k=;
        h=From:To:Subject:In-Reply-To:From;
        b=gH6K4JjONHJZ/ervrwdObFohuvxSnpMzXRfJJXwccqCfxJ1H+Qq9XTI8lmAHh/IrA
         uS2Kubp31pH9zf117Mnl8VMaaB1YYM2uQVb9sRF2Fd4dfHuEiTsHbj6R6lDvO72vBz
         qksTttx4lIMHw1Q1aNBz2TtUqCrDCX85goSthkYo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com,
        huang.ying.caritas@gmail.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 095/200] mm/vmalloc: rework the drain logic
Message-ID: <20201215030849.1tGt5v8fS%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: rework the drain logic

A current "lazy drain" model suffers from at least two issues.

First one is related to the unsorted list of vmap areas, thus in order to
identify the [min:max] range of areas to be drained, it requires a full
list scan.  What is a time consuming if the list is too long.

Second one and as a next step is about merging all fragments with a free
space.  What is also a time consuming because it has to iterate over
entire list which holds outstanding lazy areas.

See below the "preemptirqsoff" tracer that illustrates a high latency.  It
is ~24676us.  Our workloads like audio and video are effected by such long
latency:

<snip>
  tracer: preemptirqsoff

  preemptirqsoff latency trace v1.1.5 on 4.9.186-perf+
  --------------------------------------------------------------------
  latency: 24676 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 P:8)
     -----------------
     | task: crtc_commit:112-261 (uid:0 nice:0 policy:1 rt_prio:16)
     -----------------
   => started at: __purge_vmap_area_lazy
   => ended at:   __purge_vmap_area_lazy

                   _------=> CPU#
                  / _-----=> irqs-off
                 | / _----=> need-resched
                 || / _---=> hardirq/softirq
                 ||| / _--=> preempt-depth
                 |||| /     delay
   cmd     pid   ||||| time  |   caller
      \   /      |||||  \    |   /
crtc_com-261     1...1    1us*: _raw_spin_lock <-__purge_vmap_area_lazy
[...]
crtc_com-261     1...1 24675us : _raw_spin_unlock <-__purge_vmap_area_lazy
crtc_com-261     1...1 24677us : trace_preempt_on <-__purge_vmap_area_lazy
crtc_com-261     1...1 24683us : <stack trace>
 => free_vmap_area_noflush
 => remove_vm_area
 => __vunmap
 => vfree
 => drm_property_free_blob
 => drm_mode_object_unreference
 => drm_property_unreference_blob
 => __drm_atomic_helper_crtc_destroy_state
 => sde_crtc_destroy_state
 => drm_atomic_state_default_clear
 => drm_atomic_state_clear
 => drm_atomic_state_free
 => complete_commit
 => _msm_drm_commit_work_cb
 => kthread_worker_fn
 => kthread
 => ret_from_fork
<snip>

To address those two issues we can redesign a purging of the outstanding
lazy areas.  Instead of queuing vmap areas to the list, we replace it by
the separate rb-tree.  In hat case an area is located in the tree/list in
ascending order.  It will give us below advantages:

a) Outstanding vmap areas are merged creating bigger coalesced blocks,
   thus it becomes less fragmented.

b) It is possible to calculate a flush range [min:max] without scanning
   all elements.  It is O(1) access time or complexity;

c) The final merge of areas with the rb-tree that represents a free
   space is faster because of (a).  As a result the lock contention is
   also reduced.

Link: https://lkml.kernel.org/r/20201116220033.1837-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: huang ying <huang.ying.caritas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    8 +--
 mm/vmalloc.c            |   90 +++++++++++++++++++++-----------------
 2 files changed, 53 insertions(+), 45 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-rework-the-drain-logic
+++ a/include/linux/vmalloc.h
@@ -72,16 +72,14 @@ struct vmap_area {
 	struct list_head list;          /* address sorted list */
 
 	/*
-	 * The following three variables can be packed, because
-	 * a vmap_area object is always one of the three states:
+	 * The following two variables can be packed, because
+	 * a vmap_area object can be either:
 	 *    1) in "free" tree (root is vmap_area_root)
-	 *    2) in "busy" tree (root is free_vmap_area_root)
-	 *    3) in purge list  (head is vmap_purge_list)
+	 *    2) or "busy" tree (root is free_vmap_area_root)
 	 */
 	union {
 		unsigned long subtree_max_size; /* in "free" tree */
 		struct vm_struct *vm;           /* in "busy" tree */
-		struct llist_node purge_list;   /* in purge list */
 	};
 };
 
--- a/mm/vmalloc.c~mm-vmalloc-rework-the-drain-logic
+++ a/mm/vmalloc.c
@@ -413,10 +413,13 @@ static DEFINE_SPINLOCK(vmap_area_lock);
 static DEFINE_SPINLOCK(free_vmap_area_lock);
 /* Export for kexec only */
 LIST_HEAD(vmap_area_list);
-static LLIST_HEAD(vmap_purge_list);
 static struct rb_root vmap_area_root = RB_ROOT;
 static bool vmap_initialized __read_mostly;
 
+static struct rb_root purge_vmap_area_root = RB_ROOT;
+static LIST_HEAD(purge_vmap_area_list);
+static DEFINE_SPINLOCK(purge_vmap_area_lock);
+
 /*
  * This kmem_cache is used for vmap_area objects. Instead of
  * allocating from slab we reuse an object from this cache to
@@ -820,10 +823,17 @@ insert:
 	if (!merged)
 		link_va(va, root, parent, link, head);
 
-	/*
-	 * Last step is to check and update the tree.
-	 */
-	augment_tree_propagate_from(va);
+	return va;
+}
+
+static __always_inline struct vmap_area *
+merge_or_add_vmap_area_augment(struct vmap_area *va,
+	struct rb_root *root, struct list_head *head)
+{
+	va = merge_or_add_vmap_area(va, root, head);
+	if (va)
+		augment_tree_propagate_from(va);
+
 	return va;
 }
 
@@ -1138,7 +1148,7 @@ static void free_vmap_area(struct vmap_a
 	 * Insert/Merge it back to the free tree/list.
 	 */
 	spin_lock(&free_vmap_area_lock);
-	merge_or_add_vmap_area(va, &free_vmap_area_root, &free_vmap_area_list);
+	merge_or_add_vmap_area_augment(va, &free_vmap_area_root, &free_vmap_area_list);
 	spin_unlock(&free_vmap_area_lock);
 }
 
@@ -1326,32 +1336,32 @@ void set_iounmap_nonlazy(void)
 static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 {
 	unsigned long resched_threshold;
-	struct llist_node *valist;
-	struct vmap_area *va;
-	struct vmap_area *n_va;
+	struct list_head local_pure_list;
+	struct vmap_area *va, *n_va;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
-	valist = llist_del_all(&vmap_purge_list);
-	if (unlikely(valist == NULL))
+	spin_lock(&purge_vmap_area_lock);
+	purge_vmap_area_root = RB_ROOT;
+	list_replace_init(&purge_vmap_area_list, &local_pure_list);
+	spin_unlock(&purge_vmap_area_lock);
+
+	if (unlikely(list_empty(&local_pure_list)))
 		return false;
 
-	/*
-	 * TODO: to calculate a flush range without looping.
-	 * The list can be up to lazy_max_pages() elements.
-	 */
-	llist_for_each_entry(va, valist, purge_list) {
-		if (va->va_start < start)
-			start = va->va_start;
-		if (va->va_end > end)
-			end = va->va_end;
-	}
+	start = min(start,
+		list_first_entry(&local_pure_list,
+			struct vmap_area, list)->va_start);
+
+	end = max(end,
+		list_last_entry(&local_pure_list,
+			struct vmap_area, list)->va_end);
 
 	flush_tlb_kernel_range(start, end);
 	resched_threshold = lazy_max_pages() << 1;
 
 	spin_lock(&free_vmap_area_lock);
-	llist_for_each_entry_safe(va, n_va, valist, purge_list) {
+	list_for_each_entry_safe(va, n_va, &local_pure_list, list) {
 		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
 		unsigned long orig_start = va->va_start;
 		unsigned long orig_end = va->va_end;
@@ -1361,8 +1371,8 @@ static bool __purge_vmap_area_lazy(unsig
 		 * detached and there is no need to "unlink" it from
 		 * anything.
 		 */
-		va = merge_or_add_vmap_area(va, &free_vmap_area_root,
-					    &free_vmap_area_list);
+		va = merge_or_add_vmap_area_augment(va, &free_vmap_area_root,
+				&free_vmap_area_list);
 
 		if (!va)
 			continue;
@@ -1419,9 +1429,15 @@ static void free_vmap_area_noflush(struc
 	nr_lazy = atomic_long_add_return((va->va_end - va->va_start) >>
 				PAGE_SHIFT, &vmap_lazy_nr);
 
-	/* After this point, we may free va at any time */
-	llist_add(&va->purge_list, &vmap_purge_list);
+	/*
+	 * Merge or place it to the purge tree/list.
+	 */
+	spin_lock(&purge_vmap_area_lock);
+	merge_or_add_vmap_area(va,
+		&purge_vmap_area_root, &purge_vmap_area_list);
+	spin_unlock(&purge_vmap_area_lock);
 
+	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > lazy_max_pages()))
 		try_purge_vmap_area_lazy();
 }
@@ -3351,8 +3367,8 @@ recovery:
 	while (area--) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		va = merge_or_add_vmap_area(vas[area], &free_vmap_area_root,
-					    &free_vmap_area_list);
+		va = merge_or_add_vmap_area_augment(vas[area], &free_vmap_area_root,
+				&free_vmap_area_list);
 		if (va)
 			kasan_release_vmalloc(orig_start, orig_end,
 				va->va_start, va->va_end);
@@ -3401,8 +3417,8 @@ err_free_shadow:
 	for (area = 0; area < nr_vms; area++) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		va = merge_or_add_vmap_area(vas[area], &free_vmap_area_root,
-					    &free_vmap_area_list);
+		va = merge_or_add_vmap_area_augment(vas[area], &free_vmap_area_root,
+				&free_vmap_area_list);
 		if (va)
 			kasan_release_vmalloc(orig_start, orig_end,
 				va->va_start, va->va_end);
@@ -3482,18 +3498,15 @@ static void show_numa_info(struct seq_fi
 
 static void show_purge_info(struct seq_file *m)
 {
-	struct llist_node *head;
 	struct vmap_area *va;
 
-	head = READ_ONCE(vmap_purge_list.first);
-	if (head == NULL)
-		return;
-
-	llist_for_each_entry(va, head, purge_list) {
+	spin_lock(&purge_vmap_area_lock);
+	list_for_each_entry(va, &purge_vmap_area_list, list) {
 		seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start);
 	}
+	spin_unlock(&purge_vmap_area_lock);
 }
 
 static int s_show(struct seq_file *m, void *p)
@@ -3551,10 +3564,7 @@ static int s_show(struct seq_file *m, vo
 	seq_putc(m, '\n');
 
 	/*
-	 * As a final step, dump "unpurged" areas. Note,
-	 * that entire "/proc/vmallocinfo" output will not
-	 * be address sorted, because the purge list is not
-	 * sorted.
+	 * As a final step, dump "unpurged" areas.
 	 */
 	if (list_is_last(&va->list, &vmap_area_list))
 		show_purge_info(m);
_
