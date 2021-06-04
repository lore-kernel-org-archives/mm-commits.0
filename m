Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA48C4743C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 19:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564B7613F9
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 19:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFDTYe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFDTYe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 15:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4488C613F9;
        Fri,  4 Jun 2021 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622834567;
        bh=uUhfTfKZeI59JnKq4uGyCy1ThPDI+7qW/4cOtzPAi+g=;
        h=Date:From:To:Subject:From;
        b=tlDqLfQ8Bsp5fsbbO1pE6/RYivIWu2zfxfgn66UmqVumpBe2s7WpPH6NWe7wrt+VF
         Pz5IbGFBtWHb8diwkw0Cinsx99Z5PMw84s1301CZEW054X2MDKgo/IiKSO4cB14+7q
         hGKEeVUGnttm5xQdx/GPB4wrZBphqYsKZ7G7AVg8=
Date:   Fri, 04 Jun 2021 12:22:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210604192246.eMCYHcsVh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c           |    3 ---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ----
 drivers/gpu/drm/tegra/hub.c                       |    4 ----
 3 files changed, 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -364,8 +364,6 @@ static int amdgpu_ctx_query2(struct amdg
 	if (atomic_read(&ctx->guilty))
 		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
 
-<<<<<<< HEAD
-=======
 	if (adev->ras_enabled && con) {
 		/* Return the cached values in O(1),
 		 * and schedule delayed work to cache
@@ -390,7 +388,6 @@ static int amdgpu_ctx_query2(struct amdg
 				      msecs_to_jiffies(AMDGPU_RAS_COUNTE_DELAY_MS));
 	}
 
->>>>>>> linux-next/akpm-base
 	mutex_unlock(&mgr->lock);
 	return 0;
 }
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10060,11 +10060,7 @@ static int validate_overlay(struct drm_a
 {
 	int i;
 	struct drm_plane *plane;
-<<<<<<< HEAD
-	struct drm_plane_state *old_plane_state, *new_plane_state;
-=======
 	struct drm_plane_state *new_plane_state;
->>>>>>> linux-next/akpm-base
 	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
 
 	/* Check if primary plane is contained inside overlay */
--- a/drivers/gpu/drm/tegra/hub.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/tegra/hub.c
@@ -632,11 +632,7 @@ static void tegra_shared_plane_atomic_up
 	 * dGPU sector layout.
 	 */
 	if (tegra_plane_state->tiling.sector_layout == TEGRA_BO_SECTOR_LAYOUT_GPU)
-<<<<<<< HEAD
-		base |= BIT_ULL(39);
-=======
 		addr_flag = BIT_ULL(39);
->>>>>>> linux-next/akpm-base
 #endif
 
 	base = tegra_plane_state->iova[0] + fb->offsets[0];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

