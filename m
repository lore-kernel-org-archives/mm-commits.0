Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D572EBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100708; cv=none; b=u+VLDYo+hWMo99tiQY2iIhYD95mklLzUp55KDNmMWTgjGxPVmZ+a/gceWMuyuUoo2cG/LCbrpkTeoiRwUbT5Ciwnw1WTtYe1k64Dy6GBuJIuPMLBY5Y39qnbiAXyXHx74nOuxJbmjY2IVsCqfM2xU1Q8cHUzt+9jCe5NklR4jI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100708; c=relaxed/simple;
	bh=0MsLtTR6Va78D64uroNQ5IiapnyVw1so62EaEkQFwdw=;
	h=Date:To:From:Subject:Message-Id; b=ehAwe/Q5duwU9SH0fNDhbWl5MPytWRg7CxquLRHFSnfGFuFUdRlv9lPJI6rsHuFqcyddGjGRh4C2LOzGRLc2IbEiWi8W0lJwrGmQOWKs/G7FZ5hPQnqS4QEEWiEbvJmEly3tS9jxS2knp2LYZHEDDaYpmurauYBBsgEHxtv96tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCRhbeKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCRhbeKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A3C113CC;
	Fri, 26 Apr 2024 03:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100708;
	bh=0MsLtTR6Va78D64uroNQ5IiapnyVw1so62EaEkQFwdw=;
	h=Date:To:From:Subject:From;
	b=BCRhbeKEFnMb0DMRSvYWeU+H2qPLGJn//qBJb5RCToW/iY5m7qEXJJ915+9twgX5E
	 1IN73uPvlhLHL4+vo5Qfi9gS06q5CyM5UL4f5qtCUG5Z6DYOgq/L6OmCHXJoqAvDVm
	 B2ErpDoUkyixUTEyy6nZBXOmv3dgWaE3/XptozsY=
Date: Thu, 25 Apr 2024 20:05:07 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-missing-vmalloch-includes-fix-6.patch removed from -mm tree
Message-Id: <20240426030507.E87A3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix-6.patch

This patch was dropped because it was folded into fix-missing-vmalloch-includes.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! fix missing vmalloc.h includes
Date: Fri, 5 Apr 2024 15:51:15 -0700

fix arc build

Link: https://lkml.kernel.org/r/20240405225115.431056-1-surenb@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404050828.5pKgmCLu-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kernel test robot <lkp@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/mmu-arcv2.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arc/include/asm/mmu-arcv2.h~fix-missing-vmalloch-includes-fix-6
+++ a/arch/arc/include/asm/mmu-arcv2.h
@@ -9,6 +9,8 @@
 #ifndef _ASM_ARC_MMU_ARCV2_H
 #define _ASM_ARC_MMU_ARCV2_H
 
+#include <soc/arc/aux.h>
+
 /*
  * TLB Management regs
  */
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes.patch
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

