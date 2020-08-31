Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D552C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476B8207BB
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834205;
	bh=MMyWfTApVPh9663fJBjLjfAXGvjCfVeFQklBZw5sSoM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RAfpNRvImAx9ZXKlVCowumxuIAiQUq+ezwby8fblWDJyhYqSC0H2nlVyJQaunPj97
	 5eGp5PVFwdZ51gRQ2d8/eM0GPTUhgIPZMZlapisGKbI0D8/Wm1yvdnJdG4jYbovfXq
	 MzU0wO7DA08VB/gF6+ReW9VEObUXenlF2QYBESMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHaAgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgHaAgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 20:36:44 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4795A2076D;
        Mon, 31 Aug 2020 00:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834203;
        bh=MMyWfTApVPh9663fJBjLjfAXGvjCfVeFQklBZw5sSoM=;
        h=Date:From:To:Subject:From;
        b=wMEeNmxeUJhx73Qnt3VhwYW4cr4O5WU4FjwANUDBsNG9R0RczCsqK+r31IcOCexgH
         5H8dRLmDKNkG8Xe8bhhFOOnNO1Wqt/jene0EoAJi1l0h44laEpA1i5YHtP7UF1k20r
         1gSxy5r0JiIjYiPX4VXcvezvsill0/cC2a9tgTU8=
Date:   Sun, 30 Aug 2020 17:36:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, oleg@redhat.com, hch@lst.de,
        ebiederm@xmission.com, jannh@google.com
Subject:  +
 mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch added to -mm tree
Message-ID: <20200831003642.siOvm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the now-unnecessary mmget_still_valid() hack
has been added to the -mm tree.  Its filename is
     mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

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
Subject: mm: remove the now-unnecessary mmget_still_valid() hack

The preceding patches have ensured that core dumping properly takes the
mmap_lock.  Thanks to that, we can now remove mmget_still_valid() and all
its users.

Link: http://lkml.kernel.org/r/20200827114932.3572699-8-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/uverbs_main.c |    3 -
 drivers/vfio/pci/vfio_pci.c           |   38 +++++++++++-------------
 fs/proc/task_mmu.c                    |   18 -----------
 fs/userfaultfd.c                      |   28 +++++------------
 include/linux/sched/mm.h              |   25 ---------------
 mm/khugepaged.c                       |    2 -
 mm/madvise.c                          |   17 ----------
 mm/mmap.c                             |    5 ---
 8 files changed, 29 insertions(+), 107 deletions(-)

--- a/drivers/infiniband/core/uverbs_main.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -845,8 +845,6 @@ void uverbs_user_mmap_disassociate(struc
 		 * will only be one mm, so no big deal.
 		 */
 		mmap_read_lock(mm);
-		if (!mmget_still_valid(mm))
-			goto skip_mm;
 		mutex_lock(&ufile->umap_lock);
 		list_for_each_entry_safe (priv, next_priv, &ufile->umaps,
 					  list) {
@@ -865,7 +863,6 @@ void uverbs_user_mmap_disassociate(struc
 			}
 		}
 		mutex_unlock(&ufile->umap_lock);
-	skip_mm:
 		mmap_read_unlock(mm);
 		mmput(mm);
 	}
--- a/drivers/vfio/pci/vfio_pci.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1480,31 +1480,29 @@ static int vfio_pci_zap_and_vma_lock(str
 		} else {
 			mmap_read_lock(mm);
 		}
-		if (mmget_still_valid(mm)) {
-			if (try) {
-				if (!mutex_trylock(&vdev->vma_lock)) {
-					mmap_read_unlock(mm);
-					mmput(mm);
-					return 0;
-				}
-			} else {
-				mutex_lock(&vdev->vma_lock);
+		if (try) {
+			if (!mutex_trylock(&vdev->vma_lock)) {
+				mmap_read_unlock(mm);
+				mmput(mm);
+				return 0;
 			}
-			list_for_each_entry_safe(mmap_vma, tmp,
-						 &vdev->vma_list, vma_next) {
-				struct vm_area_struct *vma = mmap_vma->vma;
+		} else {
+			mutex_lock(&vdev->vma_lock);
+		}
+		list_for_each_entry_safe(mmap_vma, tmp,
+					 &vdev->vma_list, vma_next) {
+			struct vm_area_struct *vma = mmap_vma->vma;
 
-				if (vma->vm_mm != mm)
-					continue;
+			if (vma->vm_mm != mm)
+				continue;
 
-				list_del(&mmap_vma->vma_next);
-				kfree(mmap_vma);
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
 
-				zap_vma_ptes(vma, vma->vm_start,
-					     vma->vm_end - vma->vm_start);
-			}
-			mutex_unlock(&vdev->vma_lock);
+			zap_vma_ptes(vma, vma->vm_start,
+				     vma->vm_end - vma->vm_start);
 		}
+		mutex_unlock(&vdev->vma_lock);
 		mmap_read_unlock(mm);
 		mmput(mm);
 	}
--- a/fs/proc/task_mmu.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/fs/proc/task_mmu.c
@@ -1246,24 +1246,6 @@ static ssize_t clear_refs_write(struct f
 					count = -EINTR;
 					goto out_mm;
 				}
-				/*
-				 * Avoid to modify vma->vm_flags
-				 * without locked ops while the
-				 * coredump reads the vm_flags.
-				 */
-				if (!mmget_still_valid(mm)) {
-					/*
-					 * Silently return "count"
-					 * like if get_task_mm()
-					 * failed. FIXME: should this
-					 * function have returned
-					 * -ESRCH if get_task_mm()
-					 * failed like if
-					 * get_proc_task() fails?
-					 */
-					mmap_write_unlock(mm);
-					goto out_mm;
-				}
 				for (vma = mm->mmap; vma; vma = vma->vm_next) {
 					vma->vm_flags &= ~VM_SOFTDIRTY;
 					vma_set_page_prot(vma);
--- a/fs/userfaultfd.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/fs/userfaultfd.c
@@ -601,8 +601,6 @@ static void userfaultfd_event_wait_compl
 
 		/* the various vma->vm_userfaultfd_ctx still points to it */
 		mmap_write_lock(mm);
-		/* no task can run (and in turn coredump) yet */
-		VM_WARN_ON(!mmget_still_valid(mm));
 		for (vma = mm->mmap; vma; vma = vma->vm_next)
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
@@ -842,7 +840,6 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
-	bool still_valid;
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -858,7 +855,6 @@ static int userfaultfd_release(struct in
 	 * taking the mmap_lock for writing.
 	 */
 	mmap_write_lock(mm);
-	still_valid = mmget_still_valid(mm);
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
@@ -869,17 +865,15 @@ static int userfaultfd_release(struct in
 			continue;
 		}
 		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
-		if (still_valid) {
-			prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
-					 new_flags, vma->anon_vma,
-					 vma->vm_file, vma->vm_pgoff,
-					 vma_policy(vma),
-					 NULL_VM_UFFD_CTX);
-			if (prev)
-				vma = prev;
-			else
-				prev = vma;
-		}
+		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
+				 new_flags, vma->anon_vma,
+				 vma->vm_file, vma->vm_pgoff,
+				 vma_policy(vma),
+				 NULL_VM_UFFD_CTX);
+		if (prev)
+			vma = prev;
+		else
+			prev = vma;
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
@@ -1309,8 +1303,6 @@ static int userfaultfd_register(struct u
 		goto out;
 
 	mmap_write_lock(mm);
-	if (!mmget_still_valid(mm))
-		goto out_unlock;
 	vma = find_vma_prev(mm, start, &prev);
 	if (!vma)
 		goto out_unlock;
@@ -1511,8 +1503,6 @@ static int userfaultfd_unregister(struct
 		goto out;
 
 	mmap_write_lock(mm);
-	if (!mmget_still_valid(mm))
-		goto out_unlock;
 	vma = find_vma_prev(mm, start, &prev);
 	if (!vma)
 		goto out_unlock;
--- a/include/linux/sched/mm.h~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/include/linux/sched/mm.h
@@ -49,31 +49,6 @@ static inline void mmdrop(struct mm_stru
 		__mmdrop(mm);
 }
 
-/*
- * This has to be called after a get_task_mm()/mmget_not_zero()
- * followed by taking the mmap_lock for writing before modifying the
- * vmas or anything the coredump pretends not to change from under it.
- *
- * It also has to be called when mmgrab() is used in the context of
- * the process, but then the mm_count refcount is transferred outside
- * the context of the process to run down_write() on that pinned mm.
- *
- * NOTE: find_extend_vma() called from GUP context is the only place
- * that can modify the "mm" (notably the vm_start/end) under mmap_lock
- * for reading and outside the context of the process, so it is also
- * the only case that holds the mmap_lock for reading that must call
- * this function. Generally if the mmap_lock is hold for reading
- * there's no need of this check after get_task_mm()/mmget_not_zero().
- *
- * This function can be obsoleted and the check can be removed, after
- * the coredump code will hold the mmap_lock for writing before
- * invoking the ->core_dump methods.
- */
-static inline bool mmget_still_valid(struct mm_struct *mm)
-{
-	return likely(!mm->core_state);
-}
-
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
  * @mm: The address space to pin.
--- a/mm/khugepaged.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/mm/khugepaged.c
@@ -431,7 +431,7 @@ static void insert_to_mm_slots_hash(stru
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
+	return atomic_read(&mm->mm_users) == 0;
 }
 
 static bool hugepage_vma_check(struct vm_area_struct *vma,
--- a/mm/madvise.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/mm/madvise.c
@@ -1086,23 +1086,6 @@ int do_madvise(unsigned long start, size
 	if (write) {
 		if (mmap_write_lock_killable(current->mm))
 			return -EINTR;
-
-		/*
-		 * We may have stolen the mm from another process
-		 * that is undergoing core dumping.
-		 *
-		 * Right now that's io_ring, in the future it may
-		 * be remote process management and not "current"
-		 * at all.
-		 *
-		 * We need to fix core dumping to not do this,
-		 * but for now we have the mmget_still_valid()
-		 * model.
-		 */
-		if (!mmget_still_valid(current->mm)) {
-			mmap_write_unlock(current->mm);
-			return -EINTR;
-		}
 	} else {
 		mmap_read_lock(current->mm);
 	}
--- a/mm/mmap.c~mm-remove-the-now-unnecessary-mmget_still_valid-hack
+++ a/mm/mmap.c
@@ -2565,7 +2565,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (vma && (vma->vm_start <= addr))
 		return vma;
 	/* don't alter vm_end if the coredump is running */
-	if (!prev || !mmget_still_valid(mm) || expand_stack(prev, addr))
+	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
 		populate_vma_page_range(prev, addr, prev->vm_end, NULL);
@@ -2591,9 +2591,6 @@ find_extend_vma(struct mm_struct *mm, un
 		return vma;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return NULL;
-	/* don't alter vm_start if the coredump is running */
-	if (!mmget_still_valid(mm))
-		return NULL;
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
_

Patches currently in -mm which might be from jannh@google.com are

binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

