Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FEEC49EA6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DF761248
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhFXUXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhFXUXb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC2E61248;
        Thu, 24 Jun 2021 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624566072;
        bh=/5xY7EMiWBGOfJnYhuoEQdWrdCu1BLMipIVuBgSq390=;
        h=Date:From:To:Subject:From;
        b=jZSKSMImMPpbBT88n2O5TURGlc1PTpBkjoDeFXBTilJ2Z+WWTFXcdOZ/izvIu0qBD
         PiKUm6VpiQynsCux9sgi0h4utipybHCiyzkbAasHIkV3wc8zNAreJj0tZRXvKpZGip
         X1qyFe/ms+YL9U3XBwolkvGFpUOF4U0eZZ51viB0=
Date:   Thu, 24 Jun 2021 13:21:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210624202111.F2rEwiMX3%akpm@linux-foundation.org>
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

 kernel/sched/fair.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/kernel/sched/fair.c~linux-next-git-rejects
+++ a/kernel/sched/fair.c
@@ -3295,10 +3295,6 @@ static inline bool cfs_rq_is_decayed(str
 	if (cfs_rq->avg.runnable_sum)
 		return false;
 
-<<<<<<< HEAD
-	if (child_cfs_rq_on_list(cfs_rq))
-		return false;
-=======
 	/*
 	 * _avg must be null when _sum are null because _avg = _sum / divider
 	 * Make sure that rounding and/or propagation of PELT values never
@@ -3307,7 +3303,6 @@ static inline bool cfs_rq_is_decayed(str
 	SCHED_WARN_ON(cfs_rq->avg.load_avg ||
 		      cfs_rq->avg.util_avg ||
 		      cfs_rq->avg.runnable_avg);
->>>>>>> linux-next/akpm-base
 
 	return true;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-add-vmalloc_no_huge-fix.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
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
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

