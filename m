Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404126;
	b=io0FjIbN1iDa+E2Jaeyc4Y0kVZ88da5j9i+2jOGCc0VT4WDOSy/Js7a/p0bbBi5xTxTA
	 DYthdelv2x5diyAEGg6A6SrdaIjwf/S+b/bkzsDdEg623IKvHUvAfI6r+/YNeMffnGAHt
	 kJ8GMic8HfZ7W5MTwHeUqgCILhtchWAKicvP71LFGZfX680slrzrjuVAXGsgqNDrjBshK
	 0lsySkbz0nkouSx6IrrpkH/ptUHmB6JJUmNp/FFdFuy2r60HpI+9zBpUaWqJCuSstn9gB
	 RxcIDZIFbHBfkN3zhbP0E6df+UJarEVWwzbbFyx7LDookMTUPezea1bSV3yYwwADSFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404126;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=o/fooE/mqiak5gzNPD+ZWchHbbKvelmKK6vguNaKGQM=;
	b=P0OlY7b4bqJeAxXCvZfacFapA9+9Zy39GHcsqiOukmm7GAV/hJqZ3j8YcMr4T4qLf5wv
	 8xKxfIbjvaGS+WYZ4EXOn/Ox25aHVExlpO3l9tOL8GfaWwRSxo2YOO1ZSjjZJ/GRjwqy3
	 1NPG6jZzMGAju7EWeOkQv+4zQlLsKlyCSYQXe9vcS08hp4J4aNpRIgHLZ0lAGIQBxHwE3
	 M9LxLClQtvcpRZEXt+wqYZUB/OnNTGYjQKvix/glXpkZxQ0kKYFKbpMajj25/q+Q5sAoO
	 iU+jcOLY1igWK18Z25U0ZT7X/Xad81B18Ed3Mi1qkZwpN0uaSjun1Tu5CDNpgJrWBOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sWyBjRwN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ABC606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sWyBjRwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE80F1F000C1;
	Fri, 30 Oct 2026 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404125;
	bh=o/fooE/mqiak5gzNPD+ZWchHbbKvelmKK6vguNaKGQM=;
	h=Date:To:From:Subject;
	b=sWyBjRwNqdIo4w1p9RrqSLyeGLc+HZzZ6QeHaKvDLP/UnYQNTFrWFwYa/nvg9oabX
	 pLhAuVbvlM05rxKo43VaEafvYzhNnHQjw9j9fle9OBX6EeUMv3ogbplgbiG6LJ+Q3c
	 UCMhIweVeFvtPn8SKHM7L0Fa3Uc10iiIiS0IyGC8=
Date: Fri, 30 Oct 2026 16:48:45 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,harry@kernel.org,
	hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-simplify-high-limit-handling-after-a-charge.patch added to mm-new branch
Message-Id: <20261030234845.AE80F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: simplify high limit handling after a charge
has been added to the -mm mm-new branch.  Its filename is
     memcg-simplify-high-limit-handling-after-a-charge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-simplify-high-limit-handling-after-a-charge.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simplify high limit handling after a charge
Date: Fri, 30 Oct 2026 13:54:16 -0700

Separate the hierarchy scan from high-limit enforcement. Find the first
cgroup over the applicable limit, then queue high_work or record the
task's overage after the scan. Worker contexts check only memory.high;
local charges also check memory.swap.high.

Clarify the enforcement comments. Keep the synchronous pending-overage
check independent of the scan result so a blocking charge still handles
overage left by earlier charges.

No functional change intended.

Link: https://lore.kernel.org/20261030205418.341214-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
---

 mm/memcontrol.c |  102 ++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 57 deletions(-)

--- a/mm/memcontrol.c~memcg-simplify-high-limit-handling-after-a-charge
+++ a/mm/memcontrol.c
@@ -2611,9 +2611,8 @@ static unsigned long calculate_high_dela
 }
 
 /*
- * Reclaims memory over the high limit. Called directly from
- * try_charge() (context permitting), as well as from the userland
- * return path where reclaim is always able to block.
+ * Handle pending high overage during a blocking charge or on return
+ * to userspace.
  */
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2707,76 +2706,65 @@ out:
 
 /*
  * Called after @nr_pages were charged to @memcg. If @memcg or one of its
- * ancestors is over memory.high or memory.swap.high, start reclaim or slow
- * down the task.
+ * ancestors is over its high limit, either queue high_work to reclaim from
+ * that cgroup, or record the overage so the charging task reclaims later
+ * and sleeps if reclaim can't keep up. high_work only handles memory.high;
+ * memory.swap.high is only enforced on the charging task.
  */
 static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
+	struct mem_cgroup *iter;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+	bool use_high_work = !in_task() || (current->flags & PF_KTHREAD) ||
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
+	 * Check the charged cgroup and its parents. Local charges normally defer
+	 * reclaim until return to userspace so it can use GFP_KERNEL. Large
+	 * pending overages may be handled synchronously below. The handler looks
+	 * up current->mm and rechecks the limits. If the task moved to another
+	 * cgroup in the meantime, the handler works on the new cgroup instead.
+	 * That is rare and costs little.
 	 */
-	do {
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
 		bool mem_high, swap_high;
 
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/*
-		 * Don't make an unrelated interrupted task handle this charge.
-		 * Kernel threads may be working for other tasks, so let a worker
-		 * reclaim instead.
-		 * Remote charges need reclaim from their charged hierarchy.
-		 */
-		if (use_worker) {
-			if (mem_high) {
-				if (allow_spinning)
-					schedule_work(&memcg->high_work);
-				else
-					irq_work_queue(&memcg->high_irq_work);
-				break;
-			}
-			continue;
-		}
-
-		if (mem_high || swap_high) {
-			/*
-			 * The allocating tasks in this cgroup will need to do
-			 * reclaim or be throttled to prevent further growth
-			 * of the memory or swap footprints.
-			 *
-			 * Target some best-effort fairness between the tasks,
-			 * and distribute reclaim work and delay penalties
-			 * based on how much each task is actually allocating.
-			 */
-			current->memcg_nr_pages_over_high += nr_pages;
-			set_notify_resume(current);
+		mem_high = page_counter_read(&iter->memory) >
+			READ_ONCE(iter->memory.high);
+		swap_high = !use_high_work &&
+			(page_counter_read(&iter->swap) > READ_ONCE(iter->swap.high));
+		if (mem_high || swap_high)
 			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	}
 
-	/* Interrupts, kernel threads, and remote chargers stop here. */
-	if (use_worker)
+	/*
+	 * Use a worker for interrupts, kernel threads, and tasks whose mm
+	 * does not match the charged hierarchy.
+	 */
+	if (use_high_work) {
+		if (!iter)
+			return;
+		if (allow_spinning)
+			schedule_work(&iter->high_work);
+		else
+			irq_work_queue(&iter->high_irq_work);
 		return;
+	}
+
+	if (iter) {
+		/*
+		 * Count the full batch so reclaim work and delay penalties scale
+		 * with the pages charged by this task.
+		 */
+		current->memcg_nr_pages_over_high += nr_pages;
+		set_notify_resume(current);
+	}
 
 	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
+	 * Earlier charges may have left high overage pending even if this charge
+	 * found no new overage. Handle it now if this charge can block, to limit
+	 * overrun while the task remains in the kernel.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    gfpflags_allow_blocking(gfp_mask))
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

