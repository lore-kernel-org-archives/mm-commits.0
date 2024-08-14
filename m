Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DD31B1505
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 19:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723663630; cv=none; b=MMAYzMwKykdHlXbmD1vXiATQPKiZThWfItjAFNb8/i/qt2CZaMEl1KXQW7WbW1wc24svJGlYKuQdEc+XQbDOB8WlUWpcK7EHJm/W+i79kR08yzYOgH+bKdI6cG8vmhXQZVB0KnO1Wi/xHKDp6Ue6FYI+SNliSpGc7GGRIx6MUQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723663630; c=relaxed/simple;
	bh=KTJHVBjM9gNVt/u+vvayStakispL2mnLtxzgMi0FIBE=;
	h=Date:To:From:Subject:Message-Id; b=uxbH/qVURWoaqMuvZ+d2aJCn5vsu02tKbfCLGcTu7CttQTtzMTn3bOfq0IuL263clRCYU8gTTPhrrWvjo20ODTEJZcR1BhhiGjUvIGDkOTm4iQmgGlJHw/AWXYo0KM3O24HvzDaSqMkvTQYbKC8CRFCAGz1kplyD+QSsm3rCfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KA450T4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KA450T4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0D1C116B1;
	Wed, 14 Aug 2024 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723663630;
	bh=KTJHVBjM9gNVt/u+vvayStakispL2mnLtxzgMi0FIBE=;
	h=Date:To:From:Subject:From;
	b=KA450T4L+JkZeiQF9KinSq2DzqCU49B0FgiHOhu9QLkYXfZMRWwHoiycHo4QxaLUJ
	 l8TaQWgjqmWv0Y2dZE37wA7mP62RWTjIW9yJPecGo40KpcX3SSBualR/AGks/uerzg
	 ZoKpnZTNPQUCNoEq9AhY7nhbYbadaRt7I6L5uzyo=
Date: Wed, 14 Aug 2024 12:27:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch added to mm-unstable branch
Message-Id: <20240814192710.3C0D1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmem: add lockdep assertion to obj_cgroup_memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kmem: add lockdep assertion to obj_cgroup_memcg
Date: Wed, 14 Aug 2024 17:34:15 +0800

obj_cgroup_memcg() is supposed to safe to prevent the returned memory
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
Link: https://lkml.kernel.org/r/20240814093415.17634-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
@@ -4708,7 +4708,7 @@ void __mem_cgroup_uncharge(struct folio
 	struct uncharge_gather ug;
 
 	/* Don't touch folio->lru of any random page, pre-check: */
-	if (!folio_memcg(folio))
+	if (!folio_memcg_charged(folio))
 		return;
 
 	uncharge_gather_clear(&ug);
@@ -4753,7 +4753,7 @@ void mem_cgroup_replace_folio(struct fol
 		return;
 
 	/* Page cache replacement: new folio already charged? */
-	if (folio_memcg(new))
+	if (folio_memcg_charged(new))
 		return;
 
 	memcg = folio_memcg(old);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kmem-remove-mem_cgroup_from_obj.patch
mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

