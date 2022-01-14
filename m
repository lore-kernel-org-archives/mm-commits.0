Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64008C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiANVYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:24:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43490 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVYK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:24:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95013B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD58C36AE9;
        Fri, 14 Jan 2022 21:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195448;
        bh=9pQMippMVil8KrSWIbr0WkOdx3SFOhvPgX3UafhiuUg=;
        h=Date:From:To:Subject:From;
        b=gg5GxIGoS6C8Adnju/QPCJuHDFUs1MhnN0Hl1bnisgyAP94824R8rmgddic5RwSmm
         Z1Z6BnzxiI9KPSKsA7Mh5z+Fqa+aq8s1sTYEC8VMA1+h1cmXziqQneecN/1DAPGDv/
         YlzNbWBoBWEtD3S04uxa51v6BrRRhCqHMbq1fOQA=
Date:   Fri, 14 Jan 2022 13:24:07 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, ligang.bdlg@bytedance.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [folded-merged]
 =?US-ASCII?Q?shmem-fix-a-race-between-shmem=5Funused=5Fhuge=5Fshrink-and-?=
 =?US-ASCII?Q?shmem=5Fevict=5Finode-checkpatch-fixes.patch?= removed from
 -mm tree
Message-ID: <20220114212407.M9xuLTi0W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes

WARNING: Block comments should align the * on each line
#143: FILE: mm/shmem.c:643:
+		/*
+		* Make sure the inode is either on the global list or deleted from

total: 0 errors, 1 warnings, 91 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gang Li <ligang.bdlg@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes
+++ a/mm/shmem.c
@@ -640,10 +640,11 @@ drop:
 		goto put;
 move_back:
 		/*
-		* Make sure the inode is either on the global list or deleted from
-		* any local list before iput() since it could be deleted in another
-		* thread once we put the inode (then the local list is corrupted).
-		*/
+		 * Make sure the inode is either on the global list or deleted
+		 * from any local list before iput() since it could be deleted
+		 * in another thread once we put the inode (then the local list
+		 * is corrupted).
+		 */
 		spin_lock(&sbinfo->shrinklist_lock);
 		list_move(&info->shrinklist, &sbinfo->shrinklist);
 		sbinfo->shrinklist_len++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
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

