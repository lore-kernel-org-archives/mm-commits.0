Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB4E811E7
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211570; cv=none; b=Wn48uLrKEGi1OaQ4Lwc2B9wP4HrCdH8hwA8OSbU0YgxszrGhar5dRoMJwuTR6BappDqSAT7SpMPfnAglCwPHAujDUp6zffP0IYiUYcYAAMGEBzi9yG9jSbMYK12xkrDVmxRA/Ng/gDbiUYGYOb8EGRJidAxCSDIFsTRw3J1o7f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211570; c=relaxed/simple;
	bh=MPR2ygGiE8Zr0NzTy7W/33Zd40RpYMEdf/iDI9G0e+4=;
	h=Date:To:From:Subject:Message-Id; b=TnnjIzPF2bcgDhR0GXXFImWmudU/XQWG5n4yEML/RgKAdYJQsFigGtf1BnpAIudUlEcoSBe5sBiyMfiFsUHirjdReyxcq7uHF46FyhT/vQ5usAQtqsZ6oxEuuKbicrGzMcvUs0qIO1OwXvSlwluBWETXW9mf36dJE9QUZqQS57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgUHQXxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgUHQXxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125A4C113CC;
	Mon, 15 Apr 2024 20:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713211569;
	bh=MPR2ygGiE8Zr0NzTy7W/33Zd40RpYMEdf/iDI9G0e+4=;
	h=Date:To:From:Subject:From;
	b=IgUHQXxzv42SzMFvMzvvnaUn3V3zRgwy3SKNJsaTWR63SjF/tH/l1nFQl0sgbU6eB
	 SekXiqacN+5TWO/m0VLnotUFCKfziDs0BC1d3d7jPeeNrYBEqeJDRBuqVOToYswrXo
	 MOwmrkKI4FPYcdK1VZGGbvbJe4bIPgBcVXXS8fi0=
Date: Mon, 15 Apr 2024 13:06:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch added to mm-unstable branch
Message-Id: <20240415200609.125A4C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: remove WRITE_ONCE when setting folio->index during UFFDIO_MOVE
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

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
Subject: userfaultfd: remove WRITE_ONCE when setting folio->index during UFFDIO_MOVE
Date: Sun, 14 Apr 2024 19:08:21 -0700

When folio is moved with UFFDIO_MOVE it gets locked before the rmap and
index are modified.  Due to the folio lock being already held,
WRITE_ONCE() is not needed when setting the folio index.  Remove it.

Link: https://lkml.kernel.org/r/20240415020821.1152951-1-surenb@google.com
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/userfaultfd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move
+++ a/mm/huge_memory.c
@@ -2200,7 +2200,7 @@ int move_pages_huge_pmd(struct mm_struct
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 		_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
--- a/mm/userfaultfd.c~userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1026,7 +1026,7 @@ static int move_present_pte(struct mm_st
 	}
 
 	folio_move_anon_rmap(src_folio, dst_vma);
-	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+	src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
 	/* Follow mremap() behavior and treat the entry dirty after the move */
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes-fix-2.patch
fix-missing-vmalloch-includes-fix-6.patch
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
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch
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
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

