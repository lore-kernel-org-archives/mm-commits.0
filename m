Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832263;
	b=Q1+xCHVwEVcsnyYLTmRRJvp6uV2nen4nn02px3GaqDpyOlk7JMc+Gd6Lj5hQWRvZfVul
	 9SfyjwkK2q8zl/G7su2q8xyXPlf2RJX/AFoz68k4xGQnUN7iKYW6UKUJ0Ykgo7LvZms/V
	 UESPOI9nKh4rFsUJcUk3jf+gcJkfKwse0tMk4ZNoljvI2Mt52KryCe3Bhp92zWMZn/Xpb
	 xw0i2gvBHVR4QBMrKxWTIDCe8fsZoBW3dnEi0QXbo01r9pAUdf3K5kMterRou9IGmzUzm
	 BVmNQatvqPeDcIeB73S1QtiwFSdbGqeBL0ihT64PyioZtWUc97iC+GaMiDDSmxGlY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832263;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rwa4v2d3UiyIi2NyD2tYeZr1C4XqHjBzqDzM5Q6zy34=;
	b=gBhBJdVnQgYFhEdq+e30dxhKGQ+iL7VNVSKhEIrcOCiPiirtbTcsTwqgkhSmZyrhTgBk
	 JBKSOYNrYkgzfLXEQGpF7z2hGqkBE9BDyiqOm9zm9qrvXHF4rkQrLKXSLWsR+hIZdhfrL
	 hK1PQpfRw1lqVDnmM8RkFOkpDRHKDRM6KbhjET0BV1D6oD+ZE70PpvEOWQpYSq6S/TEKP
	 7P4gQ3POoqGlY2LWgB4OLXfyGuSTOLUQ1U7+m6XalvtkX6vRYXWV0LstBGfpsQ+U9HXRR
	 i5mZ2Sps9QE6GjUQk37rDhibNtdQwg9kPwnz5QjFS0z1s90k/lS9XK4tKbYWGGpHg9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gQdjWciE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BFA606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gQdjWciE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E9A1F01829;
	Sat, 24 Oct 2026 08:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832262;
	bh=rwa4v2d3UiyIi2NyD2tYeZr1C4XqHjBzqDzM5Q6zy34=;
	h=Date:To:From:Subject;
	b=gQdjWciESYAGe94TGiYnlfcrsg/8XGsX6rOXEE0rYJz2A5xElvsun2viUffV51pkA
	 ugieDdWd2Bo8gBgtrdiwKZdHUU0LTxnCG/iy3HAkMkNJVfzNQMsVqtTvIbrc9J1wOG
	 PmNNCeQ3puNIL/O7Uosca3mmiqaIwisIvcmPJykk=
Date: Sat, 24 Oct 2026 01:57:42 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-keep-swap-charging-under-rcu-protection.patch removed from -mm tree
Message-Id: <20261024085742.93E9A1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: memcg: keep swap charging under RCU protection
has been removed from the -mm tree.  Its filename was
     memcg-keep-swap-charging-under-rcu-protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5963,30 +5964,29 @@ int __mem_cgroup_try_charge_swap(struct
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


