Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D434F3EC2CB;
	Tue, 31 Mar 2026 22:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774996815; cv=none; b=jfv7pfzCzuoecJjxP7ctuI6Qu5O7Hs2Af9IO87s8bMlsNnrk4gcs1TH9Khm7MOpvERMlOYrCH8JMKKgaX0xyA1odKz3HuVrLLbcV/tkjzL2iX4y8EMQYWY2tWZlv+a6BiSCRvWZVCFePsJtiBKsdEHPma/IbbJyGalLDtvdnYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774996815; c=relaxed/simple;
	bh=jB4tWs9RKbmWfxy1lEMujQC5KfUDS5qhAk/bfkV4PAA=;
	h=Date:To:From:Subject:Message-Id; b=eFMSIhl64MOBvJ4KRrMK7TS4NHqauuXzKz46xn6ENH4cHcSfyTjD0g9KMtRiq/kSTpsqmnnAZNR53TcQ+Yt8lTnBTGMhqv7q6pRc9Y9y7iGhoL5i6jRrh01VUH/xeKQyCUvr0cNd//AV+6ROad70A+Q4qCv3oZoB0M8zRbWZa+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hoEM9H/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hoEM9H/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771EBC19423;
	Tue, 31 Mar 2026 22:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774996815;
	bh=jB4tWs9RKbmWfxy1lEMujQC5KfUDS5qhAk/bfkV4PAA=;
	h=Date:To:From:Subject:From;
	b=hoEM9H/cQRc/l4/wePc5OMX20xwLnpq4s8CwMZSiQDwRKLPNWvf1JzUHwS4GHPvja
	 PulBK1hQ2Mr030pypfdDbGjoM3Qv5S2Vq81dYiVEHaT9VRZws7pYMEZQ1YOcNO1r6D
	 QvGShruRRxp6JPsL4RuccVOfNSLJ0H5GgX+NxWZY=
Date: Tue, 31 Mar 2026 15:40:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lirongqing@baidu.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch added to mm-unstable branch
Message-Id: <20260331224015.771EBC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use dedicated unbound workqueues for vmap drain
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/vmalloc: use dedicated unbound workqueues for vmap drain
Date: Tue, 31 Mar 2026 22:23:52 +0200

drain_vmap_area_work() function can take >10ms to complete when there are
many accumulated vmap areas in a system with high CPU count, causing
workqueue watchdog warnings when run via schedule_work():

  workqueue: drain_vmap_area_work hogged CPU for >10000us

Move the top-level drain work to a dedicated WQ_UNBOUND workqueue so the
scheduler can run this background work on any available CPU, improving
responsiveness.  Use the WQ_MEM_RECLAIM to ensure forward progress under
memory pressure.

Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM workqueue. 
This allows drain_vmap_work to wait for helpers completion without
creating dependency on the same rescuer thread and avoid a potential
parent/child deadlock.

Simplify purge helper scheduling by removing cpumask-based iteration to
iterating directly over vmap nodes checking work_queued state.

Link: https://lkml.kernel.org/r/20260331202352.879718-1-urezki@gmail.com
Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   79 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 27 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain
+++ a/mm/vmalloc.c
@@ -949,6 +949,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1067,6 +1068,8 @@ static void reclaim_and_purge_vmap_areas
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_helpers_wq;
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
@@ -2329,6 +2332,16 @@ static void purge_vmap_node(struct work_
 	reclaim_list_global(&local_list);
 }
 
+static bool
+schedule_drain_vmap_work(struct workqueue_struct *wq,
+		struct work_struct *work)
+{
+	if (wq)
+		return queue_work(wq, work);
+
+	return false;
+}
+
 /*
  * Purges all lazily-freed vmap areas.
  */
@@ -2336,19 +2349,12 @@ static bool __purge_vmap_area_lazy(unsig
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
@@ -2368,10 +2374,9 @@ static bool __purge_vmap_area_lazy(unsig
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2379,29 +2384,31 @@ static bool __purge_vmap_area_lazy(unsig
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
+				vn->work_queued = schedule_drain_vmap_work(
+					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
 
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
@@ -2465,7 +2472,8 @@ static void free_vmap_area_noflush(struc
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
+			&drain_vmap_work);
 }
 
 /*
@@ -5483,3 +5491,20 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmalloc_init_workqueue(void)
+{
+	struct workqueue_struct *drain_wq, *helpers_wq;
+	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
+
+	drain_wq = alloc_workqueue("vmap_drain", flags, 0);
+	WARN_ON_ONCE(drain_wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, drain_wq);
+
+	helpers_wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
+	WARN_ON_ONCE(helpers_wq == NULL);
+	WRITE_ONCE(drain_vmap_helpers_wq, helpers_wq);
+
+	return 0;
+}
+early_initcall(vmalloc_init_workqueue);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch
mm-vmalloc-use-dedicated-unbound-workqueue-for-vmap-purge-drain.patch

