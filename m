Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5453951FCAD
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030079; cv=none; b=BnHSAdyFkHZzXCqMVrl+7wgIKXP+5BN1q9QcAfdL/JI7kPkrCbCTgJdFH0SX2LI/7iGS52j0drsaupW8HAddtNtfNBi4h9ed1WkTUl96ZiIwOusPFfSSXAQL3XqUDhpDgEKnRnh8235E1CLg2O/0FnSVpI9+RpSLl/8wbgL0lrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030079; c=relaxed/simple;
	bh=xTSf5UYZ2SoIEwfBYg291NO2yFMsL+8jBwKxu4tSO4k=;
	h=Date:To:From:Subject:Message-Id; b=cbRAfa0r09b9e648C8llFJgvGdc8bAkcLDWhd8hHY4mJn1CQ5bVqTLlBE/Hnz1paBFaDDkXEBkdFAX3FIyuqtPrT8WNioLEqVryDxDsQx6DdvUzflDXZCBNA7RFYHA1K5qs4ic3xHP05AqgVf4B9d3LEVjzOtFsHIHc/K/vjGTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCsO0phu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCsO0phu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ACA1F000FF;
	Mon, 21 Sep 2026 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030077;
	bh=Oh22N8lXGssSj3gOaQsFoinEIPfoUgLXuCMIPeYg9sc=;
	h=Date:To:From:Subject;
	b=BCsO0phuSd9DDcb3T1w48j9GeSBt5YxPfYauvAGlWMvQzWiRPcfnN3rVRjmlocShv
	 OwIgxu4Xh5FCmVqSW9A5XPsoZOzsCWRMzLAb+J8nrMkMx3AVQ/W4OkyLmwo0kAXLM3
	 oVie210Bx9bCtA4cmVwnjn6xe8Bp3xlkePBytWAg=
Date: Mon, 21 Sep 2026 15:34:37 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-memcg-private-id-refcount-to-objcg.patch added to mm-new branch
Message-Id: <20260921223437.D9ACA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move memcg private ID refcount to objcg
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-memcg-private-id-refcount-to-objcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-memcg-private-id-refcount-to-objcg.patch

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
Subject: memcg: move memcg private ID refcount to objcg
Date: Mon, 21 Sep 2026 14:16:27 +0800

The memcg private ID is used by objects that can't afford storing a whole
pointer and can outlive memcgs to track the memcg (notably swap entries). 
The current design holds a refcount to the css, preventing the memcg from
being freed.

This patch unbinds the lifetime of memcgid from the memcg so it can be
freed.  The idea is to move the refcount of memcgid to one of the memcg's
objcg.  The objcg is stored in the global memcgid xarray instead and used
for retrieving the online memcg from it.  So swapped out pages no longer
pin the dying memcg.

After the change, a memcgid can refer to a non present memcg.  To handle
this situation, when trying to get the original memcg from the id, compare
the memcgid passed in with that of the memcg, and return NULL to indicate
its death if they differ.  NULL checks are added for list_lru_walk_node(),
workingset_test_recent() to skip dead memcgs.  For MGLRU recency test,
mem_cgroup_lruvec() will substitute NULL with root_mem_cgroup.

In the earlier patch, an extra xarray lookup was introduced in swap
uncharging path.  Now that we have the objcg pointer in the function, the
extra overhead can be removed by using it for putting directly.

Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com
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

 include/linux/memcontrol.h |    7 +--
 mm/list_lru.c              |    2 
 mm/memcontrol.c            |   73 +++++++++++++++++++++++++----------
 mm/workingset.c            |    2 
 4 files changed, 60 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-memcg-private-id-refcount-to-objcg
+++ a/include/linux/memcontrol.h
@@ -180,6 +180,7 @@ struct obj_cgroup {
 	struct percpu_ref refcnt;
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
+	refcount_t private_id_ref;
 	union {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
@@ -225,9 +226,6 @@ struct mem_cgroup {
 	/* vmpressure notifications. Written on every reclaim iteration. */
 	struct vmpressure vmpressure;
 
-	/* Written on every swap charge and uncharge. */
-	refcount_t private_id_ref;
-
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* MEMCG_KMEM for nmi context */
 	atomic_t		kmem_stat;
@@ -324,6 +322,9 @@ struct mem_cgroup {
 	unsigned long zswap_max;
 #endif
 
+	/* The objcg holding private memcg ID. */
+	struct obj_cgroup *private_id_objcg;
+
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
--- a/mm/list_lru.c~memcg-move-memcg-private-id-refcount-to-objcg
+++ a/mm/list_lru.c
@@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct
 		xa_for_each(&lru->xa, index, mlru) {
 			rcu_read_lock();
 			memcg = mem_cgroup_from_private_id(index);
-			if (!mem_cgroup_tryget(memcg)) {
+			if (!memcg || !mem_cgroup_tryget(memcg)) {
 				rcu_read_unlock();
 				continue;
 			}
--- a/mm/memcontrol.c~memcg-move-memcg-private-id-refcount-to-objcg
+++ a/mm/memcontrol.c
@@ -4075,6 +4075,13 @@ static void memcg_wb_domain_size_changed
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
+static inline struct obj_cgroup *obj_cgroup_from_private_id(unsigned short id)
+{
+	lockdep_assert_once(rcu_read_lock_held());
+
+	return xa_load(&mem_cgroup_private_ids, id);
+}
+
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->private_id > 0) {
@@ -4083,34 +4090,44 @@ static void mem_cgroup_private_id_remove
 	}
 }
 
-static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
+		unsigned short id, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
-		mem_cgroup_private_id_remove(memcg);
+	struct obj_cgroup *objcg_free;
 
-		/* Memcg ID pins CSS */
-		css_put(&memcg->css);
+	if (refcount_sub_and_test(n, &objcg->private_id_ref)) {
+		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
+		VM_WARN_ON(objcg_free != objcg);
+
+		/* Memcg ID pins the objcg */
+		obj_cgroup_put(objcg);
 	}
 }
 
 static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	lockdep_assert_in_rcu_read_lock();
 
-	memcg = mem_cgroup_from_private_id(id);
-	__mem_cgroup_private_id_put(memcg, n);
+	objcg = obj_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(objcg, id, n);
 }
 
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_private_id_put(memcg, 1);
+	__mem_cgroup_private_id_put(memcg->private_id_objcg, memcg->private_id, 1);
 }
 
 unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
+	struct obj_cgroup *objcg;
+
+	lockdep_assert_once(rcu_read_lock_held());
+
+	objcg = memcg->private_id_objcg;
+
+	while (!refcount_add_not_zero(n, &objcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4120,6 +4137,7 @@ unsigned short mem_cgroup_private_id_get
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
+		objcg = memcg->private_id_objcg;
 	}
 
 	return mem_cgroup_private_id(memcg);
@@ -4130,11 +4148,25 @@ unsigned short mem_cgroup_private_id_get
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
+ *
+ * @return: the memcg, or NULL if the memcg referred to is already dead.
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return xa_load(&mem_cgroup_private_ids, id);
+
+	objcg = obj_cgroup_from_private_id(id);
+	if (!objcg)
+		return NULL;
+
+	memcg = obj_cgroup_memcg(objcg);
+	if (mem_cgroup_private_id(memcg) != id)
+		return NULL;
+
+	return memcg;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
@@ -4381,9 +4413,10 @@ static int mem_cgroup_css_online(struct
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->private_id_ref, 1);
-	css_get(css);
+	/* CSS pins memcg ID, memcg ID pins obj cgroup */
+	memcg->private_id_objcg = objcg;
+	refcount_set(&memcg->private_id_objcg->private_id_ref, 1);
+	obj_cgroup_get(memcg->private_id_objcg);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4395,7 +4428,7 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
@@ -5833,8 +5866,6 @@ static void __init memcg_struct_check(vo
 				      memory_events_local);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      vmpressure);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
-				      private_id_ref);
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      kmem_stat);
@@ -5880,6 +5911,8 @@ static void __init memcg_struct_check(vo
 				      zswap_writeback);
 #endif
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id_objcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      kmemcg_id);
@@ -6014,10 +6047,12 @@ int __mem_cgroup_try_charge_swap(struct
  */
 void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
+	objcg = obj_cgroup_from_private_id(id);
+	memcg = obj_cgroup_memcg(objcg);
 	if (memcg) {
 		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
@@ -6026,7 +6061,7 @@ void __mem_cgroup_uncharge_swap(unsigned
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(id, nr_pages);
+		__mem_cgroup_private_id_put(objcg, id, nr_pages);
 	}
 	rcu_read_unlock();
 }
--- a/mm/workingset.c~memcg-move-memcg-private-id-refcount-to-objcg
+++ a/mm/workingset.c
@@ -470,7 +470,7 @@ bool workingset_test_recent(void *shadow
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from bingfangguo@tencent.com are

mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch
memcg-keep-swap-charging-under-rcu-protection.patch
memcg-base-swap-charge-accounting-on-memcgid-root-status.patch
memcg-manipulate-memcg-private-id-references-by-id.patch
memcg-move-memcg-private-id-refcount-to-objcg.patch

