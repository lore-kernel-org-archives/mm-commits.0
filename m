Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA302155A5B
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 23:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714089011; cv=none; b=iLvxC7i6tNlWk7efZ93w3H4ys3TIHvuAmSioYvHrsZ87RT809d+m5tc21VTbrO8komq5Cwnl0ehuHxnkh6WZcHWydZyanLxc6UrA9qgQ1A22Qb+pM0JR3BYCi5Paj/j6yQJ8uLFwTbY+s25yzb8lEgqZfQ3io3AtLcVMnR50DWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714089011; c=relaxed/simple;
	bh=qUg1qNcIgD195k0oo4mO+m59DonjQ+Dn7DZMS1XfAyY=;
	h=Date:To:From:Subject:Message-Id; b=iCmNjvJNjXdLIDd7a6pFkMRyybUjLNCsl+J9/NcWSSFl9keIIRaEjp1e43DhYyacoqVXqsyeFJIe0cH4VmHWNrYwmDvUU+GbgQ/e+tieI2N/zO+wfH8COaDoKnmI0hj5ZcRML4FAbrTr9/a5lt/oICYQU3nox9rEw+vOvyQdgyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nNqPTWdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nNqPTWdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA07C113CC;
	Thu, 25 Apr 2024 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714089011;
	bh=qUg1qNcIgD195k0oo4mO+m59DonjQ+Dn7DZMS1XfAyY=;
	h=Date:To:From:Subject:From;
	b=nNqPTWdxgaeXMoHBygzqX+jeE+QcdGmWgTDZi/1YqnEagjSNONc3/ztIc898M5ELN
	 5r04tKLEWIrxh+f7fovw6a/Jl2qgax7WpsWvo9cVpO8WGIMmJv5p46Drm7Ig67NQta
	 simDXnPa8WEJY57SwEhhcEkQt9NjkG4qgOmRL414=
Date: Thu, 25 Apr 2024 16:50:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,kent.overstreet@linux.dev,iamjoonsoo.kim@lge.com,cl@linux.com,catalin.marinas@arm.com,42.hyeyoo@gmail.com,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slub-avoid-recursive-loop-with-kmemleak.patch added to mm-unstable branch
Message-Id: <20240425235011.2DA07C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/slub: avoid recursive loop with kmemleak
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slub-avoid-recursive-loop-with-kmemleak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slub-avoid-recursive-loop-with-kmemleak.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: mm/slub: avoid recursive loop with kmemleak
Date: Thu, 25 Apr 2024 13:55:23 -0700

The system will immediate fill up stack and crash when both
CONFIG_DEBUG_KMEMLEAK and CONFIG_MEM_ALLOC_PROFILING are enabled.  Avoid
allocation tagging of kmemleak caches, otherwise recursive allocation
tracking occurs.

Link: https://lkml.kernel.org/r/20240425205516.work.220-kees@kernel.org
Fixes: 279bb991b4d9 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 mm/slub.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-slub-avoid-recursive-loop-with-kmemleak
+++ a/mm/kmemleak.c
@@ -463,7 +463,7 @@ static struct kmemleak_object *mem_pool_
 
 	/* try the slab allocator first */
 	if (object_cache) {
-		object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
+		object = kmem_cache_alloc_noprof(object_cache, gfp_kmemleak_mask(gfp));
 		if (object)
 			return object;
 	}
@@ -947,7 +947,7 @@ static void add_scan_area(unsigned long
 	untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
 
 	if (scan_area_cache)
-		area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
+		area = kmem_cache_alloc_noprof(scan_area_cache, gfp_kmemleak_mask(gfp));
 
 	raw_spin_lock_irqsave(&object->lock, flags);
 	if (!area) {
--- a/mm/slub.c~mm-slub-avoid-recursive-loop-with-kmemleak
+++ a/mm/slub.c
@@ -2018,7 +2018,7 @@ prepare_slab_obj_exts_hook(struct kmem_c
 	if (!p)
 		return NULL;
 
-	if (s->flags & SLAB_NO_OBJ_EXT)
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return NULL;
 
 	if (flags & __GFP_NO_OBJ_EXT)
_

Patches currently in -mm which might be from keescook@chromium.org are

alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch
mm-slub-avoid-recursive-loop-with-kmemleak.patch

