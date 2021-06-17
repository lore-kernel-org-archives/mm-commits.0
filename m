Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F81C2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 05:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10A26128C
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 05:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFQFOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 01:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhFQFOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 01:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A2860FF1;
        Thu, 17 Jun 2021 05:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623906758;
        bh=aTsPKPc/uovIym8lz9ukdwgucO+Tmq2IiHNICeUGTGw=;
        h=Date:From:To:Subject:From;
        b=J7Lu0JXicwgFuTldlMZFdzDqHifeQlGsutGoDAYRKA7YoywcW73UqrgD++WpI0z2C
         z2RRDVyCY6eF2iBbJ3NuWGQeuCWT/PmTMZ0+4dnTDpzVZAmC6BeGcz/pLgXY7RiuhV
         NIT2C/IrpmvJpz209JjUV3vrcgS2ezDDEgd8KYng=
Date:   Wed, 16 Jun 2021 22:12:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  +
 kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch added to -mm
 tree
Message-ID: <20210617051238.B00FRav4a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cgroup/cgroup.c: don't export cgroup_get_e_css twice
has been added to the -mm tree.  Its filename is
     kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch

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
Subject: kernel/cgroup/cgroup.c: don't export cgroup_get_e_css twice


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/cgroup/cgroup.c~kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice
+++ a/kernel/cgroup/cgroup.c
@@ -600,7 +600,6 @@ static void cgroup_get_live(struct cgrou
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
 	css_get(&cgrp->self);
 }
-EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 /**
  * __cgroup_task_count - count the number of tasks in a cgroup. The caller
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slubc-include-swabh.patch
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

