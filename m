Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB29DC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiAEXQs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiAEXQr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:16:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51896C061245
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 15:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0E05B80D96
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 23:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFDEC36AE9;
        Wed,  5 Jan 2022 23:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641424604;
        bh=+xPCgCw5rhhlwh2auen3n68Sk8nMIZudSMFpDeb2c9A=;
        h=Date:From:To:Subject:From;
        b=q0MxVzioIogjrb0Ldocd+AhriL1JZcntKp9atnwyAqL0ZT4byIjYCyGUlP77iY1Sn
         qM3pxMjMjht2Hs8NxGiq3hyevXHzGR2gt57EszUdnbtYRzfZlb+nTV6ma7JjEloVen
         A3hc0jSDwEm1jlphLStga2MwUBYzDB8zcVZbJUUc=
Date:   Wed, 05 Jan 2022 15:16:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  + mm-simplify-try_to_unuse-fix.patch added to -mm tree
Message-ID: <20220105231643.6QHtaU4sl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-try_to_unuse-fix
has been added to the -mm tree.  Its filename is
     mm-simplify-try_to_unuse-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-try_to_unuse-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-try_to_unuse-fix.patch

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
Subject: mm-simplify-try_to_unuse-fix

fix shmem_unuse() stub, per Matthew

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-simplify-try_to_unuse-fix
+++ a/mm/shmem.c
@@ -3990,7 +3990,7 @@ int __init shmem_init(void)
 	return 0;
 }
 
-int shmem_unuse(unsigned int type, unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
fs-f2fs-datac-fix-mess.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

