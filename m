Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C512FDC57
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 18:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897044; cv=none; b=HgEOTCft1WyxUPLqcFdkgosJ2hxRnHirANYPh58uwwvyPyopfihDDV64BGXOP5Ro3qnMp/JIX0h8/jfDHA6wWlg7lCp0RlU5/x1HaGyRZk5dLWCLWNjIeZVjo5KrnMU7Q3MXqi3LXn4CWKe99uAIBu8Zh8R9ZP1AFy1K3trFxVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897044; c=relaxed/simple;
	bh=jhpFMSf5bdqd8KuOYkwkKF3tZOW1CLWAqbue5DrFlpE=;
	h=Date:To:From:Subject:Message-Id; b=txeh0dNgUM54gRrQYk10newF84Be5sggVD1g5nsuL8hZBLkLJ3n/HimY85dT93S7a7HE9Zb4P48e1l/z2tG3EBOwxfxX9Ynf/dMclAPaCMcl0LoP/HBDIGkxBfq8Hjr8Zeds+EVtHNqK3I0XpaF6Aj7OPp1bmFiJqfV4KvDj7jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgLpjKPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgLpjKPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE0EC4CEF7;
	Mon, 30 Mar 2026 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897043;
	bh=jhpFMSf5bdqd8KuOYkwkKF3tZOW1CLWAqbue5DrFlpE=;
	h=Date:To:From:Subject:From;
	b=rgLpjKPY+o/iXGnHHk8gP6CUSkY0yG7ub/L6d3bT7gWRGgtwCOcxBS2kTpDfEwOdp
	 JGVY5bLcc5uik2pDEGSpkjKZnUjQQtkcPzkA+wuqLm1MBnzgimk2p6PTH/JDNQbIdA
	 lQ6J8RvlpfAaYSzawScOUVPbrzedip+VNsqA+0VM=
Date: Mon, 30 Mar 2026 11:57:23 -0700
To: mm-commits@vger.kernel.org,lirongqing@baidu.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch added to mm-new branch
Message-Id: <20260330185723.BCE0EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use dedicated unbound workqueue for vmap purge/drain
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch

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

mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch

