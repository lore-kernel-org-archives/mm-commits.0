Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832265;
	b=fNCnySXp/jqpOVr5knMLI5S8iwEk2jX15nUfOgggJ8J8VcfSjuG2sovv/1frpYhM5nXa
	 aqfdOcRg+j8+D5IB33axwjsjIqe3F+K+dZ8+QxaAFNti9f1DLnoxynWbXHnd7MND0SEat
	 CaTSl+9gtPbOipplv/kDxiGEDkPBwlMwSM/hPshnQ44V2HFePSCtb4urGK4sTetus128J
	 L3L+Mi5a5S0ELjtDJGwaYKCkdiUReo/o/6Tdob7+eIp3fKWbECUquQ2VyC2PX2kS26AH+
	 N2ZL8Q0CqTQp6khJlvKy1YnxZLPsuLt08PZH02L+WuT0XzWXlauLMqdV1r06BhlmcVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832265;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NHEISGyoal2V37RMrwy1zxIB2PNTj2QHkjcn0dm95IY=;
	b=zO5AXXTljeUu1Kn3VprOMsiK8yLZsM3Ht/I6ozUyKxj4q6Tirq+YYXctjK4bz520FABq
	 YTnK3rRQfIIIlC7XaM504+ia58Z3GfPq8kd1ojHKL31wSYloTsAMfW3p+wlztWPJJ1iQZ
	 D1Pwx4miavWgoowTY8pue40ZJ0Y8mj6VmeKAP2kLto0tIcKEV+ePGUu8+NNvSGgQ3sN8c
	 nt2uql5WQSxEHkEjltXdWIADPF2IYLJVOZis+NJMlIdU1nY9elFzhW+dzVViK7AYfm9b+
	 L8BcPtULpez1aWiLf0hk/M57dcBv1WPj1AU8Pd1Ofn3I/MxE8TQxBQtMbSkp+vdiU+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zyu5P39L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB392606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zyu5P39L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A908A1F01829;
	Sat, 24 Oct 2026 08:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832264;
	bh=NHEISGyoal2V37RMrwy1zxIB2PNTj2QHkjcn0dm95IY=;
	h=Date:To:From:Subject;
	b=zyu5P39LSjA2CbdpJ8mDKJaRcy3OAkQM8qc2BzHQk1FCYD5g1eKe2KEUH0GsR7D3x
	 kGg/ydsU7jEkY2nQFTLLZNld/Y0HVCdSEpgW6B0dMd4LsAiPMnjgqJmBa2b7SltFKE
	 8LMGqsAds1rTjWlea01b1btor1ATFh+WVrCSC56E=
Date: Sat, 24 Oct 2026 01:57:44 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-manipulate-memcg-private-id-references-by-id.patch removed from -mm tree
Message-Id: <20261024085744.A908A1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: memcg: manipulate memcg private ID references by ID
has been removed from the -mm tree.  Its filename was
     memcg-manipulate-memcg-private-id-references-by-id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id
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
@@ -4105,7 +4120,8 @@ struct mem_cgroup *mem_cgroup_private_id
 		}
 		memcg = parent_mem_cgroup(memcg);
 	}
-	return memcg;
+
+	return mem_cgroup_private_id(memcg);
 }
 
 /**
@@ -4430,7 +4446,7 @@ static void mem_cgroup_css_offline(struc
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5971,15 +5987,13 @@ int __mem_cgroup_try_charge_swap(struct
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
@@ -6011,7 +6025,7 @@ void __mem_cgroup_uncharge_swap(unsigned
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


