Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A28EBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101031; cv=none; b=OAm0uhnuCb5x+h8yRRw/uN1qhOATiDvP4xmY7w6rVTdXfu5Abk+sCqAr0rX8RSIbxbX9Mp447HM/ZkY8D07ycxrAsd8ATMe4lo6mZ45niwbPqcEDqlPCdW5+YydWsOhSFa0h/rF9Ib3nEwOrmcWrvv9sy0IdwK6y36jCsF5n73w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101031; c=relaxed/simple;
	bh=Mj6/QVxfeU896fFQ0XIFos0uG9tW7RIwKEQfWdSLUro=;
	h=Date:To:From:Subject:Message-Id; b=AkeFxd2cBN7U4VZIbwp+qe2cThQumA/Pts6/mwE7JAg9ALCmoqSX1/kipkeBCHCa08QPrjYt1Gjx9/2o0wi0m1zwsz5g9dk7G+1GDcYVrlNcEaqRdPPzIq2W9zm2QLcFu76VtbPyFLdkvwISbwTfAKIOp2RUQuKPjvFs9KFDx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MFj9NaMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MFj9NaMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ECDC113CC;
	Fri, 26 Apr 2024 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101030;
	bh=Mj6/QVxfeU896fFQ0XIFos0uG9tW7RIwKEQfWdSLUro=;
	h=Date:To:From:Subject:From;
	b=MFj9NaMRFwuHoSpghX7jGazo3729OuPn8oVVUvJnswifb9/6Sg3lDjeHNY8EyBLcQ
	 rOCXlyg9LDgeL/RPArr23Bbj+H8a6sfuJb/z6lnNmzS+UjtcunTw8oP1d9J0H20Pka
	 AI3DHf06LO1amFH4f1r5STfr+MKYrpLlzoN3RLfE=
Date: Thu, 25 Apr 2024 20:10:29 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-enable-page-allocation-tagging-fix.patch removed from -mm tree
Message-Id: <20240426031030.27ECDC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mm: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     mm-enable-page-allocation-tagging-fix.patch

This patch was dropped because it was folded into mm-enable-page-allocation-tagging.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: mm: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:48 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-3-surenb@google.com
Fixes: 6522e08ac1c6 ("mm: enable page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c  |    6 +++---
 mm/page_alloc.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c~mm-enable-page-allocation-tagging-fix
+++ a/mm/mempolicy.c
@@ -2209,7 +2209,7 @@ static struct page *alloc_pages_preferre
 }
 
 /**
- * alloc_pages_mpol_noprof - Allocate pages according to NUMA mempolicy.
+ * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
  * @order: Order of the page allocation.
  * @pol: Pointer to the NUMA mempolicy.
@@ -2278,7 +2278,7 @@ struct page *alloc_pages_mpol_noprof(gfp
 }
 
 /**
- * vma_alloc_folio_noprof - Allocate a folio for a VMA.
+ * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
  * @order: Order of the folio.
  * @vma: Pointer to VMA.
@@ -2309,7 +2309,7 @@ struct folio *vma_alloc_folio_noprof(gfp
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
 /**
- * alloc_pages_noprof - Allocate pages.
+ * alloc_pages - Allocate pages.
  * @gfp: GFP flags.
  * @order: Power of two of number of pages to allocate.
  *
--- a/mm/page_alloc.c~mm-enable-page-allocation-tagging-fix
+++ a/mm/page_alloc.c
@@ -4839,7 +4839,7 @@ static void *make_alloc_exact(unsigned l
 }
 
 /**
- * alloc_pages_exact_noprof - allocate an exact number physically-contiguous pages.
+ * alloc_pages_exact - allocate an exact number physically-contiguous pages.
  * @size: the number of bytes to allocate
  * @gfp_mask: GFP flags for the allocation, must not contain __GFP_COMP
  *
@@ -4867,7 +4867,7 @@ void *alloc_pages_exact_noprof(size_t si
 EXPORT_SYMBOL(alloc_pages_exact_noprof);
 
 /**
- * alloc_pages_exact_nid_noprof - allocate an exact number of physically-contiguous
+ * alloc_pages_exact_nid - allocate an exact number of physically-contiguous
  *			   pages on a node.
  * @nid: the preferred node ID where memory should be allocated
  * @size: the number of bytes to allocate
@@ -6323,7 +6323,7 @@ int __alloc_contig_migrate_range(struct
 }
 
 /**
- * alloc_contig_range_noprof() -- tries to allocate given range of pages
+ * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
  * @migratetype:	migratetype of the underlying pageblocks (either
@@ -6510,7 +6510,7 @@ static bool zone_spans_last_pfn(const st
 }
 
 /**
- * alloc_contig_pages_noprof() -- tries to find and allocate contiguous range of pages
+ * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
  * @nr_pages:	Number of contiguous pages to allocate
  * @gfp_mask:	GFP mask to limit search and used during compaction
  * @nid:	Target node
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
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

