Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B638F9A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287557; cv=none; b=VTrohueZ75vKdCkQyfdqossRUcTiur47YjtUeDOlNNcMHmcaqFcNkpI4cWVl7ZIuYOQVSXSy66qfX1A0bPYOjdGvCU6KGdkADAqoLPm8ts2F21ELAVp9eETGOQ0lkMoc34W+lHB8x6yI9Bu0gSEi4qHEi09uFvP6rQyS/HcWXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287557; c=relaxed/simple;
	bh=wBcSAJ9dDI/khh2jotc3KX0VVenOAJ246WM4J0GHM4I=;
	h=Date:To:From:Subject:Message-Id; b=c5XVzaotc6fBQTss16EZTPMGqNeWkDJYSJ6sm2q4ufoX44H1q7nZZd6+VGHpO2X79KvJ6B9Thsq+WFQ3WMyRZPhLA6qSzzx2fgSKWzVCbSr6Pen42IRgG9w1V4Jmaxw0K5LC3Ai2mRp/FqhlarnaEpfqESq6NkURLnDWfaSGKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JWwU9lc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JWwU9lc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C72C4AF0A;
	Tue, 25 Jun 2024 03:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287556;
	bh=wBcSAJ9dDI/khh2jotc3KX0VVenOAJ246WM4J0GHM4I=;
	h=Date:To:From:Subject:From;
	b=JWwU9lc2IgqVBws8sbjvCPIy0W9SxLq3+LLDmGj/AM6kOcWlchlazbpFq+T//t0Qe
	 dqZaqNSRY9fxWReUolvlY77/ix4qHU37kxM206veWwCGXHJ+8qYN7x46iuquccMsAS
	 gvOqomUbWz+ukALdIEKdzaELTeVGwRQG9hPcnK/s=
Date: Mon, 24 Jun 2024 20:52:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch removed from -mm tree
Message-Id: <20240625035236.64C72C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slab: fix 'variable obj_exts set but not used' warning
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/slab: fix 'variable obj_exts set but not used' warning
Date: Fri, 14 Jun 2024 15:59:51 -0700

slab_post_alloc_hook() uses prepare_slab_obj_exts_hook() to obtain
slabobj_ext object.  Currently the only user of slabobj_ext object in this
path is memory allocation profiling, therefore when it's not enabled this
object is not needed.  This also generates a warning when compiling with
CONFIG_MEM_ALLOC_PROFILING=n.  Move the code under this configuration to
fix the warning.  If more slabobj_ext users appear in the future, the code
will have to be changed back to call prepare_slab_obj_exts_hook().

Link: https://lkml.kernel.org/r/20240614225951.3845577-1-surenb@google.com
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406150444.F6neSaiy-lkp@intel.com/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slab-fix-variable-obj_exts-set-but-not-used-warning
+++ a/mm/slub.c
@@ -3902,7 +3902,6 @@ bool slab_post_alloc_hook(struct kmem_ca
 			  unsigned int orig_size)
 {
 	unsigned int zero_size = s->object_size;
-	struct slabobj_ext *obj_exts;
 	bool kasan_init = init;
 	size_t i;
 	gfp_t init_flags = flags & gfp_allowed_mask;
@@ -3945,9 +3944,11 @@ bool slab_post_alloc_hook(struct kmem_ca
 		kmemleak_alloc_recursive(p[i], s->object_size, 1,
 					 s->flags, init_flags);
 		kmsan_slab_alloc(s, p[i], init_flags);
+#ifdef CONFIG_MEM_ALLOC_PROFILING
 		if (need_slab_obj_ext()) {
+			struct slabobj_ext *obj_exts;
+
 			obj_exts = prepare_slab_obj_exts_hook(s, flags, p[i]);
-#ifdef CONFIG_MEM_ALLOC_PROFILING
 			/*
 			 * Currently obj_exts is used only for allocation profiling.
 			 * If other users appear then mem_alloc_profiling_enabled()
@@ -3955,8 +3956,8 @@ bool slab_post_alloc_hook(struct kmem_ca
 			 */
 			if (likely(obj_exts))
 				alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
-#endif
 		}
+#endif
 	}
 
 	return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
_

Patches currently in -mm which might be from surenb@google.com are

lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

