Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9F12F363
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570888; cv=none; b=clR19dkTDKNxVX1a3u/kZHJjvpS/aiK5M4S8n3c2mz8BBoZ87+jm6LWKtaLZWlupuxFHLD+hvvTrkBT7F/F6oLEzhzl5myPQDYGADrRKdvRQ/Z1yzKn1ynCpUceNXZHbgSBgQL7v/4m1MGkTK8x5m/NzPskbM9d14aKZu5Ff+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570888; c=relaxed/simple;
	bh=gSfqLGOJK3W1xCD5i8Yk/NoN1jjZObShVV2D+3t9FCU=;
	h=Date:To:From:Subject:Message-Id; b=MGhXtKPsaB1QwSdJ1a06k4L5dFp8RYpbzDCMyK9Lyfi1zX6eTa4MfDp7OYBlHxOZVf0zKLx5xqkiykJwPrE3oA5eaz3od7VW9PI0PKbxeA2b2OaEmJoTmosBpBTniFJTn8u+C44eoCUULXlwQeaDSWwF0kptoUE5J+1fgG7nBRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLDT2Ke8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLDT2Ke8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBE9C433F1;
	Wed, 27 Mar 2024 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570888;
	bh=gSfqLGOJK3W1xCD5i8Yk/NoN1jjZObShVV2D+3t9FCU=;
	h=Date:To:From:Subject:From;
	b=HLDT2Ke8yLjJNLNO9622+bhdLlj1cb58XikaP+GCf584Wqexyu447h3ndFCpRRRpy
	 uO4YhUZIeYYrESJ1OFyuAnxMz0tzroGK4mwSj3R+jT7CmqDthDoxbJfyHQFSbhfKrq
	 iZ/TR2H8iTtGpTliJqNsSvRT5nRUWd7WxXk3qvzY=
Date: Wed, 27 Mar 2024 13:21:27 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch added to mm-unstable branch
Message-Id: <20240327202128.0DBE9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: mm: vmalloc: undo _noprof additions in the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch

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
Subject: Documentation: mm: vmalloc: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:50 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-5-surenb@google.com
Fixes: ed49858097c1 ("mm: vmalloc: enable memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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
@@ -3690,7 +3690,7 @@ fail:
 }
 
 /**
- * __vmalloc_node_range_noprof - allocate virtually contiguous memory
+ * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
  * @align:		  desired alignment
  * @start:		  vm area range start
@@ -3846,7 +3846,7 @@ fail:
 }
 
 /**
- * __vmalloc_node_noprof - allocate virtually contiguous memory
+ * __vmalloc_node - allocate virtually contiguous memory
  * @size:	    allocation size
  * @align:	    desired alignment
  * @gfp_mask:	    flags for the page level allocator
@@ -3926,7 +3926,7 @@ void *vmalloc_huge_noprof(unsigned long
 EXPORT_SYMBOL_GPL(vmalloc_huge_noprof);
 
 /**
- * vzalloc_noprof - allocate virtually contiguous memory with zero fill
+ * vzalloc - allocate virtually contiguous memory with zero fill
  * @size:    allocation size
  *
  * Allocate enough pages to cover @size from the page level
@@ -3964,7 +3964,7 @@ void *vmalloc_user_noprof(unsigned long
 EXPORT_SYMBOL(vmalloc_user_noprof);
 
 /**
- * vmalloc_node_noprof - allocate memory on a specific node
+ * vmalloc_node - allocate memory on a specific node
  * @size:	  allocation size
  * @node:	  numa node
  *
@@ -3984,7 +3984,7 @@ void *vmalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vmalloc_node_noprof);
 
 /**
- * vzalloc_node_noprof - allocate memory on a specific node with zero fill
+ * vzalloc_node - allocate memory on a specific node with zero fill
  * @size:	allocation size
  * @node:	numa node
  *
@@ -4014,7 +4014,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
 #endif
 
 /**
- * vmalloc_32_noprof - allocate virtually contiguous memory (32bit addressable)
+ * vmalloc_32 - allocate virtually contiguous memory (32bit addressable)
  * @size:	allocation size
  *
  * Allocate enough 32bit PA addressable pages to cover @size from the
@@ -4030,7 +4030,7 @@ void *vmalloc_32_noprof(unsigned long si
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
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
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
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

