Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F6134C141
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388561; cv=none; b=H6nqP3YNcH3LnwzO+BSy6oXlZLUw4RnjUzqo6NumLb01EYhD0c6Ga+uf8/qc08g7QZg+nesXaUe6CaIZm0DaAOC7QMS24fqJMyaoTKkB9RyUp9tyyrIO6irQCaflZC/vOVlwBTFFj1XVyvkkMjYNoK3xNvFHUwU2/4sWRrSi4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388561; c=relaxed/simple;
	bh=mhShd+i4bL5DPQ/l0bwgnyZrX5vs0mTEnye+voWrio4=;
	h=Date:To:From:Subject:Message-Id; b=RqPG2W1DcF6UklRfYXad/8UsjrJV+kQL+HYB1Jwu2cxMT+0x8lBXlmvb3x432W66sOBomWbQQRRwOL/X2bdWufDfLufpV7vxord+nwGzLGGaRKWAHQCGqjYv8FYsFo3mibxtlt96eUivFoPnRaJaJYLBD9LHQyXuYtgYu7kDwA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0MaOeYgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MaOeYgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD479C19424;
	Tue, 24 Mar 2026 21:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388560;
	bh=mhShd+i4bL5DPQ/l0bwgnyZrX5vs0mTEnye+voWrio4=;
	h=Date:To:From:Subject:From;
	b=0MaOeYgAp2XSKwu/fMYUPe0db9OVHEx7vq/YiPA4FFixWyLslyjs/NfHX+Z9G/AY8
	 StlVFaRuPXCaIA73O1c3TeUQdrlkO7+3WeB6i0MIHjXnZz5pbklxuLMmBtXGI2pIEp
	 Uh7TEdhVWItTfVnT/HN3a6X+Mt2WYE2jaKcr9qss=
Date: Tue, 24 Mar 2026 14:42:40 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,chenridong@huaweicloud.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-consolidate-private-id-refcount-get-put-helpers.patch removed from -mm tree
Message-Id: <20260324214240.BD479C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: consolidate private id refcount get/put helpers
has been removed from the -mm tree.  Its filename was
     memcg-consolidate-private-id-refcount-get-put-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: memcg: consolidate private id refcount get/put helpers
Date: Fri, 13 Feb 2026 18:03:32 +0800

We currently have two different sets of helpers for getting or putting the
private IDs' refcount for order 0 and large folios.  This is redundant. 
Just use one and always acquire the refcount of the swapout folio size
unless it's zero, and put the refcount using the folio size if the charge
failed, since the folio size can't change.  Then there is no need to
update the refcount for tail pages.

Same for freeing, then only one pair of get/put helper is needed now.

The performance might be slightly better, too: both "inc unless zero" and
"add unless zero" use the same cmpxchg implementation.  For large folios,
we saved an atomic operation.  And for both order 0 and large folios, we
saved a branch.

Link: https://lkml.kernel.org/r/20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Acked-by: Shakeel Butt <shakeel.butt@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    5 +----
 mm/memcontrol-v1.h |    4 ++--
 mm/memcontrol.c    |   29 +++++++----------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

--- a/mm/memcontrol.c~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol.c
@@ -3634,13 +3634,7 @@ static void mem_cgroup_private_id_remove
 	}
 }
 
-void __maybe_unused mem_cgroup_private_id_get_many(struct mem_cgroup *memcg,
-					   unsigned int n)
-{
-	refcount_add(n, &memcg->id.ref);
-}
-
-static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -3650,14 +3644,9 @@ static void mem_cgroup_private_id_put_ma
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg)
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	mem_cgroup_private_id_put_many(memcg, 1);
-}
-
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
-{
-	while (!refcount_inc_not_zero(&memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -3957,7 +3946,7 @@ static void mem_cgroup_css_offline(struc
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg);
+	mem_cgroup_private_id_put(memcg, 1);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5247,19 +5236,15 @@ int __mem_cgroup_try_charge_swap(struct
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg);
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
-
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_private_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
@@ -5288,7 +5273,7 @@ void __mem_cgroup_uncharge_swap(swp_entr
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put_many(memcg, nr_pages);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
--- a/mm/memcontrol-v1.c~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol-v1.c
@@ -635,11 +635,8 @@ void memcg1_swapout(struct folio *folio,
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
-	swap_memcg = mem_cgroup_private_id_get_online(memcg);
 	nr_entries = folio_nr_pages(folio);
-	/* Get references for the tail pages, too */
-	if (nr_entries > 1)
-		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
+	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
--- a/mm/memcontrol-v1.h~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol-v1.h
@@ -27,8 +27,8 @@ void drain_all_stock(struct mem_cgroup *
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 int memory_stat_show(struct seq_file *m, void *v);
 
-void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
+						    unsigned int n);
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
_

Patches currently in -mm which might be from kasong@tencent.com are


