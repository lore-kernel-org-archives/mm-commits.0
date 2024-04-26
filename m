Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242957605E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101142; cv=none; b=IQfHh1RUv7S3NastH2DE3mfARul5vVPDp51do/JcjK0VN/JSg2bBcDgq/CnitTGC8KQRKoJG6dQ8DsJWJLVyjqfJhF8tdVGv/Y1kEqWNvOspjXDP2PxQFtlfrvZ2xawGmmCIGS/VRonTSeGjjs0CLhDck1ICqhne1dyJSlU54o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101142; c=relaxed/simple;
	bh=thrXUt5KqpgiqNlGS5HNMBHoTFVRKOalid0maTsrKY4=;
	h=Date:To:From:Subject:Message-Id; b=rf7Q3d0QDqgKKAgrfm4mOEtoS9sNHVVsOm/RqvAndSG+PMyNCNqOCy0Zfijsi2jlUsFi83XUKd66kImIdgHOUyORA0yVDYrsn/P/np1ObpVK88CfftjJL7VWTsOjav7fZOp+Wyu68rswDOLtBoctNlXJDaQIbGT8PgVckIOS+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yPeNkrLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yPeNkrLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4970C113CC;
	Fri, 26 Apr 2024 03:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101142;
	bh=thrXUt5KqpgiqNlGS5HNMBHoTFVRKOalid0maTsrKY4=;
	h=Date:To:From:Subject:From;
	b=yPeNkrLSYJz3MZpxzcE6CBorFqmzyLFDVJLmd9ET5bqKsV8UbWXaQimLHSoDC8FJ/
	 VE7dmsiCQvxl8l7a5e+L04Ug7PlHCM7OdiphmpGkAo+pi523aXI/hgOjU7dAiEA3zO
	 4SBoMV6HQvaAO1sp0vgbeWCX3IrSbcAOdA/26kNw=
Date: Thu, 25 Apr 2024 20:12:21 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mempool-hook-up-to-memory-allocation-profiling-fix-2.patch removed from -mm tree
Message-Id: <20240426031221.E4970C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempool: Documentation: add missing mempool_create_node documentation
has been removed from the -mm tree.  Its filename was
     mempool-hook-up-to-memory-allocation-profiling-fix-2.patch

This patch was dropped because it was folded into mempool-hook-up-to-memory-allocation-profiling.patch

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
Tested-by: Kees Cook <keescook@chromium.org>
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

