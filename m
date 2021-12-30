Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A09C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Dec 2021 03:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhL3DrR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 22:47:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235450AbhL3DrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 22:47:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 891BFB80E36
        for <mm-commits@vger.kernel.org>; Thu, 30 Dec 2021 03:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B251C36AEA;
        Thu, 30 Dec 2021 03:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640836034;
        bh=ntkTcLDbtfSTDNiJZ1zsdQ821mW9/Y/xg2x5x+dxgTE=;
        h=Date:From:To:Subject:From;
        b=QxcCkHx79iYYIzbpKi6YH1kjwOZyNz+Y/DTF713MEnHKDeGHh1j/Cb7z7n/1VqhvS
         btrGFScU+uN3SIsilLR8++wFQVpevM7hJCdcYpC+xNjwpuDE+AhJ1Gv8k4J67FcDaY
         1If8jIbc9AhhnWUsevTuZjmCq0RxPNsgO8cP1w/w=
Date:   Wed, 29 Dec 2021 19:47:13 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + fs-f2fs-datac-fix-mess.patch added to -mm tree
Message-ID: <20211230034713.kR_DhD6kH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/f2fs/data.c: fix mess
has been added to the -mm tree.  Its filename is
     fs-f2fs-datac-fix-mess.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-f2fs-datac-fix-mess.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-f2fs-datac-fix-mess.patch

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
Subject: fs/f2fs/data.c: fix mess

fs/f2fs/data.c: In function 'f2fs_read_single_page':
fs/f2fs/data.c:2092:1: error: label 'confused' defined but not used [-Werror=unused-label]
 2092 | confused:
      | ^~~~~~~~

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/f2fs/data.c~fs-f2fs-datac-fix-mess
+++ a/fs/f2fs/data.c
@@ -2088,13 +2088,6 @@ submit_and_realloc:
 	f2fs_update_iostat(F2FS_I_SB(inode), FS_DATA_READ_IO, F2FS_BLKSIZE);
 	ClearPageError(page);
 	*last_block_in_bio = block_nr;
-	goto out;
-confused:
-	if (bio) {
-		__submit_bio(F2FS_I_SB(inode), bio, DATA);
-		bio = NULL;
-	}
-	unlock_page(page);
 out:
 	*bio_ret = bio;
 	return ret;
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
linux-next-git-rejects.patch
fs-f2fs-datac-fix-mess.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

