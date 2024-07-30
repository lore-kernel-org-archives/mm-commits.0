Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D118B482
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722370735; cv=none; b=ijgPeCew0Dmr8JZiGVusNq/0K13qDXnc158LDQtvdNZIXKLemAdbHfcXu7puUrKBQbhDaLqSTckwL2eJmBmOHElZfqOczpDsA1z/oG0iEqDUxLqXSk7yC5Ey+Uzbje394Oszg+j3tKRKGsTf+OsipO6EAW3YsloETxYlgD+yFNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722370735; c=relaxed/simple;
	bh=/a7yG2M0pBpe3Dvcv/o2kJIEZH4/2lhrC+8QXAugELg=;
	h=Date:To:From:Subject:Message-Id; b=EiVujwmZKsr0eyd3hy2vZVvjLHtnBloIK2P3nKUaWy/rHq/+19vdYQVB5z026zWREOprPUE4sCai2HKFCAluQKMGpHPQEl1XGAkOoHu7IvN1MQhPgNIPneDrmXjzsZzT4CkNS5vDzgNVkzxs8jGR2ay6WGhbdwR5daUuyJiK8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=maBO/ZYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="maBO/ZYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5149DC32782;
	Tue, 30 Jul 2024 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722370735;
	bh=/a7yG2M0pBpe3Dvcv/o2kJIEZH4/2lhrC+8QXAugELg=;
	h=Date:To:From:Subject:From;
	b=maBO/ZYWBn5jVwtTuUbiz8MNPjUspVIfBaoJdx2mVoRKOqv9go7QfplZ067vklRFc
	 YAv1RlXBoXFzuLR3fkS+CtSDea/KaUgYBN04Qdy+a4Kf16B462Brdmx85gq0+qW7DS
	 WWkeDtnLL5dU8EMNUFMtdDfTwlxYOQ0rGOjsjgDc=
Date: Tue, 30 Jul 2024 13:18:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch removed from -mm tree
Message-Id: <20240730201855.5149DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmem: add lockdep assertion to obj_cgroup_memcg
has been removed from the -mm tree.  Its filename was
     mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kmem: add lockdep assertion to obj_cgroup_memcg
Date: Thu, 25 Jul 2024 17:43:30 +0800

The obj_cgroup_memcg() is supposed to safe to prevent the returned memory
cgroup from being freed only when the caller is holding the rcu read lock
or objcg_lock or cgroup_mutex.  It is very easy to ignore thoes conditions
when users call some upper APIs which call obj_cgroup_memcg() internally
like mem_cgroup_from_slab_obj() (See the link below).  So it is better to
add lockdep assertion to obj_cgroup_memcg() to find those issues ASAP.

Because there is no user of obj_cgroup_memcg() holding objcg_lock to make
the returned memory cgroup safe, do not add objcg_lock assertion (We
should export objcg_lock if we really want to do).  Additionally, this is
some internal implementation detail of memcg and should not be accessible
outside memcg code.

Some users like __mem_cgroup_uncharge() do not care the lifetime of the
returned memory cgroup, which just want to know if the folio is charged to
a memory cgroup, therefore, they do not need to hold the needed locks.  In
which case, introduce a new helper folio_memcg_charged() to do this. 
Compare it to folio_memcg(), it could eliminate a memory access of
objcg->memcg for kmem, actually, a really small gain.

Link: https://lore.kernel.org/all/20240718083607.42068-1-songmuchun@bytedance.com/
Link: https://lkml.kernel.org/r/20240725094330.72537-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   20 +++++++++++++++++---
 mm/memcontrol.c            |    6 +++---
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg
+++ a/include/linux/memcontrol.h
@@ -366,11 +366,11 @@ static inline bool folio_memcg_kmem(stru
  * After the initialization objcg->memcg is always pointing at
  * a valid memcg, but can be atomically swapped to the parent memcg.
  *
- * The caller must ensure that the returned memcg won't be released:
- * e.g. acquire the rcu_read_lock or css_set_lock.
+ * The caller must ensure that the returned memcg won't be released.
  */
 static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
+	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return READ_ONCE(objcg->memcg);
 }
 
@@ -444,6 +444,19 @@ static inline struct mem_cgroup *folio_m
 	return __folio_memcg(folio);
 }
 
+/*
+ * folio_memcg_charged - If a folio is charged to a memory cgroup.
+ * @folio: Pointer to the folio.
+ *
+ * Returns true if folio is charged to a memory cgroup, otherwise returns false.
+ */
+static inline bool folio_memcg_charged(struct folio *folio)
+{
+	if (folio_memcg_kmem(folio))
+		return __folio_objcg(folio) != NULL;
+	return __folio_memcg(folio) != NULL;
+}
+
 /**
  * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
  * @folio: Pointer to the folio.
@@ -460,7 +473,6 @@ static inline struct mem_cgroup *folio_m
 	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
 
 	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
-	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	if (memcg_data & MEMCG_DATA_KMEM) {
 		struct obj_cgroup *objcg;
@@ -469,6 +481,8 @@ static inline struct mem_cgroup *folio_m
 		return obj_cgroup_memcg(objcg);
 	}
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
 
--- a/mm/memcontrol.c~mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg
+++ a/mm/memcontrol.c
@@ -2374,7 +2374,7 @@ void mem_cgroup_cancel_charge(struct mem
 
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
-	VM_BUG_ON_FOLIO(folio_memcg(folio), folio);
+	VM_BUG_ON_FOLIO(folio_memcg_charged(folio), folio);
 	/*
 	 * Any of the following ensures page's memcg stability:
 	 *
@@ -4709,7 +4709,7 @@ void __mem_cgroup_uncharge(struct folio
 	struct uncharge_gather ug;
 
 	/* Don't touch folio->lru of any random page, pre-check: */
-	if (!folio_memcg(folio))
+	if (!folio_memcg_charged(folio))
 		return;
 
 	uncharge_gather_clear(&ug);
@@ -4754,7 +4754,7 @@ void mem_cgroup_replace_folio(struct fol
 		return;
 
 	/* Page cache replacement: new folio already charged? */
-	if (folio_memcg(new))
+	if (folio_memcg_charged(new))
 		return;
 
 	memcg = folio_memcg(old);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kmem-remove-mem_cgroup_from_obj.patch

