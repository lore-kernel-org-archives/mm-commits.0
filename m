Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172E93ED3B4
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030931; cv=none; b=Uw28jhlocHNHPkRYIJZgdAbyf0aM3tk9SFsLDLc6BenPtkNDMEv+RO/6uX1LDOmL7mNe3vSE/ql/pPmCOGzKGxy847qG38F40+2haCRd3pjscVKPgF2dZmkTSKB3ugyz+/KhEr1OMGm3SH06p2+l/RF5mcD3LSkyVD9O7EYfDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030931; c=relaxed/simple;
	bh=fwHEsOZGbaxhIgOmqfstrsll88qvgkBTLe3EhRpyBxY=;
	h=Date:To:From:Subject:Message-Id; b=NtxnmK37Txq+YL8oUiG7Up+6393IhZFghKvlBJg1TcK91vmWPFLqQ+mYFLu0uaiQUDogh7GDHo4SoCXv9A6KLcJkkwbZreIxvKUAUV5ghkGNwZkRVpIFCUqGTTQ7OsjUyEYB9FaJSL5FlVcDUoyzlFtBUfpsqFV2ckHNmjhY/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0VugYDmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0VugYDmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7311E1F000FF;
	Mon, 21 Sep 2026 22:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030929;
	bh=J2yxtHb627XGEcrkzRfLvGe1uLnMlXkdu00+JqG2gLg=;
	h=Date:To:From:Subject;
	b=0VugYDmizRZGV4OIMUG8/SBG2phicx21ThrJcy8roMd5xgQqSqp6gGpA0PMHpxYic
	 aGcx6wQaOccFW2U/gzmCrx43W7gedUnxv7Ji0HCrVRnnNAxnXPyNC4REZvLCxqhZjY
	 NVvAU/0VBtApIY5QZpgrkv1ufa3802kXbL6E7ZeY=
Date: Mon, 21 Sep 2026 15:48:48 -0700
To: mm-commits@vger.kernel.org,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-keep-swap-charging-under-rcu-protection.patch added to mm-new branch
Message-Id: <20260921224849.7311E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: keep swap charging under RCU protection
has been added to the -mm mm-new branch.  Its filename is
     memcg-keep-swap-charging-under-rcu-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-keep-swap-charging-under-rcu-protection.patch

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
From: Bingfang Guo <bingfangguo@tencent.com>
Subject: memcg: keep swap charging under RCU protection
Date: Mon, 21 Sep 2026 14:16:24 +0800

Patch series "memcg: move memcgid refcount to objcg to unpin dying
memcgs", v2.

Although the dying memcg problem caused by LRU pages is fixed, I can still
see many dying memcgs on some workloads that use shmem and those pages are
swapped out.  For example, programs populating logs to tmpfs or containers
sharing data using shmem.  This series binds the memcgid refcount to
objcgs so dying memcgs can be freed normally in this case.

The memcg private ID identifies memcgs for objects that can outlive the
cgroup itself: swap entries and workingset shadows.  Today the ID's
refcount is embedded in the css, and every outstanding ID reference
(mostly swap entries) pins the css, keeping the entire memcg alive.  This
causes a problem: A swapped-out page holds a memcgid reference that pins
the css, so the memcg cannot be freed until the page is swapped back in
and charged back to its online parent.

The work done by Muchun Song and Qi Zheng already charges folios to the
objcg, which is reparented to its parent when the memcg offlines.  This
series applies similar idea to the memcg private ID: the ID's refcount
moves from the css into the objcg, and the memcgid xarray holds a
reference to an objcg instead of pinning the css.  When the memcg
offlines, the objcg is reparented and any remaining memcgid references
resolve to the ancestor, so swapped-out pages no longer pin the dying
memcg and get the online parent naturally on swapin.

Unbinding the ID from the memcg has three consequences the series has to
deal with:

  1. The ID stops pinning the memcg, so the paths that relied on the ID
     reference to keep the memcg alive have to hold the RCU read lock
     instead.  (Patch 1)

  2. Charge and uncharge no longer necessarily happen on the same memcg:
     swapout charges the folio's memcg, while the slot free resolves the
     nearest live ancestor.  The counters are hierarchical, and the
     MEMCG_SWAP stat is either reparented at offline (v1) or not visible
     (v2), so nothing leaks.  But "does this entry carry a counter
     charge at all" can no longer be answered from the resolved memcg:
     root is skipped only because root's swap is not accounted, and a
     non-root ID whose memcg was reparented into root still carries a
     charge that must be released.  Patch 2 adds
     mem_cgroup_private_id_is_root() and makes all three swap paths
     decide on the ID's root status.

  3. An ID can now outlive the memcg it was allocated to, so the memcg
     resolved from an ID is not necessarily the memcg the ID was handed
     out for.  Callers that need exactly that memcg (list_lru, the
     workingset and MGLRU shadow tests) now get NULL and skip the entry,
     while the swap paths, which only need something to account to, get
     the nearest live ancestor.  (Patch 4)

The series is four patches.  The first three are preparation that keeps
today's semantics while the ID is still bound to the css.  Only the last
patch changes behavior.


This patch (of 4):

This is a preparatory work for unbinding memcgid from memcg.  No
functional change.

The swap charging path currently drops its RCU read lock after acquiring a
private ID reference.  This is safe because the ID reference pins the
memcg's CSS.  After ID references are moved to pin objcgs, that lifetime
guarantee will no longer hold.

Keep the RCU read lock held while accessing the memcg for counter
charging, statistics and failure handling.  (This matches what
__memcg1_swapout() already does).  Save the private ID for swap memcg
recording before dropping the RCU read lock.  So the swap cluster locking
remains outside the RCU read-side critical section.

Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com
Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-1-6c0637dc0edb@tencent.com
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Bingfang Guo <bfguo@icloud.com>
---

 mm/memcontrol.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/memcontrol.c~memcg-keep-swap-charging-under-rcu-protection
+++ a/mm/memcontrol.c
@@ -5955,6 +5955,7 @@ int __mem_cgroup_try_charge_swap(struct
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5964,30 +5965,29 @@ int __mem_cgroup_try_charge_swap(struct
 	if (!objcg)
 		return 0;
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	if (!folio_test_swapcache(folio)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		rcu_read_unlock();
-		return 0;
-	}
-
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
-
-	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
-		return -ENOMEM;
+	scoped_guard(rcu) {
+		memcg = obj_cgroup_memcg(objcg);
+		if (!folio_test_swapcache(folio)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			return 0;
+		}
+
+		memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+		/* memcg is pined by memcg ID. */
+		private_id = mem_cgroup_private_id(memcg);
+
+		if (!mem_cgroup_is_root(memcg) &&
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			mem_cgroup_private_id_put(memcg, nr_pages);
+			return -ENOMEM;
+		}
+		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 	}
-	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
 	swap_cluster_unlock(ci);
 
 	return 0;
_

Patches currently in -mm which might be from bingfangguo@tencent.com are

mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch
memcg-keep-swap-charging-under-rcu-protection.patch
memcg-base-swap-charge-accounting-on-memcgid-root-status.patch
memcg-manipulate-memcg-private-id-references-by-id.patch
memcg-move-memcg-private-id-refcount-to-objcg.patch

