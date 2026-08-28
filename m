Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0605731195B
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787942775; cv=none; b=YyRIXLr3x+qit6wEyLx4Nsx3ouR5N5CkUFGSuCNxmej4rZyCpBIhF5OjR7oxlPT8u9dhm1tnWvEniPVQxbwspX2DqbulBmbcwoXvreSbD0siRq3NBJrJhdrTgI125++kkqdkHJmoASogcHWQQj4H5iHfZdTI0NIcOj9egtahPxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787942775; c=relaxed/simple;
	bh=1VDq144CdCla3UObVHbBBAcyWZe+HuKtdWZZmRI34mQ=;
	h=Date:To:From:Subject:Message-Id; b=tOc747MWzHiBvv5Ddj4poQA5NW1mZ9NQOD083I9z3Cxc3/bY1OyVobZSIYQcImF6ZDCXbWEnPoo6UEt8ZDtsSoqHETzTkBNbyL5JjUkylQxpaFMRD8P5Jm50+e3Q+xOfciu8vMk8PxDLbl2Bq6W4OqA4VFx/FKoSDpPkkJ2qTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T60FDhzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T60FDhzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADD41F000E9;
	Fri, 28 Aug 2026 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787942773;
	bh=BZAUPCSVjoRzaH+y+i/v7KLi+E8f5E7t16TDyIqlTfw=;
	h=Date:To:From:Subject;
	b=T60FDhzNM+PrOGutydfIR4NArDVajukwc3px1rIaQpTU3pggIvXy4LkCwOsUAH2/I
	 fdxr2mIXFbXHRDiPPsPcSpEwUJzcOpwm3AWcsocZpF8Z9GWw1mqld01wTgOxRqNeMV
	 34gnxM7NvqRADUAkBUUjbcZOsUsP3Hb6yfsD6PkM=
Date: Fri, 28 Aug 2026 11:46:13 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch added to mm-new branch
Message-Id: <20260828184613.8ADD41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
Date: Mon, 17 Aug 2026 17:03:26 +0800

obj_cgroup_memcg() currently requires a non-NULL objcg, so callers that
may hold a NULL objcg must guard the call with an explicit NULL check. 
This pattern is duplicated in folio_memcg(), folio_memcg_check(),
mm/page_owner.c, and mm/zswap.c.

Teach obj_cgroup_memcg() to accept NULL and return NULL in that case, then
remove the redundant NULL checks at the call sites.  Also remove the
mem_cgroup_from_entry() wrapper in zswap, which existed solely to provide
this NULL-safe behaviour, and replace its two callers with direct
obj_cgroup_memcg() calls.

No functional change intended.

Link: https://lore.kernel.org/09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 ++++++++---
 mm/page_owner.c            |    2 +-
 mm/zswap.c                 |   17 ++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/include/linux/memcontrol.h
@@ -380,7 +380,7 @@ enum objext_flags {
 static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
-	return READ_ONCE(objcg->memcg);
+	return objcg ? READ_ONCE(objcg->memcg) : NULL;
 }
 
 /*
@@ -433,7 +433,7 @@ static inline struct mem_cgroup *folio_m
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 /*
@@ -476,7 +476,7 @@ static inline struct mem_cgroup *folio_m
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
@@ -1050,6 +1050,11 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return NULL;
+}
+
 #define MEM_CGROUP_ID_SHIFT	0
 
 #define root_mem_cgroup		(NULL)
--- a/mm/page_owner.c~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/mm/page_owner.c
@@ -575,7 +575,7 @@ static inline int print_page_owner_memcg
 	}
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
+	memcg = obj_cgroup_memcg(objcg);
 	if (!memcg)
 		goto out_unlock;
 
--- a/mm/zswap.c~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/mm/zswap.c
@@ -647,19 +647,6 @@ static int zswap_enabled_param_set(const
 * lru functions
 **********************************/
 
-/* should be called under RCU */
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return entry->objcg ? obj_cgroup_memcg(entry->objcg) : NULL;
-}
-#else
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return NULL;
-}
-#endif
-
 static inline int entry_to_nid(struct zswap_entry *entry)
 {
 	return page_to_nid(virt_to_page(entry));
@@ -682,7 +669,7 @@ static void zswap_lru_add(struct zswap_e
 	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
@@ -694,7 +681,7 @@ static void zswap_lru_del(struct zswap_e
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

fs-fix-missed-removal-of-super_fs_objects_eligible.patch
mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch
mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch
mm-shmem-make-unused-huge-shrinker-memcg-aware.patch

