Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3BD51FCAD
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030077; cv=none; b=CSeQ4IxAR9ZsP2dZ535i57CbGvcEPEu+6BDED8kTFZRrVQu81Y2zBrFO5JhJ2vpdAmpZx3XuBVToPGCIYoYbh1IUflCUojpMynI4VGB6U9humlHaqMugGt0W8WDRHYoNzIhqzSQvuOPBFbrOCVZ6JJNsdnOsLVMUJA0lLhvVRyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030077; c=relaxed/simple;
	bh=BGgIzCmWKutZJNBzRG82Gsox5HpLkgmRefSFXgbQ2eE=;
	h=Date:To:From:Subject:Message-Id; b=QmUSt3EdLwhgAGGn+wQv54ywsMVBQkZ2jUy/PNN3ZZtEsPzw1fO+/yXtwUYIvis1wSupEdVuJcsDeeuTOS2Kw22xjvOm5VNx9AztEMfzAdsjbSjEKG5xNIktPNqlWE1GPYcfKvqzjOngLVe10B3PHNdcLU08+ZnwwCAj7RThu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L6uvz1So; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L6uvz1So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0313C1F000FF;
	Mon, 21 Sep 2026 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030075;
	bh=qTjsTo5Wd5KZ2kBfvFiKVAI/j5kI46Kxgkp+ASD2S2E=;
	h=Date:To:From:Subject;
	b=L6uvz1SoZ7IxgKFv6L275cdm4GB4kXKNFs+pfPCX4NN0R6jfUMqg/hx9KQlI00VYI
	 v0QnuzuEQolQFVHiLGwq61lK5S+zMPiZ458i+hECPmXpX2c7OHD7AjYuesj9SqOcXo
	 E7427fA2MmpUpdDBPAJ8b8wYNhPTaH3zqBQCpty0=
Date: Mon, 21 Sep 2026 15:34:34 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-manipulate-memcg-private-id-references-by-id.patch added to mm-new branch
Message-Id: <20260921223435.0313C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: manipulate memcg private ID references by ID
has been added to the -mm mm-new branch.  Its filename is
     memcg-manipulate-memcg-private-id-references-by-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-manipulate-memcg-private-id-references-by-id.patch

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
Subject: memcg: manipulate memcg private ID references by ID
Date: Mon, 21 Sep 2026 14:16:26 +0800

This is a preparatory work for moving memcgid from memcg to objcg.

Swap entries retain a private ID rather than a memcg pointer.  Once
private ID references are moved to objcgs, the ID can also outlive the
memcg to which it was originally assigned.  So it's better to make the get
and put functions accept the ID itself instead of the memcg.

Rename mem_cgroup_private_id_get_online() to mem_cgroup_private_id_get(),
and make it return the ID only.  If the memcg is already dying, the dying
memcg will still be used for charging and stats accounting in v2 swap
charging path.  But they are hierarchical and will be reparented after
offlining so it doesn't matter.

Make mem_cgroup_private_id_put() take the ID and resolve the reference
holder internally.  Convert swap uncharge and charge rollback to release
the reference using that ID.  This introduces an extra xarray lookup for
now, which will be removed in the final patch.

Separate the online-state reference release into
mem_cgroup_private_id_kill().  The offline path already has the memcg
pointer and can call the underlying put helper directly.

Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-3-6c0637dc0edb@tencent.com
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

 mm/memcontrol-v1.c |    7 +++----
 mm/memcontrol-v1.h |    3 +--
 mm/memcontrol.c    |   32 +++++++++++++++++++++++---------
 3 files changed, 27 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c~memcg-manipulate-memcg-private-id-references-by-id
+++ a/mm/memcontrol.c
@@ -4083,7 +4083,7 @@ static void mem_cgroup_private_id_remove
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4093,7 +4093,22 @@ static inline void mem_cgroup_private_id
 	}
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+{
+	struct mem_cgroup *memcg;
+
+	lockdep_assert_in_rcu_read_lock();
+
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
+}
+
+static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
+{
+	__mem_cgroup_private_id_put(memcg, 1);
+}
+
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
 	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
@@ -4106,7 +4121,8 @@ struct mem_cgroup *mem_cgroup_private_id
 		}
 		memcg = parent_mem_cgroup(memcg);
 	}
-	return memcg;
+
+	return mem_cgroup_private_id(memcg);
 }
 
 /**
@@ -4431,7 +4447,7 @@ static void mem_cgroup_css_offline(struc
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5972,15 +5988,13 @@ int __mem_cgroup_try_charge_swap(struct
 			return 0;
 		}
 
-		memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-		/* memcg is pined by memcg ID. */
-		private_id = mem_cgroup_private_id(memcg);
+		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
 		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-			mem_cgroup_private_id_put(memcg, nr_pages);
+			mem_cgroup_private_id_put(private_id, nr_pages);
 			return -ENOMEM;
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
@@ -6012,7 +6026,7 @@ void __mem_cgroup_uncharge_swap(unsigned
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
 }
--- a/mm/memcontrol-v1.c~memcg-manipulate-memcg-private-id-references-by-id
+++ a/mm/memcontrol-v1.c
@@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *
  */
 void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 	unsigned short private_id;
@@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *foli
 	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
-	private_id = mem_cgroup_private_id(swap_memcg);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
--- a/mm/memcontrol-v1.h~memcg-manipulate-memcg-private-id-references-by-id
+++ a/mm/memcontrol-v1.h
@@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id
 	return id == mem_cgroup_private_id(root_mem_cgroup);
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
-						    unsigned int n);
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx);
_

Patches currently in -mm which might be from bingfangguo@tencent.com are

mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch
memcg-keep-swap-charging-under-rcu-protection.patch
memcg-base-swap-charge-accounting-on-memcgid-root-status.patch
memcg-manipulate-memcg-private-id-references-by-id.patch
memcg-move-memcg-private-id-refcount-to-objcg.patch

