Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B229C4741F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0CEE20BED
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601505684;
	bh=Zsh1u72LLOxGq9hieb4XpZ3xNjzSA1Kmk8x12PP1xoc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HW5dfcwcotDGU9JhAXW+K+8Ci5ZdaD7i532KEMArUg6607R/PnlfbU+QxqLiNBa0W
	 IHkNqs3v3jRO7M1aJsg2UBU7sEyNX+gHKxd8mDFG5KywU97BIrJIcSeleN0MKWB/E2
	 diTVadyGJNs7S+Pr+UICeQmlO72hEWtk502MWOkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgI3WlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgI3WlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:41:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826A52074A;
        Wed, 30 Sep 2020 22:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601505672;
        bh=Zsh1u72LLOxGq9hieb4XpZ3xNjzSA1Kmk8x12PP1xoc=;
        h=Date:From:To:Subject:From;
        b=A2sfBDmbCCraL8ns+FZSex3fXAGEIb5CVmPIvNvEG67YMX0t2VFQa8t0KyfQLVoeZ
         n27aWeFUJV3SyIXEiKoGcR0U14JecscHC+fRpAtIEmHcKjQTI+6P+OCqKucMWmcnYd
         b+VKCuSifCq3CLdYSptMZ+KI9IagJJ1IWkIhXypo=
Date:   Wed, 30 Sep 2020 15:41:11 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  +
 mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch added to
 -mm tree
Message-ID: <20200930224111.4ZNZN_APt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap locking API: don't check locking if the mm isn't live yet
has been added to the -mm tree.  Its filename is
     mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mmap locking API: don't check locking if the mm isn't live yet

In preparation for adding a mmap_assert_locked() check in
__get_user_pages(), teach the mmap_assert_*locked() helpers that it's fine
to operate on an mm without locking in the middle of execve() as long as
it hasn't been installed on a process yet.

Existing code paths that do this are (reverse callgraph):

  get_user_pages_remote
    get_arg_page
      copy_strings
      copy_string_kernel
      remove_arg_zero
    tomoyo_dump_page
      tomoyo_print_bprm
      tomoyo_scan_bprm
      tomoyo_environ

Link: https://lkml.kernel.org/r/CAG48ez03YJG9JU_6tGiMcaVjuTyRE_o4LEQ7901b5ZoCnNAjcg@mail.gmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                 |    8 ++++++++
 include/linux/mm_types.h  |   10 ++++++++++
 include/linux/mmap_lock.h |   16 ++++++++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

--- a/fs/exec.c~mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet
+++ a/fs/exec.c
@@ -1129,6 +1129,14 @@ static int exec_mmap(struct mm_struct *m
 		}
 	}
 
+#if defined(CONFIG_LOCKDEP) || defined(CONFIG_DEBUG_VM)
+	/*
+	 * From here on, the mm may be accessed concurrently, and proper locking
+	 * is required for things like get_user_pages_remote().
+	 */
+	mm->mmap_lock_required = 1;
+#endif
+
 	task_lock(tsk);
 	membarrier_exec_mmap(mm);
 
--- a/include/linux/mmap_lock.h~mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet
+++ a/include/linux/mmap_lock.h
@@ -77,14 +77,22 @@ static inline void mmap_read_unlock_non_
 
 static inline void mmap_assert_locked(struct mm_struct *mm)
 {
-	lockdep_assert_held(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+#if defined(CONFIG_LOCKDEP) || defined(CONFIG_DEBUG_VM)
+	if (mm->mmap_lock_required) {
+		lockdep_assert_held(&mm->mmap_lock);
+		VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	}
+#endif
 }
 
 static inline void mmap_assert_write_locked(struct mm_struct *mm)
 {
-	lockdep_assert_held_write(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+#if defined(CONFIG_LOCKDEP) || defined(CONFIG_DEBUG_VM)
+	if (mm->mmap_lock_required) {
+		lockdep_assert_held_write(&mm->mmap_lock);
+		VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	}
+#endif
 }
 
 static inline int mmap_lock_is_contended(struct mm_struct *mm)
--- a/include/linux/mm_types.h~mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet
+++ a/include/linux/mm_types.h
@@ -556,6 +556,16 @@ struct mm_struct {
 #ifdef CONFIG_IOMMU_SUPPORT
 		u32 pasid;
 #endif
+
+#if defined(CONFIG_LOCKDEP) || defined(CONFIG_DEBUG_VM)
+		/*
+		 * Notes whether this mm has been installed on a process yet.
+		 * If not, only the task going through execve() can access this
+		 * mm, and no locking is needed around get_user_pages_remote().
+		 * This flag is only used for debug checks.
+		 */
+		bool mmap_lock_required;
+#endif
 	} __randomize_layout;
 
 	/*
_

Patches currently in -mm which might be from jannh@google.com are

mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.patch
binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch
mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

