Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B877E5336D
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 23:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738453644; cv=none; b=Rm1V9aMA6tmv7h2C1ArujeT3TYK2iiPC6W0Tqa+MMaq36H7siCTLknXn1UD5NydGrUX4mWI/zHLE8KCCCdtfL8rrGXjAUHrWLnaOqX8FFxAMiqtnQykgNweSSJmJKUW0Ijjto8RKPP169cZFBkdeoWVW3KpTgKm2wyydQ6BV5PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738453644; c=relaxed/simple;
	bh=Po/L+QyqUikyIvFO476uim7AGmS1eA6qJJSvZDHCOQk=;
	h=Date:To:From:Subject:Message-Id; b=oCD+f48MLoQKKFY3WNA6gaIN7lSQtv7Ck7X3/FP8vCUEWR3NnXxj4b4bEa3wGFuWPkbU2zika/JP90QexQmU2mMg3zINdd17LbUfHzMwFl84vkotjg/vuXAyCHaDVKNrlT/a3Ai8VnqWcCbEGhuwNi6Jtecnmn7RPAwczEe3cnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aDV0niMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aDV0niMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3A1C4CED3;
	Sat,  1 Feb 2025 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738453644;
	bh=Po/L+QyqUikyIvFO476uim7AGmS1eA6qJJSvZDHCOQk=;
	h=Date:To:From:Subject:From;
	b=aDV0niMox3DzBYuxiLclYJiRyja7xh9Hw1FhSqMRqrIid0vcQMDbQihcsGADCuEB/
	 uGfMQSL/KV0RE3SduzvgE7wjXcgGkUe17sXjDO0/K5S7wHJA1FhmK0AIL6erUiePHt
	 LrlxsuC6kcEOshuAEvKdcBq+EES2Wtw7+d4flMvw=
Date: Sat, 01 Feb 2025 15:47:23 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,quic_zhenhuah@quicinc.com,peterz@infradead.org,pasha.tatashin@soleen.com,minchan@google.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch added to mm-unstable branch
Message-Id: <20250201234724.1C3A1C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: uninline code gated by mem_alloc_profiling_key in slab allocator
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch

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
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch

