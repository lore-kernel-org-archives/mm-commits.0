Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC49137764
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570879; cv=none; b=TuW6+lNFXN99pXZhrw7ol9rnWiaN5DDkw5S1sbIiLO8P/P2FRlpAuQH6lpRfUGIFtbAT+PVAhytZXQCQWI8fWi9ST7nMK6N8Ck6+iiFn35HtGlVJeTWeHcqf+WwY+PtxDmT929jE/1rEazKbkHjxwgPkg154unXhCvr6+QsqFtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570879; c=relaxed/simple;
	bh=UnwVGqXrbj/SD3sleZTGjmtXyXIKwtK3DJjv3KKr+EY=;
	h=Date:To:From:Subject:Message-Id; b=XQ5xombg6/Yp2fCc8psGK+8YWIb+UEp5HkR9RwFXrHlWxSbkrE1qB4vTbWa8KGiQEkgBiawk3t2yXV1nOwTpU1SbavtwiDbCDIdPm235vNSFuTTzFB0rfCIIKskTfaYdrwjfN/DwUaknpCIecU1O/WALwpKZlx9u/1h/jGgkJNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=168Rxyaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="168Rxyaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93042C433F1;
	Wed, 27 Mar 2024 20:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570879;
	bh=UnwVGqXrbj/SD3sleZTGjmtXyXIKwtK3DJjv3KKr+EY=;
	h=Date:To:From:Subject:From;
	b=168RxyaqCKaIqTSRLHPDRjJ+GstHXHcU1VoXf9rZmMl8WufkAprFfQMf2SRqLMmD0
	 JpWc+Q8KxSt6heBXo7biI+ZQSLqLB5L4OSvWAkgsfnEo+KdosNbEIXSCUGJQGWr8t/
	 Q7FNb9/DgliX3tIh5MWyd4LWuas7AHVD+t63Y9P0=
Date: Wed, 27 Mar 2024 13:21:18 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-page-allocation-tagging-fix.patch added to mm-unstable branch
Message-Id: <20240327202119.93042C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: mm: undo _noprof additions in the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enable-page-allocation-tagging-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-page-allocation-tagging-fix.patch

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
Subject: Documentation: mm: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:48 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-3-surenb@google.com
Fixes: 6522e08ac1c6 ("mm: enable page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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

