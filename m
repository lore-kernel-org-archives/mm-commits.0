Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631962F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101215; cv=none; b=IhzJQAVuvgKuf/gFkIuiN3M4M3QNUYIaWPHPFgTuV0XJWMJ//nLq5UsvSoIxW2PsMg7yHaE3yo6tAyLyHz8EnjA5GdSUB+nYucX32ByitFZP+bzIonf/139mHCCSu5bzP6dSqnVj8OQeSL/DnIxxY5RuxfnZBXs2kIzbrRxD4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101215; c=relaxed/simple;
	bh=k/Kox4ZzkI5fK14xxL9IRWRVkL7nP3eF4LTKyq3A0PM=;
	h=Date:To:From:Subject:Message-Id; b=nHo3H+Qgz/O095/ngDCApSZPaLQVC6Asxu+e5PVeJmuNtRJh8zGQg/m68hqwiTq7zLYVaNGuCTvehepZOIrh/3TdeWG9s4WjpnmIYnL++t9Ws3N9Z9vnWqH60PO1CRCJsyUsbrZSG2D7DMl3SRZ1B1xjxJn5tMJBToo1tSFtOB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vaH51jg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vaH51jg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDDBC113CD;
	Fri, 26 Apr 2024 03:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101214;
	bh=k/Kox4ZzkI5fK14xxL9IRWRVkL7nP3eF4LTKyq3A0PM=;
	h=Date:To:From:Subject:From;
	b=vaH51jg/he+XTuQJx24FwL0xDyHeBydJDpE3uO4q7LOozHSiLCrT+SIbZo5XiqLi8
	 oD785W1Uvvut9U9cAbooL47ml72bzwwvH9j3uGX3HMflcurX7WI3LxqSHA/Qp4Vlhw
	 PAmBKBjTB7IbBNvTUuhOYOQZzipG8fq4cgh5ZHyw=
Date: Thu, 25 Apr 2024 20:13:34 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch removed from -mm tree
Message-Id: <20240426031334.CFDDBC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mm: vmalloc: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch

This patch was dropped because it was folded into mm-vmalloc-enable-memory-allocation-profiling.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: mm: vmalloc: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:50 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-5-surenb@google.com
Fixes: ed49858097c1 ("mm: vmalloc: enable memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c   |    8 ++++----
 mm/util.c    |    6 +++---
 mm/vmalloc.c |   14 +++++++-------
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/nommu.c~mm-vmalloc-enable-memory-allocation-profiling-fix-2
+++ a/mm/nommu.c
@@ -244,7 +244,7 @@ void *vzalloc_noprof(unsigned long size)
 EXPORT_SYMBOL(vzalloc_noprof);
 
 /**
- * vmalloc_node_noprof - allocate memory on a specific node
+ * vmalloc_node - allocate memory on a specific node
  * @size:	allocation size
  * @node:	numa node
  *
@@ -261,7 +261,7 @@ void *vmalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vmalloc_node_noprof);
 
 /**
- * vzalloc_node_noprof - allocate memory on a specific node with zero fill
+ * vzalloc_node - allocate memory on a specific node with zero fill
  * @size:	allocation size
  * @node:	numa node
  *
@@ -279,7 +279,7 @@ void *vzalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vmalloc_32_noprof  -  allocate virtually contiguous memory (32bit addressable)
+ * vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
  *
  *	Allocate enough 32bit PA addressable pages to cover @size from the
@@ -292,7 +292,7 @@ void *vmalloc_32_noprof(unsigned long si
 EXPORT_SYMBOL(vmalloc_32_noprof);
 
 /**
- * vmalloc_32_user_noprof - allocate zeroed virtually contiguous 32bit memory
+ * vmalloc_32_user - allocate zeroed virtually contiguous 32bit memory
  *	@size:		allocation size
  *
  * The resulting memory area is 32bit addressable and zeroed so it can be
--- a/mm/util.c~mm-vmalloc-enable-memory-allocation-profiling-fix-2
+++ a/mm/util.c
@@ -715,7 +715,7 @@ void *kvrealloc_noprof(const void *p, si
 EXPORT_SYMBOL(kvrealloc_noprof);
 
 /**
- * __vmalloc_array_noprof - allocate memory for a virtually contiguous array.
+ * __vmalloc_array - allocate memory for a virtually contiguous array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
@@ -731,7 +731,7 @@ void *__vmalloc_array_noprof(size_t n, s
 EXPORT_SYMBOL(__vmalloc_array_noprof);
 
 /**
- * vmalloc_array_noprof - allocate memory for a virtually contiguous array.
+ * vmalloc_array - allocate memory for a virtually contiguous array.
  * @n: number of elements.
  * @size: element size.
  */
@@ -754,7 +754,7 @@ void *__vcalloc_noprof(size_t n, size_t
 EXPORT_SYMBOL(__vcalloc_noprof);
 
 /**
- * vcalloc_noprof - allocate and zero memory for a virtually contiguous array.
+ * vcalloc - allocate and zero memory for a virtually contiguous array.
  * @n: number of elements.
  * @size: element size.
  */
--- a/mm/vmalloc.c~mm-vmalloc-enable-memory-allocation-profiling-fix-2
+++ a/mm/vmalloc.c
@@ -3703,7 +3703,7 @@ fail:
 }
 
 /**
- * __vmalloc_node_range_noprof - allocate virtually contiguous memory
+ * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
  * @align:		  desired alignment
  * @start:		  vm area range start
@@ -3859,7 +3859,7 @@ fail:
 }
 
 /**
- * __vmalloc_node_noprof - allocate virtually contiguous memory
+ * __vmalloc_node - allocate virtually contiguous memory
  * @size:	    allocation size
  * @align:	    desired alignment
  * @gfp_mask:	    flags for the page level allocator
@@ -3939,7 +3939,7 @@ void *vmalloc_huge_noprof(unsigned long
 EXPORT_SYMBOL_GPL(vmalloc_huge_noprof);
 
 /**
- * vzalloc_noprof - allocate virtually contiguous memory with zero fill
+ * vzalloc - allocate virtually contiguous memory with zero fill
  * @size:    allocation size
  *
  * Allocate enough pages to cover @size from the page level
@@ -3977,7 +3977,7 @@ void *vmalloc_user_noprof(unsigned long
 EXPORT_SYMBOL(vmalloc_user_noprof);
 
 /**
- * vmalloc_node_noprof - allocate memory on a specific node
+ * vmalloc_node - allocate memory on a specific node
  * @size:	  allocation size
  * @node:	  numa node
  *
@@ -3997,7 +3997,7 @@ void *vmalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vmalloc_node_noprof);
 
 /**
- * vzalloc_node_noprof - allocate memory on a specific node with zero fill
+ * vzalloc_node - allocate memory on a specific node with zero fill
  * @size:	allocation size
  * @node:	numa node
  *
@@ -4027,7 +4027,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
 #endif
 
 /**
- * vmalloc_32_noprof - allocate virtually contiguous memory (32bit addressable)
+ * vmalloc_32 - allocate virtually contiguous memory (32bit addressable)
  * @size:	allocation size
  *
  * Allocate enough 32bit PA addressable pages to cover @size from the
@@ -4043,7 +4043,7 @@ void *vmalloc_32_noprof(unsigned long si
 EXPORT_SYMBOL(vmalloc_32_noprof);
 
 /**
- * vmalloc_32_user_noprof - allocate zeroed virtually contiguous 32bit memory
+ * vmalloc_32_user - allocate zeroed virtually contiguous 32bit memory
  * @size:	     allocation size
  *
  * The resulting memory area is 32bit addressable and zeroed so it can be
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
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

