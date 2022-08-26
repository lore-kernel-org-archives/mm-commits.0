Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1585AECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 03:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiHZDlk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 23:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHZDlh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 23:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AF8564FE
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 20:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4921861E7E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 03:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9402CC433D6;
        Fri, 26 Aug 2022 03:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661485289;
        bh=xYN7VtceHwXC74UnlR83qoSdEcJCptSRTAMz3W6ep4o=;
        h=Date:To:From:Subject:From;
        b=Gy2BUoq3WnImEzLlKC85GdaUX2KJ2UUj3ZSNnWtoJmiytif+7/Mcqy9gG3qXDKaI9
         3d2bem7q44kc9wV/NunUAOwmIzP3hBY54poMKVMy/VsEBladcVxwTK80ssewwkyb1l
         DhVzi5IClLir0UH3g13nAn+tcic2vyRoDvh1UoJw=
Date:   Thu, 25 Aug 2022 20:41:28 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@suse.de, hch@infradead.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch added to mm-unstable branch
Message-Id: <20220826034129.9402CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
Date: Thu Aug 25 08:39:47 PM PDT 2022

fix it for mapletree

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree
+++ a/mm/nommu.c
@@ -1272,7 +1272,7 @@ error_maple_preallocate:
 	kmem_cache_free(vm_region_jar, region);
 	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
-	show_free_areas(0, NULL);
+	show_free_areas(0, NULL, GFP_KERNEL);
 	return -ENOMEM;
 
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

