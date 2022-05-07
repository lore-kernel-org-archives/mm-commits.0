Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246D0C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 21:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387452AbiEGVVN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245719AbiEGVVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 17:21:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D542725
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 14:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF36FB80CB3
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6FEC385A6;
        Sat,  7 May 2022 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651958242;
        bh=urpxzGD6VW/QOOWdg+cZ16ALR88kWaPd5bUw3X4HWs4=;
        h=Date:To:From:Subject:From;
        b=MPK0FD9/QVBeOVaHPDGKu9ufk2R8un3bin2YVXXdRQbjl5hG/bp6EC2LfkWHRx+pn
         f9C0ToW2hvxQYWlneATTQOfOy2vxqOTwzTN9D8+p1LqvGBC0tD6TrlLXQGmXWGKkBX
         jZq21cjvt5Ez2UChycV9n5QdHbFnG6VZOxrMEC2w=
Date:   Sat, 07 May 2022 14:17:21 -0700
To:     mm-commits@vger.kernel.org, mail@florommel.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-locking-api-fix-missed-mmap_sem-references-in-comments.patch added to mm-unstable branch
Message-Id: <20220507211722.5D6FEC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap locking API: fix missed mmap_sem references in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-locking-api-fix-missed-mmap_sem-references-in-comments.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Florian Rommel <mail@florommel.de>
Subject: mmap locking API: fix missed mmap_sem references in comments

Commit c1e8d7c6a7a6 ("mmap locking API: convert mmap_sem comments") missed
replacing some references of mmap_sem by mmap_lock due to misspelling
(mm_sem instead of mmap_sem).

Link: https://lkml.kernel.org/r/20220503113333.214124-1-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c |    2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                   |    2 +-
 mm/mmap.c                                         |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c~mmap-locking-api-fix-missed-mmap_sem-references-in-comments
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
@@ -184,7 +184,7 @@ static int kgd_hqd_load(struct amdgpu_de
 
 	/* read_user_ptr may take the mm->mmap_lock.
 	 * release srbm_mutex to avoid circular dependency between
-	 * srbm_mutex->mm_sem->reservation_ww_class_mutex->srbm_mutex.
+	 * srbm_mutex->mmap_lock->reservation_ww_class_mutex->srbm_mutex.
 	 */
 	release_queue(adev);
 	valid_wptr = read_user_wptr(mm, wptr, wptr_val);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c~mmap-locking-api-fix-missed-mmap_sem-references-in-comments
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
@@ -208,7 +208,7 @@ static int kgd_hqd_load(struct amdgpu_de
 
 	/* read_user_ptr may take the mm->mmap_lock.
 	 * release srbm_mutex to avoid circular dependency between
-	 * srbm_mutex->mm_sem->reservation_ww_class_mutex->srbm_mutex.
+	 * srbm_mutex->mmap_lock->reservation_ww_class_mutex->srbm_mutex.
 	 */
 	release_queue(adev);
 	valid_wptr = read_user_wptr(mm, wptr, wptr_val);
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mmap-locking-api-fix-missed-mmap_sem-references-in-comments
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -110,7 +110,7 @@ static unsigned long ttm_bo_io_mem_pfn(s
  * @bo: The buffer object
  * @vmf: The fault structure handed to the callback
  *
- * vm callbacks like fault() and *_mkwrite() allow for the mm_sem to be dropped
+ * vm callbacks like fault() and *_mkwrite() allow for the mmap_lock to be dropped
  * during long waits, and after the wait the callback will be restarted. This
  * is to allow other threads using the same virtual memory space concurrent
  * access to map(), unmap() completely unrelated buffer objects. TTM buffer
--- a/mm/mmap.c~mmap-locking-api-fix-missed-mmap_sem-references-in-comments
+++ a/mm/mmap.c
@@ -1285,7 +1285,7 @@ static int anon_vma_compatible(struct vm
  * the same as 'old', the other will be the new one that is trying
  * to share the anon_vma.
  *
- * NOTE! This runs with mm_sem held for reading, so it is possible that
+ * NOTE! This runs with mmap_lock held for reading, so it is possible that
  * the anon_vma of 'old' is concurrently in the process of being set up
  * by another page fault trying to merge _that_. But that's ok: if it
  * is being set up, that automatically means that it will be a singleton
@@ -1299,7 +1299,7 @@ static int anon_vma_compatible(struct vm
  *
  * We also make sure that the two vma's are compatible (adjacent,
  * and with the same memory policies). That's all stable, even with just
- * a read lock on the mm_sem.
+ * a read lock on the mmap_lock.
  */
 static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old, struct vm_area_struct *a, struct vm_area_struct *b)
 {
_

Patches currently in -mm which might be from mail@florommel.de are

mmap-locking-api-fix-missed-mmap_sem-references-in-comments.patch

