Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E65D13CF93
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711480573; cv=none; b=tbHoFB0EOrOUriDwFtXcAwUaJvFtmQStQRW+Mip1XRylNRy44FyYzZNf/5vI6/umJ+KCpobjq/X8lClqD5BKRxXxqZ7u2+JFiIubLsGDEet+H+HYR7oxtFlw75+3KnYsewgEO/3WlYem26ezWKaJIi8kiPNnCfN5QoFIBDf6dE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711480573; c=relaxed/simple;
	bh=zfWavE3OCSBHfUfUlDqQocOu6WO3EnGCmNQrLZNgyBk=;
	h=Date:To:From:Subject:Message-Id; b=EVD8zPeGEsXsQLc5quJ8WuynB4DPhls/VmRrm34XGhOAlLbR3YtiytyBAQ5OBzKwL58VFfDgD7pIUFRkZsI0Av/G8kZySjwu7LROsj1gZwopSusK2YnKDOF189JetduABOcNpVZM9X1IL84rNbKjJP7KQZkzAazFBl2AW+FPot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agdPo0lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agdPo0lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133D7C433C7;
	Tue, 26 Mar 2024 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711480572;
	bh=zfWavE3OCSBHfUfUlDqQocOu6WO3EnGCmNQrLZNgyBk=;
	h=Date:To:From:Subject:From;
	b=agdPo0lbuH00Rudifgetm6g+2wKSr5KiFoRSovH5WsmOuVdqBPsBX5RYSdthOfFat
	 GgnFYmafvwEq531PA6B7McQOTFh0gIyKohAAAgFppH6AS8ax5sa6xzU+kCH06hi8LR
	 jookA6xt0NNT5tjc/tiIs/+MvQuTCeCryL7OxO1U=
Date: Tue, 26 Mar 2024 12:16:11 -0700
To: mm-commits@vger.kernel.org,viro@ZenIV.linux.org.uk,torvalds@linux-foundation.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,kees@kernel.org,jpoimboe@kernel.org,jlayton@kernel.org,jack@suse.cz,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,cl@linux.com,chuck.lever@oracle.com,chengming.zhou@linux.dev,brauner@kernel.org,42.hyeyoo@gmail.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch added to mm-unstable branch
Message-Id: <20240326191612.133D7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, slab: move slab_memcg hooks to mm/memcontrol.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: move slab_memcg hooks to mm/memcontrol.c
Date: Tue, 26 Mar 2024 11:37:39 +0100

The hooks make multiple calls to functions in mm/memcontrol.c, including
to th current_obj_cgroup() marked __always_inline.  It might be faster to
make a single call to the hook in mm/memcontrol.c instead.  The hooks also
don't use almost anything from mm/slub.c.  obj_full_size() can move with
the hooks and cache_vmstat_idx() to the internal mm/slab.h

Link: https://lkml.kernel.org/r/20240326-slab-memcg-v3-2-d85d2563287a@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   90 ++++++++++++++++++++++++++++++++++++++++
 mm/slab.h       |   13 +++++
 mm/slub.c       |  103 ----------------------------------------------
 3 files changed, 105 insertions(+), 101 deletions(-)

--- a/mm/memcontrol.c~mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc
+++ a/mm/memcontrol.c
@@ -3556,6 +3556,96 @@ void obj_cgroup_uncharge(struct obj_cgro
 	refill_obj_stock(objcg, size, true);
 }
 
+static inline size_t obj_full_size(struct kmem_cache *s)
+{
+	/*
+	 * For each accounted object there is an extra space which is used
+	 * to store obj_cgroup membership. Charge it too.
+	 */
+	return s->size + sizeof(struct obj_cgroup *);
+}
+
+bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
+				  gfp_t flags, size_t size, void **p)
+{
+	struct obj_cgroup *objcg;
+	struct slab *slab;
+	unsigned long off;
+	size_t i;
+
+	/*
+	 * The obtained objcg pointer is safe to use within the current scope,
+	 * defined by current task or set_active_memcg() pair.
+	 * obj_cgroup_get() is used to get a permanent reference.
+	 */
+	objcg = current_obj_cgroup();
+	if (!objcg)
+		return true;
+
+	/*
+	 * slab_alloc_node() avoids the NULL check, so we might be called with a
+	 * single NULL object. kmem_cache_alloc_bulk() aborts if it can't fill
+	 * the whole requested size.
+	 * return success as there's nothing to free back
+	 */
+	if (unlikely(*p == NULL))
+		return true;
+
+	flags &= gfp_allowed_mask;
+
+	if (lru) {
+		int ret;
+		struct mem_cgroup *memcg;
+
+		memcg = get_mem_cgroup_from_objcg(objcg);
+		ret = memcg_list_lru_alloc(memcg, lru, flags);
+		css_put(&memcg->css);
+
+		if (ret)
+			return false;
+	}
+
+	if (obj_cgroup_charge(objcg, flags, size * obj_full_size(s)))
+		return false;
+
+	for (i = 0; i < size; i++) {
+		slab = virt_to_slab(p[i]);
+
+		if (!slab_obj_exts(slab) &&
+		    alloc_slab_obj_exts(slab, s, flags, false)) {
+			obj_cgroup_uncharge(objcg, obj_full_size(s));
+			continue;
+		}
+
+		off = obj_to_index(s, slab, p[i]);
+		obj_cgroup_get(objcg);
+		slab_obj_exts(slab)[off].objcg = objcg;
+		mod_objcg_state(objcg, slab_pgdat(slab),
+				cache_vmstat_idx(s), obj_full_size(s));
+	}
+
+	return true;
+}
+
+void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
+			    void **p, int objects, struct slabobj_ext *obj_exts)
+{
+	for (int i = 0; i < objects; i++) {
+		struct obj_cgroup *objcg;
+		unsigned int off;
+
+		off = obj_to_index(s, slab, p[i]);
+		objcg = obj_exts[off].objcg;
+		if (!objcg)
+			continue;
+
+		obj_exts[off].objcg = NULL;
+		obj_cgroup_uncharge(objcg, obj_full_size(s));
+		mod_objcg_state(objcg, slab_pgdat(slab), cache_vmstat_idx(s),
+				-obj_full_size(s));
+		obj_cgroup_put(objcg);
+	}
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
--- a/mm/slab.h~mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc
+++ a/mm/slab.h
@@ -558,6 +558,9 @@ static inline struct slabobj_ext *slab_o
 	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
 }
 
+int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
+                        gfp_t gfp, bool new_slab);
+
 #else /* CONFIG_SLAB_OBJ_EXT */
 
 static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
@@ -567,7 +570,17 @@ static inline struct slabobj_ext *slab_o
 
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
+static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
+{
+	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
+bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
+				  gfp_t flags, size_t size, void **p);
+void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
+			    void **p, int objects, struct slabobj_ext *obj_exts);
 void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr);
 #endif
--- a/mm/slub.c~mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc
+++ a/mm/slub.c
@@ -1859,12 +1859,6 @@ static bool freelist_corrupted(struct km
 #endif
 #endif /* CONFIG_SLUB_DEBUG */
 
-static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
-{
-	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
-}
-
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
@@ -1923,8 +1917,8 @@ static inline void handle_failed_objexts
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
 				__GFP_ACCOUNT | __GFP_NOFAIL)
 
-static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
-			       gfp_t gfp, bool new_slab)
+int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
+		        gfp_t gfp, bool new_slab)
 {
 	unsigned int objects = objs_per_slab(s, slab);
 	unsigned long new_exts;
@@ -2083,78 +2077,6 @@ alloc_tagging_slab_free_hook(struct kmem
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 #ifdef CONFIG_MEMCG_KMEM
-static inline size_t obj_full_size(struct kmem_cache *s)
-{
-	/*
-	 * For each accounted object there is an extra space which is used
-	 * to store obj_cgroup membership. Charge it too.
-	 */
-	return s->size + sizeof(struct obj_cgroup *);
-}
-
-static bool __memcg_slab_post_alloc_hook(struct kmem_cache *s,
-					 struct list_lru *lru,
-					 gfp_t flags, size_t size,
-					 void **p)
-{
-	struct obj_cgroup *objcg;
-	struct slab *slab;
-	unsigned long off;
-	size_t i;
-
-	/*
-	 * The obtained objcg pointer is safe to use within the current scope,
-	 * defined by current task or set_active_memcg() pair.
-	 * obj_cgroup_get() is used to get a permanent reference.
-	 */
-	objcg = current_obj_cgroup();
-	if (!objcg)
-		return true;
-
-	/*
-	 * slab_alloc_node() avoids the NULL check, so we might be called with a
-	 * single NULL object. kmem_cache_alloc_bulk() aborts if it can't fill
-	 * the whole requested size.
-	 * return success as there's nothing to free back
-	 */
-	if (unlikely(*p == NULL))
-		return true;
-
-	flags &= gfp_allowed_mask;
-
-	if (lru) {
-		int ret;
-		struct mem_cgroup *memcg;
-
-		memcg = get_mem_cgroup_from_objcg(objcg);
-		ret = memcg_list_lru_alloc(memcg, lru, flags);
-		css_put(&memcg->css);
-
-		if (ret)
-			return false;
-	}
-
-	if (obj_cgroup_charge(objcg, flags, size * obj_full_size(s)))
-		return false;
-
-	for (i = 0; i < size; i++) {
-		slab = virt_to_slab(p[i]);
-
-		if (!slab_obj_exts(slab) &&
-		    alloc_slab_obj_exts(slab, s, flags, false)) {
-			obj_cgroup_uncharge(objcg, obj_full_size(s));
-			continue;
-		}
-
-		off = obj_to_index(s, slab, p[i]);
-		obj_cgroup_get(objcg);
-		slab_obj_exts(slab)[off].objcg = objcg;
-		mod_objcg_state(objcg, slab_pgdat(slab),
-				cache_vmstat_idx(s), obj_full_size(s));
-	}
-
-	return true;
-}
 
 static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
 
@@ -2181,27 +2103,6 @@ bool memcg_slab_post_alloc_hook(struct k
 	return false;
 }
 
-static void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-				   void **p, int objects,
-				   struct slabobj_ext *obj_exts)
-{
-	for (int i = 0; i < objects; i++) {
-		struct obj_cgroup *objcg;
-		unsigned int off;
-
-		off = obj_to_index(s, slab, p[i]);
-		objcg = obj_exts[off].objcg;
-		if (!objcg)
-			continue;
-
-		obj_exts[off].objcg = NULL;
-		obj_cgroup_uncharge(objcg, obj_full_size(s));
-		mod_objcg_state(objcg, slab_pgdat(slab), cache_vmstat_idx(s),
-				-obj_full_size(s));
-		obj_cgroup_put(objcg);
-	}
-}
-
 static __fastpath_inline
 void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			  int objects)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slab-move-memcg-charging-to-post-alloc-hook.patch
mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

