Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46680C433FE
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 22:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiCFWJ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 17:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiCFWJ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 17:09:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A522BD8
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 14:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22CE360EC5
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 22:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C2C340EC;
        Sun,  6 Mar 2022 22:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646604513;
        bh=HBS4lk+CFx6++1azC6wFB6gKe/yf+WIBilBY0j1bLQs=;
        h=Date:To:From:Subject:From;
        b=SDJElmD7XrVblU18xK8LSdD5cVOKLp8rt/pQnLTMfldal0l26dq1vJY5SqQlk8Mnp
         KmPmFXV9rvf8TqSE+gT8Azp55qfcg7irDV0+f0368Ub3pFsvxjwZ2x7sgR0F15RVVr
         InSDNzf5TCDUsdKRI22rgumTn520Xy/brIGy/2oo=
Date:   Sun, 06 Mar 2022 14:08:32 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220306220833.6A5C2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/ftrace.c |    5 -----
 arch/s390/kernel/mcount.S |    9 ---------
 fs/btrfs/extent_io.c      |    4 ----
 fs/btrfs/transaction.h    |    4 ----
 4 files changed, 22 deletions(-)

--- a/arch/s390/kernel/ftrace.c~linux-next-git-rejects
+++ a/arch/s390/kernel/ftrace.c
@@ -223,13 +223,8 @@ int ftrace_make_call(struct dyn_ftrace *
 	if (IS_ERR(trampoline))
 		return PTR_ERR(trampoline);
 	s390_kernel_write(&trampoline->interceptor, &addr, sizeof(addr));
-<<<<<<< HEAD
-	brcl_enable((void *)rec->ip);
-	return 0;
-=======
 	/* Expect brcl 0x0,... */
 	return ftrace_patch_branch_mask((void *)rec->ip, 0xc004, true);
->>>>>>> linux-next/akpm-base
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
--- a/arch/s390/kernel/mcount.S~linux-next-git-rejects
+++ a/arch/s390/kernel/mcount.S
@@ -26,12 +26,7 @@ ENDPROC(ftrace_stub)
 #define STACK_PTREGS_PSW	(STACK_PTREGS + __PT_PSW)
 #define STACK_PTREGS_ORIG_GPR2	(STACK_PTREGS + __PT_ORIG_GPR2)
 #define STACK_PTREGS_FLAGS	(STACK_PTREGS + __PT_FLAGS)
-<<<<<<< HEAD
-#ifdef __PACK_STACK
-/* allocate just enough for r14, r15 and backchain */
-=======
 /* packed stack: allocate just enough for r14, r15 and backchain */
->>>>>>> linux-next/akpm-base
 #define TRACED_FUNC_FRAME_SIZE	24
 
 	.macro	ftrace_regs_entry, allregs=0
@@ -63,10 +58,6 @@ ENDPROC(ftrace_stub)
 
 	.if \allregs == 1
 	stg	%r14,(STACK_PTREGS_PSW)(%r15)
-<<<<<<< HEAD
-	stosm	(STACK_PTREGS_PSW)(%r15),0
-=======
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_HAVE_MARCH_Z10_FEATURES
 	mvghi	STACK_PTREGS_FLAGS(%r15),_PIF_FTRACE_FULL_REGS
 #else
--- a/fs/btrfs/extent_io.c~linux-next-git-rejects
+++ a/fs/btrfs/extent_io.c
@@ -6888,11 +6888,7 @@ static void assert_eb_page_uptodate(cons
 	 * would have !PageUptodate && !PageError, as we clear PageError before
 	 * reading.
 	 */
-<<<<<<< HEAD
-	if (fs_info->sectorsize < PAGE_SIZE) {
-=======
 	if (fs_info->nodesize < PAGE_SIZE) {
->>>>>>> linux-next/akpm-base
 		bool uptodate, error;
 
 		uptodate = btrfs_subpage_test_uptodate(fs_info, page,
--- a/fs/btrfs/transaction.h~linux-next-git-rejects
+++ a/fs/btrfs/transaction.h
@@ -217,11 +217,7 @@ int btrfs_wait_for_commit(struct btrfs_f
 void btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root);
 void btrfs_maybe_wake_unfinished_drop(struct btrfs_fs_info *fs_info);
-<<<<<<< HEAD
-int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
-=======
 int btrfs_clean_one_deleted_snapshot(struct btrfs_fs_info *fs_info);
->>>>>>> linux-next/akpm-base
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 void btrfs_commit_transaction_async(struct btrfs_trans_handle *trans);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

