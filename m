Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E883EC807
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545409; cv=none; b=ZRkHdFiX8blsbPoyxWLrg2kfsjT6vRx392TGxY4+TBTgEjdHKqu7dVCScyHJFlA5heS/REjqgdYq5mHcZt2DER4L9UkSEZWrtlNZqZyKcpF+v7KpznPL0HlKeNPV5FYz+2l2gygJCG5JbJxMjta7iSjBzNZJA3e75tVhcArUpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545409; c=relaxed/simple;
	bh=SeBzVDEoF8P4hnaLWma2gtJ8FzWRlnwYDtK150UxNRA=;
	h=Date:To:From:Subject:Message-Id; b=S71PoBZ8t4iG/DAYPUmcmDU9UYukahG/6rQJp9W64pE3uY0Tno3EJQSmDrv7T5MaaIcQYGuOi18cfzvf6qUwM1KoFoVPeAFU3F34oXOEQThHq3SmUorsIYQ66AKbKv5Lu6hrjn7mti5TVTQu33lE2fumAOEL210uUe4VbntafXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZx3VQpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZx3VQpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC321F00A3D;
	Fri,  4 Sep 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788545401;
	bh=GWTATCEWDL3lTk0md655kiukdCQod1bxJ3TY65tnO30=;
	h=Date:To:From:Subject;
	b=yZx3VQpYLGSwaXMiQuecX0EYBJi7duA5awAgu/I6clJaR07wTTipfOa8/RbTtFaJE
	 jwsBmXEe+E3KUot+Aq9K1fpz27qcsSPEH/NDnK2O5qKfANyaHzyHepXP7Vkw1cnAbi
	 kZaISUIPLj6BXxNpLIaz6p4AMODA7q5UTw75fpVk=
Date: Fri, 04 Sep 2026 11:10:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,stevensd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch removed from -mm tree
Message-Id: <20260904181001.1BC321F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: don't call schedule_work when no spinning is allowed
has been removed from the -mm tree.  Its filename was
     memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Stevens <stevensd@google.com>
Subject: memcg: don't call schedule_work when no spinning is allowed
Date: Mon, 31 Aug 2026 16:43:39 -0700

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI.  If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Link: https://lore.kernel.org/20260831234339.280376-1-stevensd@google.com
Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/include/linux/memcontrol.h
@@ -206,6 +206,7 @@ struct mem_cgroup {
 	spinlock_t	 peaks_lock;
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 #ifdef CONFIG_ZSWAP
--- a/mm/memcontrol.c~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/mm/memcontrol.c
@@ -2440,6 +2440,11 @@ static void high_work_func(struct work_s
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2848,7 +2853,10 @@ done_restock:
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4223,6 +4231,7 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4431,6 +4440,7 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
_

Patches currently in -mm which might be from stevensd@google.com are


