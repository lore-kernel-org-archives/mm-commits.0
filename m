Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D95CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiANV07 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANV07 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:26:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DBFC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A48A3B821BA
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403B8C36AE9;
        Fri, 14 Jan 2022 21:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195616;
        bh=CWG6Wbj+1hZQxE8KRkHNr78yHQ4Lp3ZldfA4PawxeoE=;
        h=Date:From:To:Subject:From;
        b=Hdfko/lZ+k47iH12wmkeNcQzxUmc4gdWtRIoToUrMjkzmTr0qppYB2Yl91/2QHGSV
         qJ7O4/gW0L4JYx2s21WLGZPhTN0AYBiZFocP/kVtvXGg7q3wlb0ZcALxapnjrcl9S2
         bvUFkwsGdp+XqPnQ6rK6kwKyTpia6mBCrwPKr77s=
Date:   Fri, 14 Jan 2022 13:26:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zhengqi.arch@bytedance.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-remove-redundant-check-about-fault=5Fflag=5Fallow=5Fretr?=
 =?US-ASCII?Q?y-bit-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20220114212655.AASKQrYAb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes

WARNING: Block comments use a trailing */ on a separate line
#407: FILE: arch/s390/mm/fault.c:459:
+			 * mmap_lock has not been released */

total: 0 errors, 1 warnings, 444 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/fault.c~mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes
+++ a/arch/s390/mm/fault.c
@@ -455,8 +455,10 @@ retry:
 	if (fault & VM_FAULT_RETRY) {
 		if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
 			(flags & FAULT_FLAG_RETRY_NOWAIT)) {
-			/* FAULT_FLAG_RETRY_NOWAIT has been set,
-			 * mmap_lock has not been released */
+			/*
+			 * FAULT_FLAG_RETRY_NOWAIT has been set, mmap_lock has
+			 * not been released
+			 */
 			current->thread.gmap_pfault = 1;
 			fault = VM_FAULT_PFAULT;
 			goto out_up;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

