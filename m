Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5EFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 03:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhLNDmr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 22:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhLNDmr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 22:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFA3C061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 19:42:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FAD2B817AD
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 03:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A8C34604;
        Tue, 14 Dec 2021 03:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639453364;
        bh=yFqvfRviTyye0IAIarHXHkfUSfKCCToB7iO0uqHOsnM=;
        h=Date:From:To:Subject:From;
        b=E8a/Sd7STSXdFR3KYPt39JgtrJFaK3u/tmSebaYPY65jVriVREKjrPInyfPqc2QXS
         IzmwG6QNs1o39Lq82pNPYcJ2o56ja3YOifSmZoKtazLlTKBOayp/y0dQgm9pcEybMn
         2mYo3YTI5tBbL+2kO9ctehRhGCYEkoVh+zywHdCA=
Date:   Mon, 13 Dec 2021 19:42:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch
 added to -mm tree
Message-ID: <20211214034243.0v9FFZAK_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/vmwgfx/vmwgfx_gem.c: printk fix
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch

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
Subject: drivers/gpu/drm/vmwgfx/vmwgfx_gem.c: printk fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c~drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -227,7 +227,7 @@ static void vmw_bo_print_info(int id, st
 		break;
 	}
 
-	seq_printf(m, "\t\t0x%08x: %12ld bytes %s, type = %s",
+	seq_printf(m, "\t\t0x%08x: %12zd bytes %s, type = %s",
 		   id, bo->base.base.size, placement, type);
 	seq_printf(m, ", priority = %u, pin_count = %u, GEM refs = %d, TTM refs = %d",
 		   bo->base.priority,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

