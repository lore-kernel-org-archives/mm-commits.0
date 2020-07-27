Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26524C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E64762075D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595882065;
	bh=A9dy15ho1YbUNqDW6a2I4NeBzhYylCEvdBhhf9NzQ34=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H4VpRcGrmhvgQTf2z70Ac5yJPSwinOiDBie4o+kfZ8JqqDkjEnDwoglTb8t45r8MY
	 pyrt+7r1Ey4i+mxabB953AZ+5pb0w8cqmSCo8ImknxBvddW9F6BsqV6Obu/gggdNL+
	 Q7NiX3tKdCSJxoGKsSnk4TPFWgoLnbr7OObrznGA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgG0UeY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgG0UeY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:34:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420AA20759;
        Mon, 27 Jul 2020 20:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595882063;
        bh=A9dy15ho1YbUNqDW6a2I4NeBzhYylCEvdBhhf9NzQ34=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e/HwKZY0uCLLC/S9d9fPn0PLpJhrYto9PiHxnR/20Dtr8t08x/SZI2/1NBiyAFFp1
         WiiqRw0uv2qD5OVKt/zOTCSC4XwO+U60hmqAnIBfN8DwplOpt26SA/RPSq6uBAV+CY
         hUoxKSdJxEQwimz/xVTS617AvMo86e3+CqRvsbhc=
Date:   Mon, 27 Jul 2020 13:34:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alex.williamson@redhat.com, bmt@zurich.ibm.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, dledford@redhat.com,
        fly@kernel.page, hughd@google.com, jgg@ziepe.ca,
        jglisse@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, rientjes@google.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, yinghan@google.com
Subject:  + mm-make-mm-locked_vm-an-atomic64-counter.patch added to
 -mm tree
Message-ID: <20200727203421.TaNVXG6F_%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mm->locked_vm an atomic64 counter
has been added to the -mm tree.  Its filename is
     mm-make-mm-locked_vm-an-atomic64-counter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-mm-locked_vm-an-atomic64-counter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-mm-locked_vm-an-atomic64-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pengfei Li <fly@kernel.page>
Subject: mm: make mm->locked_vm an atomic64 counter

Like commit 70f8a3ca68d3 ("mm: make mm->pinned_vm an atomic64 counter").

By making mm->locked_vm an atomic64 counter, we can safely modify it
without holding mmap_lock.

The reason for using atomic64 instead of atomic_long is to keep the same
as mm->pinned_vm, and there is no need to worry about overflow.

Link: http://lkml.kernel.org/r/20200726080224.205470-1-fly@kernel.page
Signed-off-by: Pengfei Li <fly@kernel.page>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/siw/siw_verbs.c |   12 +++++++-----
 drivers/vfio/vfio_iommu_type1.c       |    6 ++++--
 fs/io_uring.c                         |    4 ++--
 fs/proc/task_mmu.c                    |    2 +-
 include/linux/mm_types.h              |    4 ++--
 kernel/fork.c                         |    2 +-
 mm/debug.c                            |    5 +++--
 mm/mlock.c                            |    4 ++--
 mm/mmap.c                             |   18 +++++++++---------
 mm/mremap.c                           |    6 +++---
 mm/util.c                             |    6 +++---
 11 files changed, 37 insertions(+), 32 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_verbs.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1293,14 +1293,16 @@ struct ib_mr *siw_reg_user_mr(struct ib_
 		goto err_out;
 	}
 	if (mem_limit != RLIM_INFINITY) {
-		unsigned long num_pages =
-			(PAGE_ALIGN(len + (start & ~PAGE_MASK))) >> PAGE_SHIFT;
+		unsigned long num_pages, locked_pages;
+
+		num_pages = (PAGE_ALIGN(len + (start & ~PAGE_MASK)))
+				>> PAGE_SHIFT;
+		locked_pages = atomic64_read(&current->mm->locked_vm);
 		mem_limit >>= PAGE_SHIFT;
 
-		if (num_pages > mem_limit - current->mm->locked_vm) {
+		if (num_pages > mem_limit - locked_pages) {
 			siw_dbg_pd(pd, "pages req %lu, max %lu, lock %lu\n",
-				   num_pages, mem_limit,
-				   current->mm->locked_vm);
+				   num_pages, mem_limit, locked_pages);
 			rv = -ENOMEM;
 			goto err_out;
 		}
--- a/drivers/vfio/vfio_iommu_type1.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -509,7 +509,8 @@ static long vfio_pin_pages_remote(struct
 	 * pages are already counted against the user.
 	 */
 	if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-		if (!dma->lock_cap && current->mm->locked_vm + 1 > limit) {
+		if (!dma->lock_cap &&
+		    atomic64_read(&current->mm->locked_vm) + 1 > limit) {
 			put_pfn(*pfn_base, dma->prot);
 			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
 					limit << PAGE_SHIFT);
@@ -536,7 +537,8 @@ static long vfio_pin_pages_remote(struct
 
 		if (!rsvd && !vfio_find_vpfn(dma, iova)) {
 			if (!dma->lock_cap &&
-			    current->mm->locked_vm + lock_acct + 1 > limit) {
+			    atomic64_read(&current->mm->locked_vm) +
+			    lock_acct + 1 > limit) {
 				put_pfn(pfn, dma->prot);
 				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 					__func__, limit << PAGE_SHIFT);
--- a/fs/io_uring.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/fs/io_uring.c
@@ -7383,7 +7383,7 @@ static void io_unaccount_mem(struct io_r
 
 	if (ctx->sqo_mm) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm -= nr_pages;
+			atomic64_sub(nr_pages, &ctx->sqo_mm->locked_vm);
 		else if (acct == ACCT_PINNED)
 			atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
 	}
@@ -7402,7 +7402,7 @@ static int io_account_mem(struct io_ring
 
 	if (ctx->sqo_mm) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm += nr_pages;
+			atomic64_add(nr_pages, &ctx->sqo_mm->locked_vm);
 		else if (acct == ACCT_PINNED)
 			atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
 	}
--- a/fs/proc/task_mmu.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/fs/proc/task_mmu.c
@@ -58,7 +58,7 @@ void task_mem(struct seq_file *m, struct
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
 	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
-	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
+	SEQ_PUT_DEC(" kB\nVmLck:\t", atomic64_read(&mm->locked_vm));
 	SEQ_PUT_DEC(" kB\nVmPin:\t", atomic64_read(&mm->pinned_vm));
 	SEQ_PUT_DEC(" kB\nVmHWM:\t", hiwater_rss);
 	SEQ_PUT_DEC(" kB\nVmRSS:\t", total_rss);
--- a/include/linux/mm_types.h~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/include/linux/mm_types.h
@@ -457,8 +457,8 @@ struct mm_struct {
 		unsigned long hiwater_vm;  /* High-water virtual memory usage */
 
 		unsigned long total_vm;	   /* Total pages mapped */
-		unsigned long locked_vm;   /* Pages that have PG_mlocked set */
-		atomic64_t    pinned_vm;   /* Refcount permanently increased */
+		atomic64_t locked_vm;	   /* Pages that have PG_mlocked set */
+		atomic64_t pinned_vm;	   /* Refcount permanently increased */
 		unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 		unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 		unsigned long stack_vm;	   /* VM_STACK */
--- a/kernel/fork.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/kernel/fork.c
@@ -1008,7 +1008,7 @@ static struct mm_struct *mm_init(struct
 	mm->core_state = NULL;
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
-	mm->locked_vm = 0;
+	atomic64_set(&mm->locked_vm, 0);
 	atomic64_set(&mm->pinned_vm, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
--- a/mm/debug.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/mm/debug.c
@@ -218,7 +218,7 @@ void dump_mm(const struct mm_struct *mm)
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
 		"pgd %px mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
-		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
+		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %llx\n"
 		"pinned_vm %llx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
 		"start_brk %lx brk %lx start_stack %lx\n"
@@ -249,7 +249,8 @@ void dump_mm(const struct mm_struct *mm)
 		atomic_read(&mm->mm_count),
 		mm_pgtables_bytes(mm),
 		mm->map_count,
-		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
+		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm,
+		(u64)atomic64_read(&mm->locked_vm),
 		(u64)atomic64_read(&mm->pinned_vm),
 		mm->data_vm, mm->exec_vm, mm->stack_vm,
 		mm->start_code, mm->end_code, mm->start_data, mm->end_data,
--- a/mm/mlock.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/mm/mlock.c
@@ -561,7 +561,7 @@ success:
 		nr_pages = -nr_pages;
 	else if (old_flags & VM_LOCKED)
 		nr_pages = 0;
-	mm->locked_vm += nr_pages;
+	atomic64_add(nr_pages, &mm->locked_vm);
 
 	/*
 	 * vm_flags is protected by the mmap_lock held in write mode.
@@ -688,7 +688,7 @@ static __must_check int do_mlock(unsigne
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
-	locked += current->mm->locked_vm;
+	locked += atomic64_read(&current->mm->locked_vm);
 	if ((locked > lock_limit) && (!capable(CAP_IPC_LOCK))) {
 		/*
 		 * It is possible that the regions requested intersect with
--- a/mm/mmap.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/mm/mmap.c
@@ -1319,7 +1319,7 @@ static inline int mlock_future_check(str
 	/*  mlock MCL_FUTURE? */
 	if (flags & VM_LOCKED) {
 		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
+		locked += atomic64_read(&mm->locked_vm);
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		lock_limit >>= PAGE_SHIFT;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
@@ -1832,7 +1832,7 @@ out:
 					vma == get_gate_vma(current->mm))
 			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 		else
-			mm->locked_vm += (len >> PAGE_SHIFT);
+			atomic64_add(len >> PAGE_SHIFT, &mm->locked_vm);
 	}
 
 	if (file)
@@ -2343,7 +2343,7 @@ static int acct_stack_growth(struct vm_a
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked;
 		unsigned long limit;
-		locked = mm->locked_vm + grow;
+		locked = atomic64_read(&mm->locked_vm) + grow;
 		limit = rlimit(RLIMIT_MEMLOCK);
 		limit >>= PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
@@ -2436,7 +2436,7 @@ int expand_upwards(struct vm_area_struct
 				 */
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
+					atomic64_add(grow, &mm->locked_vm);
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
@@ -2516,7 +2516,7 @@ int expand_downwards(struct vm_area_stru
 				 */
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
+					atomic64_add(grow, &mm->locked_vm);
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
@@ -2859,11 +2859,11 @@ int __do_munmap(struct mm_struct *mm, un
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
 	 */
-	if (mm->locked_vm) {
+	if (atomic64_read(&mm->locked_vm)) {
 		struct vm_area_struct *tmp = vma;
 		while (tmp && tmp->vm_start < end) {
 			if (tmp->vm_flags & VM_LOCKED) {
-				mm->locked_vm -= vma_pages(tmp);
+				atomic64_sub(vma_pages(tmp), &mm->locked_vm);
 				munlock_vma_pages_all(tmp);
 			}
 
@@ -3103,7 +3103,7 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
-		mm->locked_vm += (len >> PAGE_SHIFT);
+		atomic64_add(len >> PAGE_SHIFT, &mm->locked_vm);
 	vma->vm_flags |= VM_SOFTDIRTY;
 	return 0;
 }
@@ -3175,7 +3175,7 @@ void exit_mmap(struct mm_struct *mm)
 		mmap_write_unlock(mm);
 	}
 
-	if (mm->locked_vm) {
+	if (atomic64_read(&mm->locked_vm)) {
 		vma = mm->mmap;
 		while (vma) {
 			if (vma->vm_flags & VM_LOCKED)
--- a/mm/mremap.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/mm/mremap.c
@@ -455,7 +455,7 @@ static unsigned long move_vma(struct vm_
 	}
 
 	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += new_len >> PAGE_SHIFT;
+		atomic64_add(new_len >> PAGE_SHIFT, &mm->locked_vm);
 		*locked = true;
 	}
 out:
@@ -520,7 +520,7 @@ static struct vm_area_struct *vma_to_res
 
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
-		locked = mm->locked_vm << PAGE_SHIFT;
+		locked = atomic64_read(&mm->locked_vm) << PAGE_SHIFT;
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		locked += new_len - old_len;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
@@ -765,7 +765,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 			vm_stat_account(mm, vma->vm_flags, pages);
 			if (vma->vm_flags & VM_LOCKED) {
-				mm->locked_vm += pages;
+				atomic64_add(pages, &mm->locked_vm);
 				locked = true;
 				new_addr = addr;
 			}
--- a/mm/util.c~mm-make-mm-locked_vm-an-atomic64-counter
+++ a/mm/util.c
@@ -439,7 +439,7 @@ int __account_locked_vm(struct mm_struct
 
 	mmap_assert_write_locked(mm);
 
-	locked_vm = mm->locked_vm;
+	locked_vm = atomic64_read(&mm->locked_vm);
 	if (inc) {
 		if (!bypass_rlim) {
 			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -447,10 +447,10 @@ int __account_locked_vm(struct mm_struct
 				ret = -ENOMEM;
 		}
 		if (!ret)
-			mm->locked_vm = locked_vm + pages;
+			atomic64_add(pages, &mm->locked_vm);
 	} else {
 		WARN_ON_ONCE(pages > locked_vm);
-		mm->locked_vm = locked_vm - pages;
+		atomic64_sub(pages, &mm->locked_vm);
 	}
 
 	pr_debug("%s: [%d] caller %ps %c%lu %lu/%lu%s\n", __func__, task->pid,
_

Patches currently in -mm which might be from fly@kernel.page are

mm-make-mm-locked_vm-an-atomic64-counter.patch
mm-util-account_locked_vm-does-not-hold-mmap_lock.patch

