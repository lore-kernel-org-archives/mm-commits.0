Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC12153F8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188223; cv=none; b=K7UwAVFVR0hY/w+5/1zrryULrCXBSFRWWHaGyDomYzKI/zexdII85yqYP4oA36T3ZDfZWsfKeMChElT9L7X7vUUK3hR8GWyaxU8jrxnYxLIbPSVTZWlCyKPOiQ8wMRbfsSBFPPzohn54i0wnfM1BrYXO3La8e32AOy7KzPGIyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188223; c=relaxed/simple;
	bh=6zCUOZ1SHHtgBQ2hbgJJpCefPW1z6tnuY28QS3zxj2Y=;
	h=Date:To:From:Subject:Message-Id; b=dKJMrm/HrYOco0WOiGFY+esma2l8NVWJNO7UBy3Agc5ao7M4+tL+qD4F94BbuNGJ+udoC9rwjVfclHmV5Ub3cwWLXmRgrnHaNHyvt7u5MGYtsyA2UhKh0WCKkGhQESeSqnRUrv43ycziVbBQfFzT7IavN2++/+vfCDG8u8mG4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XlFTCd3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XlFTCd3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF40C4CEEC;
	Mon, 17 Mar 2025 05:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188223;
	bh=6zCUOZ1SHHtgBQ2hbgJJpCefPW1z6tnuY28QS3zxj2Y=;
	h=Date:To:From:Subject:From;
	b=XlFTCd3AgiHkIjyswAGJ0w6VnQ1ursE59cZGs6JQk5FKQe1Hiin9bL7gT7bDUuA4y
	 YmiV4n67BO8DWSRPip9sOdr3wx68wArB5JvDkK+ymajAaxiHrAbQsW83SbBZQqGbAX
	 DGrOoqyjv441YMmQf61Con/9Q6lfXZLxR93xyIJg=
Date: Sun, 16 Mar 2025 22:10:22 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,quic_zhenhuah@quicinc.com,peterz@infradead.org,pasha.tatashin@soleen.com,minchan@google.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch removed from -mm tree
Message-Id: <20250317051023.3BF40C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: uninline code gated by mem_alloc_profiling_key in slab allocator
has been removed from the -mm tree.  Its filename was
     alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: uninline code gated by mem_alloc_profiling_key in slab allocator
Date: Sat, 1 Feb 2025 15:18:01 -0800

When a sizable code section is protected by a disabled static key, that
code gets into the instruction cache even though it's not executed and
consumes the cache, increasing cache misses.  This can be remedied by
moving such code into a separate uninlined function.  On a Pixel6 phone,
slab allocation profiling overhead measured with
CONFIG_MEM_ALLOC_PROFILING=y and profiling disabled is:

             baseline             modified
Big core     3.31%                0.17%
Medium core  3.79%                0.57%
Little core  6.68%                1.28%

This improvement comes at the expense of the configuration when profiling
gets enabled, since there is now an additional function call.  The
overhead from this additional call on Pixel6 is:

Big core     0.66%
Middle core  1.23%
Little core  2.42%

However this is negligible when compared with the overall overhead of the
memory allocation profiling when it is enabled.

On x86 this patch does not make noticeable difference because the overhead
with mem_alloc_profiling_key disabled is much lower (under 1%) to start
with, so any improvement is less visible and hard to distinguish from the
noise.  The overhead from additional call when profiling is enabled is
also within noise levels.

Link: https://lkml.kernel.org/r/20250201231803.2661189-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   51 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

--- a/mm/slub.c~alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator
+++ a/mm/slub.c
@@ -2000,7 +2000,8 @@ int alloc_slab_obj_exts(struct slab *sla
 	return 0;
 }
 
-static inline void free_slab_obj_exts(struct slab *slab)
+/* Should be called only if mem_alloc_profiling_enabled() */
+static noinline void free_slab_obj_exts(struct slab *slab)
 {
 	struct slabobj_ext *obj_exts;
 
@@ -2077,33 +2078,37 @@ prepare_slab_obj_exts_hook(struct kmem_c
 	return slab_obj_exts(slab) + obj_to_index(s, slab, p);
 }
 
-static inline void
-alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
+/* Should be called only if mem_alloc_profiling_enabled() */
+static noinline void
+__alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
-	if (need_slab_obj_ext()) {
-		struct slabobj_ext *obj_exts;
+	struct slabobj_ext *obj_exts;
 
-		obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
-		/*
-		 * Currently obj_exts is used only for allocation profiling.
-		 * If other users appear then mem_alloc_profiling_enabled()
-		 * check should be added before alloc_tag_add().
-		 */
-		if (likely(obj_exts))
-			alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
-	}
+	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
+	/*
+	 * Currently obj_exts is used only for allocation profiling.
+	 * If other users appear then mem_alloc_profiling_enabled()
+	 * check should be added before alloc_tag_add().
+	 */
+	if (likely(obj_exts))
+		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
 }
 
 static inline void
-alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
-			     int objects)
+alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
+{
+	if (need_slab_obj_ext())
+		__alloc_tagging_slab_alloc_hook(s, object, flags);
+}
+
+/* Should be called only if mem_alloc_profiling_enabled() */
+static noinline void
+__alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
+			       int objects)
 {
 	struct slabobj_ext *obj_exts;
 	int i;
 
-	if (!mem_alloc_profiling_enabled())
-		return;
-
 	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
@@ -2119,6 +2124,14 @@ alloc_tagging_slab_free_hook(struct kmem
 	}
 }
 
+static inline void
+alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
+			     int objects)
+{
+	if (mem_alloc_profiling_enabled())
+		__alloc_tagging_slab_free_hook(s, slab, p, objects);
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void
_

Patches currently in -mm which might be from surenb@google.com are


