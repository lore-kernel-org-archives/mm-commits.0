Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83067C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbhLHA0G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:26:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53164 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbhLHAZ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:25:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C479CCE1ECA
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6619C341C3;
        Wed,  8 Dec 2021 00:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638922946;
        bh=jj8rS9MOwEtAUDLcIJ87RGXT3cO3uSGQNImxN4gPBwk=;
        h=Date:From:To:Subject:From;
        b=zvIPYrOR8SwR4Gdjw8QzDxfSHgjKJ8rABEjSZ75/LreLknjWkRv/U6EtJIZvpcOaW
         OHtUiryWBIBCPyJF/PNnFYd5+aCI/o5+gR7BfaKa0Cjd1Y8x4rNEawr7wXhB3aeLXB
         nFuLgu1jvdX+UjzyHJAaRDx5Z4WU3fAzD35YO2Fw=
Date:   Tue, 07 Dec 2021 16:22:25 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        npiggin@gmail.com, uladzislau.rezki@sony.com,
        xuyu@linux.alibaba.com
Subject:  +
 mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch added to -mm tree
Message-ID: <20211208002225.w5LSgTvmB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-allocate-small-pages-for-area-pages-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch

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
Subject: mm-vmalloc-allocate-small-pages-for-area-pages-fix

tweak code layout

Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-allocate-small-pages-for-area-pages-fix
+++ a/mm/vmalloc.c
@@ -2927,12 +2927,14 @@ static void *__vmalloc_area_node(struct
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
+	unsigned int nr_small_pages, max_small_pages;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
+	nr_small_pages = size >> PAGE_SHIFT;
+	max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
+
 	array_size = (unsigned long)max_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

