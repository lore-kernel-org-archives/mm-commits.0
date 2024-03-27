Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0E12F363
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570883; cv=none; b=AfYjHxagYu9qoZJvY5XmLrPeAqqwwbDZeW8NtAt5ay8ly3W4dlhJ8kICl1hIpIiea7veeIQIlqjJQDFCvdPSrClQfeVyw67xTJ0QWSSJwNG/SCZhLaPxOhE1QBipXJtYUqAKcHKb8L7d+syVNmigZi7FldwPzrfawiQ8cea+9qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570883; c=relaxed/simple;
	bh=QLr9lbXukeLhZhSkXpU2d0X7c6+YttDfVFm5Us9G9Ys=;
	h=Date:To:From:Subject:Message-Id; b=RBocyMBJgd6I/QHgXwfRs40K7BswQdnV9h5ZYX2ZRg6JI6zEf86ft52WT9nP+fAJg8qra50tDzEXsGvb1cRysG2Zy/MR1cm0q0EZuzqgXijvZPik3h55lf/aYzAAn9nV+moBbW1uLf7/9TTRw3lO64T8yf//WISEEnUbCKye5pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVr0Qcl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVr0Qcl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8242DC433F1;
	Wed, 27 Mar 2024 20:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570882;
	bh=QLr9lbXukeLhZhSkXpU2d0X7c6+YttDfVFm5Us9G9Ys=;
	h=Date:To:From:Subject:From;
	b=DVr0Qcl1QdTniK3/7LEzatZG1cQI3M44+MncBFW0hAJvdGw30lkpShpYfjqI76OY4
	 FvKwQnCmCseDkjBRHB1cLSYe6nFqOY+0mJsbRgy36v6kpRNlR/eqWlDIKMbepE1Kf4
	 biI3t9LsQaN+HTkiTAiGN3kGF+3YvgWFZwqWw+c0=
Date: Wed, 27 Mar 2024 13:21:21 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch added to mm-unstable branch
Message-Id: <20240327202122.8242DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: mm/slab: undo _noprof additions in the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch

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
Subject: Documentation: mm/slab: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:52 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-7-surenb@google.com
Fixes: bc7b83f5e4bf ("mm/slab: enable slab allocation tagging for kmalloc and friends")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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

