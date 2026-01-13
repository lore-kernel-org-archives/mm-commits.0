Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E9C241690
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345003; cv=none; b=nWlBU0EX92iiryVLdPAS42rOlsi7pUzfTNky2hSOSpT7j2rWKuKEndHsNRmdITqKcAhhXsPR/Jlt1Wjsnsw02VJ8YcQ3RBd9lmZfLWWJmhAJzpCkjVNQiLstvnNr9A+JiHjaLRCRYU3SULnohUpPVKVMTlIJy2SXDacX+V4TnlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345003; c=relaxed/simple;
	bh=2sPjBMgeXKyXRQ8raOymnenXw7vTWmpgAqbcjeaOcoU=;
	h=Date:To:From:Subject:Message-Id; b=Mp6BgnFfNA9cg+C1+C227sgmNvdB7xoUKQ7VtjUo7RRFc+Uw/YUA82qJuzFxIOgHuvA5UmydJjG61v5/DrJyKqj6B5BND8ecLYFH6W32QA9Mxc0YOfJ8tQDhK/+RuEITPk2S8PCGmIk4I2/FYEaLglVXTTQ9c0C1nyvvSTyhbNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mEK3Ogao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mEK3Ogao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0A7C116C6;
	Tue, 13 Jan 2026 22:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345003;
	bh=2sPjBMgeXKyXRQ8raOymnenXw7vTWmpgAqbcjeaOcoU=;
	h=Date:To:From:Subject:From;
	b=mEK3OgaoeTuKMoLoxS/Zs+fOPNTJSerMnkmHcBxK+IxCX9GhpsDZpP4v9Wzs/XVq5
	 bbbBRehna393ZRGLSppRTua/AZLVIISk2Gf1FyrhUJZVsVVB84/lOjqqxQz4oznLSM
	 BPYANEq/o24ocOZsDvQtuKH9KzIc2LsDSurUutUY=
Date: Tue, 13 Jan 2026 14:56:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,marco.crivellari@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch added to mm-new branch
Message-Id: <20260113225643.0E0A7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace use of system_unbound_wq with system_dfl_wq
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Marco Crivellari <marco.crivellari@suse.com>
Subject: mm: replace use of system_unbound_wq with system_dfl_wq
Date: Tue, 13 Jan 2026 12:46:28 +0100

Patch series "Replace wq users and add WQ_PERCPU to alloc_workqueue()
users", v2.

This series continues the effort to refactor the Workqueue API.  No
behavior changes are introduced by this series.

=== Recent changes to the WQ API ===

The following, address the recent changes in the Workqueue API:

- commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
- commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The old workqueues will be removed in a future release cycle and
unbound will become the implicit default.

=== Introduced Changes by this series ===

1) [P 1-2] Replace use of system_wq and system_unbound_wq

    Workqueue users converted to the better named new workqueues:

        system_wq -> system_percpu_wq
        system_unbound_wq -> system_dfl_wq

    This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
    removed in the future.

2) [P 3] add WQ_PERCPU to remaining alloc_workqueue() users

    With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
    any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
    must now use WQ_PERCPU.

    WQ_UNBOUND will be removed in future.

For more information:
    https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/


This patch (of 3):

This patch continues the effort to refactor workqueue APIs, which has
begun with the changes introducing new workqueues and a new
alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior
of workqueues to become unbound by default so that their workload
placement is optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better
named new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lkml.kernel.org/r/20260113114630.152942-1-marco.crivellari@suse.com
Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Link: https://lkml.kernel.org/r/20260113114630.152942-2-marco.crivellari@suse.com
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 mm/kfence/core.c |    6 +++---
 mm/memcontrol.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/backing-dev.c~mm-replace-use-of-system_unbound_wq-with-system_dfl_wq
+++ a/mm/backing-dev.c
@@ -939,7 +939,7 @@ void wb_memcg_offline(struct mem_cgroup
 	memcg_cgwb_list->next = NULL;	/* prevent new wb's */
 	spin_unlock_irq(&cgwb_lock);
 
-	queue_work(system_unbound_wq, &cleanup_offline_cgwbs_work);
+	queue_work(system_dfl_wq, &cleanup_offline_cgwbs_work);
 }
 
 /**
--- a/mm/kfence/core.c~mm-replace-use-of-system_unbound_wq-with-system_dfl_wq
+++ a/mm/kfence/core.c
@@ -878,7 +878,7 @@ static void toggle_allocation_gate(struc
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	queue_delayed_work(system_unbound_wq, &kfence_timer,
+	queue_delayed_work(system_dfl_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
 
@@ -928,7 +928,7 @@ static void kfence_init_enable(void)
 #endif
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
@@ -1024,7 +1024,7 @@ static int kfence_enable_late(void)
 		return kfence_init_late();
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 	pr_info("re-enabled\n");
 	return 0;
 }
--- a/mm/memcontrol.c~mm-replace-use-of-system_unbound_wq-with-system_dfl_wq
+++ a/mm/memcontrol.c
@@ -644,7 +644,7 @@ static void flush_memcg_stats_dwork(stru
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	__mem_cgroup_flush_stats(root_mem_cgroup, true);
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
+	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
@@ -3841,7 +3841,7 @@ static int mem_cgroup_css_online(struct
 		goto offline_kmem;
 
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
-		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
+		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
_

Patches currently in -mm which might be from marco.crivellari@suse.com are

mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch
mm-replace-use-of-system_wq-with-system_percpu_wq.patch
mm-add-wq_percpu-to-alloc_workqueue-users.patch

