Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00019EBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101064; cv=none; b=F49wZRq4CEtVpBC2UBgu6MxMKU4Zw89SVbLSnkEwO4lInVWMJIbMfIYPfbQQH217aEAhUDrBOSCOfBf7urE0dvO/dFokaEpVWE+MwDZNsXtdvpaEMg/BTCvugL7QgYTKSE3yVe/M+JLdLtkCW8ozPevP3n8MHtL/V622tqSrrWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101064; c=relaxed/simple;
	bh=noy2N/YhpusKGTff3B3VkuqjIbghSsJahNfSblofwN4=;
	h=Date:To:From:Subject:Message-Id; b=lCTuAlBNuI9CfK9jGHJjQKOU+8S2YfRr5BcHps6NGhg65bLv8sWA5e5zYQ738Gb0lkOo380OxtJ06tNewpJJTjqv88yCAlOb4I7OUb88cU3a4cUSnDErRCdCkRSry+zFBYzrPxHP4LwTukZnFET87IgRy+b+v81T2Iyrf1eD3eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7+2SZfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7+2SZfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BADC113CC;
	Fri, 26 Apr 2024 03:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101062;
	bh=noy2N/YhpusKGTff3B3VkuqjIbghSsJahNfSblofwN4=;
	h=Date:To:From:Subject:From;
	b=C7+2SZfsTjUPVzyscHWBlacEoftGuc+dDUl8jEhBOXQl/hdcYnyXGkqatUDajUx9+
	 IVWfi86QavJlZ7SQeIl8uSdx+VLyF6JU5pa8thzVJOrPB96P3bvfJZ8dyp/lQj/Fso
	 jIdL0XSea1XEXAqO4FEWjVQ2+tsfKjclyynzheLk=
Date: Thu, 25 Apr 2024 20:11:01 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch removed from -mm tree
Message-Id: <20240426031102.61BADC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mm/slab: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch

This patch was dropped because it was folded into mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: mm/slab: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:52 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-7-surenb@google.com
Fixes: bc7b83f5e4bf ("mm/slab: enable slab allocation tagging for kmalloc and friends")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 mm/util.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix
+++ a/mm/slub.c
@@ -4026,7 +4026,7 @@ void *kmem_cache_alloc_lru_noprof(struct
 EXPORT_SYMBOL(kmem_cache_alloc_lru_noprof);
 
 /**
- * kmem_cache_alloc_node_noprof - Allocate an object on the specified node
+ * kmem_cache_alloc_node - Allocate an object on the specified node
  * @s: The cache to allocate from.
  * @gfpflags: See kmalloc().
  * @node: node number of the target node.
--- a/mm/util.c~mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix
+++ a/mm/util.c
@@ -115,7 +115,7 @@ char *kstrndup(const char *s, size_t max
 EXPORT_SYMBOL(kstrndup);
 
 /**
- * kmemdup_noprof - duplicate region of memory
+ * kmemdup - duplicate region of memory
  *
  * @src: memory region to duplicate
  * @len: memory region length
@@ -594,7 +594,7 @@ unsigned long vm_mmap(struct file *file,
 EXPORT_SYMBOL(vm_mmap);
 
 /**
- * kvmalloc_node_noprof - attempt to allocate physically contiguous memory, but upon
+ * kvmalloc_node - attempt to allocate physically contiguous memory, but upon
  * failure, fall back to non-contiguous (vmalloc) allocation.
  * @size: size of the request.
  * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
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
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

