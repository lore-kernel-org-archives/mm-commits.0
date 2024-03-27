Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5B7152516
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570884; cv=none; b=gczwadZESqKdzejaprMAD+dtYItSQB6HtEUB0GpHDtxsTnCBgOed605+rLBpEyDUUA9F5mAe4FPeWcumo6+8+6aS2AqWUjTOS/5wsDhVt16vyY7rIUIeLft7tle7bcpe+G6kT3kkqWdEv/Nd5W74rm933Vsn1ClrUeFqfSk9p+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570884; c=relaxed/simple;
	bh=GIAGo23IaqDizmseVNHsUvNRXfBaaJaMFZaFQFchV40=;
	h=Date:To:From:Subject:Message-Id; b=jczi6QRXitxpEUvrYk1dvRfqRxwhAYWwYZjODU1lb8bdcjL1SIcgvTHXNd+tFvN/P6sRw821IJttQzrZbUs1Dc+lJ0jo60LnOOpgih+DTCxB6r7dfL9zg67BYBpgJXLu75Tw8v8G5M82fxBRrhJckiISw0etBrIra7ZI11QP8VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdQGcIfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdQGcIfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6A9C433C7;
	Wed, 27 Mar 2024 20:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570884;
	bh=GIAGo23IaqDizmseVNHsUvNRXfBaaJaMFZaFQFchV40=;
	h=Date:To:From:Subject:From;
	b=sdQGcIfL7E+RO8BVqeIBEKlS/uMFYedjd6YxQd4UeECIabz469QAiEA7uzpxrGVu8
	 H9oa72NEb1hTtcm55IR0LEfmh2/FekrAH1qtem6UYtO6eSGSxxYV9td0puo/qEDVSi
	 ZLO4ZkhgOk/TzkhJ7CGR5SBlTu35jzmpaHEddXtk=
Date: Wed, 27 Mar 2024 13:21:23 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-hook-up-to-memory-allocation-profiling-fix.patch added to mm-unstable branch
Message-Id: <20240327202124.4A6A9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: mempool: undo _noprof additions in the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-hook-up-to-memory-allocation-profiling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-hook-up-to-memory-allocation-profiling-fix.patch

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
Subject: Documentation: mempool: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:49 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-4-surenb@google.com
Fixes: 01d3a2ac5e7f ("mempool: hook up to memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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

