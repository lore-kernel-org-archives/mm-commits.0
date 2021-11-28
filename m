Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F15CC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhK1AyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:54:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57656 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344682AbhK1AwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:52:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 617F8B80916
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9114C53FBF;
        Sun, 28 Nov 2021 00:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638060542;
        bh=PeC1aFtNDJUe0n04cIBcJ+4+xHnU/4xrWUps9yPyKQg=;
        h=Date:From:To:Subject:From;
        b=pNZ6lc8S0U6xl5LD/QNqRmSm+k1/KwCxQovp2JJ093trxJt0MK6HftT5jj4cZNGk4
         XcUA5nzR5bthNS7yAnUds73hF6AYsZt+ziKjtlmEP2TU33B8a+DKY2pE4klKrdi4BZ
         ijl1loZe/m5sPcob8Ynic+9FkkaOgF8wW8ax3S8c=
Date:   Sat, 27 Nov 2021 16:49:01 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, ligang.bdlg@bytedance.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  +
 =?US-ASCII?Q?shmem-fix-a-race-between-shmem=5Funused=5Fhuge=5Fshrink-and-?=
 =?US-ASCII?Q?shmem=5Fevict=5Finode-checkpatch-fixes.patch?= added to -mm
 tree
Message-ID: <20211128004901.qRhWUbgaf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch

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

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

