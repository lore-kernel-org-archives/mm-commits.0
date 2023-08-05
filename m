Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4468DC0015E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 16:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjHEQ4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjHEQ4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 12:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBB11BD
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 09:56:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 328F060B38
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E75C433C8;
        Sat,  5 Aug 2023 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254570;
        bh=R+1IzRcCyOirzrRfAoFUMelNXISWmSye+cBOiZaT1ak=;
        h=Date:To:From:Subject:From;
        b=B2cT4UAmuXtSK15LCPGPL4fhsWInKhwTaHp+Gk8iha0dOpYiuH9qoLhWAUhhnzXlt
         qj5behfEDvRr+lb9pm0Z7BgqJ7kfhrlQMgQCqpO20C5Onquh2ccRJfjegl/jGR9WAu
         VXJ6GxdOP6ychXVtAzMdnJKfV9UhUBtcGOQfINJk=
Date:   Sat, 05 Aug 2023 09:56:09 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch added to mm-unstable branch
Message-Id: <20230805165610.86E75C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lock vma explicitly before doing vm_flags_reset and vm_flags_reset_once
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: lock vma explicitly before doing vm_flags_reset and vm_flags_reset_once
Date: Fri, 4 Aug 2023 08:27:22 -0700

Implicit vma locking inside vm_flags_reset() and vm_flags_reset_once() is
not obvious and makes it hard to understand where vma locking is happening.
Also in some cases (like in dup_userfaultfd()) vma should be locked earlier
than vma_flags modification. To make locking more visible, change these
functions to assert that the vma write lock is taken and explicitly lock
the vma beforehand. Fix userfaultfd functions which should lock the vma
earlier.

Link: https://lkml.kernel.org/r/20230804152724.3090321-5-surenb@google.com
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    1 +
 fs/userfaultfd.c                   |    6 ++++++
 include/linux/mm.h                 |   10 +++++++---
 mm/madvise.c                       |    5 ++---
 mm/mlock.c                         |    3 ++-
 mm/mprotect.c                      |    1 +
 6 files changed, 19 insertions(+), 7 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,6 +410,7 @@ static int kvmppc_memslot_page_merge(str
 			ret = H_STATE;
 			break;
 		}
+		vma_start_write(vma);
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
--- a/fs/userfaultfd.c~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/fs/userfaultfd.c
@@ -661,6 +661,7 @@ static void userfaultfd_event_wait_compl
 		mmap_write_lock(mm);
 		for_each_vma(vmi, vma) {
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
+				vma_start_write(vma);
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 				userfaultfd_set_vm_flags(vma,
 							 vma->vm_flags & ~__VM_UFFD_FLAGS);
@@ -696,6 +697,7 @@ int dup_userfaultfd(struct vm_area_struc
 
 	octx = vma->vm_userfaultfd_ctx.ctx;
 	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
+		vma_start_write(vma);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 		return 0;
@@ -777,6 +779,7 @@ void mremap_userfaultfd_prep(struct vm_a
 		atomic_inc(&ctx->mmap_changing);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
+		vma_start_write(vma);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 	}
@@ -934,6 +937,7 @@ static int userfaultfd_release(struct in
 			prev = vma;
 		}
 
+		vma_start_write(vma);
 		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
@@ -1498,6 +1502,7 @@ static int userfaultfd_register(struct u
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
+		vma_start_write(vma);
 		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
@@ -1681,6 +1686,7 @@ static int userfaultfd_unregister(struct
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
+		vma_start_write(vma);
 		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 
--- a/include/linux/mm.h~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/include/linux/mm.h
@@ -807,18 +807,22 @@ static inline void vm_flags_init(struct
 	ACCESS_PRIVATE(vma, __vm_flags) = flags;
 }
 
-/* Use when VMA is part of the VMA tree and modifications need coordination */
+/*
+ * Use when VMA is part of the VMA tree and modifications need coordination
+ * Note: vm_flags_reset and vm_flags_reset_once do not lock the vma and
+ * it should be locked explicitly beforehand.
+ */
 static inline void vm_flags_reset(struct vm_area_struct *vma,
 				  vm_flags_t flags)
 {
-	vma_start_write(vma);
+	vma_assert_write_locked(vma);
 	vm_flags_init(vma, flags);
 }
 
 static inline void vm_flags_reset_once(struct vm_area_struct *vma,
 				       vm_flags_t flags)
 {
-	vma_start_write(vma);
+	vma_assert_write_locked(vma);
 	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
 }
 
--- a/mm/madvise.c~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/mm/madvise.c
@@ -173,9 +173,8 @@ static int madvise_update_vma(struct vm_
 	}
 
 success:
-	/*
-	 * vm_flags is protected by the mmap_lock held in write mode.
-	 */
+	/* vm_flags is protected by the mmap_lock held in write mode. */
+	vma_start_write(vma);
 	vm_flags_reset(vma, new_flags);
 	if (!vma->vm_file || vma_is_anon_shmem(vma)) {
 		error = replace_anon_vma_name(vma, anon_name);
--- a/mm/mlock.c~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/mm/mlock.c
@@ -387,6 +387,7 @@ static void mlock_vma_pages_range(struct
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
+	vma_start_write(vma);
 	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
@@ -461,9 +462,9 @@ success:
 	 * It's okay if try_to_unmap_one unmaps a page just after we
 	 * set VM_LOCKED, populate_vma_page_range will bring it back.
 	 */
-
 	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
 		/* No work to do, and mlocking twice would be wrong */
+		vma_start_write(vma);
 		vm_flags_reset(vma, newflags);
 	} else {
 		mlock_vma_pages_range(vma, start, end, newflags);
--- a/mm/mprotect.c~mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once
+++ a/mm/mprotect.c
@@ -657,6 +657,7 @@ success:
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
+	vma_start_write(vma);
 	vm_flags_reset(vma, newflags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
_

Patches currently in -mm which might be from surenb@google.com are

mm-enable-page-walking-api-to-lock-vmas-during-the-walk.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch
mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch
mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch
mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

