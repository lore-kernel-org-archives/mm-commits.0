Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445997CF16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103934; cv=none; b=PWhM7DJq2t4mFH1jk8w5nCidQuZepDTCRN07Cvoc/A2d1fnkISjAyFCo5E7q0znQCszdXAsg02uwhTdKm0xgwBF6O8AB9S+DWkq9TdB3+DMWYc5VA6/x70SSfsYUI02IfdljNq0w8T706LyBbdaDIR5Bbxt+RgMdCCg3odZp7Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103934; c=relaxed/simple;
	bh=zUegcnIFZzSM86Df/86tGzubqOSjWJ2Yk65+16msGa8=;
	h=Date:To:From:Subject:Message-Id; b=YcVtQFjiYKw9ezuMfko5pYCFthFeuXYGaAWU3yBPmMzk8+Ma7ukPsIpbSf30lIxrTxjd0wYyHTyaazHDV/GxLsdy9WFNEbuuXd9kwcuWwftmAJ2lwu7JULq9lG7HXnHKUsdqVwr1xUywZcfj9T97HMLyERyEIxdY4hn7tTVfDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spQ/jfXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spQ/jfXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19726C113CD;
	Fri, 26 Apr 2024 03:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103934;
	bh=zUegcnIFZzSM86Df/86tGzubqOSjWJ2Yk65+16msGa8=;
	h=Date:To:From:Subject:From;
	b=spQ/jfXWblyynm1nXYjNNNu9nPiKfJ1vyedPB3Zi57B8lnWmdGTRhB96p1CeLcpX/
	 FD79tWuJiWbNvBnUvPgq1F9xpqoStyB86PBw8hDty/atubqV3iW33lEH5sFAB3mkvA
	 70bmbUZtMbTTnXeIRRjh26Q4ygSX3C1C0mCkni9Q=
Date: Thu, 25 Apr 2024 20:58:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,kent.overstreet@linux.dev,iamjoonsoo.kim@lge.com,cl@linux.com,catalin.marinas@arm.com,42.hyeyoo@gmail.com,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slub-avoid-recursive-loop-with-kmemleak.patch removed from -mm tree
Message-Id: <20240426035854.19726C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slub: avoid recursive loop with kmemleak
has been removed from the -mm tree.  Its filename was
     mm-slub-avoid-recursive-loop-with-kmemleak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


