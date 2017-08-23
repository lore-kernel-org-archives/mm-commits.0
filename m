From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 23 Aug 2017 12:57:44 -0700
Message-ID: <20170823195744.XnDagCGRN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932405AbdHWT5q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 15:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm64/kernel/fpsimd.c~linux-next-git-rejects arch/arm64/kernel/fpsimd.c
--- a/arch/arm64/kernel/fpsimd.c~linux-next-git-rejects
+++ a/arch/arm64/kernel/fpsimd.c
@@ -171,13 +171,6 @@ void fpsimd_flush_thread(void)
 {
 	if (!system_supports_fpsimd())
 		return;
-<<<<<<< HEAD
-	preempt_disable();
-	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
-	fpsimd_flush_task_state(current);
-	set_thread_flag(TIF_FOREIGN_FPSTATE);
-	preempt_enable();
-=======
 
 	local_bh_disable();
 
@@ -186,7 +179,6 @@ void fpsimd_flush_thread(void)
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 
 	local_bh_enable();
->>>>>>> linux-next/akpm-base
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

