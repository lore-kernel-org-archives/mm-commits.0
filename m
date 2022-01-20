Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02890C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 01:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344494AbiATBwb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiATBwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 20:52:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12AEC061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 17:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 458096154E
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 01:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E414C004E1;
        Thu, 20 Jan 2022 01:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642643549;
        bh=gXzsRGmlvxamFRxtrQ4fkswzsq8hpjkxf15PI714yXM=;
        h=Date:From:To:Subject:From;
        b=Qgd9TyYaN0LEeRC/J+MU7MMx4qotNS5JGmXxvFsTodoWVzlOOhg9gldldyXxMfane
         BB+dVAL0Rzob4LsagOcjJayUXXEbP0Ggv0UKmFISrXyn047LOrVBk/BIGwfQEO8OQG
         WV6uRtUY3kCbod2BGmUlBoSghKcX4on0DOqpiRew=
Date:   Wed, 19 Jan 2022 17:52:28 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de,
        mm-commits@vger.kernel.org, oleg@redhat.com
Subject:  [folded-merged]
 =?US-ASCII?Q?kernel-sys-only-take-tasklist=5Flock-for-get-setpriorityprio?=
 =?US-ASCII?Q?=5Fpgrp-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20220120015228.raWDC4oCZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes

Cc: Davidlohr Bueso <dave@stgolabs.net>

WARNING: A patch subject line should describe the change not the tool that found it
#2: 
Subject: kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes

WARNING: Commit log lines starting with '#' are dropped by git as comments
#5: 
#102: FILE: kernel/sys.c:321:

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#13: 
      mechanically convert to the typical style using --fix or --fix-inplace.

total: 0 errors, 3 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
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

kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

