Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A380C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6452B233EB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgLPRAQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgLPRAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:00:16 -0500
Date:   Wed, 16 Dec 2020 08:59:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608137975;
        bh=5cfPgPESc/P1C4wglgGYREOwbXB+7drMGLHNtQ7CheE=;
        h=From:To:Subject:From;
        b=nujZvIcoIY18NluG2Epa6WjqPxtMu4coTUlpzTMsHkcXn1uZxQz96Q1hdHRCJuNs1
         YoXQX3aIPiwPDDAQYA1xTpkAyYd59RP5/n74bkfa5WPV56jteXIZ1sncMJWePUUsK7
         kmuaLNPMdftei8GPhRwo5XXXYkRSy2uq/YXqXtqo=
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  [to-be-updated]
 mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch removed
 from -mm tree
Message-ID: <20201216165934.E4mbyueNJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap locking API: don't check locking if the mm isn't live yet
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch

This patch was dropped because an updated version will be merged

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
@@ -1001,6 +1001,14 @@ static int exec_mmap(struct mm_struct *m
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
@@ -161,14 +161,22 @@ static inline void mmap_read_unlock_non_
 
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
@@ -561,6 +561,16 @@ struct mm_struct {
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

mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

