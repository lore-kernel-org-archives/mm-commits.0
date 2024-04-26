Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F88633EA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100889; cv=none; b=GUiSkpuCsIcpP/Hzd6MbiMAPiQqqIR5Oiv4UtGkKf6+0y13cOfhBTZR8bYnNIMQEGYueSkNEwKRaFn0b/Gzw6djqblqptBWgo/mpMNxRTUHWlC1WcWnXFErU6va/B2njjhHDUpVeNSehhhzAQJV7hFQ63UMCc0rvq7J3jxLR0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100889; c=relaxed/simple;
	bh=FMtXQKRqyJ6u3cXl6A2uMyE0z1zSW67T6mmp35hJoXs=;
	h=Date:To:From:Subject:Message-Id; b=SRuytica8TwbAKvzyGAWq7NB91ZJrqRbcnprj5Hmh8Q0qt32aKxCH4MeZcys3i+PKDwE/kEmy91dOFyYBm3bWf0uzUmsM/mfKZW3FlcDasG4YE7l+6s/iiwx8DDXHZbPCGY3Zp1VBZZRxqLvjNdJ1Lz8runBdDTr3txRFnLJ7Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObZ9qrMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObZ9qrMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DB3C113CC;
	Fri, 26 Apr 2024 03:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100889;
	bh=FMtXQKRqyJ6u3cXl6A2uMyE0z1zSW67T6mmp35hJoXs=;
	h=Date:To:From:Subject:From;
	b=ObZ9qrMyibZxoV54NWUOAoSIpN7dekClSCoJbIHJhWI6rcUKAg3UMHPdMq9EVO5z3
	 LbFTDDmTEMTfw3cjBpbV6tcoYAIjx224jKO+FIvN3AKFPoDif0MxPPB7+FrsCKsfCn
	 HHgOUTXRegFXZ7SKidOCiRegJeZFx50lNd5nXrOE=
Date: Thu, 25 Apr 2024 20:08:08 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,dan.carpenter@linaro.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4.patch removed from -mm tree
Message-Id: <20240426030809.04DB3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix alloc_tag_init() to prevent passing NULL to PTR_ERR()
has been removed from the -mm tree.  Its filename was
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4.patch

This patch was dropped because it was folded into lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: fix alloc_tag_init() to prevent passing NULL to PTR_ERR()
Date: Tue, 16 Apr 2024 17:33:49 -0700

codetag_register_type() never returns NULL, yet IS_ERR_OR_NULL() is used
to check its return value.  This leads to a warning about possibility of
passing NULL to PTR_ERR().  Fix that by using IS_ERR() to exclude NULL.

Link: https://lkml.kernel.org/r/20240417003349.2520094-1-surenb@google.com
Fixes: 6e8a230a6b1a ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202404051340.7Wo7oiJ5-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4
+++ a/lib/alloc_tag.c
@@ -141,7 +141,7 @@ static int __init alloc_tag_init(void)
 	};
 
 	alloc_tag_cttype = codetag_register_type(&desc);
-	if (IS_ERR_OR_NULL(alloc_tag_cttype))
+	if (IS_ERR(alloc_tag_cttype))
 		return PTR_ERR(alloc_tag_cttype);
 
 	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
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

