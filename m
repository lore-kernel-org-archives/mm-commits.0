Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61190C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbhLJWeQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbhLJWeP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:34:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1385FC061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1EF84CE2AC8
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F30C00446;
        Fri, 10 Dec 2021 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639175436;
        bh=FyygjVle5vI96vTx66uefVxJcgaqJ5eXZpoXwRZxcYo=;
        h=Date:From:To:Subject:From;
        b=fXOGLZjuvjVR82luDOkva311A/2n5hAlDVcSXbyK/Q1/RLX/0jpjRhiaGfs2zyxuI
         rp/o9gk4sqx3/QJx2woM9bzymMpyGguZxtv5B6vsYziPojiwe2ykUtHpWGZq7QsgOn
         RyI9X0+jWAyAs0no2ItuM/RI7plRd2g8nAyCiGt8=
Date:   Fri, 10 Dec 2021 14:30:34 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, mm-commits@vger.kernel.org,
        nanich.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, willy@infradead.org,
        yt0928.kim@samsung.com
Subject:  [folded-merged]
 mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch removed from
 -mm tree
Message-ID: <20211210223034.awiHMHY24%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix
has been removed from the -mm tree.  Its filename was
     mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch

This patch was dropped because it was folded into mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix

Cc: Changheun Lee <nanich.lee@samsung.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <jisoo2146.oh@samsung.com>
Cc: <junho89.kim@samsung.com>
Cc: Manjong Lee <mj0123.lee@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <seunghwan.hyun@samsung.com>
Cc: <sookwan7.kim@samsung.com>
Cc: <yt0928.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/backing-dev.c~mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix
+++ a/mm/backing-dev.c
@@ -945,10 +945,12 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
-	/* if min ratio doesn't 0, it has to set 0 before unregister */
-	if (bdi->min_ratio) {
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio.
+	 */
+	if (bdi->min_ratio)
 		bdi_set_min_ratio(bdi, 0);
-	}
 
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch
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
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

