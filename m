Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521C31C695
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498492; cv=none; b=JvLtkVvUBJ8V/l4HWNjP0pw1pyI2w2i5mbY+kFbMVv1eCz0kV1lERXXF2wQBRlx5JhkOCeOh2mwQOVI7TJwxg4YVFht9bOg4DqhtW9K9awGpY4sJaM4vB62BXelTTgucW/8ZaJF1P1uW79j9N0tx6gkHfYNnVU+WZXAvC5lhxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498492; c=relaxed/simple;
	bh=HYcsnOl5WC1rv9nZ1fpgFbN3eyfVTv6zZj143vaB9CY=;
	h=Date:To:From:Subject:Message-Id; b=eWqg7e8LB3HbwN07L0pZ8P77l/wXKPVG/0uRVRIi3E0SIJytjSI22Ia2BbUH6gCwwnoScQTUCCXZ09RPGI7etpByYEwDbSeWysSifJspiXRgl6Qxw+Ue+HYKyVwUQbks3mzumBZGOTqv+xrc+BMFDrjTg2298s1wRe497YJMaVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CoT53y54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CoT53y54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76914C19424;
	Sat, 18 Apr 2026 07:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498492;
	bh=HYcsnOl5WC1rv9nZ1fpgFbN3eyfVTv6zZj143vaB9CY=;
	h=Date:To:From:Subject:From;
	b=CoT53y54+jjNEIYa42U1DgBrXctQ0s/szIAa+n6TV4hHxqxGCXps6qp6LIFzjCmJS
	 OOOqmfp+ulKmQwHhbiGk1+a6vpk3RTjuU9J9yoHPFruoIMgftWHX0uE/U9y95x5wJe
	 +PJ9pYgXiPYTDH4vFuFRaXSFxeNj/MVU4AFqLcBc=
Date: Sat, 18 Apr 2026 00:48:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup.patch removed from -mm tree
Message-Id: <20260418074810.76914C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: return root object cgroup for root memory cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: return root object cgroup for root memory cgroup
Date: Thu, 5 Mar 2026 19:52:25 +0800

Memory cgroup functions such as get_mem_cgroup_from_folio() and
get_mem_cgroup_from_mm() return a valid memory cgroup pointer, even for
the root memory cgroup.  In contrast, the situation for object cgroups has
been different.

Previously, the root object cgroup couldn't be returned because it didn't
exist.  Now that a valid root object cgroup exists, for the sake of
consistency, it's necessary to align the behavior of object-cgroup-related
operations with that of memory cgroup APIs.

Link: https://lore.kernel.org/e9c3f40ba7681d9753372d4ee2ac7a0216848b95.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   26 +++++++++++++++-----
 mm/memcontrol.c            |   45 ++++++++++++++++++-----------------
 mm/percpu.c                |    2 -
 3 files changed, 45 insertions(+), 28 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup
+++ a/include/linux/memcontrol.h
@@ -332,6 +332,7 @@ struct mem_cgroup {
 #define MEMCG_CHARGE_BATCH 64U
 
 extern struct mem_cgroup *root_mem_cgroup;
+extern struct obj_cgroup *root_obj_cgroup;
 
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an slabobj_ext vector */
@@ -548,6 +549,11 @@ static inline bool mem_cgroup_is_root(st
 	return (memcg == root_mem_cgroup);
 }
 
+static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
+{
+	return objcg == root_obj_cgroup;
+}
+
 static inline bool mem_cgroup_disabled(void)
 {
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
@@ -774,23 +780,26 @@ struct mem_cgroup *mem_cgroup_from_css(s
 
 static inline bool obj_cgroup_tryget(struct obj_cgroup *objcg)
 {
+	if (obj_cgroup_is_root(objcg))
+		return true;
 	return percpu_ref_tryget(&objcg->refcnt);
 }
 
-static inline void obj_cgroup_get(struct obj_cgroup *objcg)
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
 {
-	percpu_ref_get(&objcg->refcnt);
+	if (!obj_cgroup_is_root(objcg))
+		percpu_ref_get_many(&objcg->refcnt, nr);
 }
 
-static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
-				       unsigned long nr)
+static inline void obj_cgroup_get(struct obj_cgroup *objcg)
 {
-	percpu_ref_get_many(&objcg->refcnt, nr);
+	obj_cgroup_get_many(objcg, 1);
 }
 
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
-	if (objcg)
+	if (objcg && !obj_cgroup_is_root(objcg))
 		percpu_ref_put(&objcg->refcnt);
 }
 
@@ -1086,6 +1095,11 @@ static inline bool mem_cgroup_is_root(st
 {
 	return true;
 }
+
+static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
+{
+	return true;
+}
 
 static inline bool mem_cgroup_disabled(void)
 {
--- a/mm/memcontrol.c~mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup
+++ a/mm/memcontrol.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 EXPORT_SYMBOL(root_mem_cgroup);
 
+struct obj_cgroup *root_obj_cgroup __read_mostly;
+
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
@@ -2693,15 +2695,14 @@ struct mem_cgroup *mem_cgroup_from_virt(
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg = NULL;
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		struct obj_cgroup *objcg = rcu_dereference(memcg->objcg);
 
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
-		objcg = rcu_dereference(memcg->objcg);
 		if (likely(objcg && obj_cgroup_tryget(objcg)))
-			break;
-		objcg = NULL;
+			return objcg;
 	}
-	return objcg;
+
+	return NULL;
 }
 
 static struct obj_cgroup *current_objcg_update(void)
@@ -2775,18 +2776,17 @@ __always_inline struct obj_cgroup *curre
 		 * Objcg reference is kept by the task, so it's safe
 		 * to use the objcg by the current task.
 		 */
-		return objcg;
+		return objcg ? : root_obj_cgroup;
 	}
 
 	memcg = this_cpu_read(int_active_memcg);
 	if (unlikely(memcg))
 		goto from_memcg;
 
-	return NULL;
+	return root_obj_cgroup;
 
 from_memcg:
-	objcg = NULL;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		/*
 		 * Memcg pointer is protected by scope (see set_active_memcg())
 		 * and is pinning the corresponding objcg, so objcg can't go
@@ -2795,10 +2795,10 @@ from_memcg:
 		 */
 		objcg = rcu_dereference_check(memcg->objcg, 1);
 		if (likely(objcg))
-			break;
+			return objcg;
 	}
 
-	return objcg;
+	return root_obj_cgroup;
 }
 
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
@@ -2812,14 +2812,8 @@ struct obj_cgroup *get_obj_cgroup_from_f
 		objcg = __folio_objcg(folio);
 		obj_cgroup_get(objcg);
 	} else {
-		struct mem_cgroup *memcg;
-
 		rcu_read_lock();
-		memcg = __folio_memcg(folio);
-		if (memcg)
-			objcg = __get_obj_cgroup_from_memcg(memcg);
-		else
-			objcg = NULL;
+		objcg = __get_obj_cgroup_from_memcg(__folio_memcg(folio));
 		rcu_read_unlock();
 	}
 	return objcg;
@@ -2922,7 +2916,7 @@ int __memcg_kmem_charge_page(struct page
 	int ret = 0;
 
 	objcg = current_obj_cgroup();
-	if (objcg) {
+	if (objcg && !obj_cgroup_is_root(objcg)) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
@@ -3251,7 +3245,7 @@ bool __memcg_slab_post_alloc_hook(struct
 	 * obj_cgroup_get() is used to get a permanent reference.
 	 */
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	/*
@@ -3927,6 +3921,9 @@ static int mem_cgroup_css_online(struct
 	if (!objcg)
 		goto free_shrinker;
 
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		root_obj_cgroup = objcg;
+
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 	obj_cgroup_get(objcg);
@@ -5551,6 +5548,9 @@ void obj_cgroup_charge_zswap(struct obj_
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -5580,6 +5580,9 @@ void obj_cgroup_uncharge_zswap(struct ob
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
--- a/mm/percpu.c~mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup
+++ a/mm/percpu.c
@@ -1622,7 +1622,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
 		return true;
 
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


