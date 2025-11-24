Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3454C2F6198
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025857; cv=none; b=jCOnVL+nf2YEkzIqEAVEC491Y32tb4g5zDjpVLo9gk5K0YKb1NITBv2wupzglo7g/zxu1OU1oPKIzPeQSmwlG+60O/9+UILbvmGEqz4qVYbRaD2agrS9bLuiPj+jIcX0b0OXUQjTCVtQWJUnIEGoy6Jsrnf0qnBqnnTy/9EsszY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025857; c=relaxed/simple;
	bh=FumpLxFFL78z3g+X/7nlBMip/pEP5sP0+C6qOcHQbpE=;
	h=Date:To:From:Subject:Message-Id; b=Mrfx9XLnalqlowsi8N2HdNQit2iP2JfesMTJyKbi3N+4Th+NJtudytt8DWXG6PRXEzTk4LfTnBTzgEqVS7SFIvpJjIi44FmdOCSSXyzPRAelyklZJ4igpXMaD+XVYc0u9r4EJz6NK5tKNMXvrnUlOktLKP3K5Qm+Wo3EQMvK0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ke/nWRbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ke/nWRbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CF1C4CEF1;
	Mon, 24 Nov 2025 23:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025856;
	bh=FumpLxFFL78z3g+X/7nlBMip/pEP5sP0+C6qOcHQbpE=;
	h=Date:To:From:Subject:From;
	b=Ke/nWRbV3PTWLIu0OllSPsHCwTZ2Q+8JwFA0ZQ0lmqAWuc7/bE8CIcS2vooNCpkro
	 d0b5/+0ACZdPJf5dxD9qWTTcfc4iCE06Z61v0V7zPTHrJmfrfFSYpKgTLY7//gu1bh
	 Rd3e10s34WSoT45Ev1ZJqYeZZP80+g1ZYM9hbdao=
Date: Mon, 24 Nov 2025 15:10:56 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-__mod_lruvec_state.patch removed from -mm tree
Message-Id: <20251124231056.A5CF1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove __mod_lruvec_state
has been removed from the -mm tree.  Its filename was
     memcg-remove-__mod_lruvec_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove __mod_lruvec_state
Date: Mon, 10 Nov 2025 15:20:07 -0800

__mod_lruvec_state() is already safe against irqs, so there is no need to
have a separate interface (i.e.  mod_lruvec_state) which wraps calls to it
with irq disabling and reenabling.  Let's rename __mod_lruvec_state() to
mod_lruvec_state().

Link: https://lkml.kernel.org/r/20251110232008.1352063-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 include/linux/vmstat.h    |   18 +-----------------
 mm/memcontrol.c           |    8 ++++----
 mm/migrate.c              |   20 ++++++++++----------
 mm/vmscan.c               |    4 ++--
 5 files changed, 18 insertions(+), 34 deletions(-)

--- a/include/linux/mm_inline.h~memcg-remove-__mod_lruvec_state
+++ a/include/linux/mm_inline.h
@@ -44,7 +44,7 @@ static __always_inline void __update_lru
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
--- a/include/linux/vmstat.h~memcg-remove-__mod_lruvec_state
+++ a/include/linux/vmstat.h
@@ -520,19 +520,9 @@ static inline const char *vm_event_name(
 
 #ifdef CONFIG_MEMCG
 
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_state(lruvec, idx, val);
-	local_irq_restore(flags);
-}
-
 void __lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
@@ -554,12 +544,6 @@ static inline void mod_lruvec_page_state
 
 #else
 
-static inline void __mod_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx, int val)
-{
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c~memcg-remove-__mod_lruvec_state
+++ a/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void mod_memcg_lruvec_state(struc
 }
 
 /**
- * __mod_lruvec_state - update lruvec memory statistics
+ * mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
  * @idx: the stat item
  * @val: delta to add to the counter, can be negative
@@ -766,7 +766,7 @@ static void mod_memcg_lruvec_state(struc
  * function updates the all three counters that are affected by a
  * change of state at this level: per-node, per-cgroup, per-lruvec.
  */
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val)
 {
 	/* Update node */
@@ -794,7 +794,7 @@ void __lruvec_stat_mod_folio(struct foli
 	}
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	__mod_lruvec_state(lruvec, idx, val);
+	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(__lruvec_stat_mod_folio);
@@ -818,7 +818,7 @@ void mod_lruvec_kmem_state(void *p, enum
 		mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		__mod_lruvec_state(lruvec, idx, val);
+		mod_lruvec_state(lruvec, idx, val);
 	}
 	rcu_read_unlock();
 }
--- a/mm/migrate.c~memcg-remove-__mod_lruvec_state
+++ a/mm/migrate.c
@@ -675,27 +675,27 @@ static int __folio_migrate_mapping(struc
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		__mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
-		__mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
+		mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+		mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
 		if (folio_test_swapbacked(folio) && !folio_test_swapcache(folio)) {
-			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
-			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
+			mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
+			mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 
 			if (folio_test_pmd_mappable(folio)) {
-				__mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
-				__mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
+				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
+				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
 			}
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
-			__mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
-			__mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
+			mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
+			mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
 		}
 #endif
 		if (dirty && mapping_can_writeback(mapping)) {
-			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
+			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
 			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
-			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
--- a/mm/vmscan.c~memcg-remove-__mod_lruvec_state
+++ a/mm/vmscan.c
@@ -2018,7 +2018,7 @@ static unsigned long shrink_inactive_lis
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
 
-	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
+	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
@@ -4744,7 +4744,7 @@ retry:
 		reset_batch_size(walk);
 	}
 
-	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
+	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


