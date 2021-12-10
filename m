Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3FDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 21:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhLJVJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 16:09:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55030 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhLJVJR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 16:09:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD8A5CE2B9F
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 21:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C786BC00446;
        Fri, 10 Dec 2021 21:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639170338;
        bh=BIKiVXeYGdk9XFTuinvBqwqmmPwKMSt8+f4kfpxV8Hg=;
        h=Date:From:To:Subject:From;
        b=uq3BYg91eOiTxQs6rARHIZUn1x8AnlW7pdlLhZZFb8dEY1OXD1xct7BrT+thexWgj
         NPaHne6mZOoHHcKV01RvkFXKUAIJgYKcceVl1w6k4CtzYwLW3r3goLWceC5HIS/Tuv
         mkXtUgo40W8P49dp46+t8okAszWxEyb+7bOUf/0U=
Date:   Fri, 10 Dec 2021 13:05:38 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?kernel-sys-only-take-tasklist=5Flock-for-get-setpriorityprio?=
 =?US-ASCII?Q?=5Fpgrp-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20211210210538.CXMNfB-nK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch

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
Subject: kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes

ERROR: code indent should use tabs where possible
#102: FILE: kernel/sys.c:321:
+^I        for_each_process_thread(g, p) {$

WARNING: From:/Signed-off-by: email address mismatch: 'From: Davidlohr Bueso <dave@stgolabs.net>' != 'Signed-off-by: Davidlohr Bueso <dbueso@suse.de>'

total: 1 errors, 1 warnings, 77 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sys.c~kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes
+++ a/kernel/sys.c
@@ -318,7 +318,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 			if (!user)
 				goto out_unlock;	/* No processes for this user */
 		}
-	        for_each_process_thread(g, p) {
+		for_each_process_thread(g, p) {
 			if (uid_eq(task_uid(p), uid) && task_pid_vnr(p)) {
 				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
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

