Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412D87602F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101141; cv=none; b=FsrBQTENw3OKGUEocd+eZgE4y3ER+ePQz2S3U+NDrT0ffsc0a5ylvvWRt16q2yzeJDN4lMff2cSj1xY86edV62CGu83T8jyI0hyvKQL6v4WZAWrHOkj2pV3Z/oYal8f1xD0YS52aFrF5jNNbXk5tbeSHsJawIZ2qd7xFlb9tYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101141; c=relaxed/simple;
	bh=K+MJyjhMbDmkvOtRzb2I/TNW7RhiFnOcgzoit3+sLJs=;
	h=Date:To:From:Subject:Message-Id; b=M5KZvF7Z679FSchEzSAGZff5pq/SZB1wOr3iIlkPNMVLrPjiIul5x3mSHKfMcx7amnErOwXRRd7eRu+Co/Mcr1EIaK+mhTl2h3AuhTdSM/u1zrvG6+Q4PFUD759VKKSEHn8g8oQ3HOWBFUPsnN6/9x8KoGuRMIzQxc52a5avB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PzWNGTJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PzWNGTJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB943C3277B;
	Fri, 26 Apr 2024 03:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101140;
	bh=K+MJyjhMbDmkvOtRzb2I/TNW7RhiFnOcgzoit3+sLJs=;
	h=Date:To:From:Subject:From;
	b=PzWNGTJhWB/ZNWptTzWj4EhqYtWoYD1bn2FLNOFlFdvb1vJCYeoqKCr/e0QOacG4O
	 o/3mFnJBCE3lVvDzrDHrirSZKJ6BV1Mo7uZFaew1UjxCeKtjt5VG1pXf75KvlZXm+1
	 4l2u8qIGQADh7YwnqvUrfKuAvImB6Quu12o/ab1I=
Date: Thu, 25 Apr 2024 20:12:20 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mempool-hook-up-to-memory-allocation-profiling-fix.patch removed from -mm tree
Message-Id: <20240426031220.BB943C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mempool: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     mempool-hook-up-to-memory-allocation-profiling-fix.patch

This patch was dropped because it was folded into mempool-hook-up-to-memory-allocation-profiling.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: mempool: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:49 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-4-surenb@google.com
Fixes: 01d3a2ac5e7f ("mempool: hook up to memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mempool-hook-up-to-memory-allocation-profiling-fix
+++ a/mm/mempool.c
@@ -366,7 +366,7 @@ out:
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_alloc_noprof - allocate an element from a specific memory pool
+ * mempool_alloc - allocate an element from a specific memory pool
  * @pool:      pointer to the memory pool which was allocated via
  *             mempool_create().
  * @gfp_mask:  the usual allocation bitmask.
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mempool-hook-up-to-memory-allocation-profiling-fix-2.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

