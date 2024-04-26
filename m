Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663082CA2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101002; cv=none; b=WaKwKwp9nifINIS3wVE3Ja9/W32r9mk9rZNZ6dGyILW88aT8rg1LsNSnKzH2hWZ6sG/pipXyRCEx0IqZmk/pfxhQ/xVH/9O5v3F2806i5WbUvWLUCha4H5pWrCYUARCkV5uo++L1ZG/LNYlSERfGEn6e+tn6fCLvQMG1mW/FNQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101002; c=relaxed/simple;
	bh=EmI+a2CRdGw2fLxRPV6WMutHEZNFIoa+UyMFVH1kTo0=;
	h=Date:To:From:Subject:Message-Id; b=kJpNQRPSgvyRrBpJU/ESIUUUEZJEwg3nQHuLtYrHerMvN/fyCfMOYwxTUu47NG1jncXEpIR/2yPlSjFtpk2gyhG1bXSk6+JoL/Vr+f5CqI+95fn7m64Q7W6KQj7nSoGh/AgHWPHXjgVpThASDvIy9gVvwK7xit6xkEHHuA8087E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VY8QKuJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VY8QKuJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3538C113CC;
	Fri, 26 Apr 2024 03:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101001;
	bh=EmI+a2CRdGw2fLxRPV6WMutHEZNFIoa+UyMFVH1kTo0=;
	h=Date:To:From:Subject:From;
	b=VY8QKuJVkkRMOvLm/JBVeZ6h/WWMlZhH5ETKZ5pQHRLV8hgoh9E0nuqR3SfskudIy
	 ySyLNoL7D1X1e0pvajurQxbAL82drXouE+zqXskBktQFYWGVd88csYzzEGZzHxULUP
	 ceva6LOlV2KzewhZiYt9523uAcni1Fyze9g1R8xk=
Date: Thu, 25 Apr 2024 20:10:01 -0700
To: mm-commits@vger.kernel.org,klarasmodin@gmail.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch removed from -mm tree
Message-Id: <20240426031001.D3538C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! increase PERCPU_MODULE_RESERVE to accommodate allocation tags
has been removed from the -mm tree.  Its filename was
     mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch

This patch was dropped because it was folded into mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! increase PERCPU_MODULE_RESERVE to accommodate allocation tags
Date: Sat, 6 Apr 2024 14:40:43 -0700

The increase of per-cpu reserved area for modules was not enough to
accommodate all allocation tags in certain use cases.  Increase some more
to fix the issue.

Link: https://lkml.kernel.org/r/20240406214044.1114406-1-surenb@google.com
Fixes: a11cb5c8e248 ("mm: percpu: increase PERCPU_MODULE_RESERVE to accommodate allocation tags")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Klara Modin <klarasmodin@gmail.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/percpu.h~mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix
+++ a/include/linux/percpu.h
@@ -15,7 +15,7 @@
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-#define PERCPU_MODULE_RESERVE		(8 << 12)
+#define PERCPU_MODULE_RESERVE		(8 << 13)
 #else
 #define PERCPU_MODULE_RESERVE		(8 << 10)
 #endif
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
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

