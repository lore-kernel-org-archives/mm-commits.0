Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CE8C04FF3
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 20:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F257D61406
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 20:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhEXUGr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 16:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232107AbhEXUGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 16:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D594561406;
        Mon, 24 May 2021 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621886717;
        bh=QnCOMOIRSb/3x8QIPVJ9wpqK1EBbDd6JCO6v0KEuF7c=;
        h=Date:From:To:Subject:From;
        b=kS1Hmym8M+ZdEKcwmCGma8+vOoxitPWcRsZibEvWIDDItoVh+FC0F20RpQ/L9/kqM
         GHOgCxxJKxbV6Hkx6xkETECD+AnyRVKioCWyM9JNc1iSB3Ea0OsIMo3oaZeFOAYqNm
         Y1nSH4YYI0IDxE8TwsVeItll5Px5W/nims0yG6YE=
Date:   Mon, 24 May 2021 13:05:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-post.patch added to -mm tree
Message-ID: <20210524200517.YnczXYNY2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-post
has been added to the -mm tree.  Its filename is
     linux-next-post.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-post.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-post.patch

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
Subject: linux-next-post

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~linux-next-post
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -698,9 +698,9 @@ int amdgpu_ttm_tt_get_user_pages(struct
 		return -ESRCH;
 
 	mmap_read_lock(mm);
-	vma = find_vma(mm, start);
+	vma = vma_lookup(mm, start);
 	mmap_read_unlock(mm);
-	if (unlikely(!vma || start < vma->vm_start)) {
+	if (unlikely(!vma)) {
 		r = -EFAULT;
 		goto out_putmm;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

