Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27733BD225;
	Sat,  5 Sep 2026 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788647832; cv=none; b=a89VM6oDxut2BXkXs9Fq/7OfGVp0z0gK8wtQnF3/eSlh9HqLb0KqE6vYcQIy14O/fDczBZXPADiPxqARQS3iRrNcfwQxT1Va9bBtubugpiHtHLgbHIX4vcz7iLdvVlP8I9eci8J58cGaW5YV4bB6ELIhQpe/OZeS5RImG9fuSZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788647832; c=relaxed/simple;
	bh=TDZBe3K2y+xusvqebvTwPITby/fTQjvc/nYQ4EvouH0=;
	h=Date:To:From:Subject:Message-Id; b=dnA5+1wOvym04PKgFOOjCSUx6Toi5vHNTIj+I/12ciEwQy1ZimisWPofvwFR+NakA1hejGZ7ErnVZLxb8VoXqJe3OsfEn+9Re5U/TNfhHIXdg9XRzdL9ASPhlqynXEsHl1W3NTFMyzJ2OGGlpuAaOACTkaura+SkRrDlfLGr1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGEJxIGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGEJxIGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E831F00A3A;
	Sat,  5 Sep 2026 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788647828;
	bh=13KKOz3h23gnp5fdzIYBI8sV2lLVGljxLq6/oo4Wqvk=;
	h=Date:To:From:Subject;
	b=HGEJxIGZWxGiCSJDyemFlDMaJsWKOyo27UJPf6Uu3zqq22cWPnG2Z2k1ce/WYDo5C
	 ve4CRrVlGYBTTjFhSaDBQpQBFn3FUUzvSbXu3HDG/MwG1YL3O046hs6lt0J7g2MiSi
	 HHOSIvTeYYqs5TEhGa00cRL84fMOgnXED8AIxAIo=
Date: Sat, 05 Sep 2026 15:37:08 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,stable@vger.kernel.org,lirongqing@baidu.com,dev.jain@arm.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch added to mm-hotfixes-unstable branch
Message-Id: <20260905223708.66E831F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: ase dedicated unbound workqueues for vmap drain
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/vmalloc: ase dedicated unbound workqueues for vmap drain
Date: Sat, 5 Sep 2026 17:27:17 +0200

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

Link: https://lore.kernel.org/20260905152717.11711-1-urezki@gmail.com
Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: Li RongQing <lirongqing@baidu.com>
Closes: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   79 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 27 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain
+++ a/mm/vmalloc.c
@@ -972,6 +972,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1090,6 +1091,8 @@ static void reclaim_and_purge_vmap_areas
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_helpers_wq;
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
@@ -2351,6 +2354,16 @@ static void purge_vmap_node(struct work_
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
@@ -2358,19 +2371,12 @@ static bool __purge_vmap_area_lazy(unsig
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
@@ -2390,10 +2396,9 @@ static bool __purge_vmap_area_lazy(unsig
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2401,29 +2406,31 @@ static bool __purge_vmap_area_lazy(unsig
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
@@ -2487,7 +2494,8 @@ static void free_vmap_area_noflush(struc
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
+			&drain_vmap_work);
 }
 
 /*
@@ -5587,3 +5595,20 @@ void __init vmalloc_init(void)
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

