Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45EB2AD3F;
	Fri, 10 Jul 2026 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783643170; cv=none; b=oBQlZcRZLrpY7jBLVHjZfTXFgG0HBYUP5LbCgWpTo8KY6SqYPVqKuZYrSijmqSopHpfaDui1WZzSQuSDYzHr23mpT62UwTdUaGEbuLAqWQW2/JQJTWioXrIVVehQAoQN2raTywyIP+QUqgL1f4ew529WDMQlaLFTNjsum1PL4OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783643170; c=relaxed/simple;
	bh=wvvZkSkaiKIF0iKkSuuwEEITrxUkRIkPCwvPrPMBs0c=;
	h=Date:To:From:Subject:Message-Id; b=lKlZkEYD0B78xBlUBBCzeqdyV2eRhizjhOjrgi+W74HG0YDUt350+VOwziPgF3SBTelqMqaOhWzp3G8+oNEUj1CtJJyqOjBAcc8DNCVuxy5qe3OiVg9UYlDXsUlf/kvHu7/bQsd6yLcIF3lCsSUCXUDGqgpD2+Sor6DMSFIljb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHI7Iusz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHI7Iusz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C041F00A3A;
	Fri, 10 Jul 2026 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783643168;
	bh=tTBt36v8/0MHc8cFNJYfzuJVRais6cCjAMmr5shCErg=;
	h=Date:To:From:Subject;
	b=RHI7IuszWoPirEGfAitLaSd6Omd9652/NCw8pTR7o5Mnk6u/Opd05pNsqhNfWtN6t
	 1vKWUQReCw7+8Qe4NrkuRWo1JMNwaCq6SMUBcKW4VKJIENv2jwsf82+4dm5cuzL9Y4
	 STLBdNcNiKZZyzNTLpe8TMHHMsx/KFuGQpmwZaKk=
Date: Thu, 09 Jul 2026 17:26:07 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peiyang_he@smail.nju.edu.cn,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260710002608.44C041F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mglru: fix stale batch updates after memcg reparenting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch

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

mm-mglru-fix-stale-batch-updates-after-memcg-reparenting.patch

