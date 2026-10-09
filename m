Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E9C4078E5;
	Fri,  9 Oct 2026 05:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525488; cv=none; b=uPVbK3VoM15RXnaUtOD2zcQhCW8n+g8zQhwcW98aOBzbqgA3KtCyE03hialsu49tg6tHThwtdO8orZRSpVR+0TfKWoDQ+yAG026XLhjUc4VxtBlnaqIGmGYriNpehwsV+ChS4BVEYApv2oTEhxDkxU3/T/EWPiYQYlIVyKClvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525488; c=relaxed/simple;
	bh=DHbJrNuMDRpu6bXFPYbrsdRmknOLKIdLF8NRlyD66ZM=;
	h=Date:To:From:Subject:Message-Id; b=Z1xcy+10A6EgnI8YgsFDEVo2P6Lbitluyww3Ay9dIKiT11qV4a6Nrd3z8FW/0Y+ARJgM0DJBxxB2+lKKxzE6ShL5NB5kI+1bNxmHaAKcYVaVjONGfdOnb8u+aDLqL7k1Yqm+FRnS9QxYOWnnPaY0Owjnm7Qb172g7FWZDSc8CRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hg8AR2KE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hg8AR2KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654CD1F00893;
	Fri,  9 Oct 2026 05:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525487;
	bh=m5obJNJsIrrzulnptEOGpu57dvg0bVsJw6mp08hC7BI=;
	h=Date:To:From:Subject;
	b=Hg8AR2KEgTWZXp8kaRheb1vuWjjUkHQoYsAtRvi2SnDca3p4Bp83fK/OD/LUwLAQj
	 FBrpeMIE+soOl1ipRWnbI4EXgX5s2tlWCktI36nrnkDcwyUDmK+2yYD4Dh87ex5ZRH
	 sgdzDeyfhEutTE6MQbw8dPFM9+oBsP48+w5zbnwo=
Date: Thu, 08 Oct 2026 22:58:07 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,nphamcs@gmail.com,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch removed from -mm tree
Message-Id: <20261009055807.654CD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: clear folio memcg after changing per memcg stats
has been removed from the -mm tree.  Its filename was
     mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bingfang Guo <bingfangguo@tencent.com>
Subject: mm/memcg: clear folio memcg after changing per memcg stats
Date: Thu, 10 Sep 2026 11:46:58 +0800

I notice extremely high swapcached count in the per memcg level
memory.stat when running tests with cgroupv1 setup by swapping pages in
and out.  It seems that the counter never gets decreased so the value is
rather useless and confusing to users reading it.  So I think fixing it so
that the value can reflect the actual swapcache usage correctly could be
helpful.

__memcg1_swapout() transfers the memsw charge of a folio to its swap entry
and clears folio->memcg_data as part of that.  In the vmscan swapout path
it runs before __swap_cache_del_folio(), which then decrements the
swapcache stats through lruvec_stat_mod_folio().  Since folio->memcg_data
has already been cleared, folio_memcg() returns NULL and the NR_SWAPCACHE
decrement only updates the node-level counter instead of the memcg's
lruvec, leaking the per-memcg swapcache count.

Users using swaps will read totally meaningless swapcache value from
per memcg memory.stat, like 200GB of swapcache on a 64GB setup, which
is quite confusing and may trigger monitoring alerts, if any.

Move the __memcg1_swapout() call into __swap_cache_del_folio(), after the
NR_FILE_PAGES and NR_SWAPCACHE updates but before
__swap_cache_do_del_folio() removes the folio from the swap cache.  This
keeps the stats attributed to the folio's memcg while still recording the
swap cgroup with a valid folio->swap.  Add a swapout parameter so the
plain swap_cache_del_folio() path is left unchanged.

Link: https://lore.kernel.org/20260910-memcg-swapcache-stats-fix-v5-1-033f510ba748@tencent.com
Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/swap.h       |    6 ++++--
 mm/swap_state.c |   13 ++++++++++---
 mm/vmscan.c     |    3 +--
 3 files changed, 15 insertions(+), 7 deletions(-)

--- a/mm/swap.h~mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats
+++ a/mm/swap.h
@@ -319,7 +319,8 @@ struct folio *swap_cache_alloc_folio(swp
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry, void *shadow);
+			    struct folio *folio, swp_entry_t entry, void *shadow,
+			    bool swapout);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
@@ -452,7 +453,8 @@ static inline void swap_cache_del_folio(
 }
 
 static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
-		struct folio *folio, swp_entry_t entry, void *shadow)
+		struct folio *folio, swp_entry_t entry, void *shadow,
+		bool swapout)
 {
 }
 
--- a/mm/swap_state.c~mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats
+++ a/mm/swap_state.c
@@ -306,21 +306,28 @@ static void __swap_cache_do_del_folio(st
  * @folio: The folio.
  * @entry: The first swap entry that the folio corresponds to.
  * @shadow: shadow value to be filled in the swap cache.
+ * @swapout: whether this folio is being reclaimed after swapout.
  *
  * Removes a folio from the swap cache and fills a shadow in place.
  * This won't put the folio's refcount. The caller has to do that.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache
  * using the index of @entry, and lock the cluster that holds the entries.
+ * If @swapout is set, the folio should be in reclaim path and IRQs
+ * should be disabled.
  */
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+			    swp_entry_t entry, void *shadow, bool swapout)
 {
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+
+	if (swapout)
+		__memcg1_swapout(folio, ci);
+
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 }
 
 /**
@@ -339,7 +346,7 @@ void swap_cache_del_folio(struct folio *
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	__swap_cache_del_folio(ci, folio, entry, NULL);
+	__swap_cache_del_folio(ci, folio, entry, NULL, false);
 	swap_cluster_unlock(ci);
 
 	folio_ref_sub(folio, folio_nr_pages(folio));
--- a/mm/vmscan.c~mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats
+++ a/mm/vmscan.c
@@ -807,8 +807,7 @@ static int __remove_mapping(struct addre
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio, ci);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
+		__swap_cache_del_folio(ci, folio, swap, shadow, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);
_

Patches currently in -mm which might be from bingfangguo@tencent.com are

memcg-keep-swap-charging-under-rcu-protection.patch
memcg-base-swap-charge-accounting-on-memcgid-root-status.patch
memcg-manipulate-memcg-private-id-references-by-id.patch
memcg-move-memcg-private-id-refcount-to-objcg.patch

