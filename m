Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5815666E
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 22:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712181654; cv=none; b=dZqapzUIxyNfG2e+ZEUw8C9esttXlHKgR3bLD/mzw6QM7/rpNFuWElPlaKWSNw94amZubV7Vz08gjw4Kumtqx7Sp7UVRbv1H8iUfw3R4zASER8jR4I7F05d+jUW+/yFDRR0YGbuj03gSYy2S3n4DPY5oGg7bB4E3jnssMil2KWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712181654; c=relaxed/simple;
	bh=st3MZclITKref4EZ6mbAKRTjOestoKOHUxSh0jKc42c=;
	h=Date:To:From:Subject:Message-Id; b=I5ERI9DPnMDUAt1Jfg2dVkyIcKEQlc4uqNEJ+piUrw6RqSFSCBlbTgc15RXOqAdVyz3YqwUU8eokdxpGNlBjoWRjgz2G6PPpOZKE6PwqXSFD2bEFZ/9pDa0sAyuOkS7+VwGu60ffw61jn9Tp+KNma/JEbY61fEWt6Vjtjg2y6mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GszcXR3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GszcXR3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E830C43394;
	Wed,  3 Apr 2024 22:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712181654;
	bh=st3MZclITKref4EZ6mbAKRTjOestoKOHUxSh0jKc42c=;
	h=Date:To:From:Subject:From;
	b=GszcXR3VBKTQgSWKGjkfb0331FVRdqu9rss7/pq26Jr/MxY2O/xXnGhiQ4j8TXxY2
	 G7jphZNeRW1J8bI2iDIIAOa20IE2hQQjp097tc+TJ3xkbYKBnoZnfbC8wrwrTchHER
	 uA+fjaWX2WEnEqceyv0JfkSVsNjcm5A3V1m+Ie6I=
Date: Wed, 03 Apr 2024 15:00:53 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-hook-up-to-memory-allocation-profiling-fix-2.patch added to mm-unstable branch
Message-Id: <20240403220054.3E830C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempool: Documentation: add missing mempool_create_node documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-hook-up-to-memory-allocation-profiling-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-hook-up-to-memory-allocation-profiling-fix-2.patch

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
Subject: mm/mempool: Documentation: add missing mempool_create_node documentation
Date: Tue, 2 Apr 2024 11:08:35 -0700

mempool_create_node documentation for two of its parameters is missing.
Document those parameters.

Link: https://lkml.kernel.org/r/20240402180835.1661905-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404010132.6v0zt6oa-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mempool.c~mempool-hook-up-to-memory-allocation-profiling-fix-2
+++ a/mm/mempool.c
@@ -256,6 +256,8 @@ EXPORT_SYMBOL(mempool_init_noprof);
  * @alloc_fn:  user-defined element-allocation function.
  * @free_fn:   user-defined element-freeing function.
  * @pool_data: optional private data available to the user-defined functions.
+ * @gfp_mask:  memory allocation flags
+ * @node_id:   numa node to allocate on
  *
  * this function creates and allocates a guaranteed size, preallocated
  * memory pool. The pool can be used from the mempool_alloc() and mempool_free()
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes-fix-2.patch
mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-enable-page-allocation-tagging-fix.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix.patch
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

