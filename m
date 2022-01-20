Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59EBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377922AbiATVaV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377920AbiATVaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE178C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C216617CF
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C510CC340E0;
        Thu, 20 Jan 2022 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714219;
        bh=aeiWBUUeUNAZtHYTaePUJJsRPW7Gr9ylleJBi7/k+Ok=;
        h=Date:From:To:Subject:From;
        b=YVnBy8V3ZthqeLmCbhsEFsSPvjZlfFLHk6fFng98pJOOKsy4sYJw8so7khzF7bKFG
         HW22vgY/tAKqjmM+3dN2vZw7RgrzwA0VLdwe2MRbaLiZkOPfg1kJAXbu+66+3iSxpk
         S67E2kUkh3JdQtNRnKP2rj1VTk57Aqjhu71HKnLY=
Date:   Thu, 20 Jan 2022 13:30:18 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de,
        mm-commits@vger.kernel.org, oleg@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?kernel-sys-only-take-tasklist=5Flock-for-get-setpriorityprio?=
 =?US-ASCII?Q?=5Fpgrp-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20220120213018.W70XbYf2h%akpm@linux-foundation.org>
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

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

