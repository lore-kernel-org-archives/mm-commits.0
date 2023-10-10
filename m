Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15799CD8CAE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjJJSUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjJJSUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:20:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A531199
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:20:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B51CC433C7;
        Tue, 10 Oct 2023 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696962048;
        bh=I1qFNAEOmIo7sEZwIkIFhPBeo6t0wtdwcLi+IfPbRp0=;
        h=Date:To:From:Subject:From;
        b=Gt6OBiIb50462xuIUp9duhlrRaFekdxbSh3Y7t+J1sb7hTLNqfxtWJ6HJNe/I9Uau
         l36BjxEy4TFsRMn10LIJXjE2cBJzTGmGcG0D0qsdWI7j91Ss33BrZerbO4f/+Agsi4
         9liVb5eom/tlk4xL8Yttg4vRZUnR/9lUgtSbfhJI=
Date:   Tue, 10 Oct 2023 11:20:12 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-scoped-objcg-protection.patch added to mm-unstable branch
Message-Id: <20231010182022.8B51CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: scoped objcg protection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-scoped-objcg-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-scoped-objcg-protection.patch

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
Subject: mm: kmem: scoped objcg protection
Date: Mon, 9 Oct 2023 17:09:28 -0700

Switch to a scope-based protection of the objcg pointer on slab/kmem
allocation paths. Instead of using the get_() semantics in the
pre-allocation hook and put the reference afterwards, let's rely
on the fact that objcg is pinned by the scope.

It's possible because:
1) if the objcg is received from the current task struct, the task is
   keeping a reference to the objcg.
2) if the objcg is received from an active memcg (remote charging),
   the memcg is pinned by the scope and has a reference to the
   corresponding objcg.

Link: https://lkml.kernel.org/r/20231010000929.450702-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++
 mm/memcontrol.c            |   47 +++++++++++++++++++++++++++++++++--
 mm/slab.h                  |   10 ++-----
 3 files changed, 54 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-scoped-objcg-protection
+++ a/include/linux/memcontrol.h
@@ -1802,6 +1802,12 @@ bool mem_cgroup_kmem_disabled(void);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+/*
+ * The returned objcg pointer is safe to use without additional
+ * protection within a scope, refer to the implementation for the
+ * additional details.
+ */
+struct obj_cgroup *current_obj_cgroup(void);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
 
--- a/mm/memcontrol.c~mm-kmem-scoped-objcg-protection
+++ a/mm/memcontrol.c
@@ -3185,6 +3185,49 @@ from_memcg:
 	return objcg;
 }
 
+__always_inline struct obj_cgroup *current_obj_cgroup(void)
+{
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (in_task()) {
+		memcg = current->active_memcg;
+		if (unlikely(memcg))
+			goto from_memcg;
+
+		objcg = READ_ONCE(current->objcg);
+		if (unlikely((unsigned long)objcg & CURRENT_OBJCG_UPDATE_FLAG))
+			objcg = current_objcg_update();
+		/*
+		 * Objcg reference is kept by the task, so it's safe
+		 * to use the objcg by the current task.
+		 */
+		return objcg;
+	}
+
+	memcg = this_cpu_read(int_active_memcg);
+	if (unlikely(memcg))
+		goto from_memcg;
+
+	return NULL;
+
+from_memcg:
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
+		/*
+		 * Memcg pointer is protected by scope (see set_active_memcg())
+		 * and is pinning the corresponding objcg, so objcg can't go
+		 * away and can be used within the scope without any additional
+		 * protection.
+		 */
+		objcg = rcu_dereference_check(memcg->objcg, 1);
+		if (likely(objcg))
+			break;
+		objcg = NULL;
+	}
+
+	return objcg;
+}
+
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	struct obj_cgroup *objcg;
@@ -3279,15 +3322,15 @@ int __memcg_kmem_charge_page(struct page
 	struct obj_cgroup *objcg;
 	int ret = 0;
 
-	objcg = get_obj_cgroup_from_current();
+	objcg = current_obj_cgroup();
 	if (objcg) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
+			obj_cgroup_get(objcg);
 			page->memcg_data = (unsigned long)objcg |
 				MEMCG_DATA_KMEM;
 			return 0;
 		}
-		obj_cgroup_put(objcg);
 	}
 	return ret;
 }
--- a/mm/slab.h~mm-kmem-scoped-objcg-protection
+++ a/mm/slab.h
@@ -484,7 +484,7 @@ static inline bool memcg_slab_pre_alloc_
 	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
 		return true;
 
-	objcg = get_obj_cgroup_from_current();
+	objcg = current_obj_cgroup();
 	if (!objcg)
 		return true;
 
@@ -497,17 +497,14 @@ static inline bool memcg_slab_pre_alloc_
 		css_put(&memcg->css);
 
 		if (ret)
-			goto out;
+			return false;
 	}
 
 	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s)))
-		goto out;
+		return false;
 
 	*objcgp = objcg;
 	return true;
-out:
-	obj_cgroup_put(objcg);
-	return false;
 }
 
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
@@ -542,7 +539,6 @@ static inline void memcg_slab_post_alloc
 			obj_cgroup_uncharge(objcg, obj_full_size(s));
 		}
 	}
-	obj_cgroup_put(objcg);
 }
 
 static inline void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

