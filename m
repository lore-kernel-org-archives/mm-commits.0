Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72065277C88
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783725435; cv=none; b=mdT8XfhlEYPNRVy99rEKerUlDcMEaj5tN0gzQbMz8uHl8HlRBac+il/yMv9GG4KkqCojfaRhnVinxOabbWyiHFgOguFgbW2JNUFSUfkzeFKjp1RdRdyEB3GExA8r4sttQK1nlsq4y394zbh90tgdQGWO2y64rItLTCxdm90XoVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783725435; c=relaxed/simple;
	bh=i39lsngF1a6F21dBGg5wM1ex3dR+jvuC8aRtAxixKxs=;
	h=Date:To:From:Subject:Message-Id; b=orR0Fj0H+lSKe0nZSgphHLwz9NfNOR5fjgoM/vEmLbRL1dCHJo5hO8Eh5XL+6Lm/VH8gYUGy1omyhCGK6XOWu8drkdcUIvrNRLplkMq+L/zTfWKWDOSeFMbS4BuLvAsNhlfEbZB9SXZdFfpxY3HRpGbaGz7O2IwnenDs+r0plj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2z1MBBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2z1MBBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFE1F000E9;
	Fri, 10 Jul 2026 23:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783725433;
	bh=mPZNV/DQU6/1X6gW/xvBrwjBtAz25SXknJQegX+88QE=;
	h=Date:To:From:Subject;
	b=K2z1MBBMLYTCCJIWXo+xDUSkLJhKbLBkHjqaKaE3COwocZOV9P8kAwfG0Umb6knl/
	 CSOjvuIjqAbmPfERXG9u3mgjpqqVg+SMhZRiPjClQwlVMpMUfLimk0pZFni6L+sBgl
	 GlERzxvMJUFf3qwKbhHJp7GMGPXqsybIzlnqQMw4=
Date: Fri, 10 Jul 2026 16:17:12 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch removed from -mm tree
Message-Id: <20260710231712.DFFFE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: fix stale batch updates after memcg reparenting
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: mglru: fix stale batch updates after memcg reparenting
Date: Wed, 1 Jul 2026 15:52:51 +0800

The mglru page table walker batches per-generation size deltas in
walk->nr_pages while walking page tables without holding the lruvec lock. 
The reset_batch_size() later folds those deltas into walk->lruvec under
the lruvec lock.

The page table walker can run concurrently with the memcg reparenting path
as follows:

CPU0                           CPU1
====                           ====

walk_mm
--> walk_page_range
    --> update_batch_size
        --> walk->nr_pages += delta

                              mem_cgroup_css_offline
                              --> memcg_reparent_objcgs
                                  --> lock lruvec
                                      lru_gen_reparent_memcg
                                      --> reparent child folios to parent
                                      unlock lruvec

    lock lruvec
    reset_batch_size
    --> child lrugen->nr_pages += delta

This will trigger the following warning in lru_gen_exit_memcg():

	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
				   sizeof(lruvec->lrugen.nr_pages)));

And the user-visible impact of underestimated nr_pages in MGLRU was
premature OOMs because MGLRU does not try to reclaim memory when nr_pages
reaches zero, but there are still more pages.

To fix it, make reset_batch_size() check CSS_DYING under RCU before
flushing the pending batch.  A non-dying memcg keeps the original lruvec
stable against RCU-delayed offlining; a dying memcg redirects the deltas
to the first non-dying ancestor.

Link: https://lore.kernel.org/20260701075251.56413-1-qi.zheng@linux.dev
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-fix-stale-batch-updates-after-memcg-reparenting
+++ a/mm/vmscan.c
@@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru
 	walk->nr_pages[new_gen][type][zone] += delta;
 }
 
+#ifdef CONFIG_MEMCG
+static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
+{
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	rcu_read_lock();
+
+	/*
+	 * The memcg can be NULL when the memory controller is disabled.
+	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
+	 */
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+
+	spin_lock_irq(&lruvec->lru_lock);
+
+	return lruvec;
+}
+#else
+static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
+{
+	lruvec_lock_irq(lruvec);
+
+	return lruvec;
+}
+#endif
+
 static void reset_batch_size(struct lru_gen_mm_walk *walk)
 {
 	int gen, type, zone;
-	struct lruvec *lruvec = walk->lruvec;
+	struct lruvec *lruvec = lock_batch_lruvec(walk->lruvec);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	walk->batched = 0;
@@ -3285,6 +3315,8 @@ static void reset_batch_size(struct lru_
 			lru += LRU_ACTIVE;
 		__update_lru_size(lruvec, lru, zone, delta);
 	}
+
+	lruvec_unlock_irq(lruvec);
 }
 
 static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
@@ -3779,11 +3811,8 @@ static void walk_mm(struct mm_struct *mm
 			mmap_read_unlock(mm);
 		}
 
-		if (walk->batched) {
-			lruvec_lock_irq(lruvec);
+		if (walk->batched)
 			reset_batch_size(walk);
-			lruvec_unlock_irq(lruvec);
-		}
 
 		cond_resched();
 	} while (err == -EAGAIN);
@@ -4867,9 +4896,7 @@ retry:
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
-		lruvec_lock_irq(lruvec);
 		reset_batch_size(walk);
-		lruvec_unlock_irq(lruvec);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


