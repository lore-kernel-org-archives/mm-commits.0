Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404119;
	b=tCZB8NAhsLoczL1/uXG/CdxaFQ/7U3WYpgV4bvWCzomQCLrQezwXk2vQkh3ZeytEGLtK
	 Pqpqml7IWbmc+oRvK9qKrZQlJXZv2tDVkoN9YKJaK9yaedFu/7t5H8tvQfKdg2mxhHe3w
	 8kl/CGCh2Ylk+km1Uf5LDjb6Ip2GLtXO3/n2MZcku7fLqIO+oyM/rnxOSutvQfezwbZ6V
	 htygnGAh+vXTdEFPi4bvTsVS24X3EAzC4qqnY8+CnhbB+ivh0IGMYAqYnkqw5PN8OTjJo
	 yeELIMEpSljTmg//2P+UdcBhcMnZykM7HgTEFZCWL0e2BrlrrIeFfgNf3QdS0mPZONA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404119;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Sf98JvcWSlvqUvhsdylowwXtGp0NCqDlEQsCGuUnMBI=;
	b=dz5YqpVr45wF7yItOrCngwXSmTxebeZxLrsxsPbGApii7v0bqWu+Zu2YBwWVKJIyrfmT
	 SPoZ6bO7bveBg+6lKKovidxqRrU5+wBYBwSLj00GwczX9bIok3MGPaGc0fsI46aStpCQD
	 w5jwj/aEzh+AVjihYfFZ2CqCR18AraXv/TxBxnU1WJj3khWJOwKs51rcTpbfYERc0Ee7N
	 ZhX6caQqsJKWWAQvVNxm7NkPG78EyrK33dvaJJalCjJgMyHgdoZweLRuJ9IeB2Sg1kYEo
	 1mcoHC+dYGrkoGVvwyWf8r2vslSF8ganIZwNneOMmzMZ1+VjnShycaCoeblrY0T1ZDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="xHV/xIuq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45A7606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xHV/xIuq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208481F000C1;
	Fri, 30 Oct 2026 23:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404118;
	bh=Sf98JvcWSlvqUvhsdylowwXtGp0NCqDlEQsCGuUnMBI=;
	h=Date:To:From:Subject;
	b=xHV/xIuqs5DnZxvYhNoU3Q3NYAFIJs+1Rp4DpGH5CWjWZLXsZ5Ej5SN+yQBrRc3c0
	 IoevbaeuKR1ivRFy0Hkv288PbyKV8EgwnhbEZOHrBmVYlKmfT5CISek8dE18rqVG6M
	 +WIqK0TnyplTu3dXGbQkg6WCF/9zk4AMiBZpUYu0=
Date: Fri, 30 Oct 2026 16:48:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,harry@kernel.org,
	hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch added to mm-new branch
Message-Id: <20261030234838.208481F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: move memory.high enforcement out of try_charge_memcg()
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch

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
Subject: memcg: move memory.high enforcement out of try_charge_memcg()
Date: Fri, 30 Oct 2026 13:54:12 -0700

Patch series "memcg: clean up memory.high enforcement", v2.

This series cleans up memory.high enforcement and uses a worker for
kernel threads and remote charges.

Kernel threads never return to userspace to run deferred reclaim.
Reclaiming and sleeping during a charge can also delay work they do for
other tasks.

Remote charges can go to a different cgroup from the caller's mm, for
example through filesystem notifications or faults in another process's
memory. The high handler uses current->mm, so it can check the caller's
limits instead of the limits of the charged cgroup.

Use high_work to reclaim from the charged hierarchy in these cases.
mm_match_cgroup() identifies charges outside the current mm's cgroup
and its ancestors. Local user charges keep their current handling.

Before that, force charges from PF_MEMALLOC tasks before trying the
limits, so they skip memory.high enforcement. Reclaim can charge memory
itself, for example when zswap stores a page, and the high_work worker
must not queue itself from its own reclaim. These charges still raise
MEMCG_MAX for the same cgroup as before.

This is best effort. A fast allocator can keep usage well above
memory.high; memory.max stays the hard limit, as it already is for
interrupts. The worker paths also skip memory.swap.high throttling and
its high-event reporting. memory.swap.high only throttles the charging
task, and a worker has no task to throttle. The cgroup's own tasks are
still throttled on their own charges, and memory.swap.max still caps
swap.

The first patch moves enforcement into memcg_enforce_high(). The second
forces charges from reclaim before the limit checks. The next two add
kernel thread and remote charge handling. The last simplifies the scan
and comments. The first and last patches have no intended behavior
change.


This patch (of 5):

try_charge_memcg() does a lot. It charges the page counters, reclaims
when a limit is hit, may call the OOM killer, and at the end it checks
and enforces memory.high. Move the memory.high part into a new function,
memcg_enforce_high(), so that try_charge_memcg() is shorter and the
memory.high code is easier to read and change.

The code and its comments move as they are. The only difference is that
the new function gets allow_spinning from gfp_mask itself.

No functional change.

Link: https://lore.kernel.org/20261030205418.341214-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/20261030205418.341214-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
---

 mm/memcontrol.c |  125 +++++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

--- a/mm/memcontrol.c~memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg
+++ a/mm/memcontrol.c
@@ -2705,6 +2705,74 @@ out:
 	css_put(&memcg->css);
 }
 
+/*
+ * Called after @nr_pages were charged to @memcg. If @memcg or one of its
+ * ancestors is over memory.high or memory.swap.high, start reclaim or slow
+ * down the task.
+ */
+static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
+			       gfp_t gfp_mask)
+{
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+
+	/*
+	 * If the hierarchy is above the normal consumption range, schedule
+	 * reclaim on returning to userland.  We can perform reclaim here
+	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
+	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
+	 * not recorded as it most likely matches current's and won't
+	 * change in the meantime.  As high limit is checked again before
+	 * reclaim, the cost of mismatch is negligible.
+	 */
+	do {
+		bool mem_high, swap_high;
+
+		mem_high = page_counter_read(&memcg->memory) >
+			READ_ONCE(memcg->memory.high);
+		swap_high = page_counter_read(&memcg->swap) >
+			READ_ONCE(memcg->swap.high);
+
+		/* Don't bother a random interrupted task */
+		if (!in_task()) {
+			if (mem_high) {
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
+				break;
+			}
+			continue;
+		}
+
+		if (mem_high || swap_high) {
+			/*
+			 * The allocating tasks in this cgroup will need to do
+			 * reclaim or be throttled to prevent further growth
+			 * of the memory or swap footprints.
+			 *
+			 * Target some best-effort fairness between the tasks,
+			 * and distribute reclaim work and delay penalties
+			 * based on how much each task is actually allocating.
+			 */
+			current->memcg_nr_pages_over_high += nr_pages;
+			set_notify_resume(current);
+			break;
+		}
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	/*
+	 * Reclaim is set up above to be called from the userland
+	 * return path. But also attempt synchronous reclaim to avoid
+	 * excessive overrun while the task is still inside the
+	 * kernel. If this is successful, the return path will see it
+	 * when it rechecks the overage and simply bail out.
+	 */
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask))
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
@@ -2862,62 +2930,7 @@ done_restock:
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
-	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
-	 */
-	do {
-		bool mem_high, swap_high;
-
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
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
-			current->memcg_nr_pages_over_high += batch;
-			set_notify_resume(current);
-			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
-
-	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
-	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

