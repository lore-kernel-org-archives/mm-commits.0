Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA645C61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 22:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjBNWZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 17:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjBNWZg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 17:25:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CF02CC42
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 14:25:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E9BFB81F5E
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 22:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C217FC433EF;
        Tue, 14 Feb 2023 22:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676413531;
        bh=mLAMBr6BSyQj5gD/MiRYsO/sub4AKt4+llcQ59vx29o=;
        h=Date:To:From:Subject:From;
        b=2udyTu2SvvL2WuNFfsRiPvMe2e2B7pwvCx/DNwecptt2MbRjPfX0K+uCupLjo5tAk
         AcBXfkJUIfVH9tcqCEVH0lDyXvlJP/8A4/2U4+sBQQ+V7MkNujNCOKSfR0K5W81zAd
         JS9Hz5O+x2Sjft5X5mBH6lPgqPMWNSKaD8guJYO8=
Date:   Tue, 14 Feb 2023 14:25:31 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-rename-memcg_kmem_enabled.patch added to mm-unstable branch
Message-Id: <20230214222531.C217FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rename memcg_kmem_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-rename-memcg_kmem_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-rename-memcg_kmem_enabled.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcontrol: rename memcg_kmem_enabled()
Date: Mon, 13 Feb 2023 11:29:22 -0800

Currently there are two kmem-related helper functions with a confusing
semantics: memcg_kmem_enabled() and mem_cgroup_kmem_disabled().

The problem is that an obvious expectation
memcg_kmem_enabled() == !mem_cgroup_kmem_disabled(),
can be false.

mem_cgroup_kmem_disabled() is similar to mem_cgroup_disabled(): it returns
true only if CONFIG_MEMCG_KMEM is not set or the kmem accounting is
disabled using a boot time kernel option "cgroup.memory=nokmem".  It never
changes the value dynamically.

memcg_kmem_enabled() is different: it always returns false until the first
non-root memory cgroup will get online (assuming the kernel memory
accounting is enabled).  It's goal is to improve the performance on
systems without the cgroupfs mounted/memory controller enabled or on the
systems with only the root memory cgroup.

To make things more obvious and avoid potential bugs, let's rename
memcg_kmem_enabled() to memcg_kmem_online().

Link: https://lkml.kernel.org/r/20230213192922.1146370-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/include/linux/memcontrol.h
@@ -1776,24 +1776,24 @@ struct obj_cgroup *get_obj_cgroup_from_p
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
-extern struct static_key_false memcg_kmem_enabled_key;
+extern struct static_key_false memcg_kmem_online_key;
 
-static inline bool memcg_kmem_enabled(void)
+static inline bool memcg_kmem_online(void)
 {
-	return static_branch_likely(&memcg_kmem_enabled_key);
+	return static_branch_likely(&memcg_kmem_online_key);
 }
 
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
-	if (memcg_kmem_enabled())
+	if (memcg_kmem_online())
 		return __memcg_kmem_charge_page(page, gfp, order);
 	return 0;
 }
 
 static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	if (memcg_kmem_enabled())
+	if (memcg_kmem_online())
 		__memcg_kmem_uncharge_page(page, order);
 }
 
@@ -1814,7 +1814,7 @@ static inline void count_objcg_event(str
 {
 	struct mem_cgroup *memcg;
 
-	if (!memcg_kmem_enabled())
+	if (!memcg_kmem_online())
 		return;
 
 	rcu_read_lock();
@@ -1854,7 +1854,7 @@ static inline struct obj_cgroup *get_obj
 	return NULL;
 }
 
-static inline bool memcg_kmem_enabled(void)
+static inline bool memcg_kmem_online(void)
 {
 	return false;
 }
--- a/mm/memcontrol.c~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/mm/memcontrol.c
@@ -345,8 +345,8 @@ static void memcg_reparent_objcgs(struct
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
-DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
-EXPORT_SYMBOL(memcg_kmem_enabled_key);
+DEFINE_STATIC_KEY_FALSE(memcg_kmem_online_key);
+EXPORT_SYMBOL(memcg_kmem_online_key);
 #endif
 
 /**
@@ -3034,7 +3034,7 @@ struct obj_cgroup *get_obj_cgroup_from_p
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled())
+	if (!memcg_kmem_online())
 		return NULL;
 
 	if (PageMemcgKmem(page)) {
@@ -3746,7 +3746,7 @@ static int memcg_online_kmem(struct mem_
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 
-	static_branch_enable(&memcg_kmem_enabled_key);
+	static_branch_enable(&memcg_kmem_online_key);
 
 	memcg->kmemcg_id = memcg->id.id;
 
--- a/mm/page_alloc.c~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/mm/page_alloc.c
@@ -1410,7 +1410,7 @@ static __always_inline bool free_pages_p
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageMemcgKmem(page))
+		if (memcg_kmem_online() && PageMemcgKmem(page))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
@@ -1441,7 +1441,7 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_enabled() && PageMemcgKmem(page))
+	if (memcg_kmem_online() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free && free_page_is_bad(page))
 		bad++;
@@ -5446,7 +5446,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		goto out;
 
 	/* Bulk allocator does not support memcg accounting. */
-	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT))
+	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT))
 		goto failed;
 
 	/* Use the single page allocator for one page. */
@@ -5618,7 +5618,7 @@ struct page *__alloc_pages(gfp_t gfp, un
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
 out:
-	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT) && page &&
+	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_pages(page, order);
 		page = NULL;
--- a/mm/percpu.c~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/mm/percpu.c
@@ -1625,7 +1625,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT))
+	if (!memcg_kmem_online() || !(gfp & __GFP_ACCOUNT))
 		return true;
 
 	objcg = get_obj_cgroup_from_current();
--- a/mm/slab.h~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/mm/slab.h
@@ -494,7 +494,7 @@ static inline bool memcg_slab_pre_alloc_
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled())
+	if (!memcg_kmem_online())
 		return true;
 
 	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
@@ -535,7 +535,7 @@ static inline void memcg_slab_post_alloc
 	unsigned long off;
 	size_t i;
 
-	if (!memcg_kmem_enabled() || !objcg)
+	if (!memcg_kmem_online() || !objcg)
 		return;
 
 	for (i = 0; i < size; i++) {
@@ -567,7 +567,7 @@ static inline void memcg_slab_free_hook(
 	struct obj_cgroup **objcgs;
 	int i;
 
-	if (!memcg_kmem_enabled())
+	if (!memcg_kmem_online())
 		return;
 
 	objcgs = slab_objcgs(slab);
@@ -649,7 +649,7 @@ static inline struct kmem_cache *virt_to
 static __always_inline void account_slab(struct slab *slab, int order,
 					 struct kmem_cache *s, gfp_t gfp)
 {
-	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
+	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
 		memcg_alloc_slab_cgroups(slab, s, gfp, true);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
@@ -659,7 +659,7 @@ static __always_inline void account_slab
 static __always_inline void unaccount_slab(struct slab *slab, int order,
 					   struct kmem_cache *s)
 {
-	if (memcg_kmem_enabled())
+	if (memcg_kmem_online())
 		memcg_free_slab_cgroups(slab);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
--- a/mm/vmscan.c~mm-memcontrol-rename-memcg_kmem_enabled
+++ a/mm/vmscan.c
@@ -915,7 +915,7 @@ static unsigned long shrink_slab_memcg(g
 		}
 
 		/* Call non-slab shrinkers even though kmem is disabled */
-		if (!memcg_kmem_enabled() &&
+		if (!memcg_kmem_online() &&
 		    !(shrinker->flags & SHRINKER_NONSLAB))
 			continue;
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-rename-memcg_kmem_enabled.patch

