Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36BD76035
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100705; cv=none; b=ODtJfegZHKzQe0SyM74eDQ+3IcsND/pb7x0AnnyRVBf+FDAbavaUqArouLgaCZ8bWhvn5qG+QMKOFbd6SsPQjqn0gK7fF3XpS+uzdtHKu77pPFFxF/itUFxR1sWdyNRVArnONtzteCfQbwJowj+K4UQlOM+3iFsnHfFAtA4qRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100705; c=relaxed/simple;
	bh=cHiyPDIRFERvkgxaJearxD5dQ7ULDd3KkZY2TzV8+3E=;
	h=Date:To:From:Subject:Message-Id; b=r/9r5BIINd+upHOBTyhQG2Ojj5EspaOmd/0oUwV++9wNcERoNaP7/dD43kFwcMRLKuM+LJ5QYbMdzAUd/iwdD/gv2HsaUDabp4V7lJHRSTSMuDhh977SzSNH2oz7fWNjtmUXmtOcpG8UKu0jPInMiyCpUp9voVobLUZkZlJsWPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k3am27Ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k3am27Ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAC9C2BBFC;
	Fri, 26 Apr 2024 03:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100704;
	bh=cHiyPDIRFERvkgxaJearxD5dQ7ULDd3KkZY2TzV8+3E=;
	h=Date:To:From:Subject:From;
	b=k3am27AxI4JTauIB35b/BTta5JPC602kKwV7lPbnu3SeLMWlE8QkBmTyTCPgl0HB+
	 eysFkcz1sLw/z+ZpVDyKh1j4rRM6VDLkxGWOgOxVRsIxcdREGd8Ct8A57tgokLGDmU
	 NQhQ5vQiGb7YEHikAjk7NDR6RhxUHrlEpjLTB60g=
Date: Thu, 25 Apr 2024 20:05:03 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-missing-vmalloch-includes-fix-2.patch removed from -mm tree
Message-Id: <20240426030504.2DAC9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix-2.patch

This patch was dropped because it was folded into fix-missing-vmalloch-includes.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! fix missing vmalloc.h includes
Date: Tue, 2 Apr 2024 11:09:32 -0700

vmalloc.h header refactoring missed vmalloc.h inclusion required for
__vmalloc_start_set symbol.  Add missing inclusion.

Link: https://lkml.kernel.org/r/20240402180933.1663992-1-surenb@google.com
Fixes: 07aecea15cc8 ("fix missing vmalloc.h includes")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290536.7f9zGl5Q-lkp@intel.com/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/numa_32.c~fix-missing-vmalloch-includes-fix-2
+++ a/arch/x86/mm/numa_32.c
@@ -24,6 +24,7 @@
 
 #include <linux/memblock.h>
 #include <linux/init.h>
+#include <linux/vmalloc.h>
 #include <asm/pgtable_areas.h>
 
 #include "numa_internal.h"
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes.patch
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
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4.patch
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
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

