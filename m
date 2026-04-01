Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3089382293
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775078845; cv=none; b=jA0uQ/mDXl4vYAzA/DSoCn/xsIfIaqq0ut9bMra6maERb7hS2Cbq2iK5nBkmB4DeCtdhThV1xpbu9sSIG7RE6jHt8JqUWp+ja5EozPnzpwQwjt59/3+ER2fGdXK1mDdTauc3zE5qZ8JF8ngGDYZqD3vy6sCUvt2a/edk2GbcQB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775078845; c=relaxed/simple;
	bh=J/TIdmUtFJdK5/8BsU0cu92BYLbRa8DXMvkEFCTE7jI=;
	h=Date:To:From:Subject:Message-Id; b=PGizNXDgPqbszur/KTAE++PEYSgRW/OhFd7BpZL3N4k1yafYK9i2gj8z6wIzTdY0n570Afv0ordRNWcjvxAJodrG0C8XHBZI95nlkpeXz9u1KeuQiSsNC1D71sSB/sYivTQZTw3EbjbV205iyQ1Mzzv8jfo9z0U5M79rgrSAJ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyq1C6OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyq1C6OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4212EC4CEF7;
	Wed,  1 Apr 2026 21:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775078845;
	bh=J/TIdmUtFJdK5/8BsU0cu92BYLbRa8DXMvkEFCTE7jI=;
	h=Date:To:From:Subject:From;
	b=yyq1C6ORa0svXAq52QtfDJAnwDpQ7OYnuIJAUu+OwnxNJwvOF9EUNO36iAzsB9ejs
	 +wjA7f6g3rv0jDfml6UDBfBQmoy3IFmQNRBCShpzXMOraTqhtgXQax6x0ogWrXF0wR
	 SBcyPD1eJmxY0CiqksbaqMd4Db0EohXUYtYDjeBE=
Date: Wed, 01 Apr 2026 14:27:24 -0700
To: mm-commits@vger.kernel.org,lirongqing@baidu.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch removed from -mm tree
Message-Id: <20260401212725.4212EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use dedicated unbound workqueue for vmap purge/drain
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: use dedicated unbound workqueue for vmap purge/drain
Date: Mon, 30 Mar 2026 19:58:24 +0200

The drain_vmap_area_work() function can take >10ms to complete when there
are many accumulated vmap areas in a system with a high CPU count, causing
workqueue watchdog warnings when run via schedule_work():

[ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND

Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to run
this background task on any available CPU, improving responsiveness.  Use
WQ_MEM_RECLAIM to ensure forward progress under memory pressure.

If queuing work to the dedicated workqueue is not possible(during early
boot), fall back to processing locally to avoid losing progress.

Also simplify purge helper scheduling by removing cpumask-based iteration
in favour to iterating directly over vmap nodes with pending work.

Link: https://lkml.kernel.org/r/20260330175824.2777270-1-urezki@gmail.com
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   74 +++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 27 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain
+++ a/mm/vmalloc.c
@@ -949,6 +949,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1067,6 +1068,7 @@ static void reclaim_and_purge_vmap_areas
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
@@ -2329,6 +2331,19 @@ static void purge_vmap_node(struct work_
 	reclaim_list_global(&local_list);
 }
 
+static bool
+schedule_drain_vmap_work(struct work_struct *work)
+{
+	struct workqueue_struct *wq = READ_ONCE(drain_vmap_wq);
+
+	if (wq) {
+		queue_work(wq, work);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Purges all lazily-freed vmap areas.
  */
@@ -2336,19 +2351,12 @@ static bool __purge_vmap_area_lazy(unsig
 		bool full_pool_decay)
 {
 	unsigned long nr_purged_areas = 0;
+	unsigned int nr_purge_nodes = 0;
 	unsigned int nr_purge_helpers;
-	static cpumask_t purge_nodes;
-	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
-	int i;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
-	/*
-	 * Use cpumask to mark which node has to be processed.
-	 */
-	purge_nodes = CPU_MASK_NONE;
-
 	for_each_vmap_node(vn) {
 		INIT_LIST_HEAD(&vn->purge_list);
 		vn->skip_populate = full_pool_decay;
@@ -2368,10 +2376,9 @@ static bool __purge_vmap_area_lazy(unsig
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2379,29 +2386,30 @@ static bool __purge_vmap_area_lazy(unsig
 		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
 		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
 
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
+		for_each_vmap_node(vn) {
+			vn->work_queued = false;
+
+			if (list_empty(&vn->purge_list))
+				continue;
 
 			if (nr_purge_helpers > 0) {
 				INIT_WORK(&vn->purge_work, purge_vmap_node);
+				vn->work_queued = schedule_drain_vmap_work(&vn->purge_work);
 
-				if (cpumask_test_cpu(i, cpu_online_mask))
-					schedule_work_on(i, &vn->purge_work);
-				else
-					schedule_work(&vn->purge_work);
-
-				nr_purge_helpers--;
-			} else {
-				vn->purge_work.func = NULL;
-				purge_vmap_node(&vn->purge_work);
-				nr_purged_areas += vn->nr_purged;
+				if (vn->work_queued) {
+					nr_purge_helpers--;
+					continue;
+				}
 			}
-		}
 
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
+			/* Sync path. Process locally. */
+			purge_vmap_node(&vn->purge_work);
+			nr_purged_areas += vn->nr_purged;
+		}
 
-			if (vn->purge_work.func) {
+		/* Wait for completion if queued any. */
+		for_each_vmap_node(vn) {
+			if (vn->work_queued) {
 				flush_work(&vn->purge_work);
 				nr_purged_areas += vn->nr_purged;
 			}
@@ -2465,7 +2473,7 @@ static void free_vmap_area_noflush(struc
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(&drain_vmap_work);
 }
 
 /*
@@ -5483,3 +5491,15 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmalloc_init_workqueue(void)
+{
+	struct workqueue_struct *wq;
+
+	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, wq);
+
+	return 0;
+}
+early_initcall(vmalloc_init_workqueue);
_

Patches currently in -mm which might be from urezki@gmail.com are


