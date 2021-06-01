Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FACC47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD727613BC
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhFATCw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233397AbhFATCw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 15:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9800861378;
        Tue,  1 Jun 2021 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622574070;
        bh=2O7asTblwR0gti088riKI00YqcsqoS70FM2lj0F+ark=;
        h=Date:From:To:Subject:From;
        b=ICpGaV+A8sejdmcr5xLQOMzZE9TXv76NaTckHPoxWRjQ8hxRAvgpzang8WcATgIS5
         /NFwyqXU/Rx2jiJvWMrf9o5/t/9R90GeDmQr7hhx8DsEWn2i9/YKHjOGtDrC0Wr9Q1
         dz0uf9QOySYGClG7iBl4Vz+OS+GWociqomd15d6o=
Date:   Tue, 01 Jun 2021 12:01:10 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210601190110.FzJvll3pU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/seccomp_filter.rst  |    3 --
 arch/arm64/kvm/arm.c                            |    3 --
 fs/gfs2/file.c                                  |   18 --------------
 kernel/seccomp.c                                |    4 ---
 tools/testing/selftests/kvm/memslot_perf_test.c |    4 ---
 5 files changed, 32 deletions(-)

--- a/arch/arm64/kvm/arm.c~linux-next-git-rejects
+++ a/arch/arm64/kvm/arm.c
@@ -899,10 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_deactivate(vcpu);
 
-<<<<<<< HEAD
 out:
-=======
->>>>>>> linux-next/akpm-base
 	/*
 	 * In the unlikely event that we are returning to userspace
 	 * with pending exceptions or PC adjustment, commit these
--- a/Documentation/userspace-api/seccomp_filter.rst~linux-next-git-rejects
+++ a/Documentation/userspace-api/seccomp_filter.rst
@@ -258,8 +258,6 @@ Userspace can then make a decision based
 and ``ioctl(SECCOMP_IOCTL_NOTIF_SEND)`` a response, indicating what should be
 returned to userspace. The ``id`` member of ``struct seccomp_notif_resp`` should
 be the same ``id`` as in ``struct seccomp_notif``.
-<<<<<<< HEAD
-=======
 
 Userspace can also add file descriptors to the notifying process via
 ``ioctl(SECCOMP_IOCTL_NOTIF_ADDFD)``. The ``id`` member of
@@ -272,7 +270,6 @@ the specific number to use. If that file
 notifying process it will be replaced. The supervisor can also add an FD, and
 respond atomically by using the ``SECCOMP_ADDFD_FLAG_SEND`` flag and the return
 value will be the injected file descriptor number.
->>>>>>> linux-next/akpm-base
 
 It is worth noting that ``struct seccomp_data`` contains the values of register
 arguments to the syscall, but does not contain pointers to memory. The task's
--- a/fs/gfs2/file.c~linux-next-git-rejects
+++ a/fs/gfs2/file.c
@@ -577,17 +577,6 @@ static vm_fault_t gfs2_fault(struct vm_f
 	struct gfs2_holder *outer_gh = gfs2_glock_is_locked_by_me(ip->i_gl);
 	struct gfs2_holder gh;
 	vm_fault_t ret;
-<<<<<<< HEAD
-	u16 state;
-	int err;
-
-	state = (vmf->flags & FAULT_FLAG_WRITE) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	gfs2_holder_init(ip->i_gl, state, 0, &gh);
-	err = gfs2_glock_nq(&gh);
-	if (err) {
-		ret = block_page_mkwrite_return(err);
-		goto out_uninit;
-=======
 	u16 state, flags = 0;
 	int err;
 
@@ -613,7 +602,6 @@ static vm_fault_t gfs2_fault(struct vm_f
 			ret = VM_FAULT_SIGBUS;
 			goto out_uninit;
 		}
->>>>>>> linux-next/akpm-base
 	}
 	ret = filemap_fault(vmf);
 	if (likely(!outer_gh))
@@ -1021,13 +1009,7 @@ static ssize_t gfs2_file_write_iter(stru
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-<<<<<<< HEAD
-		current->backing_dev_info = inode_to_bdi(inode);
-		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
-=======
 		buffered = gfs2_file_buffered_write(iocb, from);
->>>>>>> linux-next/akpm-base
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
--- a/kernel/seccomp.c~linux-next-git-rejects
+++ a/kernel/seccomp.c
@@ -1141,11 +1141,7 @@ static int seccomp_do_user_notification(
 						 struct seccomp_kaddfd, list);
 		/* Check if we were woken up by a addfd message */
 		if (addfd)
-<<<<<<< HEAD
-			seccomp_handle_addfd(addfd);
-=======
 			seccomp_handle_addfd(addfd, &n);
->>>>>>> linux-next/akpm-base
 
 	}  while (n.state != SECCOMP_NOTIFY_REPLIED);
 
--- a/tools/testing/selftests/kvm/memslot_perf_test.c~linux-next-git-rejects
+++ a/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -267,11 +267,7 @@ static bool prepare_vm(struct vm_data *d
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-<<<<<<< HEAD
-	data->vm = vm_create_default(VCPU_ID, 1024, guest_code);
-=======
 	data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
->>>>>>> linux-next/akpm-base
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix-fix.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

