Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E843176036
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940701; cv=none; b=rcRPL6Gv0t2ttxVLoM33tL97qRblRpMSPae+sk00I1ffCd8XriLXAfkdEV6RMATIpHwLYB0vVJT9aKPkBf2L41Jb+8EfpXk2OKJFGvg55A58g0mAo6BtBKETBLVXwmRqFp1iXx4WLLrSYaRkp8J2VxMcej9rEPByIfvOBqaD4B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940701; c=relaxed/simple;
	bh=0QFXkqGZjZGvcodbMBakIyK0ii7f/aYHaWaVfgbsEoo=;
	h=Date:To:From:Subject:Message-Id; b=KoQzzFUYexRSMTatHTTrmMM/ZsjRT0XnkCmOz+XXKdgbGQi1uzVNqEJMkB8kHvs53qD+XQqvZCd93tSgb0gEgr5vpzBLFTMqv31Of8kQ3SoT/oSp6O9WiV17F5qKGoBLPiG3HUZfKQcrT9n+jXJRGvw2cJ5RWkOe3QMeXI/rKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbQJP7RG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbQJP7RG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58821C4AF07;
	Thu, 25 Jul 2024 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940700;
	bh=0QFXkqGZjZGvcodbMBakIyK0ii7f/aYHaWaVfgbsEoo=;
	h=Date:To:From:Subject:From;
	b=zbQJP7RGRo81xatnBzk8JG006Cy0EJMzMy+hKpMmjycEKHXYb3JLXBdYXUczzf0tr
	 2b+/fe0duo8metcCLPJRvwDl/4yiaX0As7nVvblix7ssQh1ZF2/tMKnAWFL7J+ysGr
	 OKqJ1l30ZwRnfJN8UIvzqFavueIwtAcgBb2w0o7Y=
Date: Thu, 25 Jul 2024 13:51:39 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch added to mm-unstable branch
Message-Id: <20240725205140.58821C4AF07@smtp.kernel.org>
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
mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

